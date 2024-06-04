#!/bin/bash

#########################################################
# 							#
#	Dit bestand is gemaakt door Floris Schaller	#
# 	Naam:		Floris Schaller			#
# 	Studentnummer: 	S1168815			#
# 	Email:		floris.schaller@windesheim.ml	#
#							#
#########################################################

echo "Welkom bij het VM uitrolscript! Mede mogelijk gemaakt door Floris Schaller"
echo "Voer de klantnaam in:"
read klantnaam

echo "Wat voor omgeving mag er uitgerold worden? (Prod/Acc/Test/Dev)"
read klantomgeving

if [[ ! ${klantomgeving} =~ ^(Prod|Acc|Test|Dev)$ ]]; then
    echo "Onjuiste waarde. Kies uit Prod, Acc, Test of Dev."
    exit 1
    fi

# Maak een directory voor de klant als deze nog niet bestaat
klantdir="/home/student/IAC_test/${klantnaam}-${klantomgeving}"
mkdir -p "${klantdir}"


# SSH config klantomgeving
ssh_key_directory="$HOME/.ssh/klantkeys/$klantnaam"
ssh_private_key="$ssh_key_directory/${klantnaam}_rsa"
ssh_public_key="$ssh_private_key.pub"

# Create directory if it doesn't exist
mkdir -p "$ssh_key_directory"

# Check if the SSH keys already exist, if not, generate them
if [ ! -f "$ssh_private_key" ] || [ ! -f "$ssh_public_key" ]; then
    ssh-keygen -t rsa -b 2048 -f "$ssh_private_key" -N ''
    echo "Generated new SSH key for $klantnaam"
fi


echo "Selecteer het type Vagrant-box dat je wilt uitrollen:"
select boxtype in "ubuntu/bionic64" "centos/7" "debian/stretch64"; do
    case $boxtype in
        ubuntu/bionic64 ) echo "Ubuntu geselecteerd"; break;;
        centos/7 ) echo "CentOS geselecteerd"; break;;
        debian/stretch64 ) echo "Debian geselecteerd"; break;;
        * ) echo "Ongeldige selectie";;
    esac
done

echo "Selecteer het type server:"
select servertype in "Webserver" "Databaseserver" "Loadbalancer"; do
    case $servertype in
        Webserver ) playbook="webserver.yml"; break;;
        Databaseserver ) playbook="databaseserver.yml"; break;;
        Loadbalancer ) playbook="loadbalancer.yml"; break;;
        * ) echo "Ongeldige selectie";;
    esac
done

echo "Hoeveel RAM-geheugen moet elke machine krijgen? (in MB)"
read vm_ram

echo "Hoeveel machines wil je uitrollen?"
read aantal_machines

# Kopieer het Ansible playbook naar de klantmap, of pas de paden aan
cp "/home/student/IAC_test/roles/${playbook}" "${klantdir}/${playbook}"

# Genereer Vagrantfile binnen de klantmap
cat > "${klantdir}/Vagrantfile" <<EOF

role = "${servertype}"
Vagrant.configure("2") do |config|
 
  subnet = case role
           when "Webserver" then "192.168.2"
           when "Databaseserver" then "192.168.3"
           when "Loadbalancer" then "192.168.4"
           end

  i = 0
  vm_name = "${klantnaam}-${servertype}#{i+1}-${klantomgeving}" 
  ip = 5
  vm_ip = "#{subnet}.#{ip+1}"

  config.vm.define vm_name do |server|
    server.vm.box = "${boxtype}"
    server.vm.hostname = vm_name
    server.vm.network "private_network", ip: vm_ip
    server.ssh.insert_key = false
    server.vm.provision "file", source: "~/.ssh/klantkeys/${klantnaam}/${klantnaam}_rsa.pub", destination: "~/.ssh/authorized_keys"
      server.ssh.private_key_path = ["~/.ssh/klantkeys/${klantnaam}/${klantnaam}_rsa", "~/.vagrant.d/insecure_private_key"]
    server.vm.provider "virtualbox" do |vb|
      vb.name = vm_name
      vb.memory = "${vm_ram}"
    end
    server.vm.provision "ansible" do |ansible|
      ansible.playbook = "${playbook}"
    end
  end
end



EOF

echo "De Vagrantfile en Ansible playbook voor $servertype zijn gegenereerd in de map $klantnaam voor $aantal_machines machines."
echo "De machines worden nu uitgerold..."

# Rol de VM uit
cd "${klantdir}"
vagrant up

echo "Uitrollen is voltooid. $aantal_machines machines voor $klantnaam ($servertype) met $vm_ram MB RAM zijn nu actief."

