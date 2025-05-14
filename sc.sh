#!/bin/bash
repo="nis"
echo "Enter 1 to add a new host to the system"
read number

case $number in 
    1) 
        echo "Enter the host IP to be added"
        read ip
        ssh-copy-id -i ~/.ssh/ansible.pub student@$ip

        
        ssh -o StrictHostKeyChecking=no student@$ip <<EOF
        exit
EOF
 
        echo $ip >> /home/$USER/.ssh/$repo/inventory
        cd /home/$USER/.ssh/$repo
        git add .
        git commit -m "admin1 updated inventory"
        git push origin main
        if ansible all -m ping | grep -q $ip|awk '{print $3}'; then
         echo "Successful"
        else
         echo "Failed"
           fi

 ssh -o StrictHostKeyChecking=no student@192.168.10.4 <<EOF
        cd /home/\$USER/.ssh/$repo
        git pull
        exit
EOF

        ;;
    *)
        echo "Invalid option. Please enter 1."
        ;;
esac

