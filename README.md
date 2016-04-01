# messaging-topics #

A sample publish-subscribe microservice ecosystem that uses topics.

Features:

* Scalable publishers and subscribers using 
[RabbitMQ](http://www.rabbitmq.com/getstarted.html) as their message broker
* Log collection framework using 
[logspout](https://github.com/gliderlabs/logspout) and 
[Logstash](https://www.elastic.co/guide/en/logstash/current/introduction.html)
* Components powered by [Docker](https://www.docker.com/what-docker)

### How do I run the ecosystem? ###

To start, run:
```
bash start.sh [publisher=desired_number subscriber=desired_number]
```

This will start the simulation. The 
publishers and subscribers will continue to publish and consume messages, 
respectively, until they are stopped. You have the option of running the 
desired number of instances you want for both publishers and subscribers 
(default for both is 1).

To stop, run:
```
bash stop.sh
```

### How can I view the logs collected? ###

Currently you can view the logs by running this command:
```
docker logs logstash-1
```

### TODO ###

* Add Elasticsearch and Kibana in the log collection framework


