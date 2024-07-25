#!/bin/bash
set -e

# インストールされているRubyとNode.jsのバージョンを確認
ruby -v
node -v

# バンドルインストール（並列で3ジョブ実行）
bundle install -j3

# プリコンパイルが必要な場合はアセットをプリコンパイル
if [ ! -d "public/assets" ]; then
  echo "Precompiling assets..."
  RAILS_ENV=production bundle exec rake assets:precompile
fi

# データベースマイグレーションを実行
echo "Running database migrations..."
RAILS_ENV=production bundle exec rake db:migrate

# メインプロセスを実行（DockerfileのCMDで設定されているもの）
exec "$@"
