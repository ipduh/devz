#!/bin/bash
# Install devz as root or sudoer
# g0 2013 - http://ipduh.com/contact
# http://sl.ipduh.com/devz-howto

source ./devz.sh
cp ./devz.sh /bin/devz

if [ ! -d $DEVZ_CONFIGDIR ]
then
  mkdir $DEVZ_CONFIGDIR
fi

if [ ! -e $DEVZ_PRO_SRV ]
then
  echo "#IP address or hostname,SSH TCP port,user" > $DEVZ_PRO_SRV
  echo "#192.0.2.222,22,root" >> $DEVZ_PRO_SRV
fi

grep "source /bin/devz" ${HOME}/.bashrc &> /dev/null
if [ ! $? -eq 0 ]
then
  echo "source /bin/devz" >>  ${HOME}/.bashrc
fi

grep -E "source ~/.bashrc|. ~/.bashrc|. ${HOME}/.bashrc" ${HOME}/.bash_profile &> /dev/null
if [ ! $? -eq 0 ]
then
  echo "source ${HOME}/.bashrc" >>  ${HOME}/.bash_profile
fi

