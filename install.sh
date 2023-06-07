#!/bin/bash

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


if [[ uname -ne "Linux" ]];then
	echo -e "${RED}Not a linux machine${WHITE}"
	exit 1
fi

echo -e "${YELLOW}Installing TGPT binary${WHITE}"

ls /usr/bin/tgpt 2>/dev/null 1>&2
if [[ "$?" -eq 0 ]];then
	echo -e "${GREEN}TGPT is already installed on the system${WHITE}"
	chmod +x ShyshCTL.sh
	exit 0
fi

curl -sSL https://raw.githubusercontent.com/aandrew-me/tgpt/main/install | bash -s /usr/bin/

chmod +x ShyshCTL.sh

echo -e "\n[+]Linking ShyshCTL.sh to /usr/bin/\n"
sudo ln -s $(pwd)/ShyshCTL.sh /usr/bin/

echo -e "${GREEN}[+]DONE${WHITE}"

