cd /home/ubuntu/chef-repo/cookbooks
chef generate cookbook nginx
cd nginx/recipes





sudo knife ssh "name:nginx_node" "sudo chef-client" -x ubuntu -i tunefy-global-key.pem