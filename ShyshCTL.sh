#!/bin/bash

#colors 
# 31 RED   32 GREEN   33 YELLOW   34 BLUE   35 MAGENTA   36 CYAN   37 GRAY
# 0 NORMAL  1 BOLD  2 DIM  3 ITALIC  4 UNDERLINED  5 BLINKING   6 INVERTED   7 HIDDEN
# bgcolor  40 BLACK  41 RED  42 GREEN  43 YELLOW  44 BLUE  45 MAGENTA  46 CYAN  47 GRAY  49 Default
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
BLUE='\e[34m'
MAGENTA='\e[35m'
CYAN='\e[36m'
GRAY='\e[37m'
WHITE='\e[0;37m'

function download()
{
	echo -e "${RED}TGPT not found !!\n${GREEN}Run install.sh${WHITE}"
	exit 1
}

function usage()
{
	echo -e "${RED}Run with root privileges${WHITE}"
	exit 1
}

if [[ $EUID -ne 0 ]] ; then
	usage
fi

ls /usr/bin | grep tgpt 2>/dev/null 1>&2
if [[ $? -ne 0 ]] ; then
	download
fi


myarray=()
arrind=0
j=1

TYPES_ALL=$(sysctl -a | awk -F '.' '{print $1}' | uniq | sort)

echo -e "Types of Kernel Params On the Current System.. : "

for i in $TYPES_ALL; do
	echo -ne "${YELLOW}$j. ${GREEN}$i  ${WHITE}"
	((j++))
	myarray+=($i)
done
echo -e "\n\n\n"

arrlen=${#myarray[@]}
S=${CYAN}${myarray[@]}${WHITE}
S=$( echo $S | sed 's/ / \/ /g')

function errorfunc()
{
	echo -e "\n${RED}Either query was invalid or the parameter not found !! ${WHITE}\n\n"
	return
}

function process()
{
	G='^'$1
	RESULT=${YELLOW}$(sysctl -a 2>/dev/null| grep -e $G 2>/dev/null)${WHITE}
	RET=$?
	
	if [[ $RET -ne 0 ]]; then
		errorfunc
		return 
	fi
	echo -e "$RESULT" | nl

	while true ; do
		num=0
		X="\n${CYAN}Enter Number to get info about (0 to ret || Enter for MainMenu): ${WHITE}"
		read -p "$(echo -e $X)" num

		if [[ $num -eq 0 ]];then
			return
		fi

		MAX_NUM=$(sysctl -a 2>/dev/null | grep -e $G  | nl | awk -F '\t' '{print $1}' | tail -n 1 | sed 's/ //g')


		if [[ $num -gt $MAX_NUM ]];then
			echo -e "${RED}Invalid Index Encountered !!${WHITE}"
			continue
		fi


		QUERY='what is '$(sysctl -a | grep -e $G | nl | awk '$0 ~ /\<'$num'\>/ {print $2}' | uniq)' in linux sysctl'

		tgpt "$QUERY" 2>/dev/null
		return
	done
}

while true ; do
	read -p "PARAMS: [[ $(echo -ne $S) ]] (0/q to quit)$(echo -e "\nEnter Option: ")" option

	case $option in
		q|0|exit|quit)
	 		echo -e "${GREEN}Thank You !!${WHITE}"
	 		exit 0
			;;
		*)
			;;
	esac
	
	if [[ ! $option ]] ;then
		continue
	fi

	process $option
done
