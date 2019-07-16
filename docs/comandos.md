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
