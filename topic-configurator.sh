#!/usr/bin/env bash

set -euo pipefail

KAFKA_BASE_DIR="/usr/local/kafka"

get_topics() {
       if [ ! -z "$EXCLUDE_PATTERN" ]; then
		local topics=$(${KAFKA_BASE_DIR}/bin/kafka-topics.sh --zookeeper ${ZK_HOST}:2181 --list | grep ${TOPIC_PATTERN} | grep -v ${EXCLUDE_PATTERN}  )
	else
		local topics=$(${KAFKA_BASE_DIR}/bin/kafka-topics.sh --zookeeper ${ZK_HOST}:2181 --list | grep ${TOPIC_PATTERN} )
	fi
	echo "$topics"
}

if [ ! -z "$TOPIC_PATTERN" ] || [ ! -z "$TOPIC_CONFIG" ]; then
  TOPICS=$(get_topics)
  for TOPIC in $TOPICS; do 
      echo "Changing retention policy for $TOPIC"
      exec ${KAFKA_BASE_DIR}/bin/kafka-configs.sh --zookeeper ${ZK_HOST}:2181 --alter --entity-type topics --entity-name $TOPIC --add-config ${TOPIC_CONFIG}
      OUT=$?
      if [ $OUT -ne 0 ]; then
        echo "Failed update config for topic $TOPIC"
      exit $OUT
      fi
   done
else
  echo "Variable TOPIC_PATTERN or TOPIC_CONFIG not defined exiting.."
  exit 1
fi
