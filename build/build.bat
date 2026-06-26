@echo off

docker build --secret id=env,src=.env --tag progressive-victory:latest --no-cache .
