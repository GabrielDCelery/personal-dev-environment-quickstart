# What is this repository for?

To be able to quickly set up a working development environment on a new machine.

## How to run it?

1. Build the docker container containing the setup scripts

```sh
docker build --build-arg MY_USER_ID=$(id -u) --build-arg MY_GROUP_ID=$(id -g) -t gaze/dev:latest .
```

2. Run the docker container

```sh
docker run --rm -dt -v ~/.ssh:/home/gaze/.ssh -v ./:/home/gaze/.init-work-environment --name gaze_dev gaze/dev:latest
```

3. Enter the docker container for development

```sh
docker exec -it $(docker ps -q --filter name=gaze_dev) zsh
```
