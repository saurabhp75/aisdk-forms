#!/usr/bin/env bash
# Use this script to start a docker container for a local Redis instance
# On Linux and macOS you can run this script directly - `./start-redis.sh`

REDIS_CONTAINER_NAME=${1:-"ai-app-template-redis"}

# Check if Docker is installed
if ! [ -x "$(command -v docker)" ]; then
  echo -e "Docker is not installed. Please install docker and try again.\nDocker install guide: https://docs.docker.com/engine/install/"
  exit 1
fi

# Check if Docker daemon is running
if ! docker info > /dev/null 2>&1; then
  echo "Docker daemon is not running. Please start Docker and try again."
  exit 1
fi

# Check if the container is already running, inform the user and exit
if [ "$(docker ps -q -f name=$REDIS_CONTAINER_NAME)" ]; then
  echo "Redis container '$REDIS_CONTAINER_NAME' already running"
  exit 0
fi

# Check if the container exists but is stopped, start it, inform the user and exit
if [ "$(docker ps -q -a -f name=$REDIS_CONTAINER_NAME)" ]; then
  docker start "$REDIS_CONTAINER_NAME"
  echo "Existing redis container '$REDIS_CONTAINER_NAME' started"
  exit 0
fi

# import env variables from .env.local or .env
set -a
if [ -f .env.local ]; then
  source .env.local
elif [ -f .env ]; then
  source .env
fi

REDIS_PASSWORD=$(echo "$REDIS_URL" | awk -F':' '{print $3}' | awk -F'@' '{print $1}')
REDIS_PORT=$(echo "$REDIS_URL" | awk -F':' '{print $4}' | awk -F'\/' '{print $1}')

# If the password is "redis-pw" (default):
# Warn the user.
# Prompt to generate a random password.
# If declined, ask the user to change the password and exits.
# If accepted, generate a random password and update .env.
if [ "$REDIS_PASSWORD" == "redis-pw" ]; then
  echo "You are using the default Redis password"
  read -p "Should we generate a random password for you? [y/N]: " -r REPLY
  if ! [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Please change the default Redis password in the .env file and try again"
    exit 1
  fi
  # Generate a random URL-safe password
  REDIS_PASSWORD=$(openssl rand -base64 12 | tr '+/' '-_')
  sed -i -e "s#:redis-pw@#:$REDIS_PASSWORD@#" .env
fi

# Run a docker container  in background(-d) with the specified parameters: 
# Container name: REDIS_CONTAINER_NAME(ai-app-template-redis)
# password: REDIS_PASSWORD, 
# port: REDIS_PORT/host port(from .env) mapped to container port 6379
# Docker image used: redis(latest as there is no tag specified)
# The default command is overridden to start redis-server with the specified password
# Prints success message upon creation
docker run -d \
  --name $REDIS_CONTAINER_NAME \
  -p "$REDIS_PORT":6379 \
  redis \
  /bin/sh -c "redis-server --requirepass $REDIS_PASSWORD" \
  && echo "Redis container '$REDIS_CONTAINER_NAME' was successfully created"
