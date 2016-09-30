FROM symball/jenkins

# Switch to the root user
USER root

# Make sure cert permissions are set correctly
RUN chmod +r /usr/local/etc/jenkins/certs/ca.pem
RUN chmod +r /usr/local/etc/jenkins/certs/cert.pem
RUN chown -R jenkins:jenkins /usr/local/etc/jenkins

RUN chmod +x /usr/local/bin/jenkins.sh
# RUN chmod 755 /usr/local/bin/jenkins.sh
RUN chown jenkins:jenkins /usr/local/bin/jenkins.sh

# Switch to the jenkins user
USER jenkins
ENTRYPOINT ["/bin/tini", "--", "/usr/local/bin/jenkins.sh"]
