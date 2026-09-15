# 運用手順

## VPN監視・再接続

Ubuntuサーバー上で、NetworkManagerが管理するVPN接続を1分間隔で監視します。
VPNが切断されていた場合は、再接続スクリプトを実行します。

対象VPN接続:

- 接続名: `badcompany2-IKEv2-tls`
- 管理方式: NetworkManager
- 再接続方法: `nmcli connection up`

### スクリプトの配置

以下のスクリプトをUbuntuサーバーへ配置します。

- `/usr/local/sbin/check-vpn.sh`
- `/usr/local/sbin/reconnect-vpn.sh`

実行権限を付与します。

```bash
sudo chmod 755 /usr/local/sbin/check-vpn.sh
sudo chmod 755 /usr/local/sbin/reconnect-vpn.sh
```

### 監視スクリプト

`check-vpn.sh` は、対象VPNがNetworkManager上でアクティブか確認します。
接続されていない場合は、`reconnect-vpn.sh` を実行します。

```shell
#!/usr/bin/env bash

set -u

VPN_NAME="badcompany2-IKEv2-tls"
RECONNECT_SCRIPT="/usr/local/sbin/reconnect-vpn.sh"
LOG_TAG="vpn-monitor"

if nmcli -g NAME connection show --active | grep -Fxq "$VPN_NAME"; then
    logger -t "$LOG_TAG" "VPN is connected: $VPN_NAME"
    exit 0
fi

logger -t "$LOG_TAG" "VPN is disconnected: $VPN_NAME. Reconnecting."
"$RECONNECT_SCRIPT"
```

### 再接続スクリプト

`reconnect-vpn.sh` は、NetworkManagerを使用してVPN接続を開始します。

```shell
#!/usr/bin/env bash

set -u

VPN_NAME="badcompany2-IKEv2-tls"
LOG_TAG="vpn-reconnect"

if nmcli connection up id "$VPN_NAME"; then
    logger -t "$LOG_TAG" "VPN connected: $VPN_NAME"
    exit 0
fi

logger -t "$LOG_TAG" "VPN connection failed: $VPN_NAME"
exit 1
```

### 権限

cronから再接続する場合は、rootのcrontabへ登録します。

```bash
sudo crontab -e
```

rootのcrontabから実行するため、スクリプト内の`nmcli`に`sudo`を付ける必要はありません。
一般ユーザーのcrontabから`sudo`を実行すると、パスワード入力ができず失敗する可能性があります。

### cronへの登録

rootのcrontabへ、次の設定を追加します。

```text
* * * * * /usr/bin/flock -n /run/vpn-monitor.lock /usr/local/sbin/check-vpn.sh
```

`flock`により、前回の監視処理が終了していない場合の重複実行を防止します。

### 手動確認

VPN接続の登録名と現在の接続状態を確認します。

```bash
nmcli connection show
nmcli -g NAME connection show --active
```

監視スクリプトを手動実行します。

```bash
sudo /usr/local/sbin/check-vpn.sh
```

### ログ確認

監視・再接続のログは、`logger`でsystemd journalへ出力されます。

```bash
sudo journalctl -t vpn-monitor -t vpn-reconnect
```

### 注意事項

- VPN接続名を変更した場合は、両方のスクリプトの`VPN_NAME`を更新する
- VPNプロファイルの秘密情報や認証情報をリポジトリへ登録しない
- VPNが「接続済み」でも通信できない状態は、この監視だけでは検知できない
- 通信状態まで監視する場合は、VPN経由のIPアドレスやホストへの疎通確認を追加する
