#!/bin/bash
lowercase(){
    echo "$1" | sed "y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/"
}
OS=`lowercase \`uname\``
platform="Unknown"
MACHINE_TYPE=`uname -m`

if [ "{$OS}" == "windowsnt" ]; then
	# I am not sure we are interested in this case for a bash file.
    platform="Windows"
elif [ "{$OS}" == "darwin" ]; then
	platform="OsX"
else
    OS=`uname`
    if [ "${OS}" = "SunOS" ] ; then
        platform="Solaris"
    elif [ "${OS}" = "AIX" ] ; then
        platform="Aix"
    elif [ "${OS}" = "Linux" ] ; then
        if [ -f /etc/redhat-release ] ; then
        	platform="RedHat"
        elif [ -f /etc/SuSE-release ] ; then
        	platform="Suse"
        elif [ -f /etc/mandrake-release ] ; then
        	platform="Mandrake"
        elif [ -f /etc/debian_version ] ; then
        	dist=`grep DISTRIB_ID /etc/*-release | awk -F '=' '{print $2}'`
            platform="$dist"
        fi
        if [ -f /etc/UnitedLinux-release ] ; then
            platform="UnitedLinux"
        fi
     fi
fi
echo "MDCS Installation script for Linux and Unix platforms."
echo "This script will install and run the first instance of the MDCS"
echo "After executing this script you don't have to launch run.sh again unless you lauched shutdown.sh."
echo ""
echo ""
echo "Script detected platform: $platform."
echo ""
if [ $platform = "Ubuntu" ] || [ $platform = "Debian" ] || [ $platform = "Aix" ] || [ $platform = "Mandrake" ] || [ $platform = "OsX" ] ; then 
	echo "1- Install Anaconda:"
	if [ $platform = "Aix" ] || [ $platform = "Mandrake" ] ; then
		command -v wget >/dev/null 2>&1 || { echo >&2 "This requires wget but it's not installed.  Installing..."; sudo rpm -ivh wget*; }
		command -v conda >/dev/null 2>&1 || { echo >&2 "This requires anaconda but it's not installed.  Installing..."; wget https://3230d63b5fc54e62148e-c95ac804525aac4b6dba79b00b39d1d3.ssl.cf1.rackcdn.com/Anaconda-2.2.0-Linux-$MACHINE_TYPE.sh; bash Anaconda-2.2.0-Linux-$MACHINE_TYPE.sh; rm Anaconda-2.2.0-Linux-$MACHINE_TYPE.sh;}
	elif [ $platform = "Suse" ] ; then
		command -v wget >/dev/null 2>&1 || { echo >&2 "This requires wget but it's not installed.  Installing..."; sudo zypper install wget; }
		command -v conda >/dev/null 2>&1 || { echo >&2 "This requires anaconda but it's not installed.  Installing..."; wget https://3230d63b5fc54e62148e-c95ac804525aac4b6dba79b00b39d1d3.ssl.cf1.rackcdn.com/Anaconda-2.2.0-Linux-$MACHINE_TYPE.sh; bash Anaconda-2.2.0-Linux-$MACHINE_TYPE.sh; rm Anaconda-2.2.0-Linux-$MACHINE_TYPE.sh;}
	elif [ $platform = "RedHat" ] ; then
		command -v wget >/dev/null 2>&1 || { echo >&2 "This requires wget but it's not installed.  Installing..."; sudo yum install wget; }
		command -v conda >/dev/null 2>&1 || { echo >&2 "This requires anaconda but it's not installed.  Installing..."; wget https://3230d63b5fc54e62148e-c95ac804525aac4b6dba79b00b39d1d3.ssl.cf1.rackcdn.com/Anaconda-2.2.0-Linux-$MACHINE_TYPE.sh; bash Anaconda-2.2.0-Linux-$MACHINE_TYPE.sh; rm Anaconda-2.2.0-Linux-$MACHINE_TYPE.sh;}
	elif [ $platform = "OsX" ] ; then
		command -v wget >/dev/null 2>&1 || { echo >&2 "This requires wget but it's not installed.  Please install wget."; exit; }
		command -v conda >/dev/null 2>&1 || { echo >&2 "This requires anaconda but it's not installed.  Installing..."; wget https://3230d63b5fc54e62148e-c95ac804525aac4b6dba79b00b39d1d3.ssl.cf1.rackcdn.com/Anaconda-2.2.0-MacOSX-$MACHINE_TYPE.sh; bash Anaconda-2.2.0-Linux-$MACHINE_TYPE.sh; rm Anaconda-2.2.0-MacOSX-$MACHINE_TYPE.sh;}
	else
		command -v wget >/dev/null 2>&1 || { echo >&2 "This requires wget but it's not installed.  Installing..."; sudo apt-get install wget; }
		command -v conda >/dev/null 2>&1 || { echo >&2 "This requires anaconda but it's not installed.  Installing..."; wget https://3230d63b5fc54e62148e-c95ac804525aac4b6dba79b00b39d1d3.ssl.cf1.rackcdn.com/Anaconda-2.2.0-Linux-$MACHINE_TYPE.sh; bash Anaconda-2.2.0-Linux-$MACHINE_TYPE.sh; rm Anaconda-2.2.0-Linux-$MACHINE_TYPE.sh;}
	fi

	# command -v conda >/dev/null 2>&1 || { echo >&2 "This requires anaconda but it's not installed.  Installing..."; wget https://3230d63b5fc54e62148e-c95ac804525aac4b6dba79b00b39d1d3.ssl.cf1.rackcdn.com/Anaconda-2.2.0-Linux-x86_64.sh; bash Anaconda-2.2.0-Linux-x86_64.sh; rm Anaconda-2.2.0-Linux-x86_64.sh;}

	# wget https://3230d63b5fc54e62148e-c95ac804525aac4b6dba79b00b39d1d3.ssl.cf1.rackcdn.com/Anaconda-2.2.0-Linux-x86_64.sh
	# bash Anaconda-2.2.0-Linux-x86_64.sh
	# rm Anaconda-2.2.0-Linux-x86_64.sh
	echo ""
	echo "2- Create an environmen environment:"
	echo "Enter environment name:"
	read mdcs_env
	env_check=`conda env list | grep -v grep | grep $mdcs_env | wc -l`
	if [ $env_check -ne "0" ]; then
		echo ""
		echo -e "\033[31m WARNING: If the environment already exitst and you don't use it. You will have to run back the install script."
		echo -e "\033[0m "
		echo "Environment already exist. Use it? (y to accept):"
		read env_resp
		if [ $env_resp == "y" ]; then
			echo ""
			echo "3- Using the environment:"
			source activate $mdcs_env
		else
			exit
		fi
	else
		conda create -n $mdcs_env python=2.7 anaconda
		echo ""
		echo "3- Use the created environment:"
		source activate $mdcs_env
	fi
	echo ""
	echo "4- Check java version is >= 7:"
	# $ command -v java >/dev/null 2>&1 || { echo >&2 "This requires Java but it's not installed.  Installing..."; sudo apt-get install openjdk-7-jdk; }
	if type -p java; then
	    echo "Java has been found in this computer."
	    _java=java
	elif [[ -n "$JAVA_HOME" ]] && [[ -x "$JAVA_HOME/bin/java" ]]; then
	    echo "Java has been found in this computer."    
	    _java="$JAVA_HOME/bin/java"
	else
	    echo "Java is not installed."
	    echo "Enter your sudo password to install Java 7:"
	    if [ $platform = "Aix" ] || [ $platform = "Mandrake" ] ; then
			command -v wget >/dev/null 2>&1 || { echo >&2 "This requires wget but it's not installed.  Go to: http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html"; exit; }
		elif [ $platform = "Suse" ] ; then
			command -v wget >/dev/null 2>&1 || { echo >&2 "This requires wget but it's not installed.  Go to: http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html"; exit; }
		elif [ $platform = "OsX" ] ; then
			command -v wget >/dev/null 2>&1 || { echo >&2 "This requires wget but it's not installed.  Go to: http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html"; exit; }
		elif [ $platform = "RedHat" ] ; then
			command -v wget >/dev/null 2>&1 || { echo >&2 "This requires wget but it's not installed.  Installing..."; sudo yum install java-1.7.0-openjdk-devel; }
		else
			sudo apt-get install openjdk-7-jdk
		fi
	fi

	if [[ "$_java" ]]; then
	    version=$("$_java" -version 2>&1 | awk -F '"' '/version/ {print $2}')
	    echo version "$version"
	    if [[ "$version" > "1.6" ]]; then
	        echo "You are all set with this version of java."
	    else         
	        echo "You have an older version of java. This requires at least version 7."
	        echo "Enter your sudo password to install Java 7:"
	        if [ $platform = "Aix" ] || [ $platform = "Mandrake" ] ; then
				command -v wget >/dev/null 2>&1 || { echo >&2 "This requires wget but it's not installed.  Go to: http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html"; exit; }
			elif [ $platform = "Suse" ] ; then
				command -v wget >/dev/null 2>&1 || { echo >&2 "This requires wget but it's not installed.  Go to: http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html"; exit; }
			elif [ $platform = "OsX" ] ; then
				command -v wget >/dev/null 2>&1 || { echo >&2 "This requires wget but it's not installed.  Go to: http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html"; exit; }
			elif [ $platform = "RedHat" ] ; then
				command -v wget >/dev/null 2>&1 || { echo >&2 "This requires wget but it's not installed.  Installing..."; sudo yum install java-1.7.0-openjdk-devel; }
			else
				sudo apt-get install openjdk-7-jdk
			fi
	    fi
	fi
	echo ""
	echo "5- Install all the python requirements"
	if [ $platform = "Aix" ] || [ $platform = "Mandrake" ] ; then
		command -v wget >/dev/null 2>&1 || { echo >&2 "This requires wget but it's not installed.  Installing..."; sudo rpm -ivh wget*; }
	elif [ $platform = "Suse" ] ; then
		command -v wget >/dev/null 2>&1 || { echo >&2 "This requires wget but it's not installed.  Installing..."; sudo zypper install python-devel python-pip; }
	elif [ $platform = "OsX" ] ; then
		command -v wget >/dev/null 2>&1 || { echo >&2 "This requires wget but it's not installed.  Installing..."; sudo easy_install install pip; }
	elif [ $platform = "RedHat" ] ; then
		command -v wget >/dev/null 2>&1 || { echo >&2 "This requires wget but it's not installed.  Installing..."; sudo yum install python-devel python-pip; }
	else
		command -v pip >/dev/null 2>&1 || { echo >&2 "This requires pip but it's not installed.  Installing..."; sudo apt-get install python-dev python-pip; }
	fi
	pip install -r docs/requirements.txt
	echo ""
	echo "6- Install mongodb:"
	echo -e "\033[31m NOTE: Wait 10 sec. This screen will be cleared up."
	echo -e "\033[0m "
	conda install mongodb
	mongod --auth --dbpath=data/db --bind_ip=127.0.0.1 &
	sleep 10
	clear
	echo "Enter Mongo Admin User:"
	read mongo_admin_user
	echo "Enter Mongo Admin Password:"
	read mongo_admin_password
	echo -e "use admin\ndb.addUser({user: \"${mongo_admin_user}\", \"pwd\":\"${mongo_admin_password}\", roles: [\"userAdminAnyDatabase\",\"backup\",\"restore\",\"admin\"]})\nexit" | mongo
	echo "Enter Mongo MGI User:"
	read mongo_mgi_user
	echo "Enter Mongo MGI Password:"
	read mongo_mgi_password
	echo -e "use mgi\ndb.addUser({user: \"${mongo_mgi_user}\",pwd: \"${mongo_mgi_password}\",roles: [\"readWrite\"]})\nexit" | mongo --port 27017 -u "${mongo_admin_user}" -p "${mongo_admin_password}" --authenticationDatabase admin
	echo ""
	echo "7- Updating the MGI settings"
	sed -i 's/mgi_user/'$mongo_mgi_user'/g' mgi/settings.py
	sed -i 's/mgi_password/'$mongo_mgi_password'/g' mgi/settings.py
	echo ""
	echo "8- Running the JenaServers"
	cd rdf
	java -jar JenaServers.jar -rdfserver_endpoint 'tcp://127.0.0.1:5555' -sparqlserver_endpoint 'tcp://127.0.0.1:5556' -tdb_directory '../data/ts' -project_uri 'http://www.example.com/' &
	cd ..
	echo ""
	echo "9- Sync database"
	echo -e "\033[31m NOTE: confirm the django admin creation. Leave admin user and password as the same in the Mongo Admin db."
	echo -e "\033[0m "
	sleep 10
	python manage.py syncdb
	echo ""
	echo "10- Run the server"
	python manage.py runserver &
	sleep 10
	echo ""
	echo "11- Open the browser"
	python -mwebbrowser http://127.0.0.1:8000
else
	echo -e "\033[31m ERROR: We are sorry but $platform is not yet supported."
	echo -e "\033[0m "
fi
