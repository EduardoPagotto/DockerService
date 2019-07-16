  #!/bin/bash
  sudo rm -rf ./data/*
  mkdir -p ./data/logs
  mkdir -p ./data/redis
  mkdir -p ./data/elk
  mkdir -p ./data/elasticsearch
  mkdir -p ./data/logstash
  mkdir -p ./data/nfs_volume
  mkdir -p ./data/mongo
  mkdir -p ./data/nfs_volume
  mkdir -p ./data/sinopia

  sudo chmod go-w ./filebeat/filebeat.yml
  sudo chown root.root ./filebeat/filebeat.yml