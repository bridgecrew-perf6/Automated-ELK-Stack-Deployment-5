
**Automated ELK Stack Deployment**

The files in this repository were used to configure the network depicted below.


![Diagram

Description automatically generated](Aspose.Words.367b46cb-0971-43d4-80c2-9807052bc998.001.png)


These files have been tested and used to generate a live ELK deployment on Azure.  They can be used to either recreate the entire deployment pictured above.  Alternatively, select portions of playbook file may be used to install only certain pieces of it.

- [Elk-playbook.yml](Ansible/elk-playbook.yml)


This document contains the following details:

- Description of the Topology
- Access Policies
- ELK Configuration
  - Beats in Use
  - Machines Being Monitored
- How to Use the Ansible Build


**Description of the Topology**

The main purpose of this network is to expose a load-balanced and monitored instance of DVWA, the D\*mn Vulnerable Web Application.

The **Load Balancer** ensures that the application will be highly available for customers, by providing access to the application on the website (URL) through redundant instances of the application server in the backend pool.  If a server becomes unavailable due to maintenance or outage, the application will still be accessible through the remaining DVWA servers in the backend pool.  It ensures that the load on the website is distributed evenly among the redundant servers in the backend so that no single server bears all the load and gets overcommitted to provide a consistent user experience.

The load balancer also protects the security of the internal network by restricting access to the DVWA servers.   Connections from the internet via HTTP are restricted to the Frontend IP address of the load balancer and only the backend IP address is able to access the DVWA servers in the backend pool using   HTTP.  

Integrating an ELK server allows users to easily monitor the vulnerable VMs for changes to the network traffic and system logs.

What does Filebeat watch for?

- It gathers system events logs of /locations that you specify and forwards them to Elasticsearch/Logstash for indexing.

What does Metricbeat record?

- It records server resource metrics/statistics data such as CPU, Memory, Disk and Network utilisation and transports them to the output that you specify on Elasticsearch/Logstash.

The configuration details of each machine may be found below.


|**Name**|**Function**|**IP Address**|**Operating System**|
| :- | :- | :-: | :-: |
|Jump Box|Remote Server Management|10.0.0.4|Linux Ubuntu Server 18.04 LTS|
|Web-1|DVWA Web Server|10.0.0.5|Linux Ubuntu Server 18.04 LTS|
|Web-2|DVWA Web Server|10.0.0.6|Linux Ubuntu Server 18.04 LTS|
|Web-3|DVWA Web Server|10.0.0.7|Linux Ubuntu Server 18.04 LTS|
|ELK-VM|Monitoring /Analytics Server|10.1.0.4|Linux Ubuntu Server 18.04 LTS|


**Access Policies**

The machines on the internal network are not exposed to the public Internet.   

Only the Load Balancer and the ELK server are accessible from the Internet but only from the specific IP address of the Remote PC (home PC) which is 124.168.34.104 on the diagram. 

The DVWA servers are accessible are only accessible externally through the load balancer via HTTP port 80 on http://[FrontEndIP of Load Balancer]/login.php


The ELK server is accessible via HTTP port 5601: 

http://[PublicIP of ELK-VM]:5601/app/kibana

A summary of the access policies in place can be found in the table below.


|**Name**|**Publicly Accessible** |**Allowed  IP Addresses**|
| :- | :- | :- |
|Jump Box Provisioner|Yes|<p>Public IP of a specific Remote PC & </p><p>10.0.0.4 (JumpBox)</p>|
|Web-1|No|10.0.0.4 (JumpBox)|
|Web-2|No|10.0.0.4 (JumpBox)|
|Web-3|No|10.0.0.4 (JumpBox)|
|Elk-VM|Yes|<p>Public IP of a specific Remote PC & </p><p>10.0.0.4 (JumpBox)</p>|



**ELK Configuration**

Ansible was used to automate the configuration of the ELK machine.  No configuration was performed manually, which is advantageous because it eliminates the risk of human error and ensures consistent configuration on specific hosts where the playbooks are applied.  

The playbook implements the following tasks:

` `***The following identifies the purpose of the playbook and where the tasks will be applied***

\- name : Configure Elk VM with Docker indicates that his 

`  `hosts: elk

`  `become: true

`  `tasks:

***This section installs docker .io using apt module:***

`     `- name: Install docker.io 

`       `apt:

`           `update\_cache: yes

`           `force\_apt\_get: yes

`           `name: docker.io

`           `state: present

` `***This section installs python3-pip using apt module:***

`     `- name: Install python3-pip 

`       `apt:

`           `force\_apt\_get: yes

`           `name: python3-pip

`           `state: present

` `***This section installs the python docker using pip module:***

`     `- name: Install python docker 

`       `pip:

`           `name: docker

`           `state: present

` `***This section increases virtual memory using the command module:***

`     `- name: Increase virtual memory using sysctl module

`       `command: sysctl -w vm.max\_map\_count=262144

` `***This section downloads docker container elk and launch docker elk container*** 

`     `- name: download and launch docker elk container

`       `docker\_container:

`           `name: elk

`           `image: sebp/elk:761

`           `state: started

`           `restart\_policy: always

`           `published\_ports:

`               `- 5601:5601

`               `- 9200:9200

`               `- 5044:5044

` `***This section enables docker service when the server is rebooted*** 

`     `- name: Enable service docker on boot

`       `systemd:

`            `name: docker

`            `enabled: yes

The following screenshot displays the result of running `docker ps` after successfully configuring the ELK instance on the Elk-VM.

![Text

Description automatically generated](Aspose.Words.367b46cb-0971-43d4-80c2-9807052bc998.002.png)



**Target Machines & Beats**

This ELK server is configured to monitor the following machines:

- Web-1 (10.0.0.5), Web-2 (10.0.0.6) and Web-3  (10.0.0.7)

We have installed the following Beats on these machines:

- Filebeat and Metricbeat



**Using the Playbook**

In order to use the playbook, you will need to have an Ansible control node already configured. Assuming you have such a control node provisioned: 

SSH into the Jump-Box-Provisioner and follow the steps below:

**ELK Playbook:**

- Go to the **/etc/ansible** directory of the docker container that you are running
- In this same directory, find the **hosts** file then edit this to include the IP addresses of the **webservers** and **elk** hosts where you are going to apply the playbook

![Text

Description automatically generated](Aspose.Words.367b46cb-0971-43d4-80c2-9807052bc998.003.png)


- In the same directory, find the **ansible.cfg** file then edit the remote user to the user account that you allowed on the webserver (Redadmin in the screenshot)

![Text

Description automatically generated](Aspose.Words.367b46cb-0971-43d4-80c2-9807052bc998.004.png)

- Copy the Install-elk.yml role to  the /etc/ansible directory
- Run the playbook by typing **ansible-playbook install-elk.yml**
- SSH to the ELK VM to check that the installation worked as expected.
- Run **docker ps** to check that the **elk** is running

![Text

Description automatically generated](Aspose.Words.367b46cb-0971-43d4-80c2-9807052bc998.005.png)


**Filebeat Playbook:**

- Copy the filebeat-playbook.yml file to /etc/ansible/roles/
- Copy the filebeat-config.yml file to /etc/ansible/files directory 
- Update the filebeat-config.yml file to include the ELK private IP address in lines 1106 and 1806.

Line 1106:

![A picture containing timeline

Description automatically generated](Aspose.Words.367b46cb-0971-43d4-80c2-9807052bc998.006.png)

Line 1806:

![Text

Description automatically generated with medium confidence](Aspose.Words.367b46cb-0971-43d4-80c2-9807052bc998.007.png)

- Run the playbook filebeat-playbook.yml by typing **ansible-playbook filebeat-playbook.yml** in /etc/ansible/roles/ directory
- Use a browser to navigate to http://[ELK-VM public IP}:5601/app/kibana) to check that the installation worked as expected.
























**Screenshot of Filebeat Dashboard:** 

![Timeline

Description automatically generated with medium confidence](Aspose.Words.367b46cb-0971-43d4-80c2-9807052bc998.008.png)


**Metricbeat:**

- Copy the metricbeat-playbook.yml file to /etc/ansible/roles/
- Copy the metricbeat-config.yml file to /etc/ansible/files directory
- Update the metricbeat-config.yml file to include the ELK private IP in lines 62 and 96.

Line 62

![Graphical user interface, text

Description automatically generated](Aspose.Words.367b46cb-0971-43d4-80c2-9807052bc998.009.png)

Line 96:

![Graphical user interface, text

Description automatically generated](Aspose.Words.367b46cb-0971-43d4-80c2-9807052bc998.010.png)

- Run the playbook metricbeat-playbook.yml by typing **ansible-playbook metricbeat-playbook.yml** in /etc/ansible/roles/ directory
- Use a browser to navigate to http://(ELK-VM public IP) to check that the installation worked as expected.



**Screenshot of Metricbeats Dashboard:**

![Graphical user interface, application

Description automatically generated](Aspose.Words.367b46cb-0971-43d4-80c2-9807052bc998.011.png)



The **playbook** is the YAML file – file with extension .**yml:**

**Ansible Playbook 		Description**

install-elk.yml			- installs ELK stack on the Elk-VM server

my-playbook.yml		- installs DVWA service on the webservers

filebeat-playbook.yml		- installs Filebeat on the web servers

metricbeat-playbook.yml	- installs Metricbeat on the web servers

Which file do you update to make Ansible run the playbook on a specific machine? 

- Update the **hosts** file in **/etc/ansible** directory of the docker container you are running on the JumBox to indicate the IP addresses of the servers where the playbook will be applied (refer to Using the Playbook section of this document)






How do I specify which machine to install the ELK server on versus which to install Filebeat on?\_

- You will need to add a new line [elk] and specify the IP address of the ELK server![Text

Description automatically generated](Aspose.Words.367b46cb-0971-43d4-80c2-9807052bc998.012.png)

Which URL do you navigate to in order to check that the ELK server is running?

- You have to use the following URL format **http://[ELK-VM publicIP] :5601/app/kibana** to check that the ELK server is running 



