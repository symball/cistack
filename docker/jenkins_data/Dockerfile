FROM debian:jessie
# Using the same base image as Jenkins

MAINTAINER Simon Ball

# Create the jenkins user and set UID so that it is matched across containers
RUN useradd -d "/var/jenkins_home" -u 1000 -m -s /bin/bash jenkins

RUN mkdir -p /var/log/jenkins
RUN chown -R jenkins:jenkins /var/log/jenkins

VOLUME ["/var/log/jenkins", "/var/jenkins_home"]

USER jenkins
CMD ["echo", "Data container up"]
