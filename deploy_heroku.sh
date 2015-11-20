
echo  'Run to install heroku toolbelt'- 'wget -O- https://toolbelt.heroku.com/install-ubuntu.sh | sh '
echo '--------------------------------------------------------------------------------\n\n'
echo  'LOGIN TO YOUR HEROKU ACCOUNT'
heroku login
echo '--------------------------------------------------------------------------------\n\n'

git init
git add .
echo  'Enter first commit message'
read comit_message
git commit -m "$comit_message"
echo  'Do you have existing app on heroku [Y/n]?'
read app_exists

if [ $app_exists == y ]
then
		echo 'Enter the heroku app name'
		read app_name
		heroku git:remote -a $app_name
else
   heroku create
fi
git push heroku master
heroku run rake db:migrate
echo '################# THANKS TO VISHAL GARG ###########################'
heroku apps:info