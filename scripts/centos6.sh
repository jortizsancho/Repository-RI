#! /bin/bash

sudo yum update
sudo yum -y install unzip
sudo yum -y install zip
sudo yum -y install maven
    
set +e
# Install java 8
./scripts/installJavaCentos.sh
cd $INSPWD

# Install tomcat 8
./scripts/installTomcat8.sh

# Install virtuoso
./scripts/installVirtuosoCentos6.sh

set -e

# Install mongodb
sudo ./scripts/installMongoCentos.sh

sudo yum install -y mongodb-org

# Add the file settings
sudo ./scripts/repositorySettings.sh

# Install the repository from source code or build
if [ -d "$INSPWD/src" ]; then
	# Installation from source code
	./scripts/oAuthConfigSources.sh
	mvn clean install
	cp ./target/FiwareRepository.war $INSPWD/apache-tomcat/webapps/FiwareRepository.war
else
	# Installation from build
	./scripts/oAuthConfig.sh
	cp ./FiwareRepository.war $INSPWD/apache-tomcat/webapps/FiwareRepository.war
fi

#Start Virtuoso
cd $INSPWD/virtuoso7/var/lib/virtuoso/db/
$INSPWD/virtuoso7/bin/virtuoso-t -f &
cd $INSPWD

#Start Tomcat
cd $INSPWD/apache-tomcat/bin/
./startup.sh
cd $INSPWD

#Create taks
sudo ./scripts/startupCentos.sh

