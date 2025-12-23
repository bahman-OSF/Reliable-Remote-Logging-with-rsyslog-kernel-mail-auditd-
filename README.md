#### This project demonstrates how to reliably forward logs from a source Ubuntu VM to a destination Ubuntu VM using rsyslog over TCP, with disk-assisted queues.

#### Implementation of the porject step by step:

1. installation of required packages (both machines):
   ``` bash
   sudo apt update
   sudo apt install -y rsyslog auditd
