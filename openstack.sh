#!/bin/bash

# Function to display command without executing
show_command() {
    echo ""
    echo "=========================================="
    echo "📝 Command to run:"
    echo "$1"
    echo "=========================================="
    echo ""
}

# Part 1: Identity Management
create_project() {
    echo "Enter the project name (default: lab8_project):"
    read -r project_name
    if [[ -z "$project_name" ]]; then
        project_name="lab8_project"
    fi
    echo "Enter the project description (default: Week 8 Foundation):"
    read -r description
    if [[ -z "$description" ]]; then
        description="Week 8 Foundation"
    fi
    cmd="openstack project create --description \"$description\" $project_name"
    show_command "$cmd"
}

create_user() {
    echo "Enter the username (default: lab_student):"
    read -r username
    if [[ -z "$username" ]]; then
        username="lab_student"
    fi
    echo "Enter the password for $username (default: secret):"
    read -r -s password
    if [[ -z "$password" ]]; then
        password="secret"
    fi
    echo "Enter the project name for $username (default: lab8_project):"
    read -r project
    if [[ -z "$project" ]]; then
        project="lab8_project"
    fi
    cmd="openstack user create --password $password --project $project $username"
    show_command "$cmd"
}

assign_member_role() {
    echo "Enter the project name (default: lab8_project):"
    read -r project
    if [[ -z "$project" ]]; then
        project="lab8_project"
    fi
    echo "Enter the username (default: lab_student):"
    read -r username
    if [[ -z "$username" ]]; then
        username="lab_student"
    fi
    echo "Enter the role name (default: member):"
    read -r role
    if [[ -z "$role" ]]; then
        role="member"
    fi
    cmd="openstack role add --project $project --user $username $role"
    show_command "$cmd"
}

# Part 2: Image Management
download_image() {
    echo "Enter the download URL (default: http://download.cirros-cloud.net/0.5.1/cirros-0.5.1-x86_64-disk.img):"
    read -r url
    if [[ -z "$url" ]]; then
        url="http://download.cirros-cloud.net/0.5.1/cirros-0.5.1-x86_64-disk.img"
    fi
    cmd="wget $url"
    show_command "$cmd"
}

upload_image() {
    echo "Enter the image name (default: cirros-lab8):"
    read -r image_name
    if [[ -z "$image_name" ]]; then
        image_name="cirros-lab8"
    fi
    echo "Enter the image filename (default: cirros-0.5.1-x86_64-disk.img):"
    read -r filename
    if [[ -z "$filename" ]]; then
        filename="cirros-0.5.1-x86_64-disk.img"
    fi
    cmd="openstack image create \"$image_name\" --file $filename --disk-format qcow2 --container-format bare --public"
    show_command "$cmd"
}

# Part 3: Networking
create_network() {
    echo "Enter the network name (default: lab8_net):"
    read -r network_name
    if [[ -z "$network_name" ]]; then
        network_name="lab8_net"
    fi
    cmd="openstack network create $network_name"
    show_command "$cmd"
}

create_subnet() {
    echo "Enter the network name (default: lab8_net):"
    read -r network_name
    if [[ -z "$network_name" ]]; then
        network_name="lab8_net"
    fi
    echo "Enter the subnet range (default: 192.168.88.0/24):"
    read -r subnet_range
    if [[ -z "$subnet_range" ]]; then
        subnet_range="192.168.88.0/24"
    fi
    echo "Enter the DNS nameserver (default: 8.8.8.8):"
    read -r dns
    if [[ -z "$dns" ]]; then
        dns="8.8.8.8"
    fi
    echo "Enter the subnet name (default: lab8_subnet):"
    read -r subnet_name
    if [[ -z "$subnet_name" ]]; then
        subnet_name="lab8_subnet"
    fi
    cmd="openstack subnet create --network $network_name --subnet-range $subnet_range --dns-nameserver $dns $subnet_name"
    show_command "$cmd"
}

create_router() {
    echo "Enter the router name (default: lab8_router):"
    read -r router_name
    if [[ -z "$router_name" ]]; then
        router_name="lab8_router"
    fi
    cmd="openstack router create $router_name"
    show_command "$cmd"
}

wire_internal_link() {
    echo "Enter the router name (default: lab8_router):"
    read -r router_name
    if [[ -z "$router_name" ]]; then
        router_name="lab8_router"
    fi
    echo "Enter the subnet name (default: lab8_subnet):"
    read -r subnet_name
    if [[ -z "$subnet_name" ]]; then
        subnet_name="lab8_subnet"
    fi
    cmd="openstack router add subnet $router_name $subnet_name"
    show_command "$cmd"
}

wire_external_link() {
    echo "Enter the router name (default: lab8_router):"
    read -r router_name
    if [[ -z "$router_name" ]]; then
        router_name="lab8_router"
    fi
    echo "Enter the external network name (default: public):"
    read -r external_net
    if [[ -z "$external_net" ]]; then
        external_net="public"
    fi
    cmd="openstack router set --external-gateway $external_net $router_name"
    show_command "$cmd"
}

# Part 4: Flavors
check_flavors() {
    cmd="openstack flavor list"
    show_command "$cmd"
}

create_micro_flavor() {
    echo "Enter flavor name (default: m1.nebula_micro):"
    read -r flavor_name
    if [[ -z "$flavor_name" ]]; then
        flavor_name="m1.nebula_micro"
    fi
    echo "Enter RAM in MB (default: 256):"
    read -r ram
    if [[ -z "$ram" ]]; then
        ram="256"
    fi
    echo "Enter disk size in GB (default: 1):"
    read -r disk
    if [[ -z "$disk" ]]; then
        disk="1"
    fi
    echo "Enter number of vCPUs (default: 1):"
    read -r vcpus
    if [[ -z "$vcpus" ]]; then
        vcpus="1"
    fi
    cmd="openstack flavor create --id auto --ram $ram --disk $disk --vcpus $vcpus $flavor_name"
    show_command "$cmd"
}

create_small_flavor() {
    echo "Enter flavor name (default: m1.nebula_small):"
    read -r flavor_name
    if [[ -z "$flavor_name" ]]; then
        flavor_name="m1.nebula_small"
    fi
    echo "Enter RAM in MB (default: 1024):"
    read -r ram
    if [[ -z "$ram" ]]; then
        ram="1024"
    fi
    echo "Enter disk size in GB (default: 5):"
    read -r disk
    if [[ -z "$disk" ]]; then
        disk="5"
    fi
    echo "Enter number of vCPUs (default: 1):"
    read -r vcpus
    if [[ -z "$vcpus" ]]; then
        vcpus="1"
    fi
    cmd="openstack flavor create --id auto --ram $ram --disk $disk --vcpus $vcpus $flavor_name"
    show_command "$cmd"
}

# Part 5: Security
create_keypair() {
    echo "Enter keypair name (default: nebula_key):"
    read -r key_name
    if [[ -z "$key_name" ]]; then
        key_name="nebula_key"
    fi
    cmd="openstack keypair create $key_name > ${key_name}.pem"
    show_command "$cmd"
    echo ""
    echo "Then secure the key: chmod 600 ${key_name}.pem"
}

create_security_group() {
    echo "Enter security group name (default: nebula_web_sg):"
    read -r sg_name
    if [[ -z "$sg_name" ]]; then
        sg_name="nebula_web_sg"
    fi
    echo "Enter description (default: Web Server Firewall):"
    read -r description
    if [[ -z "$description" ]]; then
        description="Web Server Firewall"
    fi
    cmd="openstack security group create $sg_name --description \"$description\""
    show_command "$cmd"
}

open_ports() {
    echo "Enter security group name (default: nebula_web_sg):"
    read -r sg_name
    if [[ -z "$sg_name" ]]; then
        sg_name="nebula_web_sg"
    fi
    
    echo "Open SSH (port 22)? (yes/no, default: yes):"
    read -r open_ssh
    if [[ -z "$open_ssh" ]] || [[ $open_ssh == "yes" ]]; then
        cmd="openstack security group rule create --proto tcp --dst-port 22 $sg_name"
        show_command "$cmd"
    fi
    
    echo "Open HTTP (port 80)? (yes/no, default: yes):"
    read -r open_http
    if [[ -z "$open_http" ]] || [[ $open_http == "yes" ]]; then
        cmd="openstack security group rule create --proto tcp --dst-port 80 $sg_name"
        show_command "$cmd"
    fi
}

# Part 6: Launch Instance
create_boot_script() {
    echo "Enter boot script filename (default: boot.sh):"
    read -r script_name
    if [[ -z "$script_name" ]]; then
        script_name="boot.sh"
    fi
    echo ""
    echo "Commands to create the script:"
    echo "cat > $script_name << 'EOF'"
    echo '#!/bin/sh'
    echo 'while true; do echo -e '\''HTTP/1.0 200 OK\r\n\r\nHello Nebula Inc'\'' | sudo nc -l -p 80 ; done &'
    echo "EOF"
    echo "chmod +x $script_name"
}

launch_instance() {
    echo "Enter instance name (default: nebula_web_01):"
    read -r instance_name
    if [[ -z "$instance_name" ]]; then
        instance_name="nebula_web_01"
    fi
    echo "Enter flavor name (default: m1.nebula_micro):"
    read -r flavor
    if [[ -z "$flavor" ]]; then
        flavor="m1.nebula_micro"
    fi
    echo "Enter image name (default: cirros-lab8):"
    read -r image
    if [[ -z "$image" ]]; then
        image="cirros-lab8"
    fi
    echo "Enter network name (default: lab8_net):"
    read -r network
    if [[ -z "$network" ]]; then
        network="lab8_net"
    fi
    echo "Enter security group name (default: nebula_web_sg):"
    read -r sg
    if [[ -z "$sg" ]]; then
        sg="nebula_web_sg"
    fi
    echo "Enter keypair name (default: nebula_key):"
    read -r key
    if [[ -z "$key" ]]; then
        key="nebula_key"
    fi
    echo "Enter boot script filename (default: boot.sh):"
    read -r script
    if [[ -z "$script" ]]; then
        script="boot.sh"
    fi
    
    cmd="openstack server create --flavor $flavor --image $image --network $network --security-group $sg --key-name $key --user-data $script $instance_name"
    show_command "$cmd"
}

# Part 7: Floating IP
create_floating_ip() {
    echo "Enter network name for floating IP (default: public):"
    read -r network
    if [[ -z "$network" ]]; then
        network="public"
    fi
    cmd="openstack floating ip create $network"
    show_command "$cmd"
    
    echo ""
    echo "Do you want to attach the floating IP to an instance? (yes/no, default: yes):"
    read -r attach
    if [[ -z "$attach" ]] || [[ $attach == "yes" ]]; then
        echo "Enter instance name (default: nebula_web_01):"
        read -r instance
        if [[ -z "$instance" ]]; then
            instance="nebula_web_01"
        fi
        echo "Enter the Floating IP address:"
        read -r floating_ip
        cmd="openstack server add floating ip $instance $floating_ip"
        show_command "$cmd"
    fi
}

# Part 8: Management & Inspection
show_instance_details() {
    echo "Enter instance name (default: nebula_web_01):"
    read -r instance
    if [[ -z "$instance" ]]; then
        instance="nebula_web_01"
    fi
    cmd="openstack server show $instance"
    show_command "$cmd"
}

show_console_log() {
    echo "Enter instance name (default: nebula_web_01):"
    read -r instance
    if [[ -z "$instance" ]]; then
        instance="nebula_web_01"
    fi
    cmd="openstack console log show $instance"
    show_command "$cmd"
}

resize_instance() {
    echo "Enter instance name (default: nebula_web_01):"
    read -r instance
    if [[ -z "$instance" ]]; then
        instance="nebula_web_01"
    fi
    echo "Enter target flavor (default: m1.nebula_small):"
    read -r flavor
    if [[ -z "$flavor" ]]; then
        flavor="m1.nebula_small"
    fi
    cmd="openstack server resize --flavor $flavor $instance"
    show_command "$cmd"
}

pause_instance() {
    echo "Enter instance name (default: nebula_web_01):"
    read -r instance
    if [[ -z "$instance" ]]; then
        instance="nebula_web_01"
    fi
    cmd="openstack server pause $instance"
    show_command "$cmd"
}

suspend_instance() {
    echo "Enter instance name (default: nebula_web_01):"
    read -r instance
    if [[ -z "$instance" ]]; then
        instance="nebula_web_01"
    fi
    cmd="openstack server suspend $instance"
    show_command "$cmd"
}

# Part 9: Cleanup
cleanup_resources() {
    echo "Select resource to delete:"
    echo "1) Instance"
    echo "2) Security Group"
    echo "3) Both"
    read -r choice
    
    case $choice in
        1)
            echo "Enter instance name (default: nebula_web_01):"
            read -r instance
            if [[ -z "$instance" ]]; then
                instance="nebula_web_01"
            fi
            cmd="openstack server delete $instance"
            show_command "$cmd"
            ;;
        2)
            echo "Enter security group name (default: nebula_web_sg):"
            read -r sg
            if [[ -z "$sg" ]]; then
                sg="nebula_web_sg"
            fi
            cmd="openstack security group delete $sg"
            show_command "$cmd"
            ;;
        3)
            echo "Enter instance name (default: nebula_web_01):"
            read -r instance
            if [[ -z "$instance" ]]; then
                instance="nebula_web_01"
            fi
            echo "Enter security group name (default: nebula_web_sg):"
            read -r sg
            if [[ -z "$sg" ]]; then
                sg="nebula_web_sg"
            fi
            show_command "openstack server delete $instance && openstack security group delete $sg"
            ;;
        *)
            echo "Invalid choice"
            ;;
    esac
}

# Main Menu
while true; do
    clear
    echo ""
    echo "=========================================="
    echo "      NEBULA INC - OpenStack Lab Menu"
    echo "=========================================="
    echo "Part 1 - Identity Management:"
    echo "  1) Create Project"
    echo "  2) Create User"
    echo "  3) Assign Member Role"
    echo ""
    echo "Part 2 - Image Management:"
    echo "  4) Download CirrOS Image"
    echo "  5) Upload Image to Glance"
    echo ""
    echo "Part 3 - Networking:"
    echo "  6) Create Network"
    echo "  7) Create Subnet"
    echo "  8) Create Router"
    echo "  9) Wire Internal Link (Router + Subnet)"
    echo "  10) Wire External Link (Public Gateway)"
    echo ""
    echo "Part 4 - Flavors:"
    echo "  11) Check Existing Flavors"
    echo "  12) Create Micro Flavor (256MB)"
    echo "  13) Create Small Flavor (1024MB)"
    echo ""
    echo "Part 5 - Security:"
    echo "  14) Create Keypair"
    echo "  15) Create Security Group"
    echo "  16) Open Ports (SSH & HTTP)"
    echo ""
    echo "Part 6 - Launch Instance:"
    echo "  17) Create Boot Script"
    echo "  18) Launch Instance"
    echo ""
    echo "Part 7 - Floating IP:"
    echo "  19) Create & Attach Floating IP"
    echo ""
    echo "Part 8 - Management & Inspection:"
    echo "  20) Show Instance Details"
    echo "  21) Show Console Log"
    echo "  22) Resize Instance"
    echo "  23) Pause Instance"
    echo "  24) Suspend Instance"
    echo ""
    echo "Part 9 - Cleanup:"
    echo "  25) Delete Resources"
    echo "  0) Exit"
    echo "=========================================="
    echo -n "Select an option: "
    read -r choice

    case $choice in
        1) create_project ;;
        2) create_user ;;
        3) assign_member_role ;;
        4) download_image ;;
        5) upload_image ;;
        6) create_network ;;
        7) create_subnet ;;
        8) create_router ;;
        9) wire_internal_link ;;
        10) wire_external_link ;;
        11) check_flavors ;;
        12) create_micro_flavor ;;
        13) create_small_flavor ;;
        14) create_keypair ;;
        15) create_security_group ;;
        16) open_ports ;;
        17) create_boot_script ;;
        18) launch_instance ;;
        19) create_floating_ip ;;
        20) show_instance_details ;;
        21) show_console_log ;;
        22) resize_instance ;;
        23) pause_instance ;;
        24) suspend_instance ;;
        25) cleanup_resources ;;
        0) echo "Exiting... Goodbye!"; clear; exit 0 ;;
        *) echo "Invalid option. Please try again." ;;
    esac
    
    echo ""
    echo -n "Press Enter to continue..."
    read -r
done

# history -c && history -w 
