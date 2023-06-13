# 2023-06-13  10:56
===================

https://fedingo.com/how-to-uninstall-docker-in-ubuntu/

1. Find out packages to be deleted
----------------------------------
Open terminal and run the following command to determine which packages need to be deleted on your system.

    $ dpkg -l | grep -i docker
ii  docker-buildx-plugin                  0.10.5-1~ubuntu.22.04~jammy                              amd64        Docker Buildx cli plugin.
ii  docker-ce                             5:24.0.2-1~ubuntu.22.04~jammy                            amd64        Docker: the open-source application container engine
ii  docker-ce-cli                         5:24.0.2-1~ubuntu.22.04~jammy                            amd64        Docker CLI: the open-source application container engine
ii  docker-ce-rootless-extras             5:24.0.2-1~ubuntu.22.04~jammy                            amd64        Rootless support for Docker.
ii  docker-compose-plugin                 2.18.1-1~ubuntu.22.04~jammy                              amd64        Docker Compose (V2) plugin for the Docker CLI.
ii  docker-desktop                        4.20.1-110738                                            amd64        Docker Desktop is an easy-to-install application that enables you to locally build and share containerized applications and microservices. It includes Docker Engine, Docker CLI client, Docker Compose, Docker Content Trust, Kubernetes, and Credential Helper. Docker Desktop runs a light-weight Linux VM to provide an isolated local container runtime, and an experience consistent with Mac and Windows versions of Docker Desktop.
uh@u


2. Delete packages
----------------------------------
    $ sudo apt-get purge -y docker-engine docker docker.io docker-ce docker-ce-cli
    $ sudo apt-get autoremove -y --purge docker-engine docker docker.io docker-ce
    $ sudo apt-get autoremove -y --purge docker-buildx-plugin docker-compose-plugin

This will remove all docker-related packages from your system. However, it will not remove images, containers, volumes, or user created configuration files on your host.
    $ dpkg -l | grep -i docker
# To check


3. Delete Remaining Files
----------------------------------
Run the following commands to delete all images, containers, volumes, user created configuration files. Do this only if you are sure you don’t need to use Docker again. Otherwise, if you re-install Docker, you will not be able to access these files.

$ sudo rm -rf /var/lib/docker /etc/docker
$ sudo rm /etc/apparmor.d/docker
$ sudo groupdel docker
$ sudo rm -rf /var/run/docker.sock

Depending on your system, you may also need to run the following commands.

$ sudo rm -rf /usr/local/bin/docker-compose
$ sudo rm -rf /etc/docker
$ sudo rm -rf ~/.docker


4. Final checks
----------------------------------
    $ journalctl --disk-usage
Archived and active journals take up 1.7G in the file system.
# 4.1 - If you decide to clear the logs, run command to rotate the journal files. All currently active journal files will be marked as archived, so that they are never written to in future.
    $ sudo journalctl --rotate
# 4.2 - Now clear the journal logs by choosing one of following commands:
Delete journal logs older than X days:
    $ sudo journalctl --vacuum-time=2days
Delete log files until the disk space taken falls below the specified size:
    $ sudo journalctl --vacuum-size=100M
Delete old logs and limit file number to X:
    $ sudo journalctl --vacuum-files=5
# 4.3 - You can also edit the configuration file to limit the journal log disk usage (100 MB for example).
    $ sudo -H vim /etc/systemd/journald.conf
...
SystemMaxUse=250M
...

# 4.4 - Finally reload systemd daemon via command:

    $ systemctl daemon-reload

