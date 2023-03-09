#!/bin/bash
#deploy the application
ls -l
mkdir react_app && mv -f * react_app
tar -cvzf react_app.tar.gz react_app
scp -o StrictHostKeyChecking=no -i $key react_app.tar.gz ubuntu@43.207.231.100:/home/ubuntu
ssh -T -o StrictHostKeyChecking=no -i $key ubuntu@43.207.231.100<<EOF
cd /home/ubuntu
rm -rf react_app || true
sudo docker system prune -y
tar -xvzf react_app.tar.gz 
#deploy based on git hub branch commit
if [[ $GIT_BRANCH == origin/dev ]]
then
cd react_app
chmod +x build.sh
./build.sh
docker login --username=$docker_username --password=$docker_password
echo $docker_password | docker login -u $docker_username --password-stdin
docker image push jeeviarajsam/reactapp_dev:v1
elif [[ $GIT_BRANCH == origin/master ]]
then
cd react_app
chmod +x build.sh
./build.sh
docker login --username=$docker_username --password=$docker_password
echo $docker_password | docker login -u $docker_username --password-stdin
docker image push jeeviarajsam/reactapp_dev:v1
else
echo "error data"
fi
