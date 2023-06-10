2023-06-08
------------------------------------------
# Plan of work:
    
    [1] - Create a sample Python application
    [2] - Create a new Dockerfile which contains instructions required to build a Python image
    [3] - Build an image and run the newly built image as a container
    [4] - Set up volumes and networking
    [5] - Orchestrate containers using Compose
    [6] - Use containers for development
    [7] - Configure a CI/CD pipeline for your application using GitHub Actions
    [8] - Deploy your application to the cloud

------------------------------------------


[1] - Create a sample Python application
=============
from flask import Flask
app = Flask(__name__)

@app.route("/")
def hello():
    return "Hello World!"
=============


[2] - Create a new Dockerfile which contains instructions required to build a Python image
=============
# syntax=docker/dockerfile:1
FROM ubuntu:22.04

# install app dependencies
RUN apt-get update && apt-get install -y python3 python3-pip
RUN pip install flask==2.1.*

# install app
COPY hello.py /

# final configuration
ENV FLASK_APP=hello
EXPOSE 8000
CMD flask run --host 0.0.0.0 --port 8000
=============


[3] - Build an image and run the newly built image as a container

    $ docker build -t k8spy:latest .
    $ docker tag k8spy:latest azrubael/k8spy:latest
    $ docker push azrubael/k8spy:latest
    $ docker rmi 6d894a7df5bf -f
    $ docker run -it -p 8000:8000 azrubael/k8spy:latest
Running on http://127.0.0.1:8000


--------------------------------------
    $ docker build -t azbionic8 .
    $ docker run -it --name azbionic8 -p 4444:8000 azbionic8:latest                                     