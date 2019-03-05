FROM python:3.6-alpine

RUN adduser -D scopsassgn

WORKDIR /home/scopsassgn

COPY requirements.txt requirements.txt
RUN python -m venv venv
RUN venv/bin/pip install -r requirements.txt
RUN venv/bin/pip install gunicorn pymysql

COPY app app
COPY migrations migrations
COPY scopsassgn.py config.py boot.sh ./
RUN chmod a+x boot.sh

ENV FLASK_APP scopsassgn.py

RUN chown -R scopsassgn:scopsassgn ./
USER scopsassgn

EXPOSE 5000
ENTRYPOINT ["./boot.sh"]
