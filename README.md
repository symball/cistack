# Getting up and running

## Prerequisites
Before attempting to run the experiment, make sure you have the following installed
- docker
- docker-compose
- docker-machine
- virtualbox

###### Certificates
Copy the certificates from your Docker machine to the docker/Jenkins
```
Example
cp ~/.docker/machine/certs ~/development/cistack/docker/jenkins/certs
```

###### Start the Swarm
Run the bash script
```
sh setup-swarm.sh
```
Put yourself in context of the swarm manager
```
eval "$(docker-machine env --swarm swarm-manager)"
```

###### Fire up Docker
This may take a while the first time as it will pull images from DockerHub
```
docker-compose up
```
At this point, you should be able to point your browser to Jenkins; the default
user name and password is admin/admin. In order to discover where this might be,
open up another terminal list your docker machines
```
docker-machine ls
```

###### Configuration
Because we are in effect creating a brand new environment, there is an element of
configuration needed within Jenkins. The keys here are the same as copied to the
Jenkins docker file
** Credentials **
- Go to Credentials -> Global -> Add
- Choose Docker Host Certificate Authentication
- Client key field, paste the contents of key.pem
- Client Certification field, paste the contents of cert.pem
- Server CA Cert field, paste the contents of ca.pem

** Yet Another Docker Plugin (YADP) **
- Go to Jenkins global configuration
- Scroll down to Cloud
- Select YADP
- Set Docker Host URL. Use the current URL, so long as it is a swarm manager, Docker
makes sure it gets routed to whjere needed/ e.g http://192.168.99.100:2376
- Set Host Credentials to those created in the previous step

** Add a Docker template **
- Docker image name = The name of Android image after typing ```docker-compose ps```
from the swarm manager context
- Pull Image = Never
- Remove Container Settings = remove volume
- Jenkins Slave config = androidslave <-- This is a label we will use in pipeline
- Launch method = JNLP
- Save

###### Testing it out
Now, we can use the aforementioned Docker image at any point in the pipeline by
referencing the Jenkins Slave config as the node name. A quick example
```
node ('androidslave') {
  stage 'Greetings'
   sh 'echo "Go go M800 Swarm!"'
  stage 'Checkout'
  ....
  stage 'build'
  ....
}
