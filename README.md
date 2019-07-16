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

# Registro dos servicos de docker no boot da maquina
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

## Resumo dos Serviços
- [E.L.K.](docs/elk.md)
- [Redis](docs/redis.md)
- [MongoDB](docs/mongodb.md)
- [Syslog-ng](docs/syslog-ng.md)
- [Comandos Uteis docker](docs/comandos.md)
