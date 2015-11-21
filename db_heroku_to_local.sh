
echo 'What heroku app database would you like to sync to your local environment?'
echo $(date  +"%T") 
echo '--------------------------------------------------------------------------------'
read app_name

echo 'What is your local db user?'
echo '--------------------------------------------------------------------------------'
read user_name

echo 'What is your local db name?'
echo '--------------------------------------------------------------------------------'
read db_name

set -e


heroku pg:backups capture --app $app_name
curl -o tmp/latest.dump `heroku pg:backups public-url --app $app_name`
# Setup local db
rake db:drop
rake db:create

# Load databse into local db
pg_restore -h localhost -U $user_name -d $db_name < tmp/latest.dump
# Clean up
rm -f tmp/latest.dump
