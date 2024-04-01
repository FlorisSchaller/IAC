#!/bin/bash

echo "Welkom bij het VM uitrolscript!"
echo "Voer de klantnaam in:"
read klantnaam

# Maak een directory voor de klant als deze nog niet bestaat
klantdir="./${klantnaam}-prod"
mkdir -p "${klantdir}"

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
cp "${playbook}" "${klantdir}/${playbook}"

# Genereer Vagrantfile binnen de klantmap
cat > "${klantdir}/Vagrantfile" <<EOF
Vagrant.configure("2") do |config|
  config.vm.box = "$boxtype"
EOF

for (( i=1; i<=$aantal_machines; i++ ))
do
    vm_name="${klantnaam}-${servertype,,}-prod$i" # Zet servertype naar lowercase
    vm_ip="192.168.1.$((ip_start+i))"
cat >> "${klantdir}/Vagrantfile" <<EOF
  config.vm.define "$vm_name" do |server|
    server.vm.hostname = "$vm_name"
    server.vm.network "private_network", ip: "$vm_ip"
    server.vm.provider "virtualbox" do |vb|
      vb.name = "$vm_name"
      vb.memory = "$vm_ram"
    end
    server.vm.provision "ansible" do |ansible|
      ansible.playbook = "${playbook}"
    end
  end
EOF
done

cat >> "${klantdir}/Vagrantfile" <<EOF
end
EOF

echo "De Vagrantfile en Ansible playbook voor $servertype zijn gegenereerd in de map $klantnaam voor $aantal_machines machines."
echo "De machines worden nu uitgerold..."

# Rol de VM uit
cd "${klantdir}"
vagrant up

echo "Uitrollen is voltooid. $aantal_machines machines voor $klantnaam ($servertype) met $vm_ram MB RAM zijn nu actief."

