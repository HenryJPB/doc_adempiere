#--------------------------------------------------------------------------------------
# Bqto 17 julio 2023 14:37    
# Renombrar un Volumen logico:
# doc: https://pilas.guru/20210527/renombrar-volumen-docker/
# https://www.commands.dev/workflows/rename_docker_volume
#--------------------------------------------------------------------------------------

# i.) Crear nuevo volumen
sudo docker volume create --name postgres-db

# ii.) Copiar contenido al nuevo volumen.
( plantilla 👇 ) 
sudo docker run --rm -it -v <viejo_volumen>:/from -v <nuevo_volumen>:/to alpine ash -c "cd /from ; cp -av . /to"
( en accion 👇 ) 
sudo docker run --rm -it -v f04da1868590c6d646808abd7817454d4e428d41a0c87dd4ddcaab65285ef440:/from -v postgres-db:/to alpine ash -c 'cd /from ; cp -av . /to'

# iii.) Eliminar old volumen
( plantilla 👇 ) 
sudo docker volume rm <viejo_volumen>

( en accion 👇 ) 
sudo docker volume rm f04da1868590c6d646808abd7817454d4e428d41a0c87dd4ddcaab65285ef440

# https://www.commands.dev/workflows/rename_docker_volume   # dice:
sudo docker volume create --name postgres-db &&
sudo docker run --rm -it -v f04da1868590c6d646808abd7817454d4e428d41a0c87dd4ddcaab65285ef440:/from -v postgres-db:/to alpine ash -c 'cd /from ; cp -av . /to'  &&
sudo docker volume rm f04da1868590c6d646808abd7817454d4e428d41a0c87dd4ddcaab65285ef440

