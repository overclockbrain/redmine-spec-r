# ベースイメージ（Redmine公式の最新安定版）
FROM redmine:5.1

# 開発に必要なツールをインストール
# build-essential: Gemのネイティブ拡張（C言語で書かれたライブラリ）のビルドに必要
# git: Gemfileでgit経由のライブラリを入れる場合に必要
# vim: コンテナ内でちょっと編集したい時に便利
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    vim \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# 開発環境用の設定
# Bundlerの並列実行数とか設定しとくと速い
ENV BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3

# 権限トラブル回避：redmineユーザーでGemをインストールできるようにする
# ここがミソ！公式イメージは /usr/local/bundle が root 権限でロックされてるから緩める
RUN mkdir -p /usr/local/bundle && \
    chown -R redmine:redmine /usr/local/bundle && \
    chmod -R u+rwx,g+rwx,o+rwx /usr/local/bundle

# 以降のコマンドは redmine ユーザーとして実行（セキュリティ的にも◎）
USER redmine