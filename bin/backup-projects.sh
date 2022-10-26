if [ -d "/mnt/Backup" ]
then
  /bin/rsync -arvuz --delete --exclude '.venv' --exclude 'pyc' /home/fabio/projects /mnt/Backup
fi
