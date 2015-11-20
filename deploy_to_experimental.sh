echo 'snappea-experimental - select deployment branch(q to quit)?'
read branch_to_deploy
if [[ $branch_to_deploy == q ]]
then
  exit
fi

set -e
heroku maintenance:on --app snappea-experimental

echo $(date  +"%T") 'snappea-experimental - snapshot database'
heroku pgbackups:capture --app snappea-experimental --expire

echo $(date  +"%T") 'snappea-experimental - deploy code'
git push --force experimental $branch_to_deploy:master

echo $(date  +"%T") 'snappea-experimental - migrate database'
heroku run rake db:migrate --app snappea-experimental
heroku maintenance:off --app snappea-experimental

echo $(date  +"%T") 'snappea-experimental - complete'
heroku ps --app snappea-experimental