bash 'install_and_configure_primary_database' do
    code <<-EOH
        sudo sh -c 'echo "deb https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
        wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
        sudo apt-get update
        sudo apt-get -y install postgresql
        
        sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" /etc/postgresql/16/main/postgresql.conf
        sudo sed -i "s/#wal_level = replica/wal_level = replica/" /etc/postgresql/16/main/postgresql.conf
        echo "host all all 0.0.0.0/0 md5" | sudo tee -a /etc/postgresql/16/main/pg_hba.conf > /dev/null
        echo "host replication replicator REPLICA_DATABASE_IPX/32 scram-sha-256" | sudo tee -a /etc/postgresql/16/main/pg_hba.conf > /dev/null
        sudo systemctl restart postgresql
        sudo -u postgres psql -c "CREATE DATABASE tunefy_database;"
        sudo -u postgres createuser --replication -P '1231' -e replicator

        wget https://raw.githubusercontent.com/jubuitrago/Tunefy/main/database/scripts/init.sql -P /tmp/
        sudo -u postgres psql -d tunefy_database -f /tmp/init.sql
        #sudo -u postgres psql -d tunefy_database
    EOH
end