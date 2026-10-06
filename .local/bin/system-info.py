import argparse
import configparser
import glob
import os
import subprocess
import sys
from dataclasses import dataclass
from pathlib import Path

try:
    import psutil
except ImportError:
    print(
        "Missing Python dependency: psutil",
        file=sys.stderr,
    )
    sys.exit(1)


@dataclass
class ValIcons:
    percent_icon: str
    percent_critical: bool
    temp_icon: str
    temp_critical: bool


@dataclass
class GpuInfo:
    name: str = "N/A"
    utilization: int | None = None
    temperature: int | None = None


def get_icon(
    percent_val: int | None,
    temp_val: int | None,
) -> ValIcons:
    percent_critical = False
    temp_critical = False

    if percent_val is None or percent_val < 40:
        percent_icon = "󰾆 "
    elif percent_val < 70:
        percent_icon = "󰾅 "
    elif percent_val < 90:
        percent_icon = "󰓅 "
    else:
        percent_critical = True
        percent_icon = " "

    if temp_val is None or temp_val < 40:
        temp_icon = " "
    elif temp_val < 70:
        temp_icon = " "
    elif temp_val < 90:
        temp_icon = " "
    else:
        temp_critical = True
        temp_icon = " "

    return ValIcons(
        percent_icon,
        percent_critical,
        temp_icon,
        temp_critical,
    )


def format_percent(value: int | None) -> str:
    if value is None:
        return "N/A"

    return f"{value}%"


def format_temperature(value: int | None) -> str:
    if value is None:
        return "N/A"

    return f"{value}°C"


def read_text(path: str | Path) -> str | None:
    try:
        return Path(path).read_text(encoding="utf-8").strip()
    except (OSError, UnicodeError):
        return None


def read_int(path: str | Path) -> int | None:
    value = read_text(path)

    if value is None:
        return None

    try:
        return int(value)
    except ValueError:
        return None


def get_cpu_temperature() -> int | None:
    try:
        temperatures = psutil.sensors_temperatures()
    except (AttributeError, OSError):
        return None

    preferred_sensors = (
        "coretemp",
        "k10temp",
        "zenpower",
        "cpu_thermal",
    )

    for sensor_name in preferred_sensors:
        entries = temperatures.get(sensor_name)

        if not entries:
            continue

        valid_temperatures = []

        for entry in entries:
            try:
                valid_temperatures.append(float(entry.current))
            except (TypeError, ValueError):
                continue

        if valid_temperatures:
            return round(max(valid_temperatures))

    for entries in temperatures.values():
        if not entries:
            continue

        for entry in entries:
            try:
                return round(float(entry.current))
            except (TypeError, ValueError):
                continue

    return None


def get_cpu_name() -> str:
    try:
        with open(
            "/proc/cpuinfo",
            "r",
            encoding="utf-8",
        ) as cpu_info:
            for line in cpu_info:
                if line.startswith("model name"):
                    return line.split(":", 1)[1].strip()
    except OSError:
        pass

    return "N/A"


def get_cpu_info(label_mode: str):
    cpu_name = get_cpu_name()
    cpu_percent = round(psutil.cpu_percent(interval=1))
    cpu_temp = get_cpu_temperature()

    icons = get_icon(
        cpu_percent,
        cpu_temp,
    )

    percent_text = format_percent(cpu_percent)
    temp_text = format_temperature(cpu_temp)

    return {
        "text": (
            f"󰍛 {temp_text}"
            if label_mode == "temp"
            else f"󰍛 {percent_text}"
        ),
        "tooltip": (
            f"󰍛 Name: {cpu_name}\n"
            f"{icons.percent_icon}Utilization: {percent_text}\n"
            f"{icons.temp_icon}Temp: {temp_text}"
        ),
        "critical": (
            icons.temp_critical
            if label_mode == "temp"
            else icons.percent_critical
        ),
    }


def get_ram_info():
    memory = psutil.virtual_memory()

    total_gb = round(memory.total / (1024**3), 2)
    used_gb = round(memory.used / (1024**3), 2)

    memory_percent = round(memory.percent)
    critical = memory_percent >= 90

    if memory_percent < 40:
        icon = "󰾆 "
    elif memory_percent < 70:
        icon = "󰾅 "
    elif memory_percent < 90:
        icon = "󰓅 "
    else:
        icon = " "

    return {
        "text": f"{icon} {used_gb} GB",
        "tooltip": (
            f"{icon}Percent Utilization: {memory_percent}%\n"
            f"  Utilization: {used_gb}/{total_gb} GB"
        ),
        "critical": critical,
    }


def get_nvidia_smi_info() -> GpuInfo | None:
    try:
        result = subprocess.run(
            [
                "nvidia-smi",
                "--query-gpu=name,utilization.gpu,temperature.gpu",
                "--format=csv,noheader,nounits",
            ],
            check=False,
            capture_output=True,
            text=True,
            timeout=2,
        )
    except (FileNotFoundError, OSError, subprocess.TimeoutExpired):
        return None

    if result.returncode != 0:
        return None

    output = result.stdout.strip()

    if not output:
        return None

    first_gpu = output.splitlines()[0]
    parts = [part.strip() for part in first_gpu.split(",")]

    if len(parts) < 3:
        return None

    try:
        utilization = round(float(parts[1]))
    except ValueError:
        utilization = None

    try:
        temperature = round(float(parts[2]))
    except ValueError:
        temperature = None

    return GpuInfo(
        name=parts[0] or "NVIDIA GPU",
        utilization=utilization,
        temperature=temperature,
    )


def get_gpu_vendor_name(vendor_id: str | None) -> str:
    vendor_names = {
        "0x1002": "AMD GPU",
        "0x10de": "NVIDIA GPU",
        "0x8086": "Intel GPU",
    }

    if vendor_id is None:
        return "GPU"

    return vendor_names.get(
        vendor_id.lower(),
        f"GPU ({vendor_id})",
    )


def get_gpu_hwmon_temperature(device_path: Path) -> int | None:
    hwmon_paths = sorted(
        glob.glob(
            str(device_path / "hwmon" / "hwmon*" / "temp1_input")
        )
    )

    for temp_path in hwmon_paths:
        raw_temp = read_int(temp_path)

        if raw_temp is None:
            continue

        if abs(raw_temp) >= 1000:
            return round(raw_temp / 1000)

        return raw_temp

    return None


def get_sysfs_gpu_info() -> GpuInfo | None:
    cards = sorted(Path("/sys/class/drm").glob("card[0-9]*"))

    candidates = []

    for card in cards:
        device_path = card / "device"

        if not device_path.exists():
            continue

        vendor_id = read_text(device_path / "vendor")

        if vendor_id is None:
            continue

        candidates.append(
            (
                card,
                device_path,
                vendor_id.lower(),
            )
        )

    if not candidates:
        return None

    vendor_priority = {
        "0x1002": 0,
        "0x10de": 1,
        "0x8086": 2,
    }

    candidates.sort(
        key=lambda item: vendor_priority.get(
            item[2],
            99,
        )
    )

    _, device_path, vendor_id = candidates[0]

    utilization = read_int(
        device_path / "gpu_busy_percent"
    )

    if utilization is not None:
        utilization = max(
            0,
            min(100, utilization),
        )

    temperature = get_gpu_hwmon_temperature(
        device_path
    )

    return GpuInfo(
        name=get_gpu_vendor_name(vendor_id),
        utilization=utilization,
        temperature=temperature,
    )


def get_gpu_data() -> GpuInfo:
    nvidia_info = get_nvidia_smi_info()

    if nvidia_info is not None:
        return nvidia_info

    sysfs_info = get_sysfs_gpu_info()

    if sysfs_info is not None:
        return sysfs_info

    return GpuInfo()


def get_gpu_info(label_mode: str):
    gpu = get_gpu_data()

    icons = get_icon(
        gpu.utilization,
        gpu.temperature,
    )

    percent_text = format_percent(
        gpu.utilization
    )

    temp_text = format_temperature(
        gpu.temperature
    )

    return {
        "text": (
            f"󰢮 {temp_text}"
            if label_mode == "temp"
            else f"󰢮 {percent_text}"
        ),
        "tooltip": (
            f"󰢮 Name: {gpu.name}\n"
            f"{icons.percent_icon}Utilization: {percent_text}\n"
            f"{icons.temp_icon}Temp: {temp_text}"
        ),
        "critical": (
            icons.temp_critical
            if label_mode == "temp"
            else icons.percent_critical
        ),
    }


def get_system_info_config(
    config_path: str,
) -> tuple[str, str]:
    os.makedirs(
        os.path.dirname(config_path),
        exist_ok=True,
    )

    config = configparser.ConfigParser()

    if not os.path.isfile(config_path):
        config["DEFAULT"] = {
            "cpu-label-mode": "utilization",
            "gpu-label-mode": "utilization",
        }

        with open(
            config_path,
            "w",
            encoding="utf-8",
        ) as config_file:
            config.write(config_file)

        return "utilization", "utilization"

    config.read(config_path)

    cpu_label_mode = config.get(
        "DEFAULT",
        "cpu-label-mode",
        fallback="utilization",
    )

    gpu_label_mode = config.get(
        "DEFAULT",
        "gpu-label-mode",
        fallback="utilization",
    )

    if cpu_label_mode not in (
        "utilization",
        "temp",
    ):
        cpu_label_mode = "utilization"

    if gpu_label_mode not in (
        "utilization",
        "temp",
    ):
        gpu_label_mode = "utilization"

    return (
        cpu_label_mode,
        gpu_label_mode,
    )


def set_system_info_config(
    config_path: str,
    cpu_mode: str,
    gpu_mode: str,
):
    os.makedirs(
        os.path.dirname(config_path),
        exist_ok=True,
    )

    config = configparser.ConfigParser()

    if os.path.isfile(config_path):
        config.read(config_path)

    if "DEFAULT" not in config:
        config["DEFAULT"] = {}

    config["DEFAULT"]["cpu-label-mode"] = (
        cpu_mode
        if cpu_mode in ("utilization", "temp")
        else "utilization"
    )

    config["DEFAULT"]["gpu-label-mode"] = (
        gpu_mode
        if gpu_mode in ("utilization", "temp")
        else "utilization"
    )

    with open(
        config_path,
        "w",
        encoding="utf-8",
    ) as config_file:
        config.write(config_file)


def print_polybar(
    info,
    normal_color: str,
    critical_color: str,
):
    color = (
        critical_color
        if info["critical"]
        else normal_color
    )

    print(
        f"%{{F{color}}}"
        f"{info['text']}"
        "%{F-}"
    )


def main():
    config_path = os.path.expanduser(
        "~/.cache/meowrch/system-info.ini"
    )

    (
        cpu_label_mode,
        gpu_label_mode,
    ) = get_system_info_config(config_path)

    parser = argparse.ArgumentParser()

    parser.add_argument(
        "--cpu",
        action="store_true",
    )

    parser.add_argument(
        "--ram",
        action="store_true",
    )

    parser.add_argument(
        "--gpu",
        action="store_true",
    )

    parser.add_argument(
        "--click",
        action="store_true",
    )

    parser.add_argument(
        "--normal-color",
        default="#a6e3a1",
    )

    parser.add_argument(
        "--critical-color",
        default="#f38ba8",
    )

    args = parser.parse_args()

    if args.cpu:
        if args.click:
            set_system_info_config(
                config_path=config_path,
                cpu_mode=(
                    "temp"
                    if cpu_label_mode == "utilization"
                    else "utilization"
                ),
                gpu_mode=gpu_label_mode,
            )
            return

        print_polybar(
            get_cpu_info(cpu_label_mode),
            args.normal_color,
            args.critical_color,
        )
        return

    if args.ram:
        print_polybar(
            get_ram_info(),
            args.normal_color,
            args.critical_color,
        )
        return

    if args.gpu:
        if args.click:
            set_system_info_config(
                config_path=config_path,
                cpu_mode=cpu_label_mode,
                gpu_mode=(
                    "temp"
                    if gpu_label_mode == "utilization"
                    else "utilization"
                ),
            )
            return

        print_polybar(
            get_gpu_info(gpu_label_mode),
            args.normal_color,
            args.critical_color,
        )
        return

    parser.print_help()


if __name__ == "__main__":
    main()
