echo 'snappea-staging - select deployment branch.'
read branch_to_deploy
set -e

echo $(date  +"%T") 'snappea-staging - production & staging database snapshot'
heroku pgbackups:capture --app snappea --expire
heroku pgbackups:capture --app snappea-staging --expire

echo $(date  +"%T") 'snappea-staging - Restoring production database to staging'
heroku maintenance:on --app snappea-staging
heroku pg:reset DATABASE_URL --app snappea-staging --confirm snappea-staging
heroku pgbackups:restore DATABASE `heroku pgbackups:url --app snappea` --app snappea-staging --confirm snappea-staging

echo $(date  +"%T") 'snappea-staging - deploy code'
git push --force staging $branch_to_deploy:master
heroku restart --app snappea-staging

echo $(date  +"%T") 'snappea-staging - migrate database'
heroku run rake db:migrate --app snappea-staging
heroku maintenance:off --app snappea-staging

echo $(date  +"%T") 'snappea-staging - complete'
heroku ps --app snappea-staging