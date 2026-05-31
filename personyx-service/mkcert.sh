# 自己署名証明書作成コマンド
# 以下のコマンドによりcetrsフォルダにfullchain.pemとprivkey.pemの2ファイルが作成される
cd "E:\Dev\036 personyx\personyx\personyx-service"
docker run --rm -v ${PWD}:/work -w /work alpine sh -c "apk add --no-cache openssl && openssl genrsa -out certs/privkey.pem 2048 && openssl req -new -key certs/privkey.pem -out certs/csr.pem -subj '/CN=local.personyx' && openssl x509 -req -days 365 -in certs/csr.pem -signkey certs/privkey.pem -out certs/fullchain.pem && rm certs/csr.pem"