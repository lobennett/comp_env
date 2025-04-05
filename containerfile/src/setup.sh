#!/bin/bash
#
# PURPOSE: Setup a simple python project with uv
# DESC: This script will activate the virtual environment in /opt/.venv in
# the container and then create a new project using cookiecutter
# (https://github.com/cookiecutter/cookiecutter). The cookiecutter template
# is a simple project template that we at the Poldrack Lab started using 
# for creating new python projects. 

source /opt/.venv/bin/activate
uvx cookiecutter https://github.com/lobennett/uv_cookie.git