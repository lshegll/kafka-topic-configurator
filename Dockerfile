FROM openjdk:8-jre-slim

ENV TOPIC_PATTERN=""
ENV ZK_HOST=localhost
ENV EXCLUDE_PATTERN=""
ENV TOPIC_CONFIG=""


RUN apt-get update && apt-get install -y --no-install-recommends \
	wget \
    && rm -rf /var/lib/apt/lists/* 
RUN wget http://apache.cp.if.ua/kafka/1.1.0/kafka_2.11-1.1.0.tgz && tar -xzf kafka_2.11-1.1.0.tgz -C /usr/local/ && \
    ln -s /usr/local/kafka_2.11-1.1.0/ /usr/local/kafka

COPY topic-configurator.sh /
RUN chmod +x /topic-configurator.sh
CMD /topic-configurator.sh