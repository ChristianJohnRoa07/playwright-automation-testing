FROM node:24

# Remove default user "node" from node base image
RUN userdel -r node

ARG DEV_CONTAINER_UID
ARG DEV_CONTAINER_GID

ENV USER_HOME="/home/dev"
ENV APP_HOME="/home/dev/code"

# Setup the dev environment
WORKDIR ${USER_HOME}

RUN addgroup --gid ${DEV_CONTAINER_GID} devgroup
RUN adduser --uid ${DEV_CONTAINER_UID} --gid ${DEV_CONTAINER_GID} --disabled-password --shell /bin/bash --home /home/dev dev
RUN mkdir -p .ssh && chmod 700 .ssh
COPY ./.devcontainer/.bash_history .bash_history
RUN chmod 600 .bash_history
COPY ./.devcontainer/.bashrc .bashrc


# Setup the app
WORKDIR ${APP_HOME}

# Change user
RUN chown -R dev:devgroup ${USER_HOME}
USER dev

CMD ["sleep", "infinity"]
