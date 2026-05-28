# Отчет по выполениню задания Simple Docker
- Я изучил докер, разработку простого докер-образа для собственного сервера.

## List
1. [Готовый докер](#part-1-готовый-докер) \
2. [Операции с контейнером](#part-2-операции-с-контейнером) \

## Part 1. Готовый докер
  - ### Установка `docker` на **Ubuntu**
  - Использую инструкцию с официального сайта \
  ![docker engine install ubuntu](images/docker-engine-install-ubuntu.png)
  - Проверяю установку \
  ![docker --version](images/docker--version.png)
  - Проверяю работу демона \
  ![docker daemon](images/docker-engine.png)
  - Качаю образ `nginx` \
  ![docker pull nginx](images/docker-image-nginx.png)
  - Смотрю список образов \
  ![docker image ls](images/docker-image-list.png)
  - Запускаю докер-образ и проверяю через `docker ps` \
  ![docker run -d](images/docker-run-nginx.png)
  - Смотрю информацию о контейнере \
  ![docker inspect](images/docker-inspect.png)
  - IP-адрес 172.17.0.2, порт контейнера 80, проброса порта на хост нету т.к. была команда без флага `-p [host_ip]:host_port:container_port[/protocol]` \
  ![docker container IP, port etc](images/docker-container-ipaddress.png)
  - Предыдущая команда не показывает размер контейнера поэтому используем другую команду для этого: \
  ![docker container size](images/docker-container-size.png)
    + размер контейнера 1.095kB (virtual 152MB)
    + `docker ps -s` (новый синтаксис `docker container ls -s`)
    + `docker system df` (т.к. у меня запущен 1 контейнер, то можно и тут глянуть)
  - Остановка докер контейнера и проверка его статуса \
  ![docker stop ID](images/docker-container-stop.png)
  - Запускаю докер с портами 80 и 443 в контейнере, замапленными на такие же порты на локальной машине, через команду *run* \
  ![docker run -d -p 80:80](images/docker-container-tcp-ports-80-443.png)
  - Проверяю браузер по адресу `localhost:80` \
  ![localhost](images/localhost-port-80.png)
  - Перезапускаю докер контейнер \
  ![docker restart](images/docker-container-restart.png)

## Part 2. Операции с контейнером
  - Запускаю команду `docker exec` \
  ![docker exec](images/docker-container-exec.png)
  - Создаю файл `nginx.conf` на хостовой машине \
  ![touch nginx.conf](images/touch%20nginx-conf.png)
  - Добавляю отдачу страницы статуса сервера \
  ![/status](images/nginx-conf.png)
  - Копирую конфиг в контейнер \
  ![docker cp](images/docker-cp.png)
  - Перезагружаю `nginx` в контейнере \
  ![nginx -s reload](images/nginx-reload.png)
  - Проверяю сайт \
  ![localhost/status](images/localhost-status.png)
  - Экспорт контейнера \
  ![docker export](images/docker-export.png)
  - Останавливаю контейнер \
  ![docker stop](images/docker-stop.png)
  - Удаляю образ`nginx` \
  ![docker rmi](images/docker-rmi.png)
  - Удаляю контейнер \
  ![docker rm](images/docker-rm.png)
  - Импортирую контейнер обратно \
  ![docker import](images/docker-import.png)
  - Запускаю контейнер со второй попытки \
  ![docker run](images/docker-run-2.png)
  - Оказывается import стирает мета-данные и их надо вручную вписать для запуска контейнера. Адрес localhost:80/status работает \
  ![docker-container-status](images/localhost-status-2.png)
