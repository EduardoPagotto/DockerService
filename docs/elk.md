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
