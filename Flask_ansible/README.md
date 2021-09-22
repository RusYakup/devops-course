# Flask app

This is simple web server that listens "POST" requests, 
validate json post body data
and sends response depend on requested data

## Start app

For local start app you must install packages from Pipfile and activate pipenv:
pipenv install

Activate pipenv:

pipenv shell

Run app:

python3 app.py

# Ansible 



- Install VirtualBox VM, create VM (node host) with latest Debian netinstall image.
- Setup network (add bridge interface, ensure VM is getting ip address, if no - check /etc/network/interfaces configuration).
- Install Ansible on master host 
  On master host (termina) :
  
Clone this repository   
``https://github.com/RusYakup/devops-course.git``


``cd devops-course/flask_ansible``

Run these commands to install ssl_certificate Ansible role, generate new ssh authentication key and transfer it to node host:

``ansible-galaxy install ome.ssl_certificate``


``ssh-keygen -f ~/.ssh/id_rsa -q -N ""``


``ssh-copy-id <user-of-node-host>@<ip-address-of-node-host>``


Add these lines in `/etc/ansible/hosts` file:

```[debianserver]
<ip-address-of-node-host>

[debianserver:vars]
ansible_python_interpreter=/usr/bin/python3
ansible_user='{{ node_user }}'
ansible_become_pass='{{ node_root_password }}'
```



Set up Ansible vault (on master host) to store passwords:
Create `vault.yml` file with this contents:

```node_user: <user-of-node-host>
node_root_password: <root-password-of-node-host>
```
Encrypt file:

```ansible-vault encrypt vault.yml```

Run Ansible playbook

```ansible-playbook --ask-vault-pass --extra-vars '@vault.yml' playbook.yml```



test application:


```curl -s -XPOST -H "Content-Type: application/json" -d '{"animal":"leon","sound":"aaggggrrru","count": 1 }'  http://<ip-address-of-node-host>. ```

