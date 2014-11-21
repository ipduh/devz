#!/bin/bash
# Install devz as user
# g0 2013 - http://ipduh.com/contact
# http://sl.ipduh.com/devz-howto

source ./devz.sh

if [ ! -d $DEVZ_CONFIGDIR ]
then
  mkdir $DEVZ_CONFIGDIR
fi

diff /bin/devz ./devz.sh &> /dev/null
if [ ! $? -eq 0 ]
then
  cp ./devz.sh ${DEVZ_CONFIGDIR}/devz
  echo "DEVZAT=${DEVZ_CONFIGDIR}/devz" > ${DEVZ_OVERWRITE}
  grep "source ${DEVZ_CONFIGDIR}/devz" ${HOME}/.bashrc
  if [ ! $? -eq 0 ]
  then
    echo "source ${DEVZ_CONFIGDIR}/devz" >> ${HOME}/.bashrc
  fi
else
  grep "source /bin/devz" ${HOME}/.bashrc &> /dev/null
  if [ ! $? -eq 0 ]
  then
    echo "source /bin/devz" >>  ${HOME}/.bashrc
  fi
fi

if [ ! -e $DEVZ_PRO_SRV ]
then
  echo "#IP address or hostname,SSH TCP port,user" > $DEVZ_PRO_SRV
  echo "#192.0.2.222,22,root" >> $DEVZ_PRO_SRV
fi

