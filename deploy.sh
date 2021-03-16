
bundle
yarn install --check-files
rails assets:precompile
rails db:migrate
sudo service nginx restart


