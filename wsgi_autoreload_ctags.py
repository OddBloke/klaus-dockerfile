import os
import warnings

from klaus.contrib.wsgi_autoreload import make_autoreloading_app

if 'KLAUS_REPOS' in os.environ:
    warnings.warn("use KLAUS_REPOS_ROOT instead of KLAUS_REPOS for the autoreloader apps", DeprecationWarning)

if 'KLAUS_HTDIGEST_FILE' in os.environ:
    with open(os.environ['KLAUS_HTDIGEST_FILE']) as file:
        application = make_autoreloading_app(
            os.environ.get('KLAUS_REPOS_ROOT') or os.environ['KLAUS_REPOS'],
            os.environ['KLAUS_SITE_NAME'],
            os.environ.get('KLAUS_USE_SMARTHTTP'),
            file,
            ctags_policy=os.environ.get('KLAUS_CTAGS_POLICY', 'none'),
        )
else:
    application = make_autoreloading_app(
        os.environ.get('KLAUS_REPOS_ROOT') or os.environ['KLAUS_REPOS'],
        os.environ['KLAUS_SITE_NAME'],
        os.environ.get('KLAUS_USE_SMARTHTTP'),
        ctags_policy=os.environ.get('KLAUS_CTAGS_POLICY', 'none'),
    )
