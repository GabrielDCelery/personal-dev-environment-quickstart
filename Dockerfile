FROM ubuntu:22.04

RUN apt update && \
    apt upgrade -y;

RUN yes | unminimize;

RUN apt install python3 python3-pip -y && \
    pip3 install --upgrade pip;

RUN pip3 install ansible && \
    ansible --version;

RUN apt install sudo -y;

ARG MY_USER_NAME=gaze
ARG MY_USER_ID=1001
ARG MY_GROUP_NAME=gaze
ARG MY_GROUP_ID=1001

RUN getent group ${MY_GROUP_ID} || groupadd --gid ${MY_GROUP_ID} ${MY_GROUP_NAME}
RUN useradd -m ${MY_USER_NAME} -u ${MY_USER_ID} -g ${MY_GROUP_ID}

RUN echo "${MY_USER_NAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${MY_USER_NAME}
RUN visudo -cf /etc/sudoers.d/${MY_USER_NAME}

USER ${MY_USER_NAME}

WORKDIR /home/${MY_USER_NAME}

COPY . ./.init-work-environment

ENV MY_USER_NAME=${MY_USER_NAME}

ENTRYPOINT ansible-playbook /home/$MY_USER_NAME/.init-work-environment/local.yaml && sleep infinity
