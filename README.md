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

## Requirements

This depends on the [AWS CLI][].

[AWS CLI]: http://aws.amazon.com/cli/
