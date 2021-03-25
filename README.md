The rails project is dockerized


You need to install docker to run this app docker

Steps to run in local machine

# create a .env file
cp .env.sample .env

# build the image (This may take a while in the first time)
docker-compose build

# start the containers
docker-compose up

# seed the database
docker-compose run app rails db:seed
