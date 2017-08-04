# FastChecker
Bash script to identify fast the security level of networks and web applications against well known vulnerabilities.

With the usage of the Nmap script engine, hping3, sslscan tool and wafw00f the script performs the following checks:

<ul>
  <li>Check for Poodle vulnerability</li>
  <li>Check for Heartbleed vulnerability</li>
	<li>SSL scan</li> 
	<li>Check for anonymous FTP connections</li>
	<li>Check for Shellshock Vulnerability</li>
  <li>Check for Slowloris Vulnerability</li>
	<li>Check HTTP methods</li>
	<li>Check timestamps</li>
	<li>Check webserver information</li>
	<li>Check Strict-Transport-Security</li>
	<li>Banner grabbing</li>
	<li>Viewing all DNS records</li>
	<li>Check DNS Server hostname.bind Map Hostname Disclosure</li>
	<li>Check DNS Server BIND version Directive Remote Version Disclosure</li>
	<li>Check DNS Transfer Zone</li>
	<li>WAF detection</li>
</ul>


#References:
https://nmap.org/book/nse.html








