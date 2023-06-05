FROM ruby:3.1.2

# postgresqlのコマンドインストール
RUN apt-get update -qq && apt-get install -y postgresql-client
# nodejsのインストール
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && apt-get install -y --fix-missing nodejs
# yarnのインストール
RUN npm install --global yarn


# コンテナ内にディレクトリ作成
RUN mkdir /rice_inventory_management
#作業場所の設定
WORKDIR /rice_inventory_management
#gemfileをコンテナ内にコピーしインストール
COPY Gemfile /rice_inventory_management/Gemfile
COPY Gemfile.lock /rice_inventory_management/Gemfile.lock
RUN gem install bundler
RUN bundle install
# ソースコードをコピー
COPY . /rice_inventory_management

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["/usr/bin/entrypoint.sh"]
EXPOSE 3000
# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
