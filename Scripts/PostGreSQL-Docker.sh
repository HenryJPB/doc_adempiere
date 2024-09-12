Bqto: 02 Agosto 2023 14:23   

===============================================================================================
Como crear un contenedor Docker-PostGreSQL y persistir la información
================================================================================================

# i.) Creamos un container docker PostGreSQL le colocamos nombre al container y al volumen. 
# recuerda q:
  el atributo '--rm' significa Borrar un contenedor al terminar de ejecutarlo.
  
( plantilla 👇 )
# Creamos el contenedor con PostgreSQL
 docker run --rm  --name postgresql \
  -e POSTGRES_PASSWORD=docker \
  -p 5432:5432 \
  -v $HOME/docker/volumes/datos-pg:/var/lib/postgresql/data \
  --shm-size=256MB \
  --network red-pg \
  -d postgres

( En accion 👇 )
sudo docker run --name postgres-bulleyes-contenedor -e POSTGRES_PASSWORD=123 -p 5434:5432 -v postgres-db:/var/lib/postgresql/data -d postgres:bulleyes  👍 
 
( lo mismo reutilizando un volumen previamente creado: *Ver* ) 
sudo docker run --name postgres-bullseye-contenedor -e POSTGRES_PASSWORD=123 -p 5434:5432 --mount src=<nombre-del-volumen>,dst=/var/lib/postgresql/data -d postgres:bulleyes

( En accion 👇 )
sudo docker run --name postgres-bullseye-contenedor -e POSTGRES_PASSWORD=123 -p 5434:5432 --mount src=postgresql-db,dst=/var/lib/postgresql/data -d postgres:bullseye
 
check it out: https://bonisql.com/2021/02/28/bases-de-datos-en-contendores-postgresql/
 
(  *ENSAYO EN TIEMPO REAL* )
1.1. *Creamos un nuevo volumen 
sudo docker volume create --name postgresql-db 👍✔️

1.2. * y transferimos la informacion de uno previamente creado:
sudo docker run --rm -it -v f04da1868590c6d646808abd7817454d4e428d41a0c87dd4ddcaab65285ef440:/from -v postgresql-db:/to alpine ash -c 'cd /from ; cp -av . /to' 👍✔️

1.3. Creamos el nuevo contenedor y le reasignamos el nuevo volumen.Utilizamos el puerto 5434 del lado del localhost:
sudo docker run --name postgres-bullseye-contenedor -e POSTGRES_PASSWORD=123 -p 5434:5432 --mount src=postgresql-db,dst=/var/lib/postgresql/data -d postgres:bullseye 👍✔️

1.4. *Conectamos a postgres--bullseye-contenedor*
sudo docker exec -it postgres-bullseye-contenedor bash 👍✔️

     1.4.1 # dentro del contenedor: 
     	   # su postgres
     	   postgres=# psql 
     	   \c desica admin    # conectar a la BD desica con el usuario admin/admin 👍✔️

1.5. Conectar al contenedor 'postgres-bullseye-contenedor' utilizando pgadmin4
     1.5.1. Inspeccionar el contenedor: 
            sudo docker inspect postgres-bullseye-contenedor
     1.5.2  check for "IPAddress": "172.17.0.3" 
     1.5.3. ejecutar pgadmin en https://localhost:8082 
     		1.5.3.1. credenciales: email: hpulgar.desica@gmail.com. contraseña: 123
     1.5.4. fue creado el Server 'postgres-contenedor-admin'. BD: desica. Usuario: admin/admin. IPADRESS=172.17.0.3, puerto=5432 ( en el contenedor ); porto=5434 en localhost para conexiones externas como el gestor de BD 'DBeaver'
     

# BACKUP ( pg_dump ):

	"docker exec dbContainer pg_dump -U username -d dbName > /home/user/backups/testingBackup.sql"
 	
 	sudo docker exec adempiere.db pg_dump -U adempiere -d DDH > datos.sql ( exito!! )

# RESTORE: 
	( en eñ contenedor Docker ) 
	cat datos.sql | sudo docker exec -i adempiere.db psql -U adempiere -d ddh
	
	( local )
	cat dump-DDH-24.11.2023.sql -U adempiere -d DDH ( contradeña: 'adempiere' ) 
 
 
 
 
####-----APARTADO----------
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


    

  
