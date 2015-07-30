# Deployment

To deploy an environment:

    ./create-env.sh $ENV_NAME

To deploy mint to this environment, first copy mint.jar to /srv/mint
on it, then ssh to it and run:

    docker run -p 4567:4567 \
        -v /srv/mint:/srv/mint \
        --link etc_postgres_1:postgres \
        --link etc_kafka_1:kafka \
        jstepien/openjdk8 java -jar /srv/mint/mint.jar


To deploy presentation to this environment, first copy presentation.jar to /srv/presentation
on it, then ssh to it and run:

    docker run --volume /home/saqib:/srv/presentation \
        --link etc_kafka_1:kafka \
        --link etc_zookeeper_1:zookeeper \
        --link etc_postgres_1:postgres \
        jstepien/openjdk8 java -jar /srv/presentation/presentation.jar server /srv/presentation/config.yaml

## Requirements

This depends on the [AWS CLI][].

[AWS CLI]: http://aws.amazon.com/cli/
