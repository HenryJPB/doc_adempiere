Bqto: 18 Agosto 2023 11:27 

===============================================================================================

file:///home/hpulgar/ShellScripts/Docker/Backup-PostGreSQL-Docker.sh

================================================================================================



# i.) Creamos un container docker PostGreSQL le colocamos nombre al container y al volumen. 

# doc: https://simplebackups.com/blog/docker-postgres-backup-restore-guide-with-examples/ 

(i).  docker exec <postgresql_container> /bin/bash \
 -c "/usr/bin/pg_dump -U <postgresql_user> <postgresql_database>" \
 | gzip -9 > postgres-backup.sql.gz
 
 Mi caso: 
 ( backup ) sudo docker exec adempiere.db bash -c pg_dump -U adempiere DDH > dump-ddh-18082023.sql

(ii). docker exec <postgresql_container> /bin/bash \
 -c "export PGPASSWORD=<postgresql_password> \
     && /usr/bin/pg_dump -U <postgresql_user> <postgresql_database>" \
 | gzip -9 > postgres-backup.sql.gz  
 
 ( backup ) sudo docker exec adempiere.db bash -c PGPASSWORD=postgresql pg_dump -U adempiere DDH > dump-ddh-18082023.sql  ( error ??? ) 
 
 NOTA error!! xq desconosco la contraseña del usuario adempiere en la instalacion docker del servidor HP 8300 ELITE. 
 
  backup ) sudo docker exec adempiere.db bash -c PGPASSWORD=postgresql pg_dump -U postgres DDH > dump-ddh-18082023.sql  ( error ??? ) 

NOTA ---Error!! xq el usuario postgres no tiene acceso a la BD DDH, ...

----------
CORREGIDO:
---------- 

 BACKUP directamente en el Servidor HP 8300 ELITE;
 i.) MOntar la unidad 'BACKUP'; 
 2.) cd /media/arcelor/backup/DATOS/ADempiere(v3.9.4)
 3.) sudo docker exec adempiere.db pg_dumpall -U adempiere > dump-ddh-18082023.sql
     ( !!! Eeeeeexiiitoo!! ) 
     

