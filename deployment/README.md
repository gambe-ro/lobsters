Deployment tools and config. As a user, you **must** call the scripts from the parent directory (lobsters/) for them to work.

Entrypoints: (the names are self-describing)

 * docker-run.sh
 * docker-restart.sh

Files you can and should edit:

 * tarsnap.cron, to set the backup frequency and time

Note that the Vagrantfile is *not maintained*, but it is kept because it might come useful.