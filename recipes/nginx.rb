# recipes/default.rb

# Instalar el paquete Nginx
package 'nginx' do
    action :install
  end
  
  # Iniciar y habilitar el servicio Nginx
  service 'nginx' do
    action [:enable, :start]
  end
  