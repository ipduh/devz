##devz DEVeloper'S Stupid Servant.
##devz A bash extention that helps the administrator of similar dev and production systems.
##devz g0 2010 - http://ipduh.com/contact
##devz http://sl.ipduh.com/devz-howto

DEVZ_VERBOSE="1"
DEVZ_EGO="devz"
DEVZAT=/bin/${DEVZ_EGO}
DEVZ_CONFIGDIR="${HOME}/.devzconfig"
DEVZ_IDENTITY="${HOME}/.ssh/id_dsa"
DEVZ_PRO_SRV="${DEVZ_CONFIGDIR}/production-servers"
DEVZ_OVERWRITE="${DEVZ_CONFIGDIR}/devz_vars"


if [ -e $DEVZ_OVERWRITE ]
then
  source $DEVZ_OVERWRITE
fi

function devz {
DEVZ_MEAT=${DEVZAT}
DEVZ_PT2="##"

if [ "${1}" = "toprod" ]
then
  toprod ${2}

elif [ "${1}" = "fromprod" ]
then
  fromprod ${2}

elif [ "${1}" = "stor" ]
then
  stor ${2}

elif [ "${1}" = "ctoprod" ]
then
  ctoprod ${2}

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

elif [ "${1}" = "rmstorfromgit" ]
then
  rmstorfromgit

else
  echo "devz"
  echo "====="
  grep "${DEVZ_PT2}devz " ${DEVZ_MEAT} |awk -F "${DEVZ_PT2}devz " '{print $2}'
  echo "*****"
  echo "devz verbs:"
  echo "*"
  echo "'toprod' or 'devz toprod'"
  grep "${DEVZ_PT2}toprod" ${DEVZ_MEAT} |awk -F "${DEVZ_PT2}toprod" '{print $2}'
  echo "*"
  echo "'ctoprod' or 'devz ctoprod'"
  grep "${DEVZ_PT2}ctoprod" ${DEVZ_MEAT} |awk -F "${DEVZ_PT2}ctoprod" '{print $2}'
  echo "*"
  echo "'fromprod' or 'devz fromprod'"
  grep "${DEVZ_PT2}fromprod" ${DEVZ_MEAT} |awk -F "${DEVZ_PT2}fromprod" '{print $2}'
  echo "*"
  echo "'stor' or 'devz stor'"
  grep "${DEVZ_PT2}stor" ${DEVZ_MEAT} |awk -F "${DEVZ_PT2}stor" '{print $2}'
  echo "*"
  echo "'devz-setagent' or 'devz setagent'"
  grep "${DEVZ_PT2}devz-setagent" ${DEVZ_MEAT} |awk -F "${DEVZ_PT2}devz-setagent" '{print $2}'
  echo "*"
  echo "'devz-showconfig' or 'devz showconfig'"
  grep "${DEVZ_PT2}devz-showconfig" ${DEVZ_MEAT} |awk -F "${DEVZ_PT2}devz-showconfig" '{print $2}'
  echo "*"
  echo "'devz-setconfig' or 'devz setconfig'"
  grep "${DEVZ_PT2}devz-setconfig" ${DEVZ_MEAT} |awk -F "${DEVZ_PT2}devz-setconfig" '{print $2}'
  echo "*"
  echo "'devz-prodsrvexists' or 'devz prodsrvexists'"
  grep "${DEVZ_PT2}devz-prodsrvexists" ${DEVZ_MEAT} |awk -F "${DEVZ_PT2}devz-prodsrvexists" '{print $2}'
  echo "*"
  echo "'rmstorfromgit' or 'devz rmstorfromgit'"
  grep "${DEVZ_PT2}rmstorfromgit" ${DEVZ_MEAT} |awk -F "${DEVZ_PT2}rmstorfromgit" '{print $2}'
  echo "*"
  echo "*****"
fi
}

##
##devz-prodsrvexists prodsrvexists
##devz-prodsrvexists check if ${DEVZ_PRO_SRV} exists and  print an example ${DEVZ_PRO_SRV} file
##
function devz-prodsrvexists {
if [ ! -e ${DEVZ_PRO_SRV} ]
then
  echo "${DEVZ_EGO}:I cannot read ${DEVZ_PRO_SRV}."
  echo "${DEVZ_EGO}:Make sure that a readable ${DEVZ_PRO_SRV} exists."
else
  echo "${DEVZ_EGO}:${DEVZ_PRO_SRV} exists. Try devz-showconfig to read it with devz."
fi

  echo ""
  echo "#Example ${DEVZ_EGO} ${DEVZ_PRO_SRV} file."
  echo "#IP or host name,SSH TCP Port,User"
  echo "192.0.2.222,22,devzuser"
  echo ""
}
##
##devz-setconfig setconfig
##devz-setconfig add server to the production-servers list file
##devz-setconfig setconfig cannot configure much, check the devz-howto for your first setup
##
function devz-setconfig {
if [ ! -e ${DEVZ_PRO_SRV} ]
 then
   devz-prodsrvexists
else
  DEVZ_SETCONFIG_PROSRV=""
  ls -l ${DEVZ_PRO_SRV}*
  read -p "Set production-servers list: " DEVZ_SETCONFIG_PROSRV;
  read -p "Add ${PROSRV} to ${DEVZ_PRO_SRV}? [y]:" DEVZ_YON;
  if [ "$DEVZ_YON" == "y" ]
    then
      echo "${DEVZ_SETCONFIG_PROSRV}" >> ${DEVZ_PRO_SRV}
  fi
  devz-showconfig
fi
}
##
##devz-showconfig showconfig
##devz-showconfig See the Current devz configuration
##
function devz-showconfig {
  if [ ! -e ${DEVZ_PRO_SRV} ]
    then
      devz-prodsrvexists
    else
      echo "******"
      echo "PRODUCTION SERVERS LIST from ${DEVZ_PRO_SRV}"
      COUNTER=1
      for DEVZ_SERVER in `grep -v -E '^#|^$' ${DEVZ_PRO_SRV}`
            do
                    PRODUCTION_SRV=`echo ${DEVZ_SERVER} | awk -F "," '{print $1}'`
                    PRODUCTION_SRV_PORT=`echo ${DEVZ_SERVER} | awk -F "," '{print $2}'`
                    PRODUCTION_SRV_USER=`echo ${DEVZ_SERVER} | awk -F "," '{print $3}'`
                    echo "${COUNTER}) - $PRODUCTION_SRV -- $PRODUCTION_SRV_PORT -- $PRODUCTION_SRV_USER -"
        (( COUNTER += 1 ))
      done
    fi
      echo "***"
      echo "IDENTITY: ${DEVZ_IDENTITY}"
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
     echo "${DEVZ_EGO}:It seems that active identities are held by the ssh-agent."
  else
     ssh-agent sh -c "ssh-add ${DEVZ_IDENTITY} && bash"
  fi
}
##
##toprod toprod file
##toprod scp a file to the production server(s)
##
function toprod {

DEVZ_PWD=`pwd`

if [ -z "${1}" ]
then
      echo "${DEVZ_EGO}:toprod WHAT?"
      echo "${DEVZ_EGO}:Type devz for help with all commands."
elif [ ! -e ${DEVZ_PRO_SRV} ]
then
  echo "${DEVZ_EGO}:Make sure that a readable ${DEVZ_PRO_SRV} exists and contains at least one 'host,port,user' row"
  echo "${DEVZ_EGO}:Type devz-prodsrvexists for an example  ${DEVZ_PRO_SRV} file."
else
  for DEVZ_SERVER in `grep -v -E '^#|^$' ${DEVZ_PRO_SRV}`
        do
                PRODUCTION_SRV=`echo ${DEVZ_SERVER} | awk -F "," '{print $1}'`
                PRODUCTION_SRV_PORT=`echo ${DEVZ_SERVER} | awk -F "," '{print $2}'`
                PRODUCTION_SRV_USER=`echo ${DEVZ_SERVER} | awk -F "," '{print $3}'`
    if [ ${DEVZ_VERBOSE} -eq 1 ]
    then
      echo "${DEVZ_EGO}:${DEVZ_PWD}/${1} to $PRODUCTION_SRV_USER@$PRODUCTION_SRV:$PRODUCTION_SRV_PORT:${DEVZ_PWD}/${1}"
    fi
    scp -r -P ${PRODUCTION_SRV_PORT} -i ${DEVZ_IDENTITY} $1 ${PRODUCTION_SRV_USER}@${PRODUCTION_SRV}:${DEVZ_PWD}/$1
  done
fi
}
##
##ctoprod ctoprod 'command;command;'
##ctoprod send command(s) to poduction server(s)
##
function ctoprod {

DEVZ_PWD=`pwd`

if [ -z "${1}" ]
then
      echo "${DEVZ_EGO}:ctoprod WHAT?"
      echo "${DEVZ_EGO}:Type devz for help with all commands."
elif [ ! -e ${DEVZ_PRO_SRV} ]
then
  echo "${DEVZ_EGO}:Make sure that a readable ${DEVZ_PRO_SRV} exists and contains at least one 'host,port,user' row"
  echo "${DEVZ_EGO}:Type devz-prodsrvexists for an example  ${DEVZ_PRO_SRV} file."
else
        for DEVZ_SERVER in `grep -v -E '^#|^$' ${DEVZ_PRO_SRV}`
        do
                PRODUCTION_SRV=`echo ${DEVZ_SERVER} | awk -F "," '{print $1}'`
                PRODUCTION_SRV_PORT=`echo ${DEVZ_SERVER} | awk -F "," '{print $2}'`
                PRODUCTION_SRV_USER=`echo ${DEVZ_SERVER} | awk -F "," '{print $3}'`
                if [ ${DEVZ_VERBOSE} -eq 1 ]
                then
                        echo "${DEVZ_EGO}: ${PRODUCTION_SRV_USER}@${PRODUCTION_SRV}:${PRODUCTION_SRV_PORT} \"$1\""
                fi
                echo "***Start ${PRODUCTION_SRV}***"
                ssh -p ${PRODUCTION_SRV_PORT} -i ${DEVZ_IDENTITY} ${PRODUCTION_SRV_USER}@${PRODUCTION_SRV} "cd ${DEVZ_PWD};${1}"
                echo "***End ${PRODUCTION_SRV}***"
        done
fi
}
##
##fromprod fromprod file
##fromprod scp a file from the first production server here.
##
function fromprod {

DEVZ_PWD=`pwd`

if [ -z "${1}" ]
then
      echo "${DEVZ_EGO}:fromprod WHAT?"
      echo "${DEVZ_EGO}:Type devz for help with all commands."
elif [ ! -e ${DEVZ_PRO_SRV} ]
then
  echo "${DEVZ_EGO}:Make sure that a readable ${DEVZ_PRO_SRV} exists and contains at least one 'host,port,user' row"
  echo "${DEVZ_EGO}:Type devz-prodsrvexists for an example  ${DEVZ_PRO_SRV} file."
else
  if [ -e $1 ]
        then
    echo "${DEVZ_EGO}:$1 exists! Please stor it and delete it or rename it."
        else
    DEVZ_SERVER=`grep -v -E '^#|^$' -m 1 ${DEVZ_PRO_SRV}`
    PRODUCTION_SRV=`echo ${DEVZ_SERVER} | awk -F "," '{print $1}'`
                PRODUCTION_SRV_PORT=`echo ${DEVZ_SERVER} | awk -F "," '{print $2}'`
                PRODUCTION_SRV_USER=`echo ${DEVZ_SERVER} | awk -F "," '{print $3}'`

    if [ ${DEVZ_VERBOSE} -eq 1 ]
                then
                        echo "${DEVZ_EGO}:$PRODUCTION_SRV_USER@$PRODUCTION_SRV:$PRODUCTION_SRV_PORT:${DEVZ_PWD}/${1} to ${DEVZ_PWD}/${1}"
                fi

    scp -r -P ${PRODUCTION_SRV_PORT} -i ${DEVZ_IDENTITY} ${PRODUCTION_SRV_USER}@${PRODUCTION_SRV}:${DEVZ_PWD}/$1 .
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
  echo "${DEVZ_EGO}:stor WHAT?"
        echo "${DEVZ_EGO}:Type devz for help with all commands."
else


  if [ ! -d ./stor ]
  then
    echo "${DEVZ_EGO}:The directory ./stor does not exist! I will create it."
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
    DEVZ_LAST=0

    for j in $(seq 0 $((${#FILEVL[@]} -1)))
    do
            if [ ${DEVZ_LAST} -lt ${FILEVL[$j]} ]
            then
                    DEVZ_LAST=${FILEVL[$j]}
            fi
    done

          diff ${1} ./stor/${1}.${DEVZ_LAST} > /dev/null
    if [ $? -eq 0 ]
    then
      echo "${DEVZ_EGO}:${1} is the same as ./stor/${1}.${DEVZ_LAST}"
      echo "${DEVZ_EGO}:I did not stor ${1}"
    else
      DEVZ_LAST=`expr ${DEVZ_LAST} + 1`
      cp $1 ./stor/$1.${DEVZ_LAST}
      echo "${DEVZ_EGO}:${1} is at ./stor/${1}.${DEVZ_LAST}"
    fi
        fi

  if [ ! -e ./stor/$1.0 -a -d ./stor ]
  then
    cp $1 ./stor/$1.0
    echo "${DEVZ_EGO}:$1 is at ./stor/$1.0"
  fi
fi
}

##
##rmstorfromgit rmstorfromgit
##rmstorfromgit remove the devz stor directories from git only
##
function rmstorfromgit {

git rm -r --cached stor
for i in `git ls-files |grep stor\/`;do git rm --cached $i;done

}
