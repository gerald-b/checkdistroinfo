#!/bin/bash

TMD=/tmp/distro.md
AUTHOR="Gerald Büchler"

main()
{
    touch ${TMD}
    rm ${TMD}
    pandoc_head
    echo -e "# DISTRO Information (Hostname: $(uname -n))" >> ${TMD}
	kernelinfo
	lsbinfo
	packageinfo
	programminfo
	listflatpak
	listsnap
	enviroment_vars
    filesystem_info
    cpuinfo
	echo -e "# EOF" >> ${TMD}
}

pandoc_head()
{
    echo -e "---" >> ${TMD}
    echo -e "title: DISTRO Information" >> ${TMD}
    echo -e "author: ${AUTHOR}" >> ${TMD}
    # Dateformat: ISO 8601
    echo -e "date: $(date '+%Y-%m-%d %H:%M:%S.%3N')" >> ${TMD}
    echo -e "lang: en" >> ${TMD}
    echo -e "maxwidth: 80%" >> ${TMD}
    echo -e "---" >> ${TMD}
}

kernelinfo()
{
	echo -e "## Kernel Version" >> ${TMD}
	echo -e "\`\`\`" >> ${TMD}
	uname -r >> ${TMD}
	echo -e "\`\`\`" >> ${TMD}
}

lsbinfo()
{
	echo -e "## LSB Release info" >> ${TMD}
	echo -e "\`\`\`" >> ${TMD}
	lsb_release -a 2>/dev/null >> ${TMD}
	echo -e "\`\`\`" >> ${TMD}
}

packageinfo()
{
	echo -e "## Package Information" >> ${TMD}
	if [ "$(whereis apt | grep -i /bin/apt | wc -l)" -eq "1" ]; then
		echo -e "\`\`\`" >> ${TMD}
		echo -e "Packagemanager:\tapt" >> ${TMD}
		echo -ne "Packagecount:\t" >> ${TMD}
		apt list --installed | wc -l 2>/dev/null >> ${TMD}
		echo -e "\`\`\`" >> ${TMD}
	fi

    ### TODO
	# arch / pacman
	# pacman -Qq | wc -l
	
    ### TODO
	# Fedora
	# dnf list installed | wc -l
}

programminfo()
{
	echo -e "## Programm Information" >> ${TMD}
	echo -e "|program|state|" >> ${TMD}
	echo -e "| ------------- |:-------------:|" >> ${TMD}
	
	search4pgm=pipewire
	programmdetails
	search4pgm=flatpak
	programmdetails
	search4pgm=snap
	programmdetails

}

programmdetails()
{
	echo -ne "| ${search4pgm} |" >> ${TMD}
	if [ "$(whereis ${search4pgm} | grep -i /bin/${search4pgm} | wc -l)" -eq "1" ]; then
		echo -ne "**installed**" >> ${TMD}
	else
		echo -ne "missing" >> ${TMD}
	fi
	echo -e "|" >> ${TMD}
}

listflatpak()
{
	if [ "$(whereis flatpak | grep -i /bin/flatpak | wc -l)" -eq "1" ]; then
		echo -e "## Flatpak installed packages" >> ${TMD}
        echo -e "|Name|Anwendungskennung|Version|Zweig|Ursprung|Installation|" >> ${TMD}
        echo -e "| ------------- | ------------- | ------------- | ------------- | ------------- | ------------- |" >> ${TMD}
		flatpak list | sed 's/./|&/' | sed 's/\t/|/g' | sed 's/$/|/' >> ${TMD}
	fi
}

listsnap()
{
	if [ "$(whereis snap | grep -i /bin/snap | wc -l)" -eq "1" ]; then
		echo -e "## Snap installed packages" >> ${TMD}
		echo -e "\`\`\`" >> ${TMD}
		snap list >> ${TMD}
		echo -e "\`\`\`" >> ${TMD}
	fi
}

enviroment_vars()
{
	echo -e "## Enviroment" >> ${TMD}
	echo -e "|varialbe            | value               |" >> ${TMD}
	echo -e "| ------------------ |:-------------------:|" >> ${TMD}
	echo -e "| \$XDG_SESSION_TYPE | ${XDG_SESSION_TYPE} |" >> ${TMD}
	echo -e "| \$SHELL            | ${SHELL}            |" >> ${TMD}
	echo -e "\n" >> ${TMD}
	echo -e "<details>" >> ${TMD}
	echo -e "  <summary>Show full enviroment variable list</summary>" >> ${TMD}
	echo -ne "\n" >> ${TMD}
	echo -e "\`\`\`" >> ${TMD}
	printenv | sort >> ${TMD}
	echo -e "\`\`\`" >> ${TMD}
	echo -e "</details>\n" >> ${TMD}
}

filesystem_info()
{
    echo -e "## Blockdevice and Diskspace Information" >> ${TMD}
    echo -e "\`\`\`" >> ${TMD}
    lsblk -fo NAME,FSTYPE,UUID >> ${TMD}
    echo -e "\`\`\`" >> ${TMD}

    echo -e "\`\`\`" >> ${TMD}
    df -h | grep -v tmpfs >> ${TMD}
    echo -e "\`\`\`" >> ${TMD}
}

cpuinfo()
{
    echo -e "## CPU Information" >> ${TMD}
    echo -e "\`\`\`" >> ${TMD}
    echo -ne "Model:\t\t" >> ${TMD}
    grep -i "model name" /proc/cpuinfo | sort -u | cut -d':' -f2 | grep -o '[^[:space:]].*[^[:space:]]' >> ${TMD}
    echo -ne "Cores:\t\t" >> ${TMD}
    grep -i "cpu cores" /proc/cpuinfo | sort -u | cut -d':' -f2 | cut -d' ' -f2 >> ${TMD}
    echo -ne "Threads:\t" >> ${TMD}
    grep -i "processor" /proc/cpuinfo | wc -l >> ${TMD}
    echo -ne "Architecture:\t" >> ${TMD}
    uname -p>> ${TMD}
    echo -e "\`\`\`" >> ${TMD}
}

main

exit 0


##### TODO

## Memory / Swap
#echo -e "$(grep -i "memtotal" /proc/meminfo | cut -d':' -f2 | grep -o '[^[:space:]].*[^[:space:]]' | cut -d' ' -f1) KB"

#echo -e "$(( $(grep -i "memtotal" /proc/meminfo | cut -d':' -f2 | grep -o '[^[:space:]].*[^[:space:]]' | cut -d' ' -f1) / 1024)) MB"

#echo -e "$(grep -i "swaptotal" /proc/meminfo | cut -d':' -f2 | grep -o '[^[:space:]].*[^[:space:]]' | cut -d' ' -f1) KB"
#echo $(grep -i "swaptotal" /proc/meminfo | cut -d':' -f2 | grep -o '[^[:space:]].*[^[:space:]]' | cut -d' ' -f1) | awk '{printf "%20.2f KB\n", ($1)}'
#echo -e "$(( $(grep -i "swaptotal" /proc/meminfo | cut -d':' -f2 | grep -o '[^[:space:]].*[^[:space:]]' | cut -d' ' -f1) / 1024)) MB"
#echo $(grep -i "swaptotal" /proc/meminfo | cut -d':' -f2 | grep -o '[^[:space:]].*[^[:space:]]' | cut -d' ' -f1) | awk '{printf "%20.2f MB\n", ($1/1024)}'
#echo $(grep -i "swaptotal" /proc/meminfo | cut -d':' -f2 | grep -o '[^[:space:]].*[^[:space:]]' | cut -d' ' -f1) | awk '{printf "%20.2f GB\n", ($1/1024/1024)}'

##### HINT: PANDOC
# ./pandoc -s /tmp/distro.md -i -t slidy  -o /tmp/distro-slide.html
# ./pandoc -s /tmp/distro.md -o /tmp/distro.html


