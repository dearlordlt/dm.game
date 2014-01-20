#!/bin/bash
# backup and deploy productions version of DM project

BASE_PATH=/var/www/html

# project name
PROJECT_NAME="dm"

# production amfphp dir
PROD_AMFPHP_DIR=new_amfphp_prod

# dev amf php dir
DEV_AMFPHP_DIR=new_amfphp

#service dir
SERVICE_DIR=$PROD_AMFPHP_DIR"/Amfphp/Services/dm"

DEV_SERVICE_DIR=$DEV_AMFPHP_DIR"/Amfphp/Services/dm"

# backup dir
BACKUP_DIR=$PROJECT_NAME"_backups"

#development (testing) dir
DEV_DIR=$PROJECT_NAME"_dev"

CURRENT_TIMESTAMP=$(date +%Y%m%d%H%M%S)

# backup made flags
CLIENT_BC_FLAG=false
SERVICE_BC_FLAG=false
DB_BC_FLAG=false


# BASE_PATH=/var/www/html/

usage () {
	echo "Utility that manages DM project backup, testing and deployment."
	echo "Have in mind that if you're deploying something it is automaticaly back up."
	echo "[-bp	backup all production (services, db, and client)]"
	echo "[-bps	backup production services]"
	echo "[-bpd	backup production DB]"
	echo "[-bpc	backup production client]"
	echo "[-dt	deploy test version to production (client and services). Before deployment creates full production backup]"
	echo "[-dtc	deploy test version client to production]"
	echo "[-dts	deploy test version services to production]"
	echo "[-h	see this help]"
}

backup_production () {
	echo "Backing up production..."
	backup_production_services
	backup_production_database
	backup_production_client
}

deploy_test_to_production () {
	deploy_test_services_to_production
	deploy_test_client_to_production
}

backup_production_services () {
	if [ "$SERVICE_BC_FLAG" == "$CURRENT_TIMESTAMP" ]; then
		return 1
	fi
	echo "backing up production services..."
	OF=$CURRENT_TIMESTAMP.tar.gz
	tar --gzip -cf $BASE_PATH/$BACKUP_DIR/$SERVICE_DIR/$OF $BASE_PATH/$SERVICE_DIR/
	
	SERVICE_BC_FLAG=$CURRENT_TIMESTAMP
}

backup_production_database () {
	if [ "$DB_BC_FLAG" == "$CURRENT_TIMESTAMP" ]; then
		return 1
	fi
	echo "backing up production database..."
	mysqldump --user backup --password=XX4yVPMBPUqfXeEn dm | gzip > $BASE_PATH/$BACKUP_DIR/mysql/$(date +%Y%m%d%H%M%S).gz
	
	DB_BC_FLAG=$CURRENT_TIMESTAMP
}

backup_production_client () {
	if [ "$CLIENT_BC_FLAG" == "$CURRENT_TIMESTAMP" ]; then
		return 1
	fi
	echo "backing up production client..."
	OF=$CURRENT_TIMESTAMP.tar.gz
	tar --gzip -cf $BASE_PATH/$BACKUP_DIR/client/$OF $BASE_PATH/$PROJECT_NAME/main.swf
	
	CLIENT_BC_FLAG=$CURRENT_TIMESTAMP
}

deploy_test_services_to_production () {
	backup_production_services
	echo "Deploying dev services to production"
	rm -rf $BASE_PATH/$PROD_AMFPHP_DIR/*
	cp -rf $BASE_PATH/$DEV_AMFPHP_DIR/* $BASE_PATH/$PROD_AMFPHP_DIR/
}

deploy_test_client_to_production () {
	backup_production_client
	echo "Deploying dev services to production"
	rm -rf $BASE_PATH/$PROJECT_NAME/main.swf
	cp -rf $BASE_PATH/$DEV_DIR/main.swf $BASE_PATH/$PROJECT_NAME/
	echo "var currentVersionTimeStamp = "$CURRENT_TIMESTAMP";" > $BASE_PATH/$PROJECT_NAME/currentversiontimestamp.js
}

# going through parameters
while [ "$1" != "" ]; do
    case $1 in
		
        -bp )           				backup_production
									exit
									;;
        -bps )    					shift
									backup_production_services
									;;
        -bpd )    					shift
									backup_production_database
									;;
        -bpc )    					shift
									backup_production_client
									;;
									
        -dt )           				deploy_test_to_production
									exit
									;;
        -dts )    					shift
									deploy_test_services_to_production
									;;
        -dtc )    					shift
									deploy_test_client_to_production
									;;
		
		
        -h | --help )           	usage
									exit
									;;

        * )                     	usage
									exit 1
    esac
    shift
done
