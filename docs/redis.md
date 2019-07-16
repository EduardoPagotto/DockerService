 # Redis SEM COMPOSER:
Crie um arquivo Dockerfile no deretorio Redis como abaixo:(ira cria uma copia modificada da imagem original)
```file
FROM redis
MAINTAINER Inovação NewSpace
COPY redis.conf /usr/local/etc/redis.conf
EXPOSE 6379
CMD redis-server /usr/local/etc/redis.conf && /bin/bash
#(&& /bin/bash opcional para controle interativo)
```		

execute o comando para gerar o docker(snapshot) da imagem redis:
```bash
docker build -t img_redis_desenv
```

- execute o docker(snapshot) a primeira vez (sem compose):
```bash
docker run --name redis_desenv -idt -p 6379:6379 img_redis_desenv
```

## Redis COM COMPOSER:
- No diretorio pegasus editar o arquivo docker-compose.yml
```file
version: '2'
services:
	redis:
	build: ./redis
	container_name: redis_desenv
	image: img_redis_desenv
	ports:
	- "6379:6379"
	environment:
	usuario: blahblah
	senha: blah_db
	volumes:
	- ~/Projetos/pegasus/redis/data:/data
```