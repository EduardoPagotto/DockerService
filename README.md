# DockerService
Controle de Docker para redis


Para colocar no boot apenas o servico do redis (com o docker-compose up) executado previamente:
 cp cfg_to_boot/docker_redis.service /etc/systemd/system/docker_redis.service
 systemctl enable docker_redis.service

ou para usar o compose no boot copie o diretorio raiz Docker-Servers para opt:
 mv Docker-Servers /opt
 cp /etc/systemd/system/docker-compose-app.service
 systemctl enable docker-compose-app.service

-Procedimento Docker Redis
--instalar docker:
sudo apt install docker.io
sudo apt install docker-compose

--Baixar o Redis:
docker pull redis

SEM COMPOSER:

	--Crie um arquivo Dockerfile no deretorio Redis como abaixo:(ira cria uma copia modificada da imagem original)

		FROM redis
		MAINTAINER Inovação NewSpace
		COPY redis.conf /usr/local/etc/redis.conf
		EXPOSE 6379
		CMD redis-server /usr/local/etc/redis.conf && /bin/bash #(&& /bin/bash opcional para controle interativo)
		
	--execute o comando para gerar o docker(snapshot) da imagem redis:
	docker build -t img_redis_desenv . #(img_redis_desenv e o nome da nova imagem criada a partir da imagem redis)

	--execute o docker(snapshot) a primeira vez (sem compose):
	docker run --name redis_desenv -idt -p 6379:6379 img_redis_desenv (nome do docker redis_desenv da imagem img_redis_desenv)

-COM COMPOSER:

	--no diretorio pegasus editar o arquivo docker-compose.yml

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

	-- buid cria imagem img_redis_desenv com docker redis_desenv:
	docker-compose build

	--Levante os dockers:
	docker-composer up


COMANDOS UTEIS:
	--executa redis-cli para teste do redis
	docker run -it --network=pegasus_default --link redis_desenv:redis --rm redis redis-cli -h redis -p 6379

	--chama manualmente configurando redis.conf 
	docker run -v ~/Projetos/pegasus/redis/redis.conf:/usr/local/etc/redis.conf --name redis-dev redis redis-server /usr/local/etc/redis.conf

	--listar imagens disponiveis:
	docker images

	--remove todos os containers parados
	docker rm -v $(docker ps -a -q -f status=exited)

	--diferencas entre a imagem original e a rodando:
	docker diff redis_desenv

	--pare o docker do redis com:
	docker stop redis_desenv

	--re-inicie o docker do redis (sem perder dados)
	docker start redis_desenv

	--remover o docker (pare ele primeriro)
	docker rm redis_desenv

	--remover a imagem (remova o docker dele primeiro)
	docker rmi img_redis_desenv (remove a imagem definitivamente)

	--exemplo de chamada interativa em python
	parametros: 
		-it interativa
		--rm remove docker quando sair
		--name nome do docker

	docker run -it --rm --name py_teste python /bin/bash

#REFERENCIAS:
	http://anandmanisankar.com/posts/docker-container-nginx-node-redis-example

------------------------------------------------------------------------------------

#mostrar db's

	show dbs

#criar db (apenas refencia, so cria depois de inserido alguma coleção)

	use nsqueue

#mostra o db atual

	db

#criar uma colecao chamada nsqueue

	a = {nome:'namespace', fila:[], status: 0}
	db.nsqueue.save(a)
#ou

	db.nsqueue.insert({nome:'namespace', fila:[], status: 0})


#listar toda a coleção

	db.nsqueue.find()

#dropar uma colecao

	db.nsqueue.drop()

#remover uma colecao

	db.nsqueue.remove()


#insere novo elemento no array dentro da colecao

	nova = {_id:ObjectId(), nome:"reconhecimento", status:0, tipo:"FIFO", ttl:0, sla:0, prioridade:0}
	db.nsqueue.update({"_id" : ObjectId("5ad95167cd8ac6079b905cc4")},{$push:{fila:nova}})

#ou

	db.nsqueue.update({"_id" : ObjectId("5ad94bcdcd8ac6079b905cc1")},{$push:{fila:{_id:ObjectId(), nome:"entrada", status:0, tipo:"FIFO", ttl:0, sla:0, prioridade:0}}})

#listar padrao humano

	db.nsqueue.find().pretty()

#remove um elemento do array dentro da colecao

	db.nsqueue.update({"_id" : ObjectId("5ad94bcdcd8ac6079b905cc1")},{$pull:{fila:{nome:"entrada"}}})

#procura por transferencia nas filas

	db.nsqueue.find({_id:ObjectId("5ad95167cd8ac6079b905cc4")},{fila:{$elemMatch:{"nome" : "transferencia"}}}).pretty()


------------------------------------------------------------------------------
#Teste do syslog 
docker run -it -v ~/Projetos/pegasus/syslog/conf/syslog-ng.conf:/etc/syslog-ng/syslog-ng.conf -v ~/Projetos/pegasus/syslog/logs:/var/log -p 514:514 -p 601:601 –name syslog-ng balabit/syslog-ng:latest -edv







