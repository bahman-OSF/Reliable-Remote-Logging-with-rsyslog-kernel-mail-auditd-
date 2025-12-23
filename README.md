#### This project demonstrates how to reliably forward logs from a source Ubuntu VM to a destination Ubuntu VM using rsyslog over TCP, with disk-assisted queues.

#### Implementation of the porject step by step:

1. Installation of required packages (both machines):
   ``` bash
   sudo apt update
   sudo apt install -y rsyslog auditd

   sudo systemctl enable auditd
   sudo systemctl start auditd

2. On destination machine, run the following command to enable TCP reception:
   ``` bash
   cp destination-VM/00-tcp-listener.conf /etc/rsyslog.d/00-tcp-listener.conf

3. Use the following config files on destination machine:
   ``` bash
   cp destination-VM/10-remote-kernel-json.conf /etc/rsyslog.d/10-remote-kernel-json.conf
   cp destination-VM/20-remote-mail-json.conf /etc/rsyslog.d/20-remote-mail-json.conf
   cp destination-VM/30-remote-audit-json.conf /etc/rsyslog.d/30-remote-audit-json.conf

4. Use the following config files on source machine (in 60-forward-reliable.conf file change the IP address of destination machine with yours):
   ``` bash
   cp source-VM/30-auditd.conf /etc/rsyslog.d/30-auditd.conf
   cp source-VM/60-forward-reliable.conf /etc/rsyslog.d/60-forward-reliable.conf
   cp source-VM/100-postfix.conf /etc/rsyslog.d/100-postfix.conf

5. Restart rsyslog service on both machines:
   ``` bash
   systemctl restart rsyslog.service

6. Verify log delivery (in these directories on destination machine a file generated named DESTINATION_MACHINE_IP.json containing delivered logs):
   ``` bash
   ls /var/log/remote/kernel/
   ls /var/log/remote/mail/
   ls /var/log/remote/audit/


   
