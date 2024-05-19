FROM ubuntu:22.04

# 環境変数の設定
ENV DEBIAN_FRONTEND=noninteractive
ENV ORMASTER_PASSWORD=ormaster

# 必要なパッケージのインストール
RUN apt-get update && apt-get install -y wget gnupg postgresql sudo curl systemctl

# 公開鍵のダウンロードとリポジトリの設定
RUN wget https://ftp.orca.med.or.jp/pub/ubuntu/archive.key -O /etc/apt/keyrings/jma.asc

# リポジトリリストファイルのダウンロードと追加
RUN wget https://ftp.orca.med.or.jp/pub/ubuntu/jma-receipt-weborca-jammy10.list -O /etc/apt/sources.list.d/jma-receipt-weborca-jammy10.list

# データベース設定ファイルをコピーする
COPY db.conf /etc/jma-receipt/

# システムのアップデートとWebORCAのインストール
RUN apt-get update \
    && apt-get dist-upgrade -y \
    && apt-get install -y jma-receipt-weborca

## 日レセのデータベースセットアップを行う
RUN service postgresql restart \
    && weborca-install \
    && /opt/jma/weborca/app/bin/jma-setup

EXPOSE 8000 5432

# エントリポイントスクリプトのコピー
COPY entrypoint.sh /usr/local/bin/

# エントリポイントスクリプトを実行可能にする
RUN chmod +x /usr/local/bin/entrypoint.sh

# エントリポイントスクリプトを実行
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
