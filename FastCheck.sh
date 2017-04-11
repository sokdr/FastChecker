#!/bin/bash
echo "####################################################################################"
echo "####################################################################################"
echo "######################## ############################# #############################"
echo "--------------------------------FastChecker v1.0.0:---------------------------------"
echo
echo "Nmap [https://nmap.org]  should be isntalled in your linux machine, if not open terminal and type 'sudo apt-get install nmap'"
echo "waf00f also should be installed on your linux machine, if not then type 'pip install wafw00f' to install it "
echo "With waf00f pls use FQDN for better resutls:"
echo "Also the script makes use of hping3 and sslscan tools:"
echo "####################################################################################"
echo
echo "Dear ##$HOSTNAME## Welcome to the Fast VUlnerability Checker v1.0.0:"
echo "======================================================="
echo "I provide you with your public IP address:"
curl -s http://checkip.dyndns.org/ | grep -o "[[:digit:].]\+"
echo "======================================================="
echo
echo -n " Please enter the IP/FQDN you want to check: "
read hostname
echo "OK...now checking the availability of $hostname:"
fping -c1 -t300 $hostname 2>/dev/null 1>/dev/null  #fping to define the timeout in milliseconds
if [ "$?" = 1 ]   								   #1 unreachable 0 reachable
then
	echo "$hostname does not exist run the script again pls:"
	exit 0;
else
	echo "OK moving on to the check-list:"
fi
echo
echo "Here is the list of vulnerabilities and checks you want to search:"
echo 
PS3='Please enter your choice: '
options=("Poodle check" "Heartbleed check" "SSL/TLS check" "ftp-anon" "Shellshock check" "Slowloris check" "HTTP-Methods" "TCP timestamp" "WebServer Information" "Strict-Transport-Security" "Banner grabbing" "DNS Server Check-List" "WAF detection" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Poodle check")
		echo "Searching for Poodle vulnerability:"
		echo
		echo "Poodle scanner start to check hosts:"
		nmap -sS -sV --version-light --script ssl-poodle -p 443 $hostname 
		echo
            ;;
        "Heartbleed check")
		echo "Searching for Heartbleed vulnerability:"
		echo
		echo "Now starting Heartbleed check:"
		nmap -p 443 --script ssl-heartbleed $hostname 
		echo
            ;;
        "SSL/TLS check")
        read -p "Please choose between Nmap or SSLscan $program [nmap sslscan]:" answer #choose nmap or sslscan
		if [[ $answer = nmap ]]; then
				nmap -sS --script ssl-enum-ciphers -p 443 $hostname 
				echo
       elif [[ $answer = sslscan ]]; then
				sslscan --no-failed $hostname  
				echo
		else echo "wrong try again-:-"
		fi
		echo
            ;;
	"ftp-anon")
		echo "check for anonymous FTP connections:"
		echo
		nmap -sV -sC -p21 $hostname 
		echo
	    ;;
	"Shellshock check")
		echo "check for Shellshock Vulnerability:"
		echo
		nmap -sV -p- --script http-shellshock $hostname 
		echo
	    ;;
	"Slowloris check")
		echo "check for Slowloris Vulnerability:"
		echo
		nmap --script http-slowloris-check $hostname 
		echo
	    ;;
	"HTTP-Methods")
		echo "Check HTTP methods:"
		echo
		nmap -sS -Pn -p 80,443 -script http-methods $hostname 
		echo
		;;
    "TCP timestamp")
		echo "Checking timestamps:"
		echo
		hping3 -S -c 1 -p 443 $hostname --tcp-timestamp
		echo
		;;
	"WebServer Information")
		echo "Checking webserver information:"
		echo
		curl -I -L $hostname 
		echo
		;;
	"Strict-Transport-Security")
		echo "Checking Strict-Transport-Security:"
		echo
		curl -si $hostname | grep "Strict" 
		echo
		;;
	"Banner grabbing")
		echo "Checking banners"
		echo -n "Enter the port you want to check:"
		read port
		echo
		nc $hostname $port 
		echo
		;;
	"DNS Server Check-List")
		echo "Please enter the IP/FQDN you want to check:" #asks again for IP/FQDN
		read dns
		dig $dns ANY +noall +answer   #Viewing all DNS records
 		echo -n "Enter the record you want to check:"
		read record 
		echo
		echo "Checking DNS Server hostname.bind Map Hostname Disclosure:"
		nslookup -q=txt -class=CHAOS hostname.bind $record  #dig $record hostname.bind chaos txt
		echo
		echo "Checking DNS Server BIND version Directive Remote Version Disclosure:"
		nslookup -q=txt -class=CHAOS version.bind $record
		echo
		read -p "Do you want to check DNS Transfer Zone $dnszone [yn]" answer 	#Check if you want to perform DNS transfer zone yes or no
		if [[ $answer = y ]];
			then	
				dig axfr $dns $record
		fi
		echo
			;;
	"WAF detection")
		echo "Check if the targeted hosts are protected by a WAF:"
		echo
		echo "Please note that wafw00f script is used to identify the following WAFs: also pls provide FQDN to test"
		wafw00f -l
		read -p "Do you want to continue $foo? [yn]" answer
		if [[ $answer = y ]];
		then
			wafw00f $hostname -v
		fi
		echo
	    ;;
        "Quit")
            break
            ;;
        *) echo invalid option;;
    esac
done

