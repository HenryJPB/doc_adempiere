Barquisimeto, 27 de cotubre 2023

--------------------------------------------------------------------------------
Crear contenedor MariaDB
--------------------------------------------------------------------------------
---------------
// Ensayo I:
---------------
// sudo docker run --name mariadb --env MARIADB_ROOT_PASSWORD=123 mariadb:latest

    doc: https://hub.docker.com/_/mariadb

--------------
// Ensayo II:
--------------
// sudo docker run -d --rm --name mysql -e MYSQL_ROOT_PASSWORD=root -p 3306:3306 -v mariadb_data:/var/lib/mysql mariadb

    doc: https://josejuansanchez.org/bd/practica-06/index.html

-----------------
// * Finalmente:
-----------------
sudo docker run --name mariadb --env MARIADB_ROOT_PASSWORD=root -p 3306:3306  -v mariadb-data:/var/lib/mysql   mariadb:latest

    doc: https://hub.docker.com/_/mariadb

    # Backup and restore a mysql database from a running Docker mysql container
    doc: https://gist.github.com/spalladino/6d981f7b33f6e0afe6bb

  # Backup
    sudo docker exec mysql-contenedor mysqldump -u root --password=root SUITGEADMIN > dump-SUITGEADMIN-200723.sql

  # Restore
    cat dump-SUITGEADMIN-{fecha}.sql | sudo docker exec -i mysql-contenedor mysql -u root --password=root SUITGEADMIN   # ( eeeeeexiitoooooo al 20-07-2023 👍✔️ )

    cat DESICA-30.11.2020.sql | sudo docker exec -i mysql-contenedor mysql -u root --password=root DESICA ( eeeeeexiitoooooo al 20-07-2023 👍✔️ )

 #  Restore backup el dia 27 de octubre 2023.

    cat cat dump-ACTIVO-05102023.sql | sudo docker exec -i mariadb mariadb -u root --password=root ACTIVO
    ------------> ERROR 1273 (HY000) at line 30: Unknown collation: 'utf8mb4_0900_ai_ci'
    SOLUCION: ( https://tecadmin.net/resolved-unknown-collation-utf8mb4_0900_ai_ci/ )

    The Linux system users can use the sed command to replace text in files directly:

        Sobre una copia de nombre 'backup.sql', ejecutar:

        sed -i 's/utf8mb4_0900_ai_ci/utf8_general_ci/g' backup.sql,
           o
         sed -i 's/utf8mb3_general_ci/utf8_general_ci/g' backup.sql

        sed -i 's/CHARSET=utf8mb4/CHARSET=utf8/g' backup.sql

        y/o, realizar el cambio de forma manual sobre la copia ,...

 # Finalmente:

    cat dump-ACTIVO.sql | sudo docker exec -i mariadb mariadb -u root --password=root ACTIVO   ( eeeeeexiitoooooo al 27-10-2023 11:37 👍✔️ )




