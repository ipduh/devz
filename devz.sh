##devz DEVeloper'S Stupid Servant
##devz g0 2010 - http://ipduh.com/contact

VERBOSE="1"
EGO="devz"

#do not replace with $0 since in run time devz is bash
DEVZAT=/bin/${EGO}

IDENTITY="${HOME}/.ssh/id_dsa"
PRO_SRV="${HOME}/.devzconfig/production-servers"

function devz {
  MEAT=${DEVZAT}
  PT2="##"

if [ "${1}" = "toprod" ]
then
  toprod ${2}

elif [ "${1}" = "fromprod" ]
then
  fromprod ${2}

elif [ "${1}" = "stor" ]
then
  stor ${2}

elif [ "${1}" = "setagent" ]
then
  devz-setagent

elif [ "${1}" = "showconfig" ]
then
  devz-showconfig

elif [ "${1}" = "setconfig" ]
then
  devz-setconfig
elif [ "${1}" = "prodsrvexists" ]
then
 devz-prodsrvexists
else
  echo "******"
  echo "devz"
  grep "${PT2}devz " ${MEAT} |awk -F "${PT2}devz " '{print $2}'
  echo "******"
  echo "devz verbs:"
  echo "*"
  echo "'toprod' or 'devz toprod'"
  grep "${PT2}toprod" ${MEAT} |awk -F "${PT2}toprod" '{print $2}'
  echo "*"
  echo "'ctoprod' or 'devz ctoprod'"
  grep "${PT2}ctoprod" ${MEAT} |awk -F "${PT2}ctoprod" '{print $2}'
  echo "*"
  echo "'fromprod' or 'devz fromprod'"
  grep "${PT2}fromprod" ${MEAT} |awk -F "${PT2}fromprod" '{print $2}'
  echo "*"
  echo "'stor' or 'devz stor'"
  grep "${PT2}stor" ${MEAT} |awk -F "${PT2}stor" '{print $2}'
  echo "*"
  echo "'devz-setagent' or 'devz setagent'"
  grep "${PT2}devz-setagent" ${MEAT} |awk -F "${PT2}devz-setagent" '{print $2}'
  echo "*"
  echo "'devz-showconfig' or 'devz showconfig'"
  grep "${PT2}devz-showconfig" ${MEAT} |awk -F "${PT2}devz-showconfig" '{print $2}'
  echo "*"
  echo "'devz-setconfig' or 'devz setconfig'"
  grep "${PT2}devz-setconfig" ${MEAT} |awk -F "${PT2}devz-setconfig" '{print $2}'
  echo "*"
  echo "'devz-prodsrvexists' or 'devz prodsrvexists'"
  grep "${PT2}devz-prodsrvexists" ${MEAT} |awk -F "${PT2}devz-prodsrvexists" '{print $2}'
  echo "*"
  echo "******"
fi
}

##
##devz-prodsrvexists prodsrvexists
##devz-prodsrvexists check if ${PRO_SRV} exists and  print an example ${PRO_SRV} file
##
function devz-prodsrvexists {
  if [ ! -e ${PRO_SRV} ]
    then
      echo "${EGO}:I cannot read ${PRO_SRV}."
      echo "${EGO}:Make sure that a readable ${PRO_SRV} exists."
  fi

  echo ""
  echo "#Example ${EGO} ${PRO_SRV} file."
  echo "#IP or host name,SSH TCP Port,User"
  echo "192.0.2.222,22,devzuser"
  echo ""
}
##
##devz-setconfig setconfig
##devz-setconfig add to the production-servers list file
##this is a silly function
##devz-setconfig you better follow devz-howto for first setup
##
function devz-setconfig {
if [ ! -e ${PRO_SRV} ]
 then
   devz-prodsrvexists
else
  DEVZ_SETCONFIG_PROSRV=""
  ls -l ${PRO_SRV}*
  read -p "Set production-servers list: " DEVZ_SETCONFIG_PROSRV;
  read -p "Add ${PROSRV} to ${PRO_SRV}? [y]:" DEVZ_YON;
  if [ "$DEVZ_YON" == "y" ]
    then
      echo "${DEVZ_SETCONFIG_PROSRV}" >> ${PRO_SRV}
  fi
  devz-showconfig
fi
}
##
##devz-showconfig showconfig
##devz-showconfig See the Current devz configuration
##
function devz-showconfig {
  if [ ! -e ${PRO_SRV} ]
    then
      devz-prodsrvexists
    else
      echo "******"
      echo "PRODUCTION SERVERS LIST from ${PRO_SRV}"
      COUNTER=1
      for SERVER in `grep -v -E '^#|^$' ${PRO_SRV}`
            do
                    PRODUCTION_SRV=`echo ${SERVER} | awk -F "," '{print $1}'`
                    PRODUCTION_SRV_PORT=`echo ${SERVER} | awk -F "," '{print $2}'`
                    PRODUCTION_SRV_USER=`echo ${SERVER} | awk -F "," '{print $3}'`
                    echo "${COUNTER}) - $PRODUCTION_SRV -- $PRODUCTION_SRV_PORT -- $PRODUCTION_SRV_USER -"
        (( COUNTER += 1 ))
      done
    fi
      echo "***"
      echo "IDENTITY: ${IDENTITY}"
      echo "******"
}
##
##devz-setagent setagent
##devz-setagent start an ssh-agent login session
##
function devz-setagent {
  ssh-add -ls 2>/dev/null
  if [ $? -eq 0 ]
  then
     echo "${EGO}:It seems that active identities are held by the ssh-agent"
  else
     ssh-agent sh -c "ssh-add ${IDENTITY} && bash"
  fi
}
##
##toprod toprod file
##toprod scp a file to the production server(s)
##
function toprod {
  PWD=`pwd`

if [ -z "${1}" ]
then
      echo "${EGO}:toprod WHAT?"
      echo "${EGO}:Type devz for help with all commands."
elif [ ! -e ${PRO_SRV} ]
then
  echo "${EGO}:Make sure that a readable ${PRO_SRV} exists and contains at least one 'host,port,user' row"
  echo "${EGO}:Type devz-prodsrvexists for an example  ${PRO_SRV} file."
else
  for SERVER in `grep -v -E '^#|^$' ${PRO_SRV}`
        do
                PRODUCTION_SRV=`echo ${SERVER} | awk -F "," '{print $1}'`
                PRODUCTION_SRV_PORT=`echo ${SERVER} | awk -F "," '{print $2}'`
                PRODUCTION_SRV_USER=`echo ${SERVER} | awk -F "," '{print $3}'`
    if [ ${VERBOSE} -eq 1 ]
    then
      echo "${EGO}:${PWD}/${1} to $PRODUCTION_SRV_USER@$PRODUCTION_SRV:$PRODUCTION_SRV_PORT:${PWD}/${1}"
    fi
    scp -r -P ${PRODUCTION_SRV_PORT} -i ${IDENTITY} $1 ${PRODUCTION_SRV_USER}@${PRODUCTION_SRV}:${PWD}/$1
  done
fi
}
##
##ctoprod ctoprod 'command;command;'
##ctoprod send command(s) to poduction server(s)
##
function ctoprod {
        PWD=`pwd`

if [ -z "${1}" ]
then
      echo "${EGO}:ctoprod WHAT?"
      echo "${EGO}:Type devz for help with all commands."
elif [ ! -e ${PRO_SRV} ]
then
  echo "${EGO}:Make sure that a readable ${PRO_SRV} exists and contains at least one 'host,port,user' row"
  echo "${EGO}:Type devz-prodsrvexists for an example  ${PRO_SRV} file."
else
        for SERVER in `grep -v -E '^#|^$' ${PRO_SRV}`
        do
                PRODUCTION_SRV=`echo ${SERVER} | awk -F "," '{print $1}'`
                PRODUCTION_SRV_PORT=`echo ${SERVER} | awk -F "," '{print $2}'`
                PRODUCTION_SRV_USER=`echo ${SERVER} | awk -F "," '{print $3}'`
                if [ ${VERBOSE} -eq 1 ]
                then
                        echo "${EGO}: ${PRODUCTION_SRV_USER}@${PRODUCTION_SRV}:${PRODUCTION_SRV_PORT} \"$1\""
                fi
                ssh -p ${PRODUCTION_SRV_PORT} -i ${IDENTITY} ${PRODUCTION_SRV_USER}@${PRODUCTION_SRV} ${1}
        done
fi
}
##
##fromprod fromprod file
##fromprod scp a file from the first production server here.
##
function fromprod {

if [ -z "${1}" ]
then
      echo "${EGO}:fromprod WHAT?"
      echo "${EGO}:Type devz for help with all commands."
elif [ ! -e ${PRO_SRV} ]
then
  echo "${EGO}:Make sure that a readable ${PRO_SRV} exists and contains at least one 'host,port,user' row"
  echo "${EGO}:Type devz-prodsrvexists for an example  ${PRO_SRV} file."
else
  if [ -e $1 ]
        then
    echo "${EGO}:$1 exists! Please stor it and delete it or rename it or delete it."
        else
    SERVER=`grep -v -E '^#|^$' -m 1 ${PRO_SRV}`
    PRODUCTION_SRV=`echo ${SERVER} | awk -F "," '{print $1}'`
                PRODUCTION_SRV_PORT=`echo ${SERVER} | awk -F "," '{print $2}'`
                PRODUCTION_SRV_USER=`echo ${SERVER} | awk -F "," '{print $3}'`

    if [ ${VERBOSE} -eq 1 ]
                then
                        echo "${EGO}:$PRODUCTION_SRV_USER@$PRODUCTION_SRV:$PRODUCTION_SRV_PORT:${PWD}/${1} to ${PWD}/${1}"
                fi

    scp -r -P ${PRODUCTION_SRV_PORT} -i ${IDENTITY} ${PRODUCTION_SRV_USER}@${PRODUCTION_SRV}:${PWD}/$1 .
  fi
fi
}
##
##stor stor file
##stor creates the directory stor in the current directory if it does not exist.
##stor makes a copy of the file in stor
##stor the file gets a version number like file.n where n [0,n]
##
function stor {

if [ -z "${1}" ]
then
  echo "${EGO}:stor WHAT?"
        echo "${EGO}:Type devz for help with all commands."
else


  if [ ! -d ./stor ]
  then
    echo "${EGO}:The directory ./stor does not exist! I will create it."
    mkdir ./stor
  fi

  if [ -e ./stor/$1.0 -a -d ./stor ]
        then
                declare -a FILES=( `ls ./stor |grep ${1} |awk -F "${1}." '{print $2}'` )
    FILEV="" #file versions string

    for i in $(seq 0 $((${#FILES[@]} -1)))
    do
            if [[ "${FILES[$i]}" =~ ^[0-9]+$ ]]
            then
                    FILEV="$FILEV ${FILES[$i]}"
            fi
    done

    declare -a FILEVL=( ${FILEV} )
    LAST=0

    for j in $(seq 0 $((${#FILEVL[@]} -1)))
    do
            if [ ${LAST} -lt ${FILEVL[$j]} ]
            then
                    LAST=${FILEVL[$j]}
            fi
    done

          diff ${1} ./stor/${1}.${LAST} > /dev/null
    if [ $? -eq 0 ]
    then
      echo "${EGO}:${1} is the same as ./stor/${1}.${LAST}"
      echo "${EGO}:I did not stor ${1}"
    else
      LAST=`expr ${LAST} + 1`
      cp $1 ./stor/$1.${LAST}
      echo "${EGO}:${1} is at ./stor/${1}.${LAST}"
    fi
        fi

  if [ ! -e ./stor/$1.0 -a -d ./stor ]
  then
    cp $1 ./stor/$1.0
    echo "${EGO}:$1 is at ./stor/$1.0"
  fi
fi
}

