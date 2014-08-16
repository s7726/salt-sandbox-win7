domain = 'example.com'
lin_hosts_path = '/etc/hosts'
win_hosts_path = 'C:/Windows/System32/drivers/etc/hosts'
$hosts_script_lin = <<HOSTS
sudo echo 127.0.0.1       localhost > #{lin_hosts_path}
sudo echo 172.16.42.10 salt.#{domain} salt >> #{lin_hosts_path}
sudo echo 172.16.42.11 minion1.#{domain} minion1 >> #{lin_hosts_path}
sudo echo 172.16.42.12 minion2.#{domain} minion2 >> #{lin_hosts_path}
HOSTS

$hosts_script_win = <<HOSTS
echo "127.0.0.1 localhost" | Out-File #{win_hosts_path} -Encoding "ASCII" -Force
echo "172.16.42.10 salt.#{domain} salt" | Out-File #{win_hosts_path} -Encoding "ASCII" -Append -Force
echo "172.16.42.11 minion1.#{domain} minion1" | Out-File #{win_hosts_path} -Encoding "ASCII" -Append -Force
echo "172.16.42.12 minion2.#{domain} minion2" | Out-File #{win_hosts_path} -Encoding "ASCII" -Append -Force
ipconfig /flushdns
HOSTS

Vagrant.configure("2") do |config|
  config.vm.define :master do |master_config|
    ## Choose your base box
    master_config.vm.box = "hashicorp/precise64"

    config.vm.provider "virtualbox" do |vb|
      vb.name = "salt-master-precise64"
      vb.customize ["modifyvm", :id, "--accelerate3d", "off"]
      vb.customize ["modifyvm", :id, "--memory", "512"]
      vb.customize ["modifyvm", :id, "--vram", "10"]
      vb.customize ["modifyvm", :id, "--vrde", "on"]
      vb.customize ["modifyvm", :id, "--vrdeport", "3389"]
    end

    ## For masterless, mount your salt file root
    master_config.vm.synced_folder "salt/roots/", "/srv/salt/"

    master_config.vm.host_name = "salt.#{domain}"
    master_config.vm.network "private_network", ip: '172.16.42.10'
    master_config.vm.provision "shell", inline: $hosts_script_lin

    ## Use all the defaults:
    master_config.vm.provision :salt do |salt|

      # These are more useful when connecting to a remote master
      # and you want to use pre-seeded keys (already accepted on master)
      ## !! Please do not use these keys in production!
      salt.minion_key = "salt/key/minion.pem"
      salt.minion_pub = "salt/key/minion.pub"

      # Good for multi-vm setups where live minions are expecting
      # existing master
      ## !! Please do not use these keys in production!
      salt.master_key = "salt/key/master.pem"
      salt.master_pub = "salt/key/master.pub"

      # Pre-seed your master (recommended)
      salt.seed_master = {"salt" => salt.minion_pub,
                          "minion1.example.com" => "salt/key/minion1.example.com.pub",
                          "minion2.example.com" => "salt/key/minion2.example.com.pub"}

      salt.install_master = true
      salt.master_config = "salt/master"
      salt.minion_config = "salt/minion"
      salt.run_highstate = true
      salt.log_level  = "debug"

    end
  end

  config.vm.define :minion1 do |minion_config|
    ## Choose your base box
    minion_config.vm.box = "hashicorp/precise64"

    config.vm.provider "virtualbox" do |vb|
      vb.name = "salt-minion-precise64"
      vb.customize ["modifyvm", :id, "--accelerate3d", "off"]
      vb.customize ["modifyvm", :id, "--memory", "512"]
      vb.customize ["modifyvm", :id, "--vram", "10"]
      vb.customize ["modifyvm", :id, "--vrde", "on"]
      vb.customize ["modifyvm", :id, "--vrdeport", "3390"]
    end

    minion_config.vm.host_name = "minion1.#{domain}"
    minion_config.vm.network "private_network", ip: '172.16.42.11'
    minion_config.vm.provision "shell", inline: $hosts_script_lin

    ## Use all the defaults:
    minion_config.vm.provision :salt do |salt|

      # These are more useful when connecting to a remote master
      # and you want to use pre-seeded keys (already accepted on master)
      ## !! Please do not use these keys in production!
      salt.minion_key = "salt/key/minion1.example.com.pem"
      salt.minion_pub = "salt/key/minion1.example.com.pub"

      salt.minion_config = "salt/minion"
      salt.run_highstate = true
      salt.log_level  = "debug"

    end
  end

  config.vm.define :minion2 do |minion_config|
    ## Choose your base box
    minion_config.vm.box = "lmayorga1980/windows7-sp1"
    minion_config.vm.communicator = "winrm"

    config.vm.provider "virtualbox" do |vb|
      vb.name = "salt-minion-windows"
      vb.gui = true
      vb.customize ["modifyvm", :id, "--accelerate3d", "on"]
      vb.customize ["modifyvm", :id, "--memory", "1024"]
      vb.customize ["modifyvm", :id, "--vram", "48"]
      vb.customize ["modifyvm", :id, "--vrde", "on"]
      vb.customize ["modifyvm", :id, "--vrdeport", "3391"]
    end

    minion_config.vm.host_name = "minion2.#{domain}"
    minion_config.vm.network "private_network", ip: '172.16.42.12'
    minion_config.vm.provision "shell", inline: $hosts_script_win

    ## Use all the defaults:
    minion_config.vm.provision :salt do |salt|

      # These are more useful when connecting to a remote master
      # and you want to use pre-seeded keys (already accepted on master)
      ## !! Please do not use these keys in production!
      salt.minion_key = "salt/key/minion2.example.com.pem"
      salt.minion_pub = "salt/key/minion2.example.com.pub"

      salt.minion_config = "salt/minion"
      salt.run_highstate = true
      salt.log_level  = "debug"

    end
  end
end