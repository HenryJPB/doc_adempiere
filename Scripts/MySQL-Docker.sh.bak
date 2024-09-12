Bqto: 19 julio 2023 11:37    

===============================================================================================
Como crear un contenedor con Docker-Mysql y persistir la información
    https://platzi.com/tutoriales/1432-docker-2018/3268-como-crear-un-contenedor-con-docker-mysql-y-persistir-la-informacion/
================================================================================================

# i.) Creamos un container docker mySQL y le colocamos nombre al container y al volumen. 
# https://coffeebytes.dev/tutorial-de-comandos-basicos-de-docker/
 sudo docker run --name mysql -e MYSQL_ROOT_PASSWORD=123 -v mysql-db:/var/lib/mysql mysql 👍 

NOTA 1: * Ensayo de como reusar un volumen con datos en un nuevo contenedor *

 1.1.) En este contenedor 👆 se creo una base de datos 'prueba' y a su vez una tabla de nombre 'empleado_dat'(1).
 1.2.) Eliminamos el contenedor mysql ( no el volumen asociado: mysql-db ). 
        # sudo docker rm -
        sudo docker rm -f mysql 

# ii.) Recreamos un nuevo contenedor y reusamos el volumen 👇
 sudo docker run --name mysql-contenedor -e MYSQL_ROOT_PASSWORD=123 --publish 3706:3306 --mount src=mysql-db,dst=/var/lib/mysql mysql
# also check: https://kb.rolosa.com/docker-container-con-mysql/
 
# iii.) check 👇:
 iii.1.) sudo docker exec -it mysql-contenedor bash
            - bash-4.4# mysql -u root -p ( contraseña 'root'   
            mysql> ...  o,
            $ sudo docker exec -it mysql-contenedor mysql -u root -p  ( contraseña 'root'   
 iii.2.) sudo docker exec -it mysql-contenedor mysql -p 
# y/o
# Access Denied for User 'root'@'localhost' (using password: YES) : https://stackoverflow.com/questions/17975120/access-denied-for-user-rootlocalhost-using-password-yes-no-privileges
 sudo docker exec -it mysql-contenedor mysql -u root -p

# https://styde.net/crear-y-eliminar-tablas-en-mysql-mariadb/
# Ejemplo (1):  
CREATE TABLE empleado_dat
( id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  dni VARCHAR(20) UNIQUE,
  nombreCompleto VARCHAR(150),
  email VARCHAR(100),
  fechaNac DATE ) 
  
   {------------------------ *Eeeeeeexxiiiiiiiitooooooo 👍👍👍✔️✔️✔️✔️✔️✔️✔️ *--------------------------}
  =====
  ASIDE: 
  =====
  
  # Check this out: 
    bash-4.4# mysql -u root -p -h 127.0.0.1 -P 3706 -e 'show global variables like "max_connections"';    --------------- Prueba NO exiosa 👎 : ERROR 1045 (28000): Access denied for user 'root'@'127.0.0.1' (using password: YES) ????????????????
    
    bash-4.4# mysql -u root -p -h localhost -P 3706 -e 'show global variables like "max_connections"';    --------------- Prueba exitosa 👍
    
    INSERT INTO mysql.user(user,authentication_string,plugin,host) 
    VALUES ("root",null,"mysql_native_password","172.17.0.1");   ---- No funciono 👎

    ERROR: Access denied for user 'root'@'172.17.0.1' (using password: YES)  ????
    SOL: ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'root';  👍
        ( Solucion de Henry tomado como ejemplo de https://stackoverflow.com/questions/51288576/dbeaver-mysql-access-denied )    
         
    ERROR: dbeaver : Public Key Retrieval is not allowed
    SOL: Goto Driver Properties and change allowPublicKeyRetrieval drop down to TRUE. 
        ( https://ganeshchandrasekaran.com/dbeaver-public-key-retrieval-is-not-allowed-77eba055bbcd ) 
        
  # Backup and restore a mysql database from a running Docker mysql container
    doc: https://gist.github.com/spalladino/6d981f7b33f6e0afe6bb 
    
  # Backup
    sudo docker exec mysql-contenedor mysqldump -u root --password=root SUITGEADMIN > dump-SUITGEADMIN-200723.sql 
    
  # Restore
    cat dump-SUITGEADMIN-{fecha}.sql | sudo docker exec -i mysql-contenedor mysql -u root --password=root SUITGEADMIN   # ( eeeeeexiitoooooo al 20-07-2023 👍✔️ )
    
    cat DESICA-30.11.2020.sql | sudo docker exec -i mysql-contenedor mysql -u root --password=root DESICA ( eeeeeexiitoooooo al 20-07-2023 👍✔️ )

    

  
