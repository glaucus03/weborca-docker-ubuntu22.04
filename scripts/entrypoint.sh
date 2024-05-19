#!/bin/bash
set -e

# 必要なディレクトリを作成
mkdir -p /tmp/weborca

# 環境変数の読み込みとエクスポート
if [ -f /opt/jma/weborca/app/etc/online.env ]; then
    set -a  # これにより、読み込まれる変数がすべてエクスポートされる
    source /opt/jma/weborca/app/etc/online.env
    set +a  # エクスポートモードを解除
else
    echo "Environment file not found."
    exit 1
fi


# PostgreSQLの起動
service postgresql start

# WebORCAの起動
cd /opt/jma/weborca/mw/bin
/opt/jma/weborca/mw/bin/weborca &

# フラグファイルのパス
FLAG_FILE="/opt/jma/weborca/conf/setup_complete.flag"

# サーバー起動を待機
sleep 10

# 初回起動時のみパスワード設定
if [ ! -f "$FLAG_FILE" ]; then
    echo "Setting up ORMASTER password..."
    # パスワード設定スクリプトを実行
    sudo chmod 1777 /tmp
    /bin/echo -e "ormaster\normaster" | sudo -u orca /opt/jma/weborca/app/bin/passwd_store.sh
    
    # フラグファイルを作成
    touch $FLAG_FILE
fi

# ログファイルへの出力を待機
touch /opt/jma/weborca/log/orca-server.log
tail -f /opt/jma/weborca/log/orca-server.log

