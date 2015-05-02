#! /bin/bash

# WAIT_CONTAINER_TIMER
# WAIT_CONTAINER_FILE
# WAIT_CONTAINER_KEY

# set -x

set -e

echo MySQL host: ${MYSQL_SERVER_HOST:=$MYSQL_PORT_3306_TCP_ADDR}
echo MySQL port: ${MYSQL_SERVER_PORT:=$MYSQL_PORT_3306_TCP_PORT}
echo PostgreSQL host: ${POSTGRESQL_SERVER_HOST:=$POSTGRESQL_PORT_5432_TCP_ADDR}
echo PostgreSQL port: ${POSTGRESQL_SERVER_PORT:=$POSTGRESQL_PORT_5432_TCP_PORT}
echo Redis host: ${REDIS_SERVER_HOST:=$REDIS_PORT_6379_TCP_ADDR}
echo Redis port: ${REDIS_SERVER_PORT:=$REDIS_PORT_6379_TCP_PORT}
export MYSQL_SERVER_HOST
export MYSQL_SERVER_PORT
export POSTGRESQL_SERVER_HOST
export POSTGRESQL_SERVER_PORT
export REDIS_SERVER_HOST
export REDIS_SERVER_PORT

function wait_container {
    if [ -n "$REDIS_SERVER_HOST" ]; then
	wait_container_redis
    elif [ -n "$WAIT_CONTAINER_FILE" ]; then
	wait_container_file
    fi
}

function wait_container_redis {
    result=1
    for i in $(seq 1 ${WAIT_CONTAINER_TIMER:-100})
    do
	sleep 1s
	result=0
	if [ $(redis-cli -h $REDIS_SERVER_HOST -p $REDIS_SERVER_PORT GET $WAIT_CONTAINER_KEY)'' = "up" ]; then
	    break
	fi
	echo spark-sql-scala-docker wait: $REDIS_SERVER_HOST
	result=1
    done
    if [ $result = 1 ]; then
	exit 1
    fi
}

function wait_container_file {
    result=1
    for i in $(seq 1 ${WAIT_CONTAINER_TIMER:-100})
    do
	sleep 1s
	result=0
	if [ -e $WAIT_CONTAINER_FILE ]; then
	    break
	fi
	echo spark-sql-scala-docker wait: $WAIT_CONTAINER_FILE
	result=1
    done
    if [ $result = 1 ]; then
	exit 1
    fi
}

COMMAND_JAR=$COMMAND_JAR_DIR/$COMMAND_JAR_NAME

wait_container

sed -i "s!hdfs://.*:9000!file:\/\/\/tmp!g" /usr/local/hadoop/etc/hadoop/core-site.xml

cat /usr/local/hadoop/etc/hadoop/core-site.xml

spark-submit --properties-file /opt/spark-defaults.conf $COMMAND_JAR
