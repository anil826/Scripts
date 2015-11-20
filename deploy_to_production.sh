echo 'snappea - deploy form local branch master'
heroku maintenance:on --app snappea

echo $(date  +"%T") 'snappea - database snapshot'
heroku pgbackups:capture -a snappea --expire

echo $(date  +"%T") 'snappea - deploy code'
heroku ps:scale clock=0 resque=0 --app snappea
git push --force heroku master
heroku ps:scale clock=1 resque=1 --app snappea

echo $(date  +"%T") 'snappea - migrate database'
heroku run rake db:migrate --app snappea
heroku maintenance:off --app snappea

echo $(date  +"%T") 'snappea - complete'
heroku ps --app snappea