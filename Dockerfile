FROM sequenceiq/spark:1.3.0

RUN mkdir -p /opt/spark/lib
RUN cd /opt/spark/lib && curl -L 'http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.30.tar.gz' -o - | tar -xz --strip-components=1 mysql-connector-java-5.1.30/mysql-connector-java-5.1.30-bin.jar
RUN curl -L 'http://jdbc.postgresql.org/download/postgresql-9.2-1002.jdbc4.jar' -o /opt/spark/lib/postgresql-9.2-1002.jdbc4.jar

ENV SPARK_CLASSPATH /opt/spark/lib/mysql-connector-java-5.1.30-bin.jar:/opt/spark/lib/postgresql-9.2-1002.jdbc4.jar

RUN rpm -ivh http://ftp-srv2.kddilabs.jp/Linux/distributions/fedora/epel/6/x86_64/epel-release-6-8.noarch.rpm

RUN yum -y install redis --enablerepo=epel

COPY spark-defaults.conf /opt/spark-defaults.conf

COPY entrypoint.sh /opt/entrypoint.sh

ENV COMMAND_JAR_DIR /opt/command.d

ENV COMMAND_JAR_NAME command.jar

VOLUME [$COMMAND_JAR_DIR"]

ENTRYPOINT ["/opt/entrypoint.sh"]
