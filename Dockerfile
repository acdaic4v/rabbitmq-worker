# Dockerfile acdaic4v/rabbitmq-worker
FROM acdaic4v/ubuntu-perl-rabbitmq:v20170330
MAINTAINER acdaic4v

LABEL Description="Create Docker Image that acts as a RabbitMQ Worker" Vendor="acdaic4v" Version="1"

# Get my scripts
RUN cd /usr/local/bin && git clone https://github.com/acdaic4v/rabbitmq-worker.git rabbitmq-worker

# Create User and group
RUN groupadd -r rabbit && useradd -r -g rabbit rabbit
RUN chown -R rabbit /usr/local/bin/rabbitmq-worker
RUN chmod u+x /usr/local/bin/rabbitmq-worker/rabbitmq-worker.pl

# YAML File with Configuration
VOLUME /usr/local/etc/rabbitmq-worker/rabbitmq-worker.yml
# Your Script to run
VOLUME /usr/local/bin/worker.pl

ENTRYPOINT /usr/local/bin/rabbitmq-worker/rabbitmq-worker.pl
