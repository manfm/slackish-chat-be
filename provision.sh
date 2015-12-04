#!/bin/bash --login

sudo -E apt-get install -y git
sudo -E apt-get install -y nodejs

sudo -E apt-get install -y libsqlite3-dev

sudo -E apt-get install -y postgresql postgresql-contrib libpq-dev
# create db user 'vagrant' and set password to pass1
sudo -u postgres createuser -s vagrant
sudo -u postgres psql -U postgres -d postgres -c "alter user vagrant with password 'pass1';"

wget -O- https://toolbelt.heroku.com/install-ubuntu.sh | sh

echo "cd /vagrant" >> /home/vagrant/.bashrc
