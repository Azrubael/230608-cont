#/bin/bash

# docker container ls -a
# docker container start <ID>
# docker container stop <ID>
# docker rm <container ID> -f
# docker rmi <image ID> -f

docker builder prune --all
docker build -t azbionic .
docker docker images

# docker run -it --name azbionic1 -p 4444:80 azbionic:latest
# docker exec -it <container ID> /bin/bash