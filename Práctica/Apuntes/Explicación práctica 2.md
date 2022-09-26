# Introducción a GNU / Linux

## Características
- No existe el concepto de extensión en el nombre de un archivo 
- Los subdirectorios no se separan con el carácter ``/ ``
- Es case sensitive
- Entre un comando y sus parámetros debemos dejar obligatoriamente un espacio en blanco 
- Separación de entorno gráfico y texto

### Configuración de discos 
El disco **IDE** (_integrated device electronics_) puede ser: 
- Master o slave 
- Estar configurando en el 1º o 2º bus

La configuración de discos **SCSI** se basa en **LUN**. Y es lo mismo para los discos **SATA**. 
Su nomenclatura se basa en la identificación de los buses y es: 
- ``/dev/hda``  si está configurado como **master** en el 1º bus IDE
- ``/dev/hdb``  si está configurado como **slave** en el 1º bus IDE
- ``/dev/hdc``  si está configurado como **master**  en el 2º bus IDE
- ``/dev/hdd``  si está configurado como **slave** en el 2º bus IDE

Las **particiones primarias** van de la primera a la cuarta (las booteables), de la quinta en adelante son **particiones lógicas**, que son extendidas. 

Con la evolución de las distribuciones Linux, se comenzó a usar **udev** (``.rules``) como gestor de dispositivos, lo que trajo _una nueva nomenclatura._
- Controla dinámicamente a los archivos del ``/dev`` SÓLO en base al hardware detectado. 
- Soporta *Persisten device naming*.
	- Es decir, que cada dispositivo tiene su nombre
	- Es importante este uso, porque no se puede garantizar que tras distintos arranques del SO los dispositivos se sigan llamando de la misma manera
- Reemplaza a _devfs_ y _hotplug_
- Se desentiende del _major_ y _minor number_
- Se basa en eventos y permite que nuevos dispositivos sean agregados posteriormente al arranque. 

Desde Debian, **todos los dispositivos llamandos _hdX_ se denominandas _sdX_.** Por estas y otras razones, se adoptaron 4 mecanismos nuevos para nomenclar. 
- Nombres persistentes por **UUID** (universal unique identifier)
	```bash
	$ ls {l/ dev/disk/by-uuid/
	3325496624186184 -> .. / .. / sda1
	5748744865476874 -> ../ .. / sda7
	```

- Utilizando **labels**
	```bash 
	$ ls -l /dev/disk/by-label
	data -> ..  / .. / sdb2 
	data2 -> ../ .. / sda2
	```

Existen diversos modos de instalar Linux. Debemos tener en cuenta la arquitectura de hardware 
- amd64 -> arquitectura 64 bits
- arm o armel -> advanced risc machine 
- i386 -> arquitectura de 32 bits 
- ia64 -> intelltanium o intel architectura-64

Podemos intalarlo desde un CD o desde un USB, permite crear instaladores o LiveCD utlizando los USB. 

## Herramientas para particionar 
El particionador de un disco se lo puede realizar mediante: 
- un *software destructivo* como fdisk. 
- un *software no destructivo* como fips, gparted. 

## Editor de textos **vim**
Está presente en cualquier distribución de Linux. Posee 3 modos de ejecución: 
- Modo insert (``Ins o i``)
- Modo visual (``v``)
- Modo de órdenes o normal (``esc``)

Y se le puede enviar una serie de comandos útiles para escribir: 
``w`` -> escribir cambios 
``q`` o ``q!`` -> salir del editor 
``dd`` -> cortar 
``y`` -> copiar al portapapeles
``p`` -> pegar desde el portapapeles 
``u`` -> deshacer 
``/`` -> frace: busca "frase" dentro del archivo 

## Usuarios 
Todo usuario debe poseer credenciales para acceder al sistema 
- ``root``: es el administrador del sistema (superusuario)
- otros: usuario estándar del sistema (``/etc/sudoers``)

##### Los archivos de configuración de usuarios: 
- ``/etc/passwd``
	```bash
	$ cat /etc/passwd
	leti:x:2375:500:Letizia,,,,Usuarios:/home/admins/leti:/bin/bash
	```
- ``/etc/group``
	```bash
	$ cat / etc/group
	infraestrctura:x:500:
	```
- ``/etc/shadow``
	```bash
	$ cat /etc/shadow
	leti:dfjiudfghfdgdfsig/u9/:dhfkugjhdjfkggjh:::
	```


##### Comandos para el manejo de usuarios:
- ``useradd <nombreUsuario>``
	- agrega a un usuario, 
	- modifica los arcxhivos /etc/passwd
	- como alternativa tiene a ``adduser``
- ``passwd <nombreUsuario>``
	- asigna o cambia la contraseña de usuario
	- modifica el archivo /etc/shadow
- ``usermod <nombreUsuario>``
	- ``-g`` -> modifica el grupo de login (modifica /etc/passwd)
	- ``-G`` -> modifica grupos adicionales (modifica /etc/group)
	- ``-d`` -> modifica el directorioo home (modifica /etc/passwd)
- ``userdel <nombreUsuario>``: elimina a un usuario 
- ``groupdel <nombreUsuario>``: elimina el grupo. 

## Permisos 
Los permisos **se aplican a directorios y a archivos**. Existen 3 tipos de permisos y se basan en una notación octal: 

Permiso | valor |octal 
------  | ------- | ------
Lectura | R | 4 
Escritura | W | 2
Ejecución | X | 1 

Los permisos **se aplican sobre los usuarios** mediante comandos: 
- Usuario con permiso del dueño -> ***U**
- Usuario con permisos de grupo -> **G**
- Usuario con permisos de otros usuario -> **O**

Se utiliza el comando ``chmod`` 
```bash
$ chmod 755 /tmp/script
```

## Entorno 
Algunos comandos útiles: 
- ls 
- cd
- mkdir
- rmdir
- rm
- mv
- cp
- man 
- info

Estos comandos están explicados en el **trabajo práctico 1**. 
## Bootloader
El bootloader o cargador de arranque es un programa que permite **cargar** **el sistema operativo**, o un **entorno previo a la carga del sistema**. Generalmente se utilizan los cargados multietapas en los que varios programas pequeños se van invocando hasta lograr cargar el sistema operativo. El código _BIOS/UEFI_ forma parte del bootloader, pero quién más "forma parte" es el código **MBR** (master boot record)

El **MBR** (de 512b) está formado por el **MBC** (ocupa 446b) y la tabla de particiones (64b). Si hay más de un **MBC**, sólo se toma en cuenta el del _primary master disk_, el **MBR** existe en todos los discos, ya que contiene la tabla de particiones. 

## Proceso de arranque **System V**
1. Se empieza a ejecutar el código del BIOS
2. El BIOS ejecuta el POST
3. El BIOS lee el sector de arranque (MBR)
4. Se carga el gestor de arranque (MBC)
5. El bootloader carga el kernel y el initrd
6. Se monta el initrd como sistema de archivos raíz y se iniclianzan componentes esenciales 
7. El kernel ejecuta el proceso init y se desmonta el initrd
8. Se lee el /etc/inittab
9. Se ejecutan los scripts apuntados por el runlevel 1 
10. El final del runlevel 1 le indica que vaya al runlevel por defecto 
11. Se ejecutan los scripts apuntados por el runlevel por defecto
12. El sistema está listo para usarse. 

### inits
- La función del **init** es cargar todos los subprocesos necesarios para el correcto funcionamiento del sistema operativo. Este proceso tiene el **PID 1** y se encuentra en ``/sbin/init``. 
- Es configurable mediante el archivo ``/etc/inittab``
- No tiene padre y es el **padre de todos los procesos** (_pstree_)
- Es el encargado de montar los filesystem y de hacer disponible los demás dispositivos. 

### runlevels
Es el modo en que arranque Linux (3 en redhat, 2 en debian). Existen 7 y permiten iniciar un conjunto de procesos al arranque o al apagado del sistema. 

> El proceso de arranque lo dividimos en niveles, cada uno es responsable de levantar (iniciar) o bajar (parar) una serie de servicios. 


- **0** -> HALT (parada)
- **1** -> single user mode (monosuario)
- **2** -> multiusuario sin NFS (soporte de red)
- **3** -> full multiuser mode console (multiusuario completo por consola)
- **4** -> no se usa 
- **5** -> X11 (todo completo pero con login gráfico basado en X)
- **6** -> reboot

Se encuentra definido en ``/etc/inittab`` y está formando por: 
```
id : nivelesEjecución:acción:proceso
```

- **ID** -> identifica la entrada en inittab (1 a 4 carácteres)
- **Niveles de ejecución** -> el ``/`` los niveles de ejecución en los que se realiza la acción 
- **Acción** -> describe la acción a realizar
	- _wait_ -> inicia cuando entra al runlevel e init espera a que termine 
	- _initdefault_ 
	- _ctrlaltdel_ -> se ejecutará cuándo init reciba la señal SIGINT
	- _off, respawn, once , sysinit , boot, bootwait, powerwait_
- **proceso** el proceso exacto que será ejecutado 
 ```bash
$ cat /etc/inittab
id:2:initdefault:
si::sysinit:/etc/init.d/rcS
ca::ctrlaltdel:/sbin/shutdown -t3 -r
```

##### Lugares
- Los **scripts** que se ejecutan están en ``/etc/init.d``. 
- En ``/etc/rcX.d`` dónde X = 0..6, hay links a los archivos del ``etc/init.d``
- El **formato** de los links es ``[S|K] <orden> <script>`` dónde **S** lanza el script con el argumento **start** y **K** lo lanza con el argumento **stop**.
```bash
$ls -1 /etc/rcS.d/
Sd56489
S710x11-commmon
```

### insserv
- Se utiliza para administrar el orden de los enlaces simbólicos del '/etc/rcX.d', resolviendo así las dependencias de forma automática. 
- Utiliza cabeceras en los scripts del /etc/inid.d que permiten especificar las relaciones con otros scripts rc -> LSBInit
- Es usado por update-rc.d para instalar/remover los links simbólicos. 
- Las dependencias se especifican mediante *facilities* → **Provides** keyword
- Las _facilites_ que empiezan con ``$`` se reservan para el sistema (``$syslog``)
- Los scripts deben cumplir LSB init script 
	- proveer al menos 'start , stop , restart , force-reload and status'
	- retornar un código apropiado 
	- declarar las depedencias. 

**LSB init script headers:**
```
### BEGIN INIT INFO
# Provides: my_daemon
# Required-Start: $syslog $remote_fs
# Required-Stop: $syslog $remote_fs
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Short-Description: This is a test daemon
# Description: This is a test daemon
# This provides example about how to
# write a Init script.
### END INIT INFO

```

## Proceso de arranque **Upstart**
Fue el primer reemplazo propuesto para SystemV (Ubuntu, Fedora, Debian). Permite la ejecución de trabajos en forma asincrónica mediante eventos (_event-based_) como principal diferencia con sysVinit que es estrictamente sincrónicos (_dependecy-based_). 

Estos trabajos se denominan **jobs** y su principal objetivo es el de definir servicios o tareas a ser ejecutadas por init. Son scripts de texto plano que definen las acciones/tareas (unidad de trabajo) a ejecutar ante determinados eventos. 

Cada **job** es definido en el ``/etc/init(.conf)`` y sulen ser de dos tipos: 
- _Task_: su ejecución es finita -> not respawining -> ``exit 0`` o uso de ``stop``
- _Service_: su ejecución es indeterminada -> respawning

Los jobs son ejecutados ante eventos (arranque del equipo, inserción de un dispositivo USB, etc). Es posible crear eventos, pero existen algunos de manera estándar y están definidos por _start on_ y _stop on_. 

Es compatible con SystemV -> /etc/init/rc-sysinit.conf, runlevels, scripts en /etc/init.d, objetivo start y stop.

__Cada JOB tiene un objetivo (goal start/stop) y un estado (state)__, en base a ellos se ejecuta un proceso específico y, al inicio, init emite un evento _startup_. 

Un job puede tener _uno o varias tareas ejecutables_, como parte de su ciclo de vida y siempre debe existir la tarea principal. 
- Las tareas de un job se definen mediante ``exec`` o ``script ... end script``

- Mediante ``initctl`` podemos administrar los jobs del dominio de Upstart: 
	- start ``<job>`` : cambia el objetivo a start del job especificado
	- stop ``<job>``: cambia el objetivo a stop del job especificado 
	- emit``<job>`` : event es emitido causando que otros jobs cambien a objetivo start o stop
- No más ``etc/inittab``

## Systemd
- Es un sistema que centraliza la administración de demonios y librerias del sistema. 
- Mejora el paralelismo de boote
- Puede ser controlado por **systemctl**
- Compatible con SysV -> si es llamado como _init_ 
- El demonio _systemd_ reemplaza al proceso init -> este pasa a tener PID 1 
- Los runlevels son reemplazados por **targets**
- Al igual que con Upstart el archivo ``/etc/inittab`` no existe más. 

**- Las unidades de trabajo son denominadas units de tipo:** 
	- _Service_: controla un servicio particular (.service) 
	- _Socket_: encapsula IPC, un sockect del sistema o file system FIFO (.socket) → sockect-based activation 
	- _Target_: agrupa units o establece puntos de sincronización durante el booteo (.target) → dependencia de unidades 
	- _Snapshot_: almacena el estado de un conjunto de unidades que puede ser restablecido m´as tarde (.snapshot)
	- etc. 

• Las units pueden tener dos estados → _active o inactive_

![[Pasted image 20220926141245.png]]

### Systemd - Activación por Socket
No todos los servicios que se inician en el booteo se utilizan impresora o el servidor en el puerto 80. **Socket** es un mecanismo de iniciación bajo demanda, así podemos ofrecer una variedad de servicios sin que realmente esten iniciados.

_Cuando el sockect recibe una conexión spawnea el servicio y le
pasa el socket_. No hay necesidad de definir dependencias entre servicios ya que se inician todos los sockets en primer medida. 
### Systemd - cgroups
Permite organizar un grupo de procesos en forma jerárquica. Agrupa conjunto de procesos relacionados (por ejemplo: un servidor web apache con sus dependientes)

Tareas que realiza: 
- Tracking mediante subsistema cgroups → no se utiliza el PID → doble _fork_ no funciona para escapar de systemd 
- Limitar el uso de recursos 
- etc

## fstab
Define qué particiones se montan al arranque. Su configuración se encuentra en ``/etc/fstab``. 
```shell
$ cat /etc/fstab
# <file system> <mount point> <type> <options> <dump
> <pass>
/dev/sda1 / ext4 errors=remount-ro 0 1
UUID=3FDE00F9523092AE /home/iso/datos ntfs user,auto ,rw,exec,uid=1000,gid=1000,umask=000 0 2
/dev/sda2 none swap sw 0 0
```
Opciones: 
- _user_: cualquier usuario puede montar la partición 
- _auto_: monta la partición al inicio 
- _ro_: read only, _rw_: read and write 
- etc
## Redirecciones
Al utilizar redirecciones ``>`` (destructivas )
- Si el archivo destino no existe, se lo crea 
- Si el archivo existe, se lo trunca y se escrbe el nuevo contenido 

Al utilizar redirecciones mediante ``>>`` (no destructivas)
- Si el archivo de destino no existe, se lo crea 
- Si el archivo existe, se agrega la información al final

## Uso de | 
El ``|`` nos permite comunicar dos procesos por medio de unpipe o tubería desde la _shell_. El PIPE conecta _stdout_ (salida estándar) del primer comando con la _stdin_ (entrada estándar) del segundo. 

Por ejemplo:
```shell
$ ls | more
```
Se ejecuta el comando ``ls`` y la salida del mismo es eviada como entrada del comando ``more``

Se pueden anidar tantos pipes como se deseen. 

	 ¿Cómo hariamos si quisiéramos contar la cantidad de usuarios del sistema que en su nombre de usuario aparece una letra "a"? 
```shell
$ cat/etc/passwd | cut -d: -f1 | grep a | wc -1
```

