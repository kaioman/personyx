# 運用手順

## PostgreSQLヘルスチェック

`personyx_db`のヘルスチェックでは、
`personyx-service/scripts/postgres-healthcheck.sh`をコンテナ内の
`/usr/local/bin/postgres-healthcheck.sh`へ読み取り専用でマウントして実行します。

バインドマウントではホスト側のファイル権限が引き継がれるため、本番環境への配置後、
Composeを起動する前に実行権限を付与してください。

```bash
cd personyx-service
sudo chmod 755 ./scripts/postgres-healthcheck.sh
```

権限を確認する場合は、次のコマンドを実行します。

```bash
stat -c '%a %n' ./scripts/postgres-healthcheck.sh
```

出力された権限が`755`であることを確認してから、`personyx_db`を起動してください。

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

## Webギャラリーへの遷移がタイムアウトする場合

### 症状

トップページは表示できるが、`/images`へのアクセスがブラウザーのNetwork
タブで`pending`のままになる場合があります。

今回の事例では、次の状態でした。

- `Images`テーブルは空だったが、DB接続とSELECTは成功した
- Webコンテナ内部から`/images`へアクセスすると`200`で3267バイト取得できた
- OCIサーバー上のApache経由ではHTTPヘッダーだけ受信し、本文が受信できなかった
- バックエンドへの直接アクセスでも、`Content-Length: 3267`に対して本文が0バイトのままタイムアウトした
- バックエンド側のtcpdumpでは、レスポンスの一部が再送され続けていた

### 切り分け手順

1. Webコンテナ内部からFlaskへ直接アクセスし、アプリケーション処理を確認する。

   `curl -v --max-time 10 http://127.0.0.1:5000/images`

2. `Images`テーブルの件数とクエリを確認する。

   `select count(*) from images`

3. OCIサーバーからバックエンドの`5000`番ポートへ直接アクセスする。

   `curl -v --http1.1 --connect-timeout 5 --max-time 15 http://<バックエンドサーバーのVPN内IP>:5000/images`

4. OCIサーバーとバックエンドの両方でTCP通信を確認する。

   `sudo tcpdump -ni any 'host <OCIサーバーのVPN内IP> and port 5000'`

5. バックエンドからOCIへの経路を確認する。

   `ip route get <OCIサーバーのVPN内IP>`

6. 経路情報からXFRMインターフェース名を確認する。
   
   `ip route get <OCIサーバーのVPN内IP>`

   出力例:

   `xx.x.x.xx dev xx-xfrm-9999999 table 220 src 192.168.x.xxx`

   この例では、`dev`の後ろに表示された
   `xx-xfrm-9999999`がXFRMインターフェース名です。    
   
   インターフェースの詳細を確認する場合:

   `ip -d link show xx-xfrm-9999999`

7. XFRMインターフェースのMTUを確認する。

   `ip link show <XFRMインターフェース名>`
   
   出力例:

   18: show xx-xfrm-9999999@NONE: <NOARP,UP,LOWER_UP> mtu 1300 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000 link/none
   
   mtu 1300の表記があるのでmtu=1300であることが確認できる
   
### 暫定復旧

VPN/IPsec経路でレスポンス本文が再送され続ける場合は、バックエンドの
XFRMインターフェースのMTUを一時的に下げて再試行します。

   `sudo ip link set dev <XFRMインターフェース名> mtu 1300`

復旧後にMTUを`1400`へ戻しても通信できる場合がありますが、経路キャッシュや
VPN/XFRMの状態が更新された影響の可能性があるため、`1400`で恒久的に解決した
とは判断しないでください。

### 恒久対策の検討

- VPN接続またはXFRMインターフェースのMTUを実効経路に合わせて固定する
- VPN経路でTCP MSSクランプを設定する
- DockerネットワークのMTUとVPN経路の実効MTUを確認する
- VPN再接続、Dockerネットワーク再作成、サーバー再起動後にも`/images`の取得を確認する

MTU変更は通信経路全体に影響するため、恒久設定にする前に、通常のWebアクセス、
DB接続、BotからVPN経由で行う通信を確認してください。
