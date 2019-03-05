sudo docker build -t scopassgn:latest .

sudo docker run --name elasticsearch -d -p 9200:9200 -p 9300:9300 --rm -e "discovery.type=single-node" docker.elastic.co/elasticsearch/elasticsearch-oss:6.1.1

sudo docker run --name mysql -d -e MYSQL_RANDOM_ROOT_PASSWORD=yes -e MYSQL_DATABASE=scopassgn -e MYSQL_USER=scopassgn -e MYSQL_PASSWORD=Student12# mysql/mysql-server:5.7

sudo docker run --name redis -d -p 6379:6379 redis:3-alpine

sudo docker run --name scopassgn -d -p 8000:5000 --rm -e SECRET_KEY=my-secret-key -e MAIL_SERVER=smtp.googlemail.com -e MAIL_PORT=587 -e MAIL_USE_TLS=true -e MAIL_USERNAME=dockertesting12@gmail.com -e MAIL_PASSWORD=Student12# --link mysql:dbserver --link redis:redis-server -e DATABASE_URL=mysql+pymysql://scopassgn:Student12#@dbserver/scopassgn -e REDIS_URL=redis://redis-server:6379/0 scopassgn:latest

sudo docker run --name rq-worker -d --rm -e SECRET_KEY=my-secret-key -e MAIL_SERVER=smtp.googlemail.com -e MAIL_PORT=587 -e MAIL_USE_TLS=true -e MAIL_USERNAME=dockertesting12@gmail.com -e MAIL_PASSWORD=Student12# --link mysql:dbserver --link redis:redis-server -e DATABASE_URL=mysql+pymysql://scopassgn:Student12#@dbserver/scopassgn -e REDIS_URL=redis://redis-server:6379/0 --entrypoint venv/bin/rq scopassgn:latest worker -u redis://redis-server:6379/0 scopassgn-tasks



