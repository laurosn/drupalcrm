#!/bin/bash
# Export some ENV variables so you don't have to type anything
export AWS_ACCESS_KEY_ID="AKIAJUB7W33OW52CKNEQ"
export AWS_SECRET_ACCESS_KEY="MWvN8qTfnNX0xvA4+sMb/mACQj8U2EEzhchMpOMV"
export PASSPHRASE="workforus"

# Your GPG key
GPG_KEY="workforus"


# The S3 destination followed by bucket name
DEST="s3://s3-eu-west-1.amazonaws.com/work-for-us-bucket/drupal/"

# Your GPG key
#GPG_KEY=YOUR_GPG_KEY

MENSAGEM_USO="
Uso: $(basename "$0") [OPÇÕES]
OPÇÕES:
  -d [date]                  date to recover
  -f [file]                  File/folder to recover
  -t [restore-to]            Recover to folder
  -h                         Show help
"

# Tratamento das opções de linha de comando
while getopts "d:f:t:h:" opcao
do
    case "$opcao" in

        d)
            DATE="$OPTARG"
        ;;

        f)
            FILE="$OPTARG"
        ;;

        t)
            TO="$OPTARG"
        ;;

        h)
            echo "$MENSAGEM_USO"
            exit 0
        ;;

        \?)
            echo -n Invalid option: $OPTARG
            echo "$MENSAGEM_USO"
            exit 1
        ;;

        :)
            echo Missing argument: $OPTARG
            exit 1
        ;;
    esac
done

if [ "$#" -eq 0 ]; then
    echo "Número inválido de argumentos"
    echo "$MENSAGEM_USO"
    exit 0
fi



duplicity --restore-time $DATE --file-to-restore $FILE ${DEST} $TO
chown -R www-data: /var/www
# Reset the ENV variables. Don't need them sitting around
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset PASSPHRASE
