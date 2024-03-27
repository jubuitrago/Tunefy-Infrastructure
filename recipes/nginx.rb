# Install nginx
package 'nginx' do
    action :install
  end
  
  # Initiate nginx service
  service 'nginx' do
    action [:enable, :start]
  end
  