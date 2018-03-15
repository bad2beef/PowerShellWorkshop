Vagrant.configure("2") do |config|
    config.vm.box = "jacqinthebox/windowsserver2016"

    $vm_cpus = 2
    $vm_ram = 4096

    config.vm.provision "setup", type: "shell", inline: <<-SCRIPT
        slmgr.vbs /rearm
        winrm.cmd s winrm/config/client '@{TrustedHosts="*"}'
        Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
        choco.exe install VisualStudioCode vscode-powershell --yes
        shutdown.exe /f /r /t 5
        cd .
    SCRIPT

    config.vm.provider :virtualbox do |v, override|
        v.customize ["modifyvm", :id, "--cpus", $vm_cpus]
        v.customize ["modifyvm", :id, "--memory", $vm_ram]
        v.customize ["modifyvm", :id, "--audio", "none"]
        v.customize ["modifyvm", :id, "--usb", "off"]
        v.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
        v.customize ["modifyvm", :id, "--draganddrop", "hosttoguest"]
        v.linked_clone = true if Vagrant::VERSION >= '1.8.0'
      end
    
      config.vm.provider :vmware_fusion do |v, override|
        v.vmx["numvcpus"] = $vm_cpus
        v.vmx["memsize"] = $vm_ram
        v.vmx["usb.present"] = "false"
        v.vmx["sound.present"] = "false"
        v.linked_clone = true if Vagrant::VERSION >= '1.8.0'
      end
    
      config.vm.provider :hyperv do |v, override|
        v.cpus = $vm_cpus
        v.memory = $vm_ram
        v.vm_integration_services = {
          guest_service_interface: true,
          heartbeat: true,
          key_value_pair_exchange: true,
          shutdown: true,
          time_synchronization: true,
          vss: true
        }
        v.differencing_disk = true
      end
end