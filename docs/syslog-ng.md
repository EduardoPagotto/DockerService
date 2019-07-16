
# Teste do syslog
```bash 
docker run -it -v ~/Projetos/pegasus/syslog/conf/syslog-ng.conf:/etc/syslog-ng/syslog-ng.conf -v ~/Projetos/pegasus/syslog/logs:/var/log -p 514:514 -p 601:601 –name syslog-ng balabit/syslog-ng:latest -edv
```
