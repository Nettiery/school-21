## 1. Готовый докер
+ Возьмем официальный докер-образ с nginx и скачаем его при помощи docker pull 

    ![](part_1/docker%20pull.png)

+ Проверяем наличие докер-образа через docker images 
    ![](part_1/Docker%20images.png)

+ Запускаем докер-образ через 
`docker run -d --name nginxer nginx`
    ![](part_1/docker%20run.png)

+  Проверяем, что образ запустился через 
`docker ps`

  ![](part_1/docker%20ps.png)

+ Посмотрим информацию о контейнере через 
  `docker inspect nginxer`

   ![](part_1/docker%20inspect.png)

+ По выводу команды  определяем:

    * размер контейнер 1095 bytes
    ![](part_1/size.png)
    * список замапленных портов 80/tcp:[]
    ![](part_1/mapped%20ports.png)
    * ip контейнера 172.17.0.3
    ![](part_1/IP.png)

+ Останавливаем докер контейнер через `docker stop ngixer` и проверяем, что контейнер остановился `docker ps`
    ![](part_1/docker%20stop.png)

+ Запускаем докер с портами 80 и 443 в контейнере, замапленными на такие же порты на локальной машине, через команду run и проверяем 
`docker run -d -p 80:80 -p 443:443 nginx`
    ![](part_1/Docker%20run%20ports.png)

+ Проверяем, что в браузере по адресу localhost:80 доступна стартовая страница nginx

![](part_1/localhost.png)

Перезапускаем докер контейнер через `docker restart [container_id|container_name]`  и проверяем, что контейнер запустился `docker ps`

![](part_1/docker%20restart.png)


## 2. Операции с контейнером

+ Прочитаем конфигурационный файл nginx.conf внутри докер контейнера через команду `docker exec quirky_goodall cat /etc/nginx/nginx.conf`

    ![](part_2/nginx.conf.png)  

+ Создаем на локальной машине файл nginx.conf и настраиваем в нем по пути /status отдачу страницы статуса сервера nginx.
    ![](part_2/nginx.conf.png)  

+ Копируем созданный файл nginx.conf внутрь докер-образа через команду docker cp.
    ![](part_2/Doker%20cp.png)  

+ Перезапускаем nginx внутри докер-образа через команду exec.
    ![](part_2/docker%20exec%20reload.png)  

+ Проверяем, что по адресу localhost/status отдается страничка со статусом сервера nginx.
    ![](part_2/localhost:status.png)  

 + Экспортируем контейнер в файл container.tar через команду export и останавливаем  контейнер.
     ![](part_2/Docker%20export%20and%20stop.png)  

+ Удаляем образ через `docker rmi nginx`, не удаляя перед этим контейнеры. Затем удаляем остановленный контейнер: `docker rm quirky_goodall`.
     ![](part_2/docker%20rmi%20rm.png)  

+ Импортируем контейнер обратно через команду import и запустим импортированный контейнер.
    ![](part_2/docker%20import%20run.png)  

+  Проверяем, что по адресу localhost/status отдается страничка со статусом сервера nginx.
    ![](part_2/localhost%20import.png)  

## 3. Мини веб-сервер

Напишем мини-сервер на C, который будет возвращать простейшую страничку с надписью Hello World!
+ Создадим файл mini_server.c, в котором будет описана логика сервера  

  ![](part_3/mini_server.png) 

+ Создадим файл nginx.conf, который будет проксировать все запросы с порта 81 на порт localhost:8080

   ![](part_3/nginx.png) 

+ Теперь выкачаем новый docker-образ и на его основе запустим новый контейнер.
   ![](part_3/docker%20run%20ps.png) 

+ После перекинем конфиг и логику сервера в новый контейнер и запустим

    `docker cp nginx.conf gifted_edison:/etc/nginx/` 
    
    `docker cp mini_server.c gifted_edison:/`

    `docker exec gifted_edison gcc ./mini_server.c -l fcgi -o mini_server` - компилируем FastCGI server.

    `docker exec gifted_edison spawn-fcgi -p 8080 fcgi_server` 
    
    `docker exec gifted_edison nginx -s reload` - запуск.

    ![](part_3/docker%20cp%20conf%20server.png) 



Проверяем, что в браузере по localhost:81 отдается написанная  страничка.

  ![](part_3/localhost81.png) 


##  4. Свой докер
+ Напишем свой docker-образ, который собирает исходники 3-й части, запускает на порту 80, после копирует внутрь написанный нами nginx.conf и, наконец, запускает nginx.
    * mini-server.c
     ![](part_4/mini_server.png) 

    * nginx.conf
    ![](part_4/nginx.png) 

    * run.sh
    ![](part_4/run.png) 

    * Dockerfile
    ![](part_4/Dockerfile.png) 

+ Соберем написанный docker-образ через команду docker build, при этом указав имя и тэг нашего контейнера 
    ![](part_4/docker%20build.png) 

+ Проверяем с помощью `docker image`.
    ![](part_4/image.png) 


+ Запускаем собранный docker-образ с мапингом порта 81 на порт 80 локальной машины.

  ![](part_4/docker%20run%20my%20version.png) 

+ Проверяем, что по localhost:80 доступна страничка написанного мини сервера.

  ![](part_4/localhost:80.png) 

+ Дописываем в nginx.conf проксирование странички /status, по которой надо отдавать статус сервера nginx.
    
  ![](part_4/nginx%20new.png) 

+  Теперь перезапустим nginx в своем docker-образе командой nginx -s reload

    ![](part_4/reload.png) 

+ Проверяем, что по localhost/status отдается страничка со статусом nginx.
    ![](part_4/localhost:status.png) 

## 5. Dockle

+ Просканируем docker-образ из предыдущего задания на предмет наличия ошибок командой `dockle [image_id|repository]`
    ![](part_5/Dockle%20before.png) 

+ Исправим ошибки и соберем новый образ и проверим его. 

    ![](part_5/Dockle%20after.png)


## 6. Базовый Docker Compose

+ Создадим конфигурационный файл docker_compose.yml
    ![](part_6/Docker_compose.png)

+ Внесем изменения в nginx.conf
    ![](part_6/nginx.png)

+ Поднимем контейнер командой `docker-compose build`
    ![](part_6/docker%20copmose%20build.png)

+ Далее  поднимаем сбилженный контейнер командой docker compose up
    ![](part_6/docker%20compose-d.png)
    
+ Проверяем, что по localhost:80 отдается страничка со статусом nginx.
    ![](part_6/localhost:80.png) 





