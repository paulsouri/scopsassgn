import json
import sys
import time
from flask import render_template
from rq import get_current_job
from app import create_app, db
from app.models import User, Post, Task
from app.email import send_email

app = create_app()
app.app_context().push()


def _set_task_progress(progress):
    job = get_current_job()
    if job:
        job.meta['progress'] = progress
        job.save_meta()
        task = Task.query.get(job.get_id())
        task.user.add_notification('task_progress', {'task_id': job.get_id(),
                                                     'progress': progress})
        if task.cancelled:
            progress = 100
        if progress >= 100:
            task.complete = True
        db.session.commit()

def _cancel_task_progress(progress):
    job = get_current_job()
    if job:
        job.meta['progress'] = progress
        job.save_meta()
        task = Task.query.get(job.get_id())
        task.user.add_notification('task_progress', {'task_id': job.get_id(),
                                                     'progress': progress})
        task.complete = True
        db.session.commit()

def stop_export_posts(user_id):
    try:
        user = User.query.get(user_id)
        _cancel_task_progress(100)
        send_email('[Scopsassgn] Your blog posts',
                sender=app.config['ADMINS'][0], recipients=[user.email],
                text_body=render_template('email/export_posts_can.txt', user=user),
                html_body=render_template('email/export_posts_can.html',
                                          user=user),
                attachments=[],
                sync=True)
    except:
        _set_task_progress(100)
        app.logger.error('Unhandled exception', exc_info=sys.exc_info())

def export_posts(user_id):
    try:
        user = User.query.get(user_id)
        _set_task_progress(0)
        data = []
        i = 0
        total_posts = user.posts.count()
        job = get_current_job()
        task = Task.query.get(job.get_id())
        for post in user.posts.order_by(Post.timestamp.asc()):
            if not task.cancelled:
                data.append({'body': post.body,
                             'timestamp': post.timestamp.isoformat() + 'Z'})
                time.sleep(5)
                print ("I AM HERE")
                i += 1
                _set_task_progress(100 * i // total_posts)
            else:
                break
        if not task.cancelled:
            send_email('[Scopsassgn] Your blog posts',
                    sender=app.config['ADMINS'][0], recipients=[user.email],
                    text_body=render_template('email/export_posts.txt', user=user),
                    html_body=render_template('email/export_posts.html',
                                              user=user),
                    attachments=[('posts.json', 'application/json',
                                  json.dumps({'posts': data}, indent=4))],
                    sync=True)
        else:
            stop_export_posts(user_id)
    except:
        _set_task_progress(100)
        app.logger.error('Unhandled exception', exc_info=sys.exc_info())
