bash 'install_and_configure_nginx' do
  code <<-EOH
    sudo apt update
    sudo apt install nginx -y
    echo 'server {

    location / {
        proxy_pass http://10.0.0.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    
}
    ' | sudo tee /etc/nginx/sites-available/default >/dev/null


    sudo systemctl restart nginx
  EOH
end
