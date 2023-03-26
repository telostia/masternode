SHELL := /bin/bash

getinfo:
	docker exec -it xrdmn bash -c "ravendark-cli --conf=/root/conf/ravendark.conf getinfo"

stop:
	docker exec -it xrdmn bash -c "ravendark-cli --conf=/root/conf/ravendark.conf stop"

status:
	docker exec -it xrdmn bash -c "ravendark-cli --conf=/root/conf/ravendark.conf masternode status"

bash:
	docker exec -it xrdmn bash

build:
	docker build -t xrdmn .

up:
	docker-compose up -d

stop:
	docker-compose stop

down:
	docker-compose down

.PHONY: getinfo status bash build up stop down
