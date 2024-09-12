Bqto: 01 agosto 2023 09:25    

===============================================================================================

Como crear un contenedor Docker-PhpMyAdmin y persistir la información
    
================================================================================================

# i.) Creamos un container docker PhpMyAdmin y le colocamos nombre al container y al volumen. 
# doc: https://bonisql.com/2021/02/28/bases-de-datos-en-contendores-postgresql/ 
# sudo docker run --name mysql -e MYSQL_ROOT_PASSWORD=123 -v mysql-db:/var/lib/mysql mysql 👍 
Para crear el contenedor y conectar a MySql ( https://www.netveloper.com/phpmyadmin-en-un-docker-para-conectar-a-cualquier-mysql )
 
sudo docker run --name phpmyadmin -d --link mysql_db_server:db -p 8080:80 phpmyadmin (plantilla)

Tenéis que cambiar el parámetro mysql_db_server por el nombre del container de tu base de datos.

También se puede conectar a otros MySql que esten en una determinada IP:

# sudo docker run --name phpmyadmin -d -e PMA_ARBITRARY=1 -p 8080:80 phpmyadmin ( originalito )

sudo docker run --name phpmyadmin -d -e PMA_ARBITRARY=1 -p 8081:80 -v phpmyadmin:/var/lib/phpmyadmin phpmyadmin ( *Eeeeeeexxiiiiiiiitooooooo 👍 )

NOTA 1: ✔️ fue probada correctamente en el navegador Opera: http://localhost:8081
           idem en Mozilla firefox, ...

NOTA 2: ❌ El servidor MySQL no autorizó su acceso en mi instalacion localhost. 

NOTA 3: ✔️  La conexion fue rechazada en mi instalacion local ( localhost ) sin embargo
	fue exitosa en mi instalacion 'mysql-contenedor' utilizando la IPADRESS=172.17.0.3 despues de ejecutar 'sudo docker inspect mysql-contenedor'. Usuario=root/root. 

NOTA 4: ✔️ la IPADRESS es variable cada vez q se inicia el contenedor ( mysql-contenedor ) 
	
	check: https://www.netveloper.com/phpmyadmin-en-un-docker-para-conectar-a-cualquier-mysql 


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

    

  
