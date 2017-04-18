# rabbitmq-worker
A Docker Container that acts as a RabbitMQ Worker

Status: Working

You need 2 Files that are exposed in your volumes
- /usr/local/etc/rabbitmq-worker
- /usr/local/bin/myworker

The first is the configuration for your RabbitMQ Server, Queue etc. in YAML format.
The second ist your script that is startet as a message occurs.

Watch the two example files in this repo
