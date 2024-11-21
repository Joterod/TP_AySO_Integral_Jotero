# -*- mode: ruby -*-
# vi: set ft=ruby :


Vagrant.configure("2") do |config|
  project = File.expand_path("./")
  config.vm.define "produccion" do |produccion|
    produccion.vm.box = "generic/fedora36"
    produccion.vm.hostname = "produccion"
    produccion.vm.network "private_network", :name => '', ip: "192.168.56.5"
    
    # Comparto la carpeta del host donde estoy parado contra la vm
    produccion.vm.synced_folder project, '/vagrant/', 
    owner: 'vagrant', group: 'vagrant' 

      # Agrega la key Privada de ssh en .vagrant/machines/default/virtualbox/private_key
      produccion.ssh.insert_key = true
      # Agrego un nuevo disco 
      produccion.vm.disk :disk, size: "10GB", name: "#{produccion.vm.hostname}_extra_storage"
      produccion.vm.disk :disk, size: "5GB", name: "#{produccion.vm.hostname}_extra_storage2"
      produccion.vm.disk :disk, size: "2GB", name: "#{produccion.vm.hostname}_extra_storage3"
      produccion.vm.disk :disk, size: "1GB", name: "#{produccion.vm.hostname}_extra_storage4"

      produccion.vm.provider "virtualbox" do |vb|
        vb.memory = "1024"
        vb.name = "produccion"
        vb.cpus = 1
        vb.linked_clone = true
        # Seteo controladora Grafica
        vb.customize ['modifyvm', :id, '--graphicscontroller', 'vmsvga']      
      end    
      # Puedo Ejecutar un script que esta en un archivo
      produccion.vm.provision "shell", path: "scripts/script_Enable_ssh_password.sh"
      produccion.vm.provision "shell", path: "scripts/instalacion.sh"
      produccion.vm.provision "shell", path: "scripts/aprovisionamiento.sh"
      produccion.vm.provision "shell", path: "scripts/lvm.sh"
      produccion.vm.provision "shell", privileged: false, inline: <<-SHELL
      # Los comandos aca se ejecutan como vagrant
  
      mkdir -p /home/vagrant/repogit
      cd /home/vagrant/repogit
      echo "192.168.56.4 testing" | sudo tee -a /etc/hosts

      # No requerir pass de sudo
      echo "vagrant ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/vagrant
      sudo chmod 0440 /etc/sudoers.d/vagrant
            # Ejecutamos el playbook de Ansible
      cd /vagrant/ansible/
      reset; ansible-playbook -i inventory/hosts playbook.yml
      cd
    SHELL
    produccion.vm.provision "shell", path: "bash_script/alta_usuarios/alta_usuarios.sh", args: ["/vagrant/bash_script/alta_usuarios/Lista_Usuarios.txt","vagrant"]
    produccion.vm.provision "shell", path: "bash_script/check_url/check_url.sh", args: ["/vagrant/bash_script/check_url/Lista_URL.txt"]
  end

  config.vm.define "testing" do |testing|
    testing.vm.box = "ubuntu/jammy64"
    testing.vm.hostname = "testing"
    testing.vm.network "private_network", :name => '', ip: "192.168.56.4"
    
    # Comparto la carpeta del host donde estoy parado contra la vm
    testing.vm.synced_folder project ,'/vagrant_testing/', 
    owner: 'vagrant', group: 'vagrant' 

      # Agrega la key Privada de ssh en .vagrant/machines/default/virtualbox/private_key
      testing.ssh.insert_key = true
      # Agrego un nuevo disco 
      testing.vm.disk :disk, size: "10GB", name: "#{testing.vm.hostname}_extra_storage"
      testing.vm.disk :disk, size: "5GB", name: "#{testing.vm.hostname}_extra_storage2"
      testing.vm.disk :disk, size: "2GB", name: "#{testing.vm.hostname}_extra_storage3"
      testing.vm.disk :disk, size: "1GB", name: "#{testing.vm.hostname}_extra_storage4"

      testing.vm.provider "virtualbox" do |vb|
        vb.memory = "1024"
        vb.name = "testing"
        vb.cpus = 1
        vb.linked_clone = true
        # Seteo controladora Grafica
        vb.customize ['modifyvm', :id, '--graphicscontroller', 'vmsvga']      
      end    
      # Puedo Ejecutar un script que esta en un archivo
      testing.vm.provision "shell", path: "scripts/script_Enable_ssh_password.sh"
      testing.vm.provision "shell", path: "scripts/instalacion.sh"
      testing.vm.provision "shell", path: "scripts/aprovisionamiento.sh"
      testing.vm.provision "shell", path: "scripts/lvm.sh"
      testing.vm.provision "shell", privileged: false, inline: <<-SHELL
      # Los comandos aca se ejecutan como vagrant
  
      mkdir -p /home/vagrant/repogit
      cd /home/vagrant/repogit
      echo "192.168.56.5 produccion" | sudo tee -a /etc/hosts
      
      # No requerir pass de sudo
      echo "vagrant ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/vagrant
      sudo chmod 0440 /etc/sudoers.d/vagrant
      
      # Ejecutamos el playbook de Ansible
      cd /vagrant_testing/ansible/
      reset; ansible-playbook -i inventory/hosts playbook.yml
    SHELL
    testing.vm.provision "shell", path: "bash_script/alta_usuarios/alta_usuarios.sh", args: ["/vagrant_testing/bash_script/alta_usuarios/Lista_Usuarios.txt","vagrant"]
    testing.vm.provision "shell", path: "bash_script/check_url/check_url.sh", args: ["/vagrant_testing/bash_script/check_url/Lista_URL.txt"]
  end
end