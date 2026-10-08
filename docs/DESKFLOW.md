# Deskflow no Arch BSPWM + SDDM, com TLS

Esta integração reproduz o ambiente X11 validado: **Windows = servidor**,
**Arch = cliente**, tanto na tela de login SDDM Astronaut quanto no BSPWM.
As duas contas Linux possuem certificados TLS diferentes, e ambas verificam o
fingerprint do servidor. Nada que contenha chaves privadas fica no repositório.

## Arquivos versionados

| Caminho | Função |
| --- | --- |
| `.xprofile` | Importa `DISPLAY` e `XAUTHORITY`; reinicia o cliente na sessão X11. |
| `.config/systemd/user/deskflow-client.service` | Serviço estático do BSPWM, usa `--new-instance`. |
| `system/usr/local/libexec/deskflow-sddm-watch` | Aguarda o greeter e executa o cliente como `sddm`. |
| `system/etc/systemd/system/deskflow-sddm.service` | Serviço systemd do watcher. |
| `scripts/setup-deskflow.sh` | Preparação local segura e ativação explícita do TLS. |

O `install.sh` instala o pacote e os serviços, mas **não habilita**
automaticamente o watcher antes de o TLS estar preparado. Se você já usa
`~/.xprofile`, o instalador preserva esse arquivo; integre manualmente o
trecho do Deskflow caso ele não exista nele.

## 1. Windows — certificado do servidor

Instale e execute o Deskflow em modo **Server**. Normalmente o PEM fica em
`C:\ProgramData\Deskflow\tls\deskflow.pem`.

No PowerShell 7, obtenha o fingerprint SHA-256 sem mostrar a chave privada:

```powershell
$Path = 'C:\ProgramData\Deskflow\tls\deskflow.pem'
$Text = Get-Content -LiteralPath $Path -Raw
$CertText = [regex]::Match($Text, '-----BEGIN CERTIFICATE-----[\s\S]*?-----END CERTIFICATE-----').Value
$Cert = [System.Security.Cryptography.X509Certificates.X509Certificate2]::CreateFromPem($CertText)
$Cert.GetCertHashString('SHA256')
```

Não envie nem versione o arquivo PEM: ele pode incluir a chave privada.

## 2. Arch — preparar, sem interromper a conexão atual

Dentro do clone `dotfiles-clean`, como usuário comum:

```bash
bash scripts/setup-deskflow.sh prepare 192.168.1.2 FINGERPRINT_SHA256_DO_WINDOWS
```

Substitua o endereço e fingerprint pelos da sua rede (com ou sem `:`).
O script não reinicia o Deskflow nem habilita serviços nesta etapa.

Ele preserva certificados já existentes, gera PEM próprio para o usuário
e outro para `sddm`, mantém as demais configurações dos INIs, grava
`trusted-servers` em ambas as contas e imprime **dois fingerprints Arch**.
Se o ambiente já tiver TLS ativo, o `prepare` não o desativa.

## 3. Windows — autorizar os DOIS clientes Arch

Abra o PowerShell como administrador e insira os dois fingerprints impressos
pelo script anterior:

```powershell
$Db = 'C:\ProgramData\Deskflow\tls\trusted-clients'
$DesktopFp = 'FINGERPRINT_SHA256_DO_BSPWM'
$SddmFp = 'FINGERPRINT_SHA256_DO_SDDM'
$New = @($DesktopFp, $SddmFp) | ForEach-Object {
    'v2:sha256:' + ($_.Replace(':', '').ToLowerInvariant())
}
$Existing = @()
if (Test-Path -LiteralPath $Db) {
    Copy-Item -LiteralPath $Db -Destination "$Db.bak" -Force
    $Existing = @(Get-Content -LiteralPath $Db)
}
$All = @($Existing + $New | Where-Object { $_ } | Sort-Object -Unique)
[System.IO.File]::WriteAllLines($Db, [string[]]$All, [System.Text.UTF8Encoding]::new($false))
```

Em **Deskflow → Settings → Security**, ative **Enable TLS Encryption**
e **Require client certificates**. Use o PEM original do Windows;
**não gere um certificado novo**, pois isso invalidaria o fingerprint
preparado no Arch.

## 4. Arch — ativar TLS somente quando o Windows estiver pronto

Mantenha um teclado local ou SSH disponível durante a transição:

```bash
bash scripts/setup-deskflow.sh activate
```

Digite `ATIVAR` para confirmar. O script ativa `tlsEnabled=true`
nos dois INIs, habilita o watcher no SDDM e reinicia o cliente BSPWM
se estiver numa sessão gráfica X11. Ele não tenta habilitar o serviço
estático de usuário durante o boot sem `DISPLAY`/`XAUTHORITY`.

Confira os logs:

```bash
journalctl --user -b -u deskflow-client.service --no-pager -n 60
sudo journalctl -b -u deskflow-sddm.service --no-pager -n 60
```

É esperado encontrar `connected to secure socket`,
`network encryption protocol: TLSv1.3` (ou outra versão TLS segura)
e `IPC: connected to server`.

Valide primeiro logout → controle do SDDM → login BSPWM; depois
reinicie o Arch e valide novamente os dois ambientes.

## Diagnóstico e segurança

```bash
systemctl is-enabled deskflow-sddm.service
systemctl is-active deskflow-sddm.service
systemctl --user is-active deskflow-client.service
pgrep -af 'deskflow-core|deskflow-sddm-watch'
```

Arquivos locais não versionados: `~/.config/Deskflow/`,
`/var/lib/sddm/.config/Deskflow/`, incluindo certificados e bases de
confiança. O script usa diretórios TLS `700` e arquivos PEM `600`.
Certificados novos expiram em 365 dias: ao renovar, atualize os
fingerprints aceitos no outro sistema.

A integração pré-login depende do greeter **SDDM X11**, não de Wayland.
Caso a conexão falhe após ativar o TLS, mantenha SSH ou teclado local,
verifique os certificados e as bases de confiança antes de desligar a
verificação por fingerprint. Não envie chaves privadas ao GitHub.
