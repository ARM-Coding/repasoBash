#!/bin/bash

# <<< Notas para entender Bash y saber hacer Scripts >>>
# El simbolo "$" delante de una variable sirve para sustituir dicha variable por su valor en el codigo (es decir, si mi variable X vale false, el codigo "$X==true" sería en esencia "false==true" )
# Si queremos asignarle un valor, tendriamos que hacer "X=true", y si queremos obtener su valor para, por ejemplo, un condicional ( dentro de un "if", por ejemplo ), sería "if [[ $X == true ]]"

# "$@" Significa "todos los parametros"
# "${nombreDeNuestraLista[@]}" Indica los valores de nuestra lista, pudiendo recorrerla utilizando un bucle "for" ( for nombreDeVariableDelBucle in ${nombreDeNuestraLista[@]} )

# Todos los bucles ( for, while, etc ) van continuados por un "do", el cual siempre se tiene que cerrar con un "done"

# Aperturas y Cierres:
# if > fi
# case > esac
# do > done

# "read -p" no solo muestra un mensaje por pantalla, si no que espera al usuario para que introduzca un valor de cualquir tipo, que se guarda en una variable inicializada justo después ( ej: read -p "Test" variableNombre )

# Para renombrar un archivo, lo más fácil es utilizar el comando "mv", indicando el nombre antiguo y acto seguido el nombre nuevo ( ej: mv nombreAntiguo nombreNuevo )
# ( es posible pasarle rutas completas para renombar archivos que no se encuentran en la misma carpeta donde se ejecuta el comando/script )

# Para introducir text dentro de un archivo que ya exista, utilizamos el comand "echo" seguido de ">>" o ">"
# ">>" añade a lo que ya haya en el archivo, sin sobreescribir
# ">" sobreescribe lo anterior
# Esto redirrecciona el resultado del comando "echo", que normalmente se imprimiria en la terminal, y en su lugar lo imprime donde le especifiquemos tras ">> ó >", siendo esto un archivo

# El comando "grep" se utiliza para buscar texto dentro de archivos
# El comando "find" se utiliza para encontrar archivos o directorios, por sus nombres

# El comando "man" en la terminal normal es tu amigo si sabes algo de inglés y no te acuerdas de como usar un comando, pues es un manual. Se utiliza haciendo "man (nombre del comando)"

# En condicionales como el "if", para comparar Strings solo existen las condiciones "==" ( es igual ) y "!=" ( no es igual )
# Por otro lado, si lo que queremos es comparar números, podemos utilizar:
# -lt (less than)
# -le (less or equal)
# -gt (greater than)
# -ge (greater or equal)
# -eq (equal)

# Si lo que queremos es comprobar es si un archivo o directorio existe, utilizamos "-f" (file) y "-d" (directory), colocando estos parametros ANTES del nombre/ruta del archivo o directorio a comprobar (ej: if [[ -d nombredeArchivoORuta ]])

# Para almacenar el resultado de un comando en una variable, utilizamos: (ej: miVariable=$comando)

menuCerrado=true # Creamos nuestra variable que controla nuestro bucle del menu
listaParametros=() # Creamos una lista vacía donde guardaremos los parametros que le pasemos en la ejecución inicial ( bash scripPractica.sh parametroEjemplo1 parametroEjemplo2... )

while [[ $menuCerrado ]] # Si esto se cambia a "false", nuestro menú dejará de mostrarse
do

    # Mostramos visualmente las opciones
    echo "1. Crear carpeta con los parametros" # Creamos carpetas con los nombres de los parametros que les pasemos
    echo "2. Eliminar carpetas" # Eliminamos las carpetas que el usuario indique a través de la terminal
    echo "3. Crear archivo" # Creamos un archivo con el nombre que quiera el usuario en la carpeta que quiera el usuario, todo indicado por peticiones por la terminal
    echo "4. Renombrar archivo" # Renombramos un archivo indicado por el usuario
    echo "5. Introducir texto en un archivo" # Introducimos texto que el usuario desee a un archivo determinado por el usuario
    echo "6. Buscar texto dentro de un archivo" # Buscamos cualquier archivo dentro de nuestra carpeta madre de manera recursiva que contenga el texto indicado
    echo "7. Salir del script" # Cerramos el script

    read -p "Seleccione una opción: " opcion

    # Este es nuestro equivalente del switch case de Java, aqui es "case", a secas, controlado por nuestra variable "opcion"
    case $opcion in

        # Un valor ( ya sea un numero como "1)", o un String como "test)" ) seguido de un parentesis representa cada caso de nuestro "case", tal como en Java
        1)

            for parametro in $@ # Este bucle "for" viaja en cada vuelta por cada parametro que se le haya pasado al Script, guardandolo en la variable "parametro"
            do

                listaParametros+=("$parametro") # Añadimos cada parametro a nuestra lista global "listaParametros". Importante el "+=" para añadir a lo ya existente en la lista, un "=" a secas sobreescribiría lo anterior

            done

            echo "Creamos carpetas con los nombres de los parametros..."

            for elem in ${listaParametros[@]} # Con este bucle for, viajamos por todos los elementos que previamente hemos guardado en la lista, que son nuestros parametros
            do

                if [[ -d $elem ]] # Comprobamos si una carpeta con ese nombre ya existe, en cuyo caso, no hacemos nada
                then

                    echo "La carpeta $elem ya existe."

                else # Si no existe, la creamos

                    mkdir $elem
                    echo "Carpeta $elem creada correctamente"

                fi

            done

        ;; # El conjunto ";;" es el equivalente al "break" en un "switch case" de Java, y es necesario
        2)

        read -p "Introduzca el nombre de la carpeta a borrar: " carpetaBorrar

        if [[ -d $carpetaBorrar ]] # Si la carpeta existe, tenemos que borrarla
        then

            rm -r $carpetaBorrar # Comando "rm" para borrar. En caso de querer borrar un archivo en una localización que no sea la del Script, es tan fácil como pasarle una ruta
            echo "Carpeta $carpetaBorrar se ha borrado correctamente."

        else # Si no existe, no hacemos nada

            echo "No existe una carpeta con el nombre $carpetaBorrar."

        fi

        ;;
        3)

        read -p "Introduzca el nombre de la carpeta en la que quiere crear el archivo: " carpetaBuscar

        if [[ -d $carpetaBuscar ]] # Si la carpeta existe, procedemos a pedirle el nombre del archivo a crear
        then

            read -p "Introduzca el nombre de su nuevo archivo: " archivoCrear

            if [[ -f $carpetaBuscar/$archivoCrear ]] # Si ese nombre de archivo ya existiese en esa ruta, dariamos un error
            then

                echo "El archivo $archivoCrear ya existe."

            else # De lo contrario, creamos dicho archivo

                touch $carpetaBuscar/$archivoCrear # Indicamos la ruta que nos ha dicho el usuario
                echo "Archivo $archivoCrear creado con exito."

            fi

        else

            echo "La carpeta $carpetaBuscar no existe, intentelo de nuevo con una carpeta existente."

        fi

        ;;
        4)

        read -p "Introduzca el nombre de la carpeta donde se encuentra el archivo a renombrar: " carpetaBuscar2

        if [[ -d $carpetaBuscar2 ]] # Si la carpeta existe, procedemos a pedirle el nombre del archivo a renombrar
        then

            read -p "Introduzca el nombre del archivo a renombrar: " archivoBuscar

            if [[ -f $carpetaBuscar2/$archivoBuscar ]] # Si el archivo existe, le pedimos el nuevo nombre, y lo renombramos
            then

                read -p "Introduzca el nuevo nombre del archivo: " nombreNuevo
                mv $carpetaBuscar2/$archivoBuscar $carpetaBuscar2/$nombreNuevo # Utilizamos el "mv" para renombrarlo
                echo "Archivo renombrado correctamente a $nombreNuevo"

            else

                echo "Archivo $archivoBuscar no existe."

            fi

        else

            echo "La carpeta $carpetaBuscar2 no existe, intentelo de nuevo con una carpeta existente."

        fi

        ;;
        5)

        read -p "Introduzca el nombre de la carpeta donde se encuentra el archivo donde introducir texto: " carpetaBuscar3

        if [[ -d $carpetaBuscar3 ]] # Si la carpeta existe, procedemos a pedirle el nombre del archivo al que introducir texto
        then

            read -p "Introduzca el nombre del archivo donde introducir texto: " archivoBuscar2

            if [[ -f $carpetaBuscar3/$archivoBuscar2 ]] # Si ese tambien existe, le podemos pedir el texto a introducir
            then

                read -p "Introduzca el texto para introducir en el archivo: " text
                echo "$text" >> $carpetaBuscar3/$archivoBuscar2 # Utilizamos ">>" para introducir texto al archivo establecido
                echo "El texto actual del archivo es: "
                cat $carpetaBuscar3/$archivoBuscar2 # El comando "cat" nos muestra por pantalla el contenido de un archivo que le pasemos, en este caso, nuestro archivo recien escrito

            else

                echo "Archivo $archivoBuscar2 no existe."

            fi

        else

            echo "La carpeta $carpetaBuscar3 no existe, intentelo de nuevo con una carpeta existente."

        fi

        ;;
        6)

        read -p "Introduzca el texto a buscar: " textBuscar # Le pedimos al usuario un texto a buscar
        grep -r $textBuscar
        # Y usamos el comando "grep" para buscar en el contenido de archivos, pasandole el texto que queremos buscar. El parametro "-r" indica que la busqueda debe ser recursiva, es decir, que busque en todas las carpetas dentro de la carpeta inicial hasta que llegue a un final, en vez de quedarse unicamente en la carpeta inicial

        ;;
        7)

        menuCerrado=false # Ponemos nuestra variable de control del menú a "false" para parar la ejecución del bucle de nuestro menú
        echo "Se ha cerrado el script."
        exit 0 # Utilizamo "exit 0" para salirnos del Script y devolver a nuestro usuario a la terminal normal

        ;;
        *) # El valor "*" en un "case" es el equivalente al "default" en un switch case de Java, el caso que ocurre si ningún caso anterior ocurre

        echo "Esta opción no es válida."

        ;;

    esac # Cerramos el "case"

done # Cerramos nuestro bucle "do" del "while" del menú


