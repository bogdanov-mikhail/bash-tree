#!/bin/bash
export LANG=en_US.UTF-8
name=$1
if [[ $name == "" ]]
then
name="."
fi
input=($name/*)
sticks=0
spaces=0
space="\u0020\u0020\u0020\u0020"
stick="\u2502\u00A0\u00A0\u0020"
eagle="\u2514\u2500\u2500\u0020"
stpip="\u251c\u2500\u2500\u0020"
alldirandfile=0
allfile=0
echo $name
tree() {
	local dir=($@)
	local dir_count=${#dir[@]}
	local i
	local j
	for ((i=0; i < $dir_count; i++))
	do
		local subdir=(${dir[$i]}/*)
		if [ -f ${dir[$i]} ]
		then
			allfile=$(($allfile + 1))
		else
			alldirandfile=$(($alldirandfile + 1))
		fi
		for ((j=0; j < $sticks; j++))
		do
			printf ${stick}
		done
		for ((j=0; j < $spaces; j++ ))
		do
			printf ${space}
		done
		if (($i == $(($dir_count - 1))))
		then
			printf "\u2514\u2500\u2500\u0020${dir[$i]##*/}\n"
		else
			printf "\u251c\u2500\u2500\u0020${dir[$i]##*/}\n"
		fi
		if [[ "${subdir[0]}" != "${dir[$i]}/*" ]]
		then
			if (($i == $(($dir_count - 1))))
			then
				spaces=$(($spaces + 1))
			else
				sticks=$(($sticks + 1))
			fi
			tree ${subdir[@]}
		fi
	done
	if (($spaces > 0))
	then
		spaces=$(($spaces - 1))
	else
		sticks=$(($sticks - 1))
	fi
}

tree ${input[@]}

printf "\n"
if (($alldirandfile == 1 && $allfile == 1)) 
then
	echo "$alldirandfile directory, $allfile file"
elif (($alldirandfile == 1 && $allfile != 1)) 
then
	echo "$alldirandfile directory, $allfile files"
elif (($alldirandfile != 1 && $allfile == 1)) 
then
	echo "$alldirandfile directories, $allfile file"
else
	echo "$alldirandfile directories, $allfile files"
fi
