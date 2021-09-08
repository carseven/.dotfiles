# Python dependencies (recommended by pyenv)
brew install openssl readline sqlite3 xz zlib

# Pyenv, pyenv-doctor, pyenv-installer, pyenv-update, pyenv-virtualenv, and pyenv-which-ext
# https://github.com/pyenv/pyenv-installer
curl https://pyenv.run | bash
# Uninstall: rm -fr ~/.pyenv


# Poetry
# This temporarily sticky sets our Python version to the system Python, and installs poetry with this version.
pyenv shell system
curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python -
pyenv shell --unset
# Uninstall: python get-poetry.py --uninstall or POETRY_UNINSTALL=1 python get-poetry.py
