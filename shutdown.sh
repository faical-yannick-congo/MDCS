#!/bin/bash
echo "1-Enter install anaconda environment name:"
read mdcs_env
source deactivate
echo ""
echo "2-Activating the environment:"
env_check=`conda env list | grep -v grep | grep $mdcs_env | wc -l`
if [ $env_check -ne "0" ]; then
	source activate $mdcs_env
else
	echo -e "\033[31m ERROR: This environment does not exist. Make sure you type the right name or look into (conda env list)."
	echo -e "\033[0m "
	exit 110
fi
echo ""
echo "3-Killing MongoDb..."
running_1=`ps ax | grep -v grep | grep "mongod --auth --dbpath=data/db --bind_ip=127.0.0.1" | wc -l`
if [ $running_1 -ne "0" ]; then
    ps aux | grep -ie "mongod --auth --dbpath=data/db --bind_ip=127.0.0.1" | awk '{print $2}' | xargs kill -9 
    sleep 10
    clear
	echo "Mongodb is down."
else
	echo "Mongodb is down."
fi
echo ""
echo "4-Killing JenaServers..."
running_2=`ps ax | grep -v grep | grep "java -jar JenaServers.jar -rdfserver_endpoint" | wc -l`
if [ $running_2 -ne "0" ]; then
    ps aux | grep -ie "java -jar JenaServers.jar -rdfserver_endpoint" | awk '{print $2}' | xargs kill -9 
	sleep 10
	clear
	echo "JenaServers are down."
else
	echo "JenaServers are down."
fi
echo ""
echo "5-Killing MDCS server..."
running_3=`ps ax | grep -v grep | grep "python manage.py runserver" | wc -l`
if [ $running_3 -ne "0" ]; then
    ps aux | grep -ie "python manage.py runserver" | awk '{print $2}' | xargs kill -9
    sleep 10
    echo "MDCS server is down."
else
	echo "MDCS server is down."
fi