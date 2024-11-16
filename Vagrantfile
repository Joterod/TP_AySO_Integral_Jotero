# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.define "testing" do |testing|
    testing.vm.box = "ubuntu/jammy64"
    testing.vm.hostname = "testing"
    testing.vm.network "private_network", :name => '', ip: "192.168.56.4"
    
    # Comparto la carpeta del host donde estoy parado contra la vm
    testing.vm.synced_folder 'compartido_testing/', '/home/vagrant/compartido', 
    owner: 'vagrant', group: 'vagrant' 

      # Agrega la key Privada de ssh en .vagrant/machines/default/virtualbox/private_key
      testing.ssh.insert_key = true
      # Agrego un nuevo disco 
      testing.vm.disk :disk, size: "5GB", name: "#{testing.vm.hostname}_extra_storage_1"
      testing.vm.disk :disk, size: "3GB", name: "#{testing.vm.hostname}_extra_storage_2"
      testing.vm.disk :disk, size: "2GB", name: "#{testing.vm.hostname}_extra_storage_3"
      testing.vm.disk :disk, size: "1GB", name: "#{testing.vm.hostname}_extra_storage_4"

      testing.vm.provider "virtualbox" do |vb|
        vb.memory = "1024"
        vb.name = "testing"
        vb.cpus = 1
        vb.linked_clone = true
        # Seteo controladora Grafica
        vb.customize ['modifyvm', :id, '--graphicscontroller', 'vmsvga']      
      end    
      # Puedo Ejecutar un script que esta en un archivo
      testing.vm.provision "shell", path: "script_Enable_ssh_password.sh"
      testing.vm.provision "shell", path: "instala_paquetes.sh"
      config.vm.provision "shell", privileged: false, inline: <<-SHELL
      # Los comandos aca se ejecutan como vagrant
  
      mkdir -p /home/vagrant/repogit
      cd /home/vagrant/repogit


    SHELL
    end
    
    
    config.vm.define :produccion do |produccion|
      produccion.vm.box = "generic/fedora38"
      produccion.vm.hostname = "produccion"
      produccion.vm.network "private_network", :name => '', ip: "192.168.56.5"
      
      # Comparto la carpeta del host donde estoy parado contra la vm
      produccion.vm.synced_folder 'compartido_produccion/', '/home/vagrant/compartido'
  
    # Agrega la key Privada de ssh en .vagrant/machines/default/virtualbox/private_key
    produccion.ssh.insert_key = true
    produccion.vm.provision "shell", path: "script_Enable_ssh_password.sh"
    produccion.vm.provider "virtualbox" do |vb2|
      vb2.memory = "1024"
      vb2.name = "produccion"
      vb2.cpus = 1
      vb2.linked_clone = true
      # Seteo controladora Grafica
      vb2.customize ['modifyvm', :id, '--graphicscontroller', 'vmsvga']
    end
    
    
    # Puedo Ejecutar un script que esta en un archivo
    produccion.vm.provision "shell", path: "script_Enable_ssh_password.sh"
    
    # Provisión para instalar
    produccion.vm.provision "shell", inline: <<-SHELL
      sudo dnf install -y /home/vagrant/compartido/tree-1.8.0-10.el9.x86_64.rpm

      subscription-manager repos --enable codeready-builder-for-rhel-9-$(arch)-rpms
      dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
    SHELL
  end
end
