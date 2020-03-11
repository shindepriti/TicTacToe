#!/bin/bash -x
echo "***Wel-Come To Tik-Tak-Toe game***"

declare -a board
board=(1 2 3 4 5 6 7 8 9)

function displayBoard(){
	echo "-----------"
	for ((i=0;i<9;i=i+3))
	do
		echo " ${board[$i]} | ${board[$i+1]} | ${board[$i+2]}"
		echo "-----------"
	done
}
displayBoard

function assignSymbol(){
	if [ $((RANDOM%2)) -eq 1 ]
	then
		player="x"
	else
		player="o"
	fi
}
assignSymbol
