#ldap setup -->
echo "Would you like to setup PAM/LDAP? [Y/N]"
read YESNO
while [ "$YESNO" != 'Y' ] && [ "$YESNO" != 'N' ]; do
	echo "Please enter either 'Y' or 'N'"
	read YESNO
done

if [ "$YESNO" = 'Y' ]; then 
	authconfig --savebackup /root/authconfig.bak
	authconfig --enableldap --enableldapauth --ldapserver="ldap://ldap-login.oit.pdx.edu/" --ldapbasedn="dc=pdx,dc=edu" --update
fi



#Stow setup -->
echo "Would you like to setup stow directories in /export/apps? [Y/N]"
read YESNO
while [ "$YESNO" != 'Y' ] && [ "$YESNO" != 'N' ]; do
	echo "Please enter either 'Y' or 'N'"
	read YESNO
done

if [ "$YESNO" = 'Y' ]; then 
	mkdir -p /export/apps/user/stow
	mkdir /export/apps/user/src
	mkdir -p /export/apps/system/stow
	mkdir /export/apps/system/src
fi

#Passwordless Sudo
echo "Would you like to setup passwordless sudo? [Y/N]"
read YESNO
while [ "$YESNO" != 'Y' ] && [ "$YESNO" != 'N' ]; do
	echo "Please enter either 'Y' or 'N'"
	read YESNO
done

if [ "$YESNO" = 'Y' ]; then 
	sed -i '108s/.*/ %wheel        ALL=(ALL)       NOPASSWD: ALL/' /etc/sudoers
fi

#Firewall Config
echo "Would you like to setup A40-WWW-PUBLIC-NEW? [Y/N]"
read YESNO
while [ "$YESNO" != 'Y' ] && [ "$YESNO" != 'N' ]; do
	echo "Please enter either 'Y' or 'N'"
	read YESNO
done

if [ "$YESNO" = 'Y' ]; then 
	rocks remove firewall host=localhost rulename=A40-WWW-PUBLIC-LAN
	rocks add firewall host=localhost network=public protocol=tcp service=www chain=INPUT action=ACCEPT flags="-m state --state NEW --source 0.0.0.0/0.0.0.0" rulename=A40-WWW-PUBLIC-NEW
	rocks sync host firewall localhost
fi


#Config web access -->

<<COMMENT
if [[ x`rocks list roll` == *'web-server'* ]] 
then
	echo "The web-server roll is installed. Would you like to block access to web directories in /var/www/html? [Y/N]"
else 
	echo "The web-server roll is not installed. Would you still like to block web access anyway? [Y/N]"
fi

read YESNO
while [ "$YESNO" != 'Y' ] && [ "$YESNO" != 'N' ]; do
	echo "Please enter either 'Y' or 'N'"
	read YESNO
done

if [ "$YESNO" = 'Y' ]; then
	WEB_DIRS=$(ls -d /var/www/html/*/)

	read -r -d '' BLOCK_STRING <<- EOM
		<Directory "$web_dir">
		deny from all
		allow from localhost
		</Directory>
	EOM

	echo "Would you like to:"
	echo "A) Default Config (block all but ganglia and roll-documentation)"
	echo "B) Block All"
	echo "C) Select manually"

        read YESNO
        while [ "$YESNO" != 'A' ] && [ "$YESNO" != 'B' ] && [ "$YESNO" != 'C' ]; do
            echo "Please enter either 'A', 'B' or 'C'"
            read YESNO

	for webdir in $WEB_DIRS; do 
		
		
	if grep -q "$BLOCK_ACCESS" /etc/httpd/conf/httpd.conf; then
		
	#TODO: Left off here. 
COMMENT


#Ganglia web setup -->
if [[ x`rocks list roll` == *'ganglia'* ]] 
then
	echo "The ganglia roll is installed. Would you like set ganglia as this cluster's home page? [Y/N]"
else 
	echo "The ganglia roll is installed. Would you still like set ganglia as this cluster's home page? [Y/N]"
fi

read YESNO
while [ "$YESNO" != 'Y' ] && [ "$YESNO" != 'N' ]; do
	echo "Please enter either 'Y' or 'N'"
	read YESNO
done

cat > /var/www/html/index.html <<- EOM
<html>
<head>
<meta HTTP-Equiv="Refresh" CONTENT="1; URL=/ganglia/">
<meta HTTP-EQUIV="expires" CONTENT="Wed, 20 Feb 2000 08:30:00 GMT">
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<head>
<html>
EOM

if [ "$YESNO" != 'Y' ]; then 
	rm -f /var/www/html/index.html

service httpd restart


