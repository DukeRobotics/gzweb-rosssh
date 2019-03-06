# gzweb-rosssh

Dockerized Gazebo Web with ROS and ssh.

Also available on DockerHub at [this](https://cloud.docker.com/repository/docker/vasilescur/gzweb-rosssh) link.

## Contents

- `ubuntu:xenial`
- ROS
- Gazebo Server
- Gazebo Web (webgz)
- ssh

## Usage

First, do:

```bash
docker pull vasilescur/gzweb-rosssh
```

Then, run with:

```bash
docker run -t -d -p 8080:8080 gzweb-rosssh
```

Use your browser to access the running web interface at `localhost:8080`.

## Building

To build the image, run:

```bash
docker build -t vasilescur/gzweb-rosssh .
```
