#!/bin/bash

# 定义变量

#定义需要部署什么服务
DEPLOY_PGSQL="true"
DEPLOY_SPRINGBOOT="true"


URL="https://raw.githubusercontent.com/KOFKOY/publicfile/main/magic.sql" #要下载的SQL文件的URL  SQL要在数据库创建成功后自己导入
URL_JAR="https://github.com/KOFKOY/magic-api/releases/download/v1.8/magic.jar" #要下载的JAR包地址 有更新时其他不变，只需要修改版本号即可

URL_FILE="magic.sql" # SQL文件名称

# 创建pgsql容器
DB="magic_db"
DB_USER="wsj"
DB_PWD="wsj123456"

JAVA_JAR="magic.jar" #Java jar名称
SERVER_PORT=9000


echo "创建自定义网络"
docker network create java_pgsql_network

if [ "$DEPLOY_PGSQL" = "true" ]; then

	echo "开始下载sql文件 $URL"

	curl -L -o "$URL_FILE" "$URL"

	# 检查 curl 命令是否成功执行
	if [ $? -eq 0 ]; then
	    echo "SQL文件下载成功."
	else
	    echo "SQL文件下载失败，请检查网络和URL"
		exit 1
	fi


	echo "启动pgsql容器"
	docker run -d --name pgsql \
	  --network java_pgsql_network \
	  --restart=always \
	  -e POSTGRES_DB="$DB" \
	  -e POSTGRES_USER="$DB_USER" \
	  -e POSTGRES_PASSWORD="$DB_PWD" \
	  -v /root/dbData/postgres:/var/lib/postgresql/data \
	  -p 19003:5432 \
	   postgres
 
fi


echo "[DEBUG] 正在检查路径: $JAVA_JAR" >&2
ls -l "$JAVA_JAR" || echo "文件不存在" >&2

if [ "$DEPLOY_SPRINGBOOT" = "true" ]; then
	
	if [ ! -f "$JAVA_JAR" ]; then
		echo "下载springboot项目jar包"
			curl -L -o "$JAVA_JAR" "$URL_JAR"

		# 检查 curl 命令是否成功执行
		if [ $? -eq 0 ]; then
			echo "JAR下载成功."
		else
			echo "JAR文件下载失败，请检查网络和URL"
			exit 1
		fi
	fi

	 # 启动 springboot
	echo "启动springboot容器"
	docker run -d --name magic -v $(pwd)/"$JAVA_JAR":/app.jar \
			   --network java_pgsql_network \
			   -e SPRING_PROFILES_ACTIVE=prod \
			   --restart=always \
		   -e DB_HOST=pgsql \
		   -e DB_PORT=5432 \
		   -e DB_NAME="$DB" \
			   -e SERVER_PORT="$SERVER_PORT" \
		   -e DB_USERNAME="$DB_USER" \
		   -e DB_PASSWORD="$DB_PWD" \
		   -p 19004:"$SERVER_PORT" \
		   openjdk:17-jdk-alpine \
		   java -jar /app.jar
fi
