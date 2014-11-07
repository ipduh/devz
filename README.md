devz
====
<pre>
******
devz
DEVeloper'S Stupid Servant.
A bash extention that helps the administrator of similar dev and production systems.
</pre>
g0 2010 - http://ipduh.com/contact
http://sl.ipduh.com/devz-howto
<pre>
******
devz verbs:
*
'toprod' or 'devz toprod'
 toprod file
 scp a file to the production server(s)
*
'ctoprod' or 'devz ctoprod'
 ctoprod 'command;command;'
 send command(s) to poduction server(s)
*
'fromprod' or 'devz fromprod'
 fromprod file
 scp a file from the first production server here.
*
'stor' or 'devz stor'
 stor file
 creates the directory stor in the current directory if it does not exist.
 makes a copy of the file in stor
 the file gets a version number like file.n where n [0,n]
*
'devz-setagent' or 'devz setagent'
 setagent
 start an ssh-agent login session
*
'devz-showconfig' or 'devz showconfig'
 showconfig
 See the Current devz configuration
*
'devz-setconfig' or 'devz setconfig'
 setconfig
 add server to the production-servers list file
 setconfig cannot configure much, check the devz-howto for your first setup
*
'devz-prodsrvexists' or 'devz prodsrvexists'
 prodsrvexists
 check if ${DEVZ_PRO_SRV} exists and  print an example ${DEVZ_PRO_SRV} file
*
******
</pre>
