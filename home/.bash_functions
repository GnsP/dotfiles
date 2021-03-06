# vim: set filetype=shell
## FUNCTIONS
yolo() {
    curl -s whatthecommit.com/index.txt
}
command_exists() {
    hash $1 2>/dev/null
    return;
}
check_and_run() {
    if command_exists $1; then
        "$@"
    fi
}
check_and_run_bg() {
    if command_exists $1; then
        ( "$@" & )  #parens help it run in subshell so that "Done" msg is not printed
    fi
}
get_fortune_cookies() {
    if command_exists fortune; then 
        echo "Fortune Cookies :";
        if command_exists cowsay; then 
            fortune | cowsay
        else
            fortune
        fi;
    fi;
}

print_date_cal() {
    cal;
    echo -ne "Today is "; date
    if [[ `date +"%d%m"` == 0101 ]]; then       #if [[ `date +"%D"` =~ 01/01* ]];
        echo "Hey man, I forgot"; figlet "Happy New Year"; echo "$USER";
    elif [[ `date +"%d%m"` == 2603 ]]; then
        figlet "Happy Birthday"
    fi;
}
print_system_status() {
    echo -e "Status of $HOSTNAME: " 

    ##### Main Memory #####
    echo -en "\t";
    free -ht | head -3 | tail -n 1 | awk '{printf "Main Memory\t:\t" $3 " used & " $4 " free"}'
    #free --old -ht | head -2 | tail -n 1 | awk '{printf " out of " $2}'; echo "";

    ##### Storage #####
    echo -e "";
    echo -en "\t"; df -h / | tail -n 1 | awk '{print "Root " $1 "\t:\t" $5 " full & " $4 " still available."}' ; 

    ##### IP #####
    echo -en "\tIP Address \t:\t"; /sbin/ifconfig wlp3s0 | awk /'inet / {print $2}' | sed -e s/addr:/''/  || /sbin/ifconfig wlan0 || echo "" #dubious, gotta test

    ##### Uptime #####
    echo -en "\tThe system has been up for ";
    perl -e 'my $uptime = `uptime`; if ($uptime =~ /^\s+\S+\s+up\s+(\S+\s+\S+,\s+\S+),/) { printf $1; } else { print "uptime gave me a weird format!"; }'
    # echo -e "" #echo -ne "Up time:"; uptime | awk /'up/' #`uptime | awk {'print $3 $4'}`
}

welcome_message() {
    # customize this first message with a message of your choice.
    # this will display the username, date, time, a calendar, the amount of users, and the up time.
    # Gotta love ASCII art with figlet
    check_and_run figlet "Welcome, " $USER;
    echo -e "";

    print_date_cal

    print_system_status

    echo "";
    # check_and_run_bg ansiweather;
    get_fortune_cookies
}
welcome_message;

# Speaks a message on ios when a server comes back up
speakwhenup() { [ "$1" ] && PHOST="$1" || return 1; until ping -c1 -W2 $PHOST >/dev/null 2>&1; do sleep 5s; done; say "$PHOST is up" >/dev/null 2>&1; }

# get IP adresses
#function my_ip() # get IP adresses
my_ip () { 
        MY_IP=$(/sbin/ifconfig wlan0 | awk "/inet/ { print $2 } " | sed -e s/addr://)
                #/sbin/ifconfig | awk /'inet addr/ {print $2}' 
        MY_ISP=$(/sbin/ifconfig wlan0 | awk "/P-t-P/ { print $3 } " | sed -e s/P-t-P://)
}

# get current host related info
ii () {
    echo -e "\nYou are logged on ${red}$HOST"
    echo -e "\nAdditionnal information:$NC " ; uname -a
    echo -e "\n${red}Users logged on:$NC " ; w -h
    echo -e "\n${red}Current date :$NC " ; date
    echo -e "\n${red}Machine stats :$NC " ; uptime
    echo -e "\n${red}Memory stats :$NC " ; free
    echo -en "\n${red}Local IP Address :$NC" ; /sbin/ifconfig wlan0 | awk /'inet addr/ {print $2}' | sed -e s/addr:/' '/ 
    #my_ip 2>&. ;
    #my_ip 2>&1 ;
    #echo -e "\n${RED}Local IP Address :$NC" ; echo ${MY_IP:."Not connected"}
    #echo -e "\n${RED}ISP Address :$NC" ; echo ${MY_ISP:."Not connected"}
    #echo -e "\n${RED}Local IP Address :$NC" ; echo ${MY_IP} #:."Not connected"}
    #echo -e "\n${RED}ISP Address :$NC" ; echo ${MY_ISP} #:."Not connected"}
    echo
}


# Easy extract
extract () {
  if [ -f $1 ] ; then
      case $1 in
          *.tar.bz2)   tar xvjf $1    ;;
          *.tar.gz)    tar xvzf $1    ;;
          *.bz2)       bunzip2 $1     ;;
          *.rar)       rar x $1       ;;
          *.gz)        gunzip $1      ;;
          *.tar)       tar xvf $1     ;;
          *.tbz2)      tar xvjf $1    ;;
          *.tgz)       tar xvzf $1    ;;
          *.zip)       unzip $1       ;;
          *.Z)         uncompress $1  ;;
          *.7z)        7z x $1        ;;
          *)           echo "don't know how to extract '$1'..." ;;
      esac
  else
      echo "'$1' is not a valid file!"
  fi
}

upinfo () {
echo -ne "${green}$HOSTNAME ${red}uptime is ${cyan} \t ";uptime | awk /'up/ {print $3,$4,$5,$6,$7,$8,$9,$10}'
}

# Makes directory then moves into it
#function mkcdr {
mkcdr () {
    mkdir -p -v $1
    cd $1
}

function countdown(){
   date1=$((`date +%s` + $1)); 
   while [ "$date1" -ne `date +%s` ]; do 
     echo -ne "$(date -u --date @$((`date +%s` - $date1)) +%H:%M:%S)\r";
   done
}
function stopwatch(){
  date1=`date +%s`; 
   while true; do 
    echo -ne "$(date -u --date @$((`date +%s` - $date1)) +%H:%M:%S)\r"; 
   done
}

function ooo(){
  while :; do clear; echo O_o; sleep 1; clear; echo o_O; sleep 1; done
}

randpw(){
  < /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-128};
  echo;
}

file_ext() {
  # TODO: If not $1; $1 = .
  find $1 -type f -name "*.*" | grep -o -E "\.[^\.]+$" | grep -o -E "[[:alpha:]]{3,6}" | awk '{print tolower($0)}' | sort | uniq -c | sort -n
}

# vim: set ft=shell:
