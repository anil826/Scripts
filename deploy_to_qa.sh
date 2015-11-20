echo 'snappea-qa - select deployment branch.'
read branch_to_deploy
set -e

heroku maintenance:on --app snappea-qa

echo $(date  +"%T") 'snappea-qa - database snapshot'
heroku pgbackups:capture --app snappea-qa --expire

echo $(date  +"%T") 'snappea-qa - deploy code'
git push --force qa $branch_to_deploy:master

echo $(date  +"%T") 'snappea-qa - migrate database'
heroku run rake db:migrate --app snappea-qa
heroku maintenance:off --app snappea-qa

echo $(date  +"%T") 'snappea-qa - complete'
heroku ps --app snappea-qa