Vagrant.configure("2") do | config |
    config.vm.box = "ubuntu/focal64"

    config.vm.define "dbserver" do | dbserver |
   
        dbserver.vm.network "private_network", ip: "192.168.13.10", virtualbox_intnet: "fithealthnetwork"
        dbserver.vm.provider "virtualbox" do | vb |
          vb.cpus = 2
          vb.memory = 2048
          vb.name = "databaseserver"
        end

        dbserver.vm.provision "copy shellfiles", type: "file", source: "src/main/sh/expect-mysql-secure-install.sh", destination: "/tmp/"
        dbserver.vm.provision "copy add user sqlscript", type: "file", source: "src/main/db/add-user.sql", destination: "/tmp/"
        dbserver.vm.provision "db schema sql", type: "file", source: "src/main/db/db-schema.sql", destination: "/tmp/"
        dbserver.vm.provision "mysql secure installation", type: "shell", path: "src/main/sh/install-mysql.sh"
        dbserver.vm.provision "confgure remote mysql access", type: "shell", path: "src/main/sh/configure-remote-mysqlaccess.sh"
    end
        
        config.vm.define "javaserver" do | javaserver |
            javaserver.vm.network "private_network", ip: "192.168.13.11", virtualbox_intnet: "fithealthnetwork"
            javaserver.vm.network "forwarded_port", host: "80", guest: "8080"
            javaserver.vm.provider "virtualbox" do | vb |
              vb.cpus = 2
              vb.memory = 2048
              vb.name = "javaaplicationserver"
            
            end
            javaserver.vm.provision "copy tomcat service config", type: "file", source: "src/main/config/tomcat.service.conf", destination: "/tmp/"
            javaserver.vm.provision "copy war", type: "file", source: "target/fithealth2.war", destination: "/tmp/", run: "always"
            javaserver.vm.provision "setupwebserver", type: "shell", path: "src/main/sh/setupwebserver.sh"
            javaserver.vm.provision "deploy application", type: "shell", path: "src/main/sh/deploywar.sh", run: "always"
        end

      
end
