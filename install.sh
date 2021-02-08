#!/bin/bash


# 2021-2-7 22:27:41 ---> 
startTime_s=$(date +%s)
if [ ! -f ./docker-compose.yml ]
then
	if [ ! -f ./docker-compose.yml.example ]; then
		echo '缺失docker-compose.yml.example文件'
		exit
	fi	

	NGINX_CONFIG_PATH="$(pwd)/nginx"
	NGINX_PORTS='80'
	WWW_PATH="$(pwd)/www"
	PHP_FPM_PATH="$(pwd)/php/php-fpm.d"
	PHP_CONFIG_PATH="$(pwd)/php/php-ini.d"
	REDIS_CONFIG_PATH="$(pwd)/redis"
	REDIS_PORTS='6379'

	NGINX_CONFIG_PATH=${NGINX_CONFIG_PATH//\//\\\/}
	WWW_PATH=${WWW_PATH//\//\\\/}
	PHP_FPM_PATH=${PHP_FPM_PATH//\//\\\/}
	REDIS_CONFIG_PATH=${REDIS_CONFIG_PATH//\//\\\/}
	PHP_CONFIG_PATH=${PHP_CONFIG_PATH//\//\\\/}

	# echo "s/NGINX_CONFIG_PATH/${NGINX_CONFIG_PATH}/g"
	# echo "s/NGINX_PORTS/${NGINX_PORTS}/g"
	# echo "s/WWW_PATH/${WWW_PATH}/g"
	# echo "s/PHP_FPM_PATH/${PHP_FPM_PATH}/g"

	if [ ! -f /usr/bin/docker ]; then
		yum -y update
		yum -y install docker
	fi

	if [ ! -f /usr/local/bin/docker-compose ]; then
		#安装docker-compose
		#sudo curl -L "https://github.com/docker/compose/releases/download/1.28.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
		#国内源
		sudo curl -L "http://get.daocloud.io/docker/compose/releases/download/1.28.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
		sudo chmod +x /usr/local/bin/docker-compose
		#docker换源
		# echo '{"registry-mirrors": ["http://hub-mirror.c.163.com"]}' > /etc/docker/daemon.json
		echo '{"registry-mirrors": ["https://17bc8gd7.mirror.aliyuncs.com"]}' > /etc/docker/daemon.json
	fi



	#修改文件
	cp ./docker-compose.yml.example ./docker-compose.yml
	sed -i "s/NGINX_CONFIG_PATH/${NGINX_CONFIG_PATH}/g" docker-compose.yml
	sed -i "s/NGINX_PORTS/${NGINX_PORTS}/g" docker-compose.yml
	sed -i "s/WWW_PATH/${WWW_PATH}/g" docker-compose.yml
	sed -i "s/PHP_FPM_PATH/${PHP_FPM_PATH}/g" docker-compose.yml
	sed -i "s/REDIS_CONFIG_PATH/${REDIS_CONFIG_PATH}/g" docker-compose.yml
	sed -i "s/REDIS_PORTS/${REDIS_PORTS}/g" docker-compose.yml
	sed -i "s/PHP_CONFIG_PATH/${PHP_CONFIG_PATH}/g" docker-compose.yml


	#启动docker服务
	service docker start

	# docker-compose up -d

	endTime_s=$(date +%s)
	echo '安装完成, 总耗时'$[ $endTime_s - $startTime_s ]'s'
else
	echo '请先删除本地的dokcer-compose.yml文件'
fi



