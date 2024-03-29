bash 'install_and_configure_nginx' do
  code <<-EOH
    sudo apt update
    sudo apt install nginx
    echo '

http {
  split_clients "${remote_addr}AAA" $frontend {
    50%     10.0.0.56:30000;
    *       10.0.0.69:30000;
  }

server {
  location / {
    proxy_pass http://$frontend;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
  }
}

    ' | sudo tee /etc/nginx/sites-available/default

    sudo systemctl restart nginx

  EOH
end