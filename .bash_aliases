# Odoo
alias cdodoo11='cd /home/fabio/projects/odoo11/odoo'
alias run11='odoo11 && cd /home/fabio/projects/odoo11/odoo && ./odoo-bin -c odoo-config'
alias porter='odoo12 && cd /home/fabio/projects/odoo12/odoo && ./odoo-bin -c odoo-config-porter'
alias trust='odoo12 && cd /home/fabio/projects/odoo12/odoo && ./odoo-bin -c odoo-config-trust'
alias run13='odoo13 && cd /home/fabio/projects/odoo13/odoo && ./odoo-bin -c odoo-config'
alias odooshell11='odoo11 && cd /home/fabio/projects/odoo11/odoo && ./odoo-bin shell -c odoo-config -d'
alias odooshell12='odoo12 && cd /home/fabio/projects/odoo12/odoo && ./odoo-bin shell -c odoo-config -d'
alias co11='git checkout 11.0'
alias pull11='cd /mnt/e/Desenvolvimento/python/odoo11/trustcode-addons && co11 && git pull && cd ../odoo-brasil && co11 && git pull && cd ../trustcode-enterprise && co11 && git pull && cd ../odoo && co11 && git pull && cd ../python-boleto && git checkout master3 && git pull && cd ../PyTrustNFe && git checkout master3 && git pull && cd ../odoo-reports && co11 && git pull'
alias coverage11='odoo11 && cdodoo11 && coverage run ./odoo-bin -c odoo-config --test-enable --log-level='test' --xmlrpc-port=8050 -d teste_unitario_11 --stop-after-init --init='

# Venvs
alias odoo11='source ~/venvs/odoo11/bin/activate'
alias odoo12='source ~/venvs/odoo12/bin/activate'
alias odoo13='source ~/venvs/odoo13/bin/activate'
alias ansible='source ~/venvs/ansible/bin/activate'
alias flask-angular='source ~/venvs/flask-angular/bin/activate'
alias erpnext='source ~/venvs/erpnext/bin/activate'

# Postgres
alias postgres='sudo service postgresql start'
alias pgadmin4='~/venvs/pgadmin4/pgadmin4.sh'

# Ubuntu
alias rm='sudo rm'
alias apt='sudo apt'
alias service='sudo service'
alias kill='sudo kill -9'
alias killall='sudo killall -9'

# Vim 
alias vim='vim.gtk'
alias vims='cd ~/.vim/sessions/ && vim -S'
