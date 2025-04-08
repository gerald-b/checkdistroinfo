#!/bin/bash

TMD=/tmp/distro.md

echo -e "# DISTRO Information" > ${TMD}
echo -e "## Kernel Version" >> ${TMD}
echo -e "\`\`\`" >> ${TMD}
uname -r >> ${TMD}
echo -e "\`\`\`" >> ${TMD}

echo -e "## LSB Release info" >> ${TMD}
echo -e "\`\`\`" >> ${TMD}
lsb_release -a 2>/dev/null >> ${TMD}
echo -e "\`\`\`" >> ${TMD}

echo -e "## Package Information" >> ${TMD}
if [ "$(whereis apt | grep -i /bin/apt | wc -l)" -eq "1" ]; then
	echo -e "\`\`\`" >> ${TMD}
	echo -e "Packagemanager:\tapt" >> ${TMD}
	echo -ne "Packagecount:\t" >> ${TMD}
	apt list --installed | wc -l 2>/dev/null >> ${TMD}
	echo -e "\`\`\`" >> ${TMD}
fi
# arch / pacman
# pacman -Qq | wc -l

# Fedora
# dnf list installed | wc -l


echo -e "## Programm Information" >> ${TMD}
echo -e "|program|state|" >> ${TMD}
echo -e "| ------------- |:-------------:|" >> ${TMD}

echo -ne "| pipewire |" >> ${TMD}
if [ "$(whereis pipewire | grep -i /bin/pipewire | wc -l)" -eq "1" ]; then
	echo -ne "**installed**" >> ${TMD}
else
	echo -ne "missing" >> ${TMD}
fi
echo -e "|" >> ${TMD}

echo -ne "| flatpak |" >> ${TMD}
if [ "$(whereis flatpak | grep -i /bin/flatpak | wc -l)" -eq "1" ]; then
	echo -ne "**installed**" >> ${TMD}
else
	echo -ne "missing" >> ${TMD}
fi
echo -e "|" >> ${TMD}

echo -ne "| snap |" >> ${TMD}
if [ "$(whereis snap | grep -i /bin/snap | wc -l)" -eq "1" ]; then
	echo -ne "**installed**" >> ${TMD}
else
	echo -ne "missing" >> ${TMD}
fi
echo -e "|" >> ${TMD}

# flatpak list



echo -e "## Enviroment" >> ${TMD}
echo -e "|varialbe            | value               |" >> ${TMD}
echo -e "| ------------------ |:-------------------:|" >> ${TMD}
echo -e "| \$XDG_SESSION_TYPE | ${XDG_SESSION_TYPE} |" >> ${TMD}
echo -e "| \$SHELL            | ${SHELL}            |" >> ${TMD}


echo -e "<details>" >> ${TMD}
echo -e "  <summary>Show full enviroment variable list</summary>" >> ${TMD}
echo -ne "\n" >> ${TMD}
echo -e "\`\`\`" >> ${TMD}
printenv >> ${TMD}
echo -e "\`\`\`" >> ${TMD}
echo -e "</details>\n" >> ${TMD}


## FSTYPE
#lsblk -fo NAME,FSTYPE,UUID

## CPU Model
#grep -i "model name" /proc/cpuinfo | sort -u | cut -d':' -f2

## Cores
#grep -i "processor" /proc/cpuinfo | wc -l


## Memory / Swap
#echo -e "$(grep -i "memtotal" /proc/meminfo | cut -d':' -f2 | grep -o '[^[:space:]].*[^[:space:]]' | cut -d' ' -f1) KB"

#echo -e "$(( $(grep -i "memtotal" /proc/meminfo | cut -d':' -f2 | grep -o '[^[:space:]].*[^[:space:]]' | cut -d' ' -f1) / 1024)) MB"

#echo -e "$(grep -i "swaptotal" /proc/meminfo | cut -d':' -f2 | grep -o '[^[:space:]].*[^[:space:]]' | cut -d' ' -f1) KB"
#echo $(grep -i "swaptotal" /proc/meminfo | cut -d':' -f2 | grep -o '[^[:space:]].*[^[:space:]]' | cut -d' ' -f1) | awk '{printf "%20.2f KB\n", ($1)}'
#echo -e "$(( $(grep -i "swaptotal" /proc/meminfo | cut -d':' -f2 | grep -o '[^[:space:]].*[^[:space:]]' | cut -d' ' -f1) / 1024)) MB"
#echo $(grep -i "swaptotal" /proc/meminfo | cut -d':' -f2 | grep -o '[^[:space:]].*[^[:space:]]' | cut -d' ' -f1) | awk '{printf "%20.2f MB\n", ($1/1024)}'
#echo $(grep -i "swaptotal" /proc/meminfo | cut -d':' -f2 | grep -o '[^[:space:]].*[^[:space:]]' | cut -d' ' -f1) | awk '{printf "%20.2f GB\n", ($1/1024/1024)}'


echo -e "# EOF" >> ${TMD}
