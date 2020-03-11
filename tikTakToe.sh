#!/bin/bash -x
echo "***Wel-Come To Tik-Tak-Toe game***"

declare -a board
board=(1 2 3 4 5 6 7 8 9)
count=0

MAX_CELL=9

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

function whoPlayFirst(){
	if [ $((RANDOM%2)) -eq 1 ]
	then
		echo "player $player Play first"
	else
		echo "player $player play first" 	
	fi
}
whoPlayFirst

function rowColumnDiagonalWin() {
	k=0
	j=0
	for((i=0;i<9;i=i+3))
	do
		if [[ ${board[$i]} == ${board[$i+1]} && ${board[$i+1]} == ${board[$i+2]} ]] ||
			[[ ${board[$j]} == ${board[$j+3]} && ${board[$j+3]} ==  ${board[$j+6]} ]] 
			[[ ${board[$k]} == ${board[$k+4]} && ${board[$k+4]} == ${board[$k+8]} ]] ||
			[[ ${board[$k+2]} == ${board[$k+4]} && ${board[$k+4]} == ${board[$k+6]} ]]
		then	
			echo "player $player Win"
			exit
		fi
		j=$((j+1))
	done
}


function getValidCell() {
	while [ $count -lt $MAX_CELL ]
	do
		read -p "Enter Number Between 1 to 9 :"  position
		if [ ${board[$position-1]} -eq $position ]
		then
			board[$position-1]=$player
			((count++))
			displayBoard
			rowColumnDiagonalWin
		else
			echo "Invalid Cell!!"
		fi
	done
}
getValidCell


