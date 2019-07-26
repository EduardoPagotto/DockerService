  #!/bin/bash
  sudo rm -rf ./data/*
  mkdir -p ./data/logs
  mkdir -p ./data/redis
  mkdir -p ./data/elk
  #mkdir -p ./data/mysql
  #mkdir -p ./data/nfs_volume
  #mkdir -p ./data/mongo
  #mkdir -p ./data/nfs_volume

  sudo chmod go-w ./elk/filebeat/filebeat.yml
  sudo chown root.root ./elk/filebeat/filebeat.yml