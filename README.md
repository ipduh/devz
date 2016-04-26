devz
==== 
DEVeloper'S Stupid Servant.<br />
A bash extention that helps the administrator of similar dev and production systems.<br />
g0 2010 - http://ipduh.com/contact<br />
http://sl.ipduh.com/devz-howto<br />
     <br />
devz verbs:<br />
 <br />
'toprod' or 'devz toprod'<br />
 toprod file<br />
 scp a file to the production server(s)<br />
 <br />
'ctoprod' or 'devz ctoprod'<br />
 ctoprod 'command;command;'<br />
 send command(s) to poduction server(s)<br />
 <br />
'fromprod' or 'devz fromprod'<br />
 fromprod file<br />
 scp a file from the first production server here.<br />
 <br />
'stor' or 'devz stor'<br />
 stor file<br />
 creates the directory stor in the current directory if it does not exist.<br />
 makes a copy of the file in stor<br />
 the file gets a version number like file.n where n [0,n]<br />
 <br />
'devz-setagent' or 'devz setagent'<br />
 setagent<br />
 start an ssh-agent login session<br />
 <br />
'devz-showconfig' or 'devz showconfig'<br />
 showconfig<br />
 See the Current devz configuration<br />
 <br />
'devz-setconfig' or 'devz setconfig'<br />
 setconfig<br />
 add server to the production-servers list file<br />
 setconfig cannot configure much, check the devz-howto for your first setup<br />
 <br />
'devz-prodsrvexists' or 'devz prodsrvexists'<br />
 prodsrvexists<br />
 check if ${DEVZ_PRO_SRV} exists and  print an example ${DEVZ_PRO_SRV} file<br />
 <br />
'rmstorfromgit' or 'devz rmstorfromgit'<br />
 rmstorfromgit<br />
 remove the devz stor directories from git only<br />
 <br />
     <br />
