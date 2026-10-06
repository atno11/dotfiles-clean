#!/usr/bin/env bash

ENABLED_COLOR=""
DISABLED_COLOR=""

SIGNAL_ICONS=(
    "󰤟 "
    "󰤢 "
    "󰤥 "
    "󰤨 "
)

SECURED_SIGNAL_ICONS=(
    "󰤡 "
    "󰤤 "
    "󰤧 "
    "󰤪 "
)

WIFI_CONNECTED_ICON=" "
ETHERNET_CONNECTED_ICON=" "

STATUS_MODE=false


network_manager_running() {
    systemctl is-active \
        --quiet NetworkManager
}


get_wifi_device() {
    nmcli \
        -t \
        -f DEVICE,TYPE \
        device status |
        awk -F: '
            $2 == "wifi" {
                print $1
                exit
            }
        '
}


signal_icon() {
    local signal="$1"
    local security="$2"
    local level

    [[ "$signal" =~ ^[0-9]+$ ]] || signal=0

    level=$((signal / 25))

    (( level > 3 )) && level=3

    if [[ "$security" =~ WPA|WEP ]]; then
        printf '%s' \
            "${SECURED_SIGNAL_ICONS[$level]}"
    else
        printf '%s' \
            "${SIGNAL_ICONS[$level]}"
    fi
}


get_status() {
    local status_icon
    local status_color

    if ! network_manager_running; then
        status_icon=" "
        status_color="$DISABLED_COLOR"
    elif nmcli \
        -t \
        -f TYPE,STATE \
        device status |
        grep -q '^ethernet:connected$'
    then
        status_icon="󰈀 "
        status_color="$ENABLED_COLOR"
    elif nmcli \
        -t \
        -f TYPE,STATE \
        device status |
        grep -q '^wifi:connected$'
    then
        local wifi_info
        local signal
        local security

        wifi_info="$(
            nmcli \
                --terse \
                --fields \
                "IN-USE,SIGNAL,SECURITY" \
                device wifi list \
                --rescan no |
                grep '^\*:' |
                head -n 1
        )"

        if [[ -n "$wifi_info" ]]; then
            IFS=: read -r _ signal security \
                <<< "$wifi_info"

            status_icon="$(
                signal_icon \
                    "$signal" \
                    "$security"
            )"

            status_color="$ENABLED_COLOR"
        else
            status_icon=" "
            status_color="$DISABLED_COLOR"
        fi
    else
        status_icon=" "
        status_color="$DISABLED_COLOR"
    fi

    if [[ -n "$status_color" ]]; then
        printf '%%{F%s}%s%%{F-}\n' \
            "$status_color" \
            "$status_icon"
    else
        printf '%s\n' "$status_icon"
    fi
}


manage_wifi() {
    local wifi_device

    wifi_device="$(get_wifi_device)"

    if [[ -z "$wifi_device" ]]; then
        notify-send \
            "Network" \
            "Wi-Fi device not found."
        return 1
    fi

    mapfile -t wifi_rows < <(
        nmcli \
            --terse \
            --fields \
            "IN-USE,SIGNAL,SECURITY,SSID" \
            device wifi list \
            --rescan yes |
            awk -F: '$4 != ""'
    )

    if (( ${#wifi_rows[@]} == 0 )); then
        notify-send \
            "Network" \
            "No Wi-Fi networks found."
        return
    fi

    local ssids=()
    local formatted=()
    local active_ssid=""

    local row
    local in_use
    local signal
    local security
    local ssid
    local icon
    local label

    for row in "${wifi_rows[@]}"; do
        IFS=: read -r \
            in_use \
            signal \
            security \
            ssid \
            <<< "$row"

        [[ -n "$ssid" ]] || continue

        icon="$(
            signal_icon \
                "$signal" \
                "$security"
        )"

        label="$icon $ssid"

        if [[ "$in_use" == "*" ]]; then
            active_ssid="$ssid"
            label="$WIFI_CONNECTED_ICON $label"
        fi

        ssids+=("$ssid")
        formatted+=("$label")
    done

    (( ${#formatted[@]} > 0 )) || return

    local chosen_network

    chosen_network="$(
        printf '%s\n' "${formatted[@]}" |
            rofi \
                -dmenu \
                -i \
                -p "Wi-Fi SSID:"
    )"

    [[ -n "$chosen_network" ]] || return

    local index=-1
    local i

    for i in "${!formatted[@]}"; do
        if [[ "${formatted[$i]}" == "$chosen_network" ]]; then
            index="$i"
            break
        fi
    done

    (( index >= 0 )) || return

    local chosen_ssid="${ssids[$index]}"
    local action

    if [[ "$chosen_ssid" == "$active_ssid" ]]; then
        action="  Disconnect"
    else
        action="󰸋  Connect"
    fi

    action="$(
        printf '%s\n%s\n' \
            "$action" \
            "  Forget" |
            rofi \
                -dmenu \
                -p "Action:"
    )"

    case "$action" in
        "󰸋  Connect")
            if nmcli \
                -g NAME \
                connection show |
                grep -Fxq "$chosen_ssid"
            then
                if nmcli \
                    connection up \
                    id "$chosen_ssid"
                then
                    notify-send \
                        "Connection Established" \
                        "Connected to \"$chosen_ssid\"."
                fi
            else
                local password

                password="$(
                    rofi \
                        -dmenu \
                        -p "Password:" \
                        -password
                )"

                [[ -n "$password" ]] || return

                if nmcli \
                    device wifi connect \
                    "$chosen_ssid" \
                    password "$password" \
                    ifname "$wifi_device"
                then
                    notify-send \
                        "Connection Established" \
                        "Connected to \"$chosen_ssid\"."
                fi
            fi
            ;;

        "  Disconnect")
            if nmcli \
                device disconnect \
                "$wifi_device"
            then
                notify-send \
                    "Disconnected" \
                    "Disconnected from \"$chosen_ssid\"."
            fi
            ;;

        "  Forget")
            if nmcli \
                connection delete \
                id "$chosen_ssid"
            then
                notify-send \
                    "Forgotten" \
                    "\"$chosen_ssid\" was removed."
            fi
            ;;
    esac
}


manage_ethernet() {
    mapfile -t eth_devices < <(
        nmcli \
            -t \
            -f DEVICE,TYPE \
            device status |
            awk -F: '
                $2 == "ethernet" {
                    print $1
                }
            '
    )

    if (( ${#eth_devices[@]} == 0 )); then
        notify-send \
            "Network" \
            "Ethernet device not found."
        return
    fi

    local entries=()
    local device
    local state

    for device in "${eth_devices[@]}"; do
        state="$(
            nmcli \
                -g GENERAL.STATE \
                device show "$device" |
                cut -d' ' -f1
        )"

        if [[ "$state" == "100" ]]; then
            entries+=(
                "$ETHERNET_CONNECTED_ICON$device"
            )
        else
            entries+=("$device")
        fi
    done

    local chosen

    chosen="$(
        printf '%s\n' "${entries[@]}" |
            rofi \
                -dmenu \
                -i \
                -p "Ethernet device:"
    )"

    [[ -n "$chosen" ]] || return

    chosen="${chosen#"$ETHERNET_CONNECTED_ICON"}"

    state="$(
        nmcli \
            -g GENERAL.STATE \
            device show "$chosen" |
            cut -d' ' -f1
    )"

    if [[ "$state" == "100" ]]; then
        if nmcli device disconnect "$chosen"; then
            notify-send \
                "Disconnected" \
                "$chosen disconnected."
        fi
    else
        if nmcli device connect "$chosen"; then
            notify-send \
                "Connected" \
                "$chosen connected."
        fi
    fi
}


main_menu() {
    while (( $# > 0 )); do
        case "$1" in
            --status)
                STATUS_MODE=true
                ;;

            --enabled-color)
                [[ $# -ge 2 ]] || exit 1
                ENABLED_COLOR="$2"
                shift
                ;;

            --disabled-color)
                [[ $# -ge 2 ]] || exit 1
                DISABLED_COLOR="$2"
                shift
                ;;

            *)
                echo "Unknown option: $1" >&2
                exit 1
                ;;
        esac

        shift
    done

    if $STATUS_MODE; then
        get_status
        exit 0
    fi

    if ! network_manager_running; then
        notify-send \
            "NetworkManager" \
            "NetworkManager is not running."
        exit 1
    fi

    local wifi_status
    local wifi_toggle
    local wifi_toggle_command
    local manage_wifi_option=""

    wifi_status="$(
        nmcli \
            -t \
            -f WIFI \
            general
    )"

    if [[ "$wifi_status" == "enabled" ]]; then
        wifi_toggle="󱛅  Disable Wi-Fi"
        wifi_toggle_command="off"
        manage_wifi_option="󱓥 Manage Wi-Fi"
    else
        wifi_toggle="󱚽  Enable Wi-Fi"
        wifi_toggle_command="on"
    fi

    local menu=("$wifi_toggle")

    if [[ -n "$manage_wifi_option" ]]; then
        menu+=("$manage_wifi_option")
    fi

    menu+=("󱓥 Manage Ethernet")

    local chosen

    chosen="$(
        printf '%s\n' "${menu[@]}" |
            rofi \
                -dmenu \
                -p " Network Management:"
    )"

    case "$chosen" in
        "$wifi_toggle")
            nmcli \
                radio wifi \
                "$wifi_toggle_command"
            ;;

        "󱓥 Manage Wi-Fi")
            manage_wifi
            ;;

        "󱓥 Manage Ethernet")
            manage_ethernet
            ;;
    esac
}


main_menu "$@"
