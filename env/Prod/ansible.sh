cd /home/ubunu
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
sudo python3 get-pip.py
sudo python3 -m pip install ansible
tee -a playbook.yml > /dev/null << EOT
#!/bin/bash
- hosts: localhost
  tasks: 
  - name: instalando python3, virtualenv
    apt:
      pkg:
      - python3
      - virtualenv
      update_cache: yes
    become: true
  - name: ativando virtualenve e instalando django e djangorestframework
    pip:
      virtualenv: /home/ubuntu/tcc/venv
      name:
      - django
      - djangorestframework
  - name: testa projeto já existe
    stat:
      path: /home/ubuntu/tcc/setup/settings.py
    register: projeto
  - name: iniciando o projeto django    
    shell: '. /home/ubuntu/tcc/venv/bin/activate ; django-admin startproject setup /home/ubuntu/tcc'
    when: not projeto.stat.exists
  - name: editando o settings.py
    lineinfile:
      path: /home/ubuntu/tcc/setup/settings.py
      regexp: 'ALLOWED_HOSTS'
      line: 'ALLOWED_HOSTS = ["*"]'
      backrefs: yes
  - name: subindo a aplicacao
    shell: '. /home/ubuntu/tcc/venv/bin/activate ; python /home/ubuntu/tcc/manage.py runserver 0.0.0.0:8000'
EOT
ansible-playbook playbook.yml