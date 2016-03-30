# messaging-topics #

A sample publish-subscribe microservice ecosystem that uses topics. It uses 
RabbitMQ as its message broker.

### How do I run the ecosystem? ###

To start, run:
```
bash start.bash [publisher=desired_number subscriber=desired_number]
```

This will start the simulation (using Docker containers). The 
publishers and subscribers will continue to publish and consume messages, 
respectively, until they are stopped. You have the option of running the 
desired number of instances you want for both publishers and subscribers 
(default for both is 1).

To stop, run:
```
bash stop.bash
```

Logs can be viewed in the Docker containers.
