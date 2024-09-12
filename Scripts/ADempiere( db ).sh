Bqto: 17 de Nov 2013 08:23

Ejecutado x Nestor Infante: 
    
    sudo docker run -d -p 5432:5434 --name adempiere.db --network adempiere_network -v adempiere_prod:/var/lib/postgresql/data -e POSTGRES_PASSWORD="#f5*%%45)" --restart unless-stopped postgres:14 postgres -c 'max_connections=1000'

    sudo docker exec -it adempiere.db.old psql -U adempiere -d DDH ( Ejemplo conectar al contenedor, ... )
    
    los datos que usa DDH_ZK es:
    ADEMPIERE_DB_NAME=DDH
    ADEMPIERE_DB_PASSWORD=AzLY7Dzx59g
    ADEMPIERE_DB_PORT=5432
    ADEMPIERE_DB_SERVER=adempiere.db
    ADEMPIERE_DB_USER=adempiere
    
-------
Remind:
-------
    ALTER DATABASE ddh RENAME TO "DDH";  

-------------------------------
Nestor dice este es el comando:
-------------------------------

    ----------------------------
    ( ADempiere en produccion ):
    ----------------------------
    sudo docker run -d -p 5432:5434 --name adempiere.db --network adempiere_network -v adempiere_prod:/var/lib/postgresql/data -e POSTGRES_PASSWORD="#f5*%%45)" --restart unless-stopped postgres:14 ( ERROR!!! check los puertos )
    ------------
    Corregido??:
    ------------ 
    sudo docker run -d -p 54323:5432 --name adempiere-db-test --mount src=pgdata_test,dst=/var/lib/postgresql/data -e POSTGRES_PASSWORD="#f5*%%45)" --restart unless-stopped postgres:14

    
    ----------------------------------------------------------------------------------
    ( ADempiere-db-test - reutilizando el volumen creado inicialmente 'pgdata_test' ):
    ----------------------------------------------------------------------------------
    sudo docker run -d -p 5432:54323 --name adempiere-db-test --mount src=pgdata_test,dst=/var/lib/postgresql/data -e POSTGRES_PASSWORD="#f5*%%45)" --restart unless-stopped postgres:14 -c 'max_connections=1000'
    *NOTA*: Error: check los puetos '5432:54323'. Es al contrario ->, al acceder al puerto 54323 te lleva al puerto 5432 del contenedor - https://apuntes.de/docker-certificacion-dca/redireccion-de-puertos/#gsc.tab=0  ) 
    
    ----------
    corregido:
    ----------
    sudo docker run -d -p 54323:5432 --name adempiere-db-test --mount src=pgdata_test,dst=/var/lib/postgresql/data -e POSTGRES_PASSWORD="#f5*%%45)" --restart unless-stopped postgres:14 -c 'max_connections=1000'
	    
    
    sudo docker exec -it adempiere-db-test bash
    
    root@222ec0721950:/# su postgres

    postgres@222ec0721950:/$ \l
    
    CREATE USER adempiere WITH PASSWORD 'adempiereTest';
    
    ALTER ROLE adempiere WITH SUPERUSER;
    
    ALTER ROLE adempiere WITH CREATEROLE;
    
    \c postgres adempiere
    
    CREATE DATABASE "DDH";
    
    
   ----------
   CORREGIDO:
   ---------- 

   BACKUP (  ) directamente en el Servidor HP 8300 ELITE;
    i.) MOntar la unidad 'BACKUP'; 
    	1.1.) sudo mount /Ruta_unidad /Ruta_destino    # doc: https://www.solvetic.com/tutoriales/article/12135-como-usar-el-comando-mount-en-linux/ 
    	1.2.) sudo fdisk -l
    		... "/dev/sda1" ...
    	1.3.) sudo mount /dev/sda1 /media/arcelor      #  💪 👏 
    	1.4.) arcelor@desica:/media/arcelor$ cd BACKUP ,... and on,...
    	      
    2.) cd /media/arcelor/backup/DATOS/ADempiere(v3.9.4)
    3.) sudo docker exec adempiere.db pg_dumpall -U adempiere > dump-ddh-18082023.sql
     ( !!! Eeeeeexiiitoo!! ) 
     
   BACKUP ( pg_dump ):
 	"docker exec dbContainer pg_dump -U username -d dbName > /home/user/backups/testingBackup.sql"
 	
 	sudo docker exec adempiere.db pg_dump -U adempiere -d DDH > datos.sql ( exito!! )

   Fuente: https://www.enmimaquinafunciona.com/pregunta/250409/docker-postgres-backup-crea-un-archivo-vacio- cuando-se-ejecuta-como-una-tarea-cron
   
    ----------------------------
   RECUPERAR DATOS DE UN BACKUP: 
   -----------------------------
   ...
   su postgres
   cat dump-DDH-24.11.2023.sql | psql -U adempiere -d DDH   
   
   -------------------------------------------------------------------------------
   RECUPERAR DATOS DE UN BACKUP En UN Contenedor ( Docker ) imagen de postgresql :
   -------------------------------------------------------------------------------
   .
   .
   cd BACKUP/Datos
   cat datos.sql | sudo docker exec -i adempiere-db-test psql -U adempiere -d DDH
   .
   .
   

   
   
    
    
    
