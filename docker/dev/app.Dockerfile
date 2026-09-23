FROM node:24

# Remove default user "node" from node base image
RUN userdel -r node

ARG DEV_CONTAINER_UID
ARG DEV_CONTAINER_GID

ENV USER_HOME="/home/dev"
ENV APP_HOME="/home/dev/code"

# Set Playwright browser install location to a shared directory
ENV PLAYWRIGHT_BROWSERS_PATH=/ms-playwright

# Setup the dev environment
WORKDIR ${USER_HOME}

RUN addgroup --gid ${DEV_CONTAINER_GID} devgroup
RUN adduser --uid ${DEV_CONTAINER_UID} --gid ${DEV_CONTAINER_GID} --disabled-password --shell /bin/bash --home /home/dev dev
RUN mkdir -p .ssh && chmod 700 .ssh

# Copy user config files with correct ownership
COPY --chown=dev:devgroup ./.devcontainer/.bash_history .bash_history
RUN chmod 600 .bash_history
COPY --chown=dev:devgroup ./.devcontainer/.bashrc .bashrc

# Install Playwright system dependencies AND browser binaries into shared folder
RUN npm install -g playwright && \
    npx playwright install-deps && \
    NODE_TLS_REJECT_UNAUTHORIZED=0 npx playwright install

# Ensure dev user owns home directory and shared browsers folder
RUN mkdir -p /ms-playwright && \
    chown -R dev:devgroup /ms-playwright && \
    chown -R dev:devgroup ${USER_HOME}

# Setup app directory and switch user
WORKDIR ${APP_HOME}
USER dev

CMD ["sleep", "infinity"]