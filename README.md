# gzweb-rosssh
Dockerized Gazebo Web with ROS and ssh

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
docker build -t gzweb-rosssh .
```
