FROM node:10.12.0 as build-stage

WORKDIR /app
COPY ./app/package*.json /app/

RUN npm install
COPY ./app/ /app/
ARG configuration=production

# Angular アプリをビルドする
RUN npm run build -- --output-path=./dist/out --configuration $configuration

# -----------------------------------------------------
# Nginx の Docker 環境を構築する
# -----------------------------------------------------
FROM nginx:1.15

# ビルドした成果物を Docker 上の Nginx のドキュメントとして扱うためにコピー(デプロイ)
COPY --from=build-stage /app/dist/out/ /usr/share/nginx/html

# Nginx の設定ファイルを Docker 上の Nginx にコピー
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf