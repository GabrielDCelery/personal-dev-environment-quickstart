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

```
==> Next steps:
- Run these two commands in your terminal to add Homebrew to your PATH:
    (echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> /home/gzeller/.zshrc
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
- Install Homebrew's dependencies if you have sudo access:
    sudo apt-get install build-essential
  For more information, see:
    https://docs.brew.sh/Homebrew-on-Linux
- We recommend that you install GCC:
    brew install gcc
- Run brew help to get started
- Further documentation:
    https://docs.brew.sh
```
