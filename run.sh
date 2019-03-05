source venv/bin/activate
export FLASK_APP=scopsassgn.py
export FLASK_DEBUG=1 # TO SWITCH THE DEBUG MODE
export MAIL_PORT=8025
export MAIL_SERVER=smtp.googlemail.com 
export MAIL_PORT=587 
export MAIL_USE_TLS=true 
export MAIL_USERNAME=dockertesting12@gmail.com 
export MAIL_PASSWORD=Student12#
flask run
