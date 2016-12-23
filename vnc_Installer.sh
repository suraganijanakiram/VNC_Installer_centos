#!/bin/bash
#Used to install VNC server in Linux CentOS and REDHAT
#NOTE:- use only in the first time fresh installation if already installed it will not work properly.
#Email or comment suggestions and feedback to suraganijanakiram@gmail.com
clear
if [ $(id -u) -eq 0 ]; then
        echo -e "\n\n\t \e[1;32m Make sure the selinux policy is disabled \e[0m"
        echo -e "\n\n\t \e[1;32m Make sure the required repo's are avilable to install the packages \e[0m \n"
        read -p "Please enter the username for vncuser: " u1
        yum groupinstall "Development Tools" "Base" -y > /dev/null
        yum groupinstall "X Window System" "Desktop" -y > /dev/null
        yum install tigervnc-server xorg-x11-fonts-Type1 -y > /dev/null
Body()
{
        p1=$u1@$(id $u1 | awk -F "=" {'print $2'} | awk -F "(" {'print $1'})*
        echo -e "$p1\n$p1\n\n" | runuser -l $u1 -c 'vncpasswd'
        echo -e "VNCSERVERS=\"1:$u1\"\nVNCSERVERARGS[1]=\"-geometry 1280x1024\"" >> /etc/sysconfig/vncservers
        service vncserver restart > /dev/null
        chkconfig vncserver on
        echo -e "\n\n\n\e[0;32mvnc server is installed in the server\e[0m\n\n\n\t\t \e[1;32mVNC username:\e[0m $u1 \n\t\t \e[1;32mVNC passowrd:\e[0m $p1\n\n"
}
case $u1 in

        root)
                Body
        ;;
        *)
                egrep "^$u1" /etc/passwd >/dev/null
                if [ $? -eq 0 ]; then
                        usermod -s /bin/bash $u1
                        Body
                else
                        useradd $u1
                        Body
                fi
        ;;
esac
else
        echo -e "\n \e[1;31m Only root can install VNC and add a VNC user to the system \e[0m \n"
        exit 2
fi
