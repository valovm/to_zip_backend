tail = 100
container = backend

build:
	docker-compose build
start:
	docker-compose up --force-recreate -d
stop:
	docker-compose down
ps:
	docker-compose ps

restart: stop start

logs:
	docker-compose logs -f --tail=$(tail) $(container)
c:
	docker-compose exec backend rails c
sh:
	docker-compose exec backend sh

migrate:
	docker-compose exec backend rake db:migrate
seed:
	docker-compose exec backend rake db:seed

pull:
	git pull
	make build
	make restart
	make migrate
	make seed

install:
	make build
	make start
	docker-compose exec backend rake db:create
	make migrate
	make seed
