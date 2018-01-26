FROM slyons/all-spark-notebook:py35_spark21

USER root

ENV APACHE_SPARK_VERSION 2.1.0
ENV HADOOP_VERSION 2.7

ENV SPARK_HOME /usr/local/spark
ENV HAIL_HOME /usr/hail

RUN conda create -y -n ipykernel_py2 python=2 ipykernel && \
	/bin/bash -c "source activate ipykernel_py2 && python -m ipykernel install --user"

RUN cd /tmp && \
    wget https://storage.googleapis.com/hail-common/distributions/0.1/Hail-0.1-1214727c640f-Spark-2.1.0.zip && \
    unzip Hail-0.1-1214727c640f-Spark-2.1.0.zip && \
    mv hail /usr/hail

#RUN git clone https://github.com/broadinstitute/hail.git ${HAIL_HOME} && \
#    cd ${HAIL_HOME} && \
#    ./gradlew shadowJar && \
#    pip install py4j && \
#    echo 'alias pyhail="PYTHONPATH=$SPARK_HOME/python:$SPARK_HOME/python/lib/py4j-0.10.3-src.zip:$HAIL_HOME/python SPARK_CLASSPATH=$HAIL_HOME/build/libs/hail-all-spark.jar python"' >> ~/.bashrc

ENV PYTHONPATH $PYTHONPATH:$SPARK_HOME/python:$SPARK_HOME/python/lib/py4j-0.10.4-src.zip:$HAIL_HOME/python
ENV PATH $PATH:/usr/hail/bin/
ENV SPARK_CLASSPATH $SPARK_CLASSPATH:$SPARK_HOME/conf/:$SPARK_HOME/jars/*:$HAIL_HOME/jars/hail-all-spark.jar
ENV MESOS_NATIVE_LIBRARY /usr/local/lib/libmesos.so
ENV SPARK_OPTS --driver-java-options=-Xms1024M --driver-java-options=-Xmx4096M --driver-java-options=-Dlog4j.logLevel=info

USER $NB_USER