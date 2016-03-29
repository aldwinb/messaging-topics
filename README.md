# messaging-topics #

A sample publish-subscribe microservice ecosystem that uses topics. It uses RabbitMQ as its message broker.

### How do I run the ecosystem? ###

```
bash simulation.bash [number_of_messages]
```

This is going to start a publish-subscribe simulation (using Docker containers). 
It will publish the number of messages passed (or 100 messages if not supplied).
Logs can be viewed in the stopped Docker containers.
