# Estrutura de dados necessaria (para todos os servicos)
## Criar os diretorios de dados:
### Automatica
```bash
./create_dir_data.sh
```

### Manual
```bash
mkdir -p ./data/logs
mkdir -p ./data/redis
mkdir -p ./data/elk
mkdir -p ./data/elasticsearch
mkdir -p ./data/logstash
mkdir -p ./data/nfs_volume
mkdir -p ./data/mongo
mkdir -p ./data/mysql
```

# Registro do servico
obs: cfg para: '/home/desenv/Projetos/DockerService' em ./boot_config/docker-compose-app.service
```bash
cp ./boot_config/docker-compose-app.service /etc/systemd/system/
touch /etc/systemd/system/docker-compose-app.service
chmod 664 /etc/systemd/system/docker-compose-app.service
systemctl daemon-reload # verifica todos os .service nos diretorios de services
systemctl enable docker-compose-app # para incluir no system
systemctl disable docker-compose-app # para desabilitar do system
systemctl start docker-compose-app
```

# ELK
Stack ELK Teste de implementação, atualmente input do elastic direto pelo logger do pyton em UDP (sem filebeat)

refs: 
- https://elk-docker.readthedocs.io/#prerequisites
- https://www.freecodecamp.org/news/how-to-use-elasticsearch-logstash-and-kibana-to-visualise-logs-in-python-in-realtime-acaab281c9de/
- https://www.youtube.com/watch?v=LapNa2l-7VA
- https://stackoverflow.com/questions/16592615/logstash-file-input-configuration

## Dependencias
Verificar se memoria esta compativel:
```bash
sysctl vm.max_map_count
```

Se estiver abaixo de 2621448 executar:
```bash
sudo sysctl -w vm.max_map_count=2621448 
```

### Testes
- [Elastic online](http://127.0.0.1:9200) 
- [Elastic Lista indices](http://127.0.0.1:9200/_cat/indices?v) 
- [Elastic healt](http://127.0.0.1:9200/_cat/health)

### deleta indice nome 'post' (1:22:59)
```bash
curl -X DELETE "127.0.0.1:9200/posts" -H 'Content-Type: application/json'
```

# Log Slatch input dados 
config recebe de beat envia para console
```conf
  input {
    beats {
      port => 5044
    }
  }
  output {
    stdout {
      codec => rubydebug
    }
  }
```

config recebe de arquivo envia para elastic
```conf
  input{
      file{
          type => "dummylog"
          path => ["/home/rohit/dummy/*.log"]
      }
  }
  output{
      elasticsearch{
          host => ["127.0.0.1:9200"]
          index => "testez1"
      }
  }
```

config recebe de beat envia para elastic
```conf
  input {
    beats {
      port => 5044
    }
  }
  output {
    elasticsearch {
      hosts => "localhost:9200"
      manage_template => false
      index => "%{[@metadata][beat]}-%{[@metadata][version]}-%{+YYYY.MM.dd}" 
      document_type => "%{[@metadata][type]}" 
    }
  }
```

# Outros Serviços separados
Docker Instalação e download do redis:
```bash
sudo apt install docker.io
sudo apt install docker-compose
docker pull redis
```

 ## SEM COMPOSER:
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

## COM COMPOSER:
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
```bash
docker-compose build
docker-composer up
```

# COMANDOS UTEIS:
Executa redis-cli para teste do redis
```bash
docker run -it --network=pegasus_default --link redis_desenv:redis --rm redis redis-cli -h redis -p 6379
```

Chama manualmente configurando redis.conf 
```bash
docker run -v ~/Projetos/pegasus/redis/redis.conf:/usr/local/etc/redis.conf --name redis-dev redis redis-server /usr/local/etc/redis.conf
```

Listar imagens disponiveis:
```bash
docker images
```
Remove todos os containers parados
```bash
docker rm -v $(docker ps -a -q -f status=exited)
```

Diferencas entre a imagem original e a rodando:
```bash
docker diff redis_desenv
```

Pare o docker do redis com:
```bash
docker stop redis_desenv
```

Re-inicie o docker do redis (sem perder dados)
```bash
docker start redis_desenv
```

Remover o docker (pare ele primeriro)
```bash
docker rm redis_desenv
```

Remover a imagem (remova o docker dele primeiro)
```bash
docker rmi img_redis_desenv (remove a imagem definitivamente)
```

exemplo de chamada interativa em python
parametros: 
	-it interativa
	--rm remove docker quando sair
	--name nome do docker

```bash
docker run -it --rm --name py_teste python /bin/bash
```

### REFERENCIAS:
- http://anandmanisankar.com/posts/docker-container-nginx-node-redis-example



# Mongodb

mostrar db's

	show dbs

criar db (apenas refencia, so cria depois de inserido alguma coleção)

	use nsqueue

mostra o db atual

	db

criar uma colecao chamada nsqueue

	a = {nome:'namespace', fila:[], status: 0}
	db.nsqueue.save(a)
ou

	db.nsqueue.insert({nome:'namespace', fila:[], status: 0})


listar toda a coleção

	db.nsqueue.find()

dropar uma colecao

	db.nsqueue.drop()

remover uma colecao

	db.nsqueue.remove()


insere novo elemento no array dentro da colecao

	nova = {_id:ObjectId(), nome:"reconhecimento", status:0, tipo:"FIFO", ttl:0, sla:0, prioridade:0}
	db.nsqueue.update({"_id" : ObjectId("5ad95167cd8ac6079b905cc4")},{$push:{fila:nova}})

ou

	db.nsqueue.update({"_id" : ObjectId("5ad94bcdcd8ac6079b905cc1")},{$push:{fila:{_id:ObjectId(), nome:"entrada", status:0, tipo:"FIFO", ttl:0, sla:0, prioridade:0}}})

listar padrao humano

	db.nsqueue.find().pretty()

remove um elemento do array dentro da colecao

	db.nsqueue.update({"_id" : ObjectId("5ad94bcdcd8ac6079b905cc1")},{$pull:{fila:{nome:"entrada"}}})

procura por transferencia nas filas

	db.nsqueue.find({_id:ObjectId("5ad95167cd8ac6079b905cc4")},{fila:{$elemMatch:{"nome" : "transferencia"}}}).pretty()

# Teste do syslog
```bash 
docker run -it -v ~/Projetos/pegasus/syslog/conf/syslog-ng.conf:/etc/syslog-ng/syslog-ng.conf -v ~/Projetos/pegasus/syslog/logs:/var/log -p 514:514 -p 601:601 –name syslog-ng balabit/syslog-ng:latest -edv
```
