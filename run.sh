#!/bin/bash
echo -e "\033[31m NOTE: Make sure you are in the MDCS root source code."
echo -e "\033[0m "
echo "1-Enter install anaconda environment name:"
	read mdcs_env
	source deactivate

echo "2-Activating the environment:"
env_check=`conda env list | grep -v grep | grep $mdcs_env | wc -l`
if [ $env_check -ne "0" ]; then
	source activate $mdcs_env
else
	echo -e "\033[31m ERROR: This environment does not exist. Make sure you type the right name or look into (conda env list)."
	echo -e "\033[0m "
	exit
fi

echo "3-Lauching MongoDb.."
mongod --auth --dbpath=data/db --bind_ip=127.0.0.1 &
sleep 10
clear
running_1=`ps ax | grep -v grep | grep "mongod --auth --dbpath=data/db --bind_ip=127.0.0.1" | wc -l`
if [ $running_1 -ne "0" ]; then
	echo "Mongodb is up."
else
	echo -e "\033[31m ERROR: Something went wrong when launching mongodb. Please read the error and fix it."
	echo -e "\033[0m "
	exit
fi

echo "4-Lauching JenaServers..."
cd rdf
java -jar JenaServers.jar -rdfserver_endpoint 'tcp://127.0.0.1:5555' -sparqlserver_endpoint 'tcp://127.0.0.1:5556' -tdb_directory '../data/ts' -project_uri 'http://www.example.com/' &
cd ..
sleep 10
clear
running_2=`ps ax | grep -v grep | grep "java -jar JenaServers.jar -rdfserver_endpoint" | wc -l`
if [ $running_2 -ne "0" ]; then
	echo "JenaServers are up."
else
	echo -e "\033[31m ERROR: Something went wrong when launching JenaServers. Please read the error and fix it."
	echo -e "\033[0m "
	exit
fi

echo "5-Lauching MDCS server..."
python manage.py runserver &
sleep 10
clear
running_3=`ps ax | grep -v grep | grep "python manage.py runserver" | wc -l`
if [ $running_3 -ne "0" ]; then
	echo "MDCS server is up."
else
	echo -e "\033[31m ERROR: Something went wrong when launching MDCS server. Please read the error and fix it."
	echo -e "\033[0m "
	exit
fi

echo "6-Opening browser..."
python -mwebbrowser http://127.0.0.1:8000