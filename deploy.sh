#!/bin/bash
#deploy the application
ls -la
mkdir react_app && cp -rf public src Dockerfile build.sh deploy.sh docker-compose.yml package-lock.json package.json react_app 
tar -cvzf react_app.tar.gz react_app
scp -o StrictHostKeyChecking=no -i $key react_app.tar.gz ubuntu@43.207.231.100:/home/ubuntu
ssh -T -o StrictHostKeyChecking=no -i $key ubuntu@43.207.231.100<<EOF
cd /home/ubuntu
irm -rf react_app || true
sudo docker system prune -fa
tar -xvzf react_app.tar.gz 
#deploy based on git hub branch commit
if [[ $GIT_BRANCH == origin/dev ]]
then
cd react_app
chmod +x build.sh
./build.sh
docker login --username=$docker_username --password=$docker_password
echo $docker_password | docker login -u $docker_username --password-stdin
docker image tag reactapp:v1 jeeviarajsam/reactapp_dev:v1
docker image push jeeviarajsam/reactapp_dev:v1
elif [[ $GIT_BRANCH == origin/master ]]
docker-compose up -d
then
cd react_app
chmod +x build.sh
./build.sh
docker login --username=$docker_username --password=$docker_password
echo $docker_password | docker login -u $docker_username --password-stdin
docker image tag reactapp:v1 jeeviarajsam/reactapp_production:v1
docker image push jeeviarajsam/reactapp_production:v1
docker-compose up -d
else
echo "error data"
fi
