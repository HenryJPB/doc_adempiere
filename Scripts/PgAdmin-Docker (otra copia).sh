Bqto: 01 agosto 2023 09:25    

===============================================================================================

Como crear un contenedor Docker-PgAdmin y persistir la información
	
	i.) Levantar los contenedores:
	    postgress-bullseye-contenedor y pgadmin4 ( sudo docker start postgress-bullseye-contenedor pgadmin4
    	ii.) acceder: http://localhost:8082 
    	
    	iii.) Credenciales: 
    	      - email=hpulgar.desica@gmail.com
    	      - contraseña: 123. 
    	iv.) Nombre o dir del Servidor: ( always check los parametros del contenedor postgres 'postgres-bullseye-contenedor'):
    		- sudo docker inspect postgres-bullseye-contenedor
    		- check PARAMETRO "IPAddress": "172.17.0.5" -es variable!!
    	      
================================================================================================

# i.) Creamos un container docker PgAdmin y le colocamos nombre al container y al volumen. 
# doc: https://bonisql.com/2021/02/28/bases-de-datos-en-contendores-postgresql/ 
# recuerda q:
  el atributo '--rm' significa Borrar un contenedor al terminar de ejecutarlo.  
 sudo docker run --name mysql -e MYSQL_ROOT_PASSWORD=123 -v mysql-db:/var/lib/mysql mysql 👍 
 
 sudo docker run --rm  --name pgadmin \
  -e "PGADMIN_DEFAULT_EMAIL=hpulgar.desica@gmail.com" \
  -e "PGADMIN_DEFAULT_PASSWORD=123" 
  -e "PGADMIN_LISTEN_PORT=80" \
  -p 8080:80 \
  -v pgadmin4:/var/lib/pgadmin \
  -d dpage/pgadmin4 ( No funciono de esa 👆 manera ) 
  
 sudo docker run --rm  --name pgadmin4 -e "PGADMIN_DEFAULT_EMAIL=hpulgar.desica@gmail.com"  -e "PGADMIN_DEFAULT_PASSWORD=123" -e "PGADMIN_LISTEN_PORT=80" -p 8082:80 -v pgadmin4:/var/lib/pgadmin -d dpage/pgadmin4 ( *Eeeeeeexxiiiiiiiitooooooo 👍 )
 
 # Crear contenedor 'pgadmin' y Reusar un volumen. Utilizar puerto 8082 :
 sudo docker run --rm  --name pgadmin4 -e "PGADMIN_DEFAULT_EMAIL=hpulgar.desica@gmail.com"  -e "PGADMIN_DEFAULT_PASSWORD=123" -e "PGADMIN_LISTEN_PORT=80" -p 8082:80 --mount src=pgadmin4,dst=/var/lib/pgadmin -d dpage/pgadmin4 ( positivo )
  

NOTA 1: ✔️ fue probada correctamente en el navegador Opera: http://localhost:8080/login

NOTA 2: ❌ La conexion fue rechazada en mi instalacion local ( localhost:5432 ), sin embargo
	fue exitosa en mi instalacion 'postgres-contenedor' utilizando la IPADRESS=172.17.0.4 despues de 		ejecutar 'sudo docker inspect postgres-contenedor', utilizando el puerto definido=5433. 	    		BD=desica, Usuario=admin/admin. 
	
	check: https://stackoverflow.com/questions/53610385/docker-postgres-and-pgadmin-4-connection-refused 



 {------------------------ *Eeeeeeexxiiiiiiiitooooooo 👍👍👍✔️✔️✔️✔️✔️✔️✔️ *--------------------------}
  =====
  ASIDE: 
  ===== 
   
# https://styde.net/crear-y-eliminar-tablas-en-mysql-mariadb/
# Ejemplo (1):  

CREATE TABLE empleado_dat
( id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  dni VARCHAR(20) UNIQUE,
  nombreCompleto VARCHAR(150),
  email VARCHAR(100),
  fechaNac DATE ) 
  
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

    

  
