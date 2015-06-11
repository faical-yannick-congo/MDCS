#!/bin/bash
echo -e "\033[31m NOTE: Make sure you are in the MDCS root source code."
echo -e "\033[0m "
# Check if gedit is running
command_1="mongod --auth --dbpath=data/db --bind_ip=127.0.0.1"
running_1=`ps ax | grep -v grep | grep "$command_1" | wc -l`
command_2="java -jar JenaServers.jar -rdfserver_endpoint"
running_2=`ps ax | grep -v grep | grep "$command_2" | wc -l`
command_3="python manage.py runserver"
running_3=`ps ax | grep -v grep | grep "$command_3" | wc -l`
if [ $running_1 -ne "0" ] || [ $running_2 -ne "0" ] || [ $running_3 -ne "0" ] ; then
    ./shutdown.sh
    if [ $? -eq "110" ]; then
    	exit
    fi
    sleep 10
    clear
    if [ $running_1 -eq "0" ] || [ $running_2 -eq "0" ] || [ $running_3 -eq "0" ] ; then
	    echo -e "\033[31m NOTE: An MDCS instance is still running. Please run a shutdown first."
		echo -e "\033[0m "	
	else
		echo "1-Activating the environment:"
		source activate $mdcs_env
		echo ""
		echo "2-Cleaning the database.."
		rm -rf data/db/*
		echo ""
		echo "3-Deleting the environment:"
		source deactivate $mdcs_env
		conda remove -n $mdcs_env
		echo ""
		echo "4-Resetting back the mgi settings file:"
		sed -i 's/^MONGO_MGI_USER = .*/MONGO_MGI_USER = "mongo_mgi_user"/' mgi/settings.py
		sed -i 's/^MONGO_MGI_PASSWORD = .*/MONGO_MGI_PASSWORD = "mongo_mgi_password"/' mgi/settings.py
	fi
else
	echo "1-Enter install anaconda environment name:"
	read mdcs_env
	source deactivate
	echo ""
	echo "2-Activating the environment:"
	source activate $mdcs_env
	echo ""
	echo "3-Cleaning the database.."
	rm -rf data/db/*
	echo ""
	echo "4-Deleting the environment:"
	source deactivate
	echo $mdcs_env
	conda env remove -n $mdcs_env
	echo ""
	echo "5-Resetting back the mgi settings file:"
	sed -i 's/^MONGO_MGI_USER = .*/MONGO_MGI_USER = "mongo_mgi_user"/' mgi/settings.py
	sed -i 's/^MONGO_MGI_PASSWORD = .*/MONGO_MGI_PASSWORD = "mongo_mgi_password"/' mgi/settings.py
fi