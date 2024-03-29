bash 'install_and_configure_nginx' do
  code <<-EOH
    sudo apt update
    sudo apt install nginx -y

    sudo cat <<EOF > /etc/nginx/sites-available/default

      server {
        location / {
          proxy_pass http://10.0.0.56;
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
        }
      }
EOF

    sudo systemctl restart nginx
  EOH
end
