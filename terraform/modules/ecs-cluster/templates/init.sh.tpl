bootcmd:
- mkdir -p /etc/ecs
- echo 'ECS_CLUSTER=${cluster}' >> /etc/ecs/ecs.config
- echo 'ECS_AVAILABLE_LOGGING_DRIVERS=["json-file","syslog","awslogs"]' >> /etc/ecs/ecs.config
- mkdir /etc/instance-metadata && curl http://169.254.169.254/latest/meta-data/local-ipv4 > /etc/instance-metadata/local-ipv4
- yum install -y vim
