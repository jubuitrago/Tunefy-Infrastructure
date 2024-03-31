bash 'install_and_configure_replica_database' do
    code <<-EOH
        sudo sh -c 'echo "deb https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
        wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
        sudo apt-get update
        sudo apt-get -y install postgresql
        
        sudo systemctl stop postgresql
        sudo sed -i "s/#hot_standby = on/hot_standby = on/" /etc/postgresql/16/main/postgresql.conf
        sudo su - postgres
        cp -R /var/lib/postgresql/16/main /var/lib/postgresql/16/main_bak
        rm -rf /var/lib/postgresql/16/main/*
        pg_basebackup -h PRIMARY_DATABASE_IPX -D /var/lib/postgresql/16/main -U replicator -P -v -R -w
        sudo -u ubuntu systemctl start postgresql
    EOH
end