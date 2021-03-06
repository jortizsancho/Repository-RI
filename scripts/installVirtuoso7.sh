#! /bin/bash

if [ $REPO_OS == "centos6" ]; then
    wget https://repo.conwet.fi.upm.es/artifactory/libs-release-local/org/fiware/apps/repository/virtuoso/7.1.0/virtuoso-7.1.0_centos-6_amd64.tar.xz
    tar -Jxf virtuoso-7.1.0_centos-6_amd64.tar.xz
    sudo rm virtuoso-7.1.0_centos-6_amd64.tar.xz
    sed -i "s|/home/centos/Repository-RI|$INSPWD|g" $INSPWD/virtuoso7/var/lib/virtuoso/db/virtuoso.ini

elif [ $REPO_OS == "centos7" ] ; then
    wget https://repo.conwet.fi.upm.es/artifactory/libs-release-local/org/fiware/apps/repository/virtuoso/7.1.0/virtuoso-7.1.0_centos-7_amd64.tar.xz
    tar -Jxf virtuoso-7.1.0_centos-7_amd64.tar.xz
    sudo rm virtuoso-7.1.0_centos-7_amd64.tar.xz
    sed -i "s|/home/centos/Repository-RI|$INSPWD|g" $INSPWD/virtuoso7/var/lib/virtuoso/db/virtuoso.ini

elif [ $REPO_OS == "debian" ] ; then
    wget https://repo.conwet.fi.upm.es/artifactory/libs-release-local/org/fiware/apps/repository/virtuoso/7.1.0/virtuoso-7.1.0_debian-7_amd64.tar.xz
    tar -Jxf virtuoso-7.1.0_debian-7_amd64.tar.xz
    sudo rm virtuoso-7.1.0_debian-7_amd64.tar.xz
    sed -i "s|/home/debian/Repository-RI|$INSPWD|g" $INSPWD/virtuoso7/var/lib/virtuoso/db/virtuoso.ini

elif [ $REPO_OS == "ubuntu12.04" ] ; then
    wget https://repo.conwet.fi.upm.es/artifactory/libs-release-local/org/fiware/apps/repository/virtuoso/7.1.0/virtuoso-7.1.0_ubuntu-12_amd64.tar.xz
    tar -Jxf virtuoso-7.1.0_ubuntu-12_amd64.tar.xz
    sudo rm virtuoso-7.1.0_ubuntu-12_amd64.tar.xz
    sed -i "s|/home/ubuntu/Repository-RI|$INSPWD|g" $INSPWD/virtuoso7/var/lib/virtuoso/db/virtuoso.ini

elif [ $REPO_OS == "ubuntu14.04" ] ; then
    wget https://repo.conwet.fi.upm.es/artifactory/libs-release-local/org/fiware/apps/repository/virtuoso/7.1.0/virtuoso-7.1.0_ubuntu-14_amd64.tar.xz
    tar -Jxf virtuoso-7.1.0_ubuntu-14_amd64.tar.xz
    sudo rm virtuoso-7.1.0_ubuntu-14_amd64.tar.xz
    sed -i "s|/home/ubuntu/Repository-RI|$INSPWD|g" $INSPWD/virtuoso7/var/lib/virtuoso/db/virtuoso.ini

else

    ./scripts/installVirtuosoCompillationTools.sh
    
    ## Install Virtuoso from the source code.
    wget https://github.com/openlink/virtuoso-opensource/archive/stable/7.zip

    if [[ $? -ne "0" ]]; then
            echo "Virtuoso 7 donwload failed. Check internet connection."
            exit 1
    fi

    unzip 7.zip
    cd virtuoso-opensource-stable-7

    CFLAGS="-O2 -m64"
    export CFLAGS

    ./autogen.sh
    if [[ $? -ne "0" ]]; then
            echo "Check that all the needed packages are installed."
            exit 1
    fi
    ./configure
    if [[ $? -ne "0" ]]; then
            echo "Check that all the needed packages are installed."
            exit 1
    fi

    make install prefix=$INSPWD/virtuoso7
    if [[ $? -ne "0" ]]; then
            echo "Compilation error, check that all the needed packages are installed."
            exit 1
    fi

    cd ..
    sudo rm -r virtuoso-opensource-stable-7
    sudo rm 7.zip
fi

cd $INSPWD/virtuoso7/var/lib/virtuoso/db/
$INSPWD/virtuoso7/bin/virtuoso-t -f &
cd $INSPWD
