#### This project demonstrates how to reliably forward logs from a source Ubuntu VM to a destination Ubuntu VM using rsyslog over TCP, with disk-assisted queues.
#### auditd, kernel, dpkg, authentication logs are sent from source machine to destination machine. what you have to do is to change 1.1.1.1 source IP address and 2.2.2.2 destination IP address with yours

#### the related bash script is added to the project. to use the bash script, you need to clone the project on source machine and run the script.

#### Implementation of the porject step by step:

1. Installation of required packages (both machines):
   ``` bash
   sudo apt update
   sudo apt install -y rsyslog auditd audispd-plugins

2. On destination machine, copy the following files which are configuration files for rsyslog service on the machine:
   ``` bash
   cp destination-VM/20-remote-input.conf /etc/rsyslog.d
   cp destination-VM/30* /etc/rsyslog.d

3. On source machine, copy the following files to configure rsyslog service on the machine:
   ``` bash
   cp source-VM/10-imfile-load.conf /etc/rsyslog.d
   cp source-VM/20* /etc/rsyslog.d
   cp source-VM/30* /etc/rsyslog.d

5. Start and enable the services on both machines:
   ``` bash
   systemctl enable --now rsyslog.service
   systemctl enable --now auditd.service

6. Verify log delivery (in these directories on destination machine a file generated named DESTINATION_MACHINE_IP.json containing delivered logs):
   ``` bash
   ls /var/log/remote-auditd/
   ls /var/log/remote-auth/
   ls /var/log/remote-dpkg/
   ls /var/log/remote-kern/


   
