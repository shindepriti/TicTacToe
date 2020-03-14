#!/bin/bash -x
echo "****WEL-COME TO TIC TAC TOE GAME****"
declare -a board
board=(1 2 3 4 5 6 7 8 9)

#variable
count=0

#constant
MAX_CELL=9

function displayBoard(){
	echo "-----------"
	for ((i=0;i<9;i=i+3))
	do
		echo " ${board[$i]} | ${board[$i+1]} | ${board[$i+2]}"
		echo "-----------"
	done
}

function assignSymbol(){
	if [[ $((RANDOM%2)) -eq 1 ]]
	then	
		player="user"
		user="x"
		computer="o"
	else
		player="computer"
		computer="x"
		user="o"
	fi
}

function switchPlayer(){
	if [[ $player == "user" ]]
	then
		userPlay
	else
		computerPlay
	fi
}

#function to check winning condition for Row Column and Diagonal
function rowColumnDiagonalWin() {
   diagonal=0
   column=0
   for((row=0;row<9;row=row+3))
   do
      if [[ ${board[$row]} == ${board[$row+1]} && ${board[$row+1]} == ${board[$row+2]} ]] ||
         [[ ${board[$column]} == ${board[$column+3]} && ${board[$column+3]} ==  ${board[$column+6]} ]] || 
         [[ ${board[$diagonal]} == ${board[$diagonal+4]} && ${board[$diagonal+4]} == ${board[$diagonal+8]} ]] ||
         [[ ${board[$diagonal+2]} == ${board[$diagonal+4]} && ${board[$diagonal+4]} == ${board[$diagonal+6]} ]]
      then  
         echo "$player Win"
         exit
      fi
      column=$((column+1))
   done
}


function winBlockCondition(){
	local symbol=$1
	if [ $flag -eq 0 ]
	then 
		computerRowWin $symbol
	fi
	if [ $flag -eq 0 ]
	then
		computerColumnWin $symbol
	fi
	if [ $flag -eq 0 ]
	then
		computerDiagonalWin $symbol
	fi
}

function computerColumnWin(){
	local symbol=$1
	for((column=0;column<9;column=column+1))
	do
		if [[ ${board[$column]} == $symbol && ${board[$column+3]} == $symbol && ${board[$column+6]} == $((column+7)) ]]
		then
			board[$column+6]=$computer
			checkConditions
		elif [[ ${board[$column]} == $symbol && ${board[$column+6]} == $symbol && ${board[$column+3]} == $((column+4)) ]]
		then
			board[$column+3]=$computer
			checkConditions
		elif [[ ${board[$column+3]} == $symbol && ${board[$column+6]} == $symbol && ${board[$column]} == $((column+1)) ]]
		then
			board[$column]=$computer
			checkConditions
		fi
	done
}

function computerRowWin(){
	local symbol=$1
	for((row=0;row<9;row=row+3))
	do
   		if [[ ${board[$row]} == $symbol && ${board[$row+1]} == $symbol && ${board[$row+2]} == $((row+3)) ]]
   		then
			board[$row+2]=$computer
			checkConditions
   		elif [[ ${board[$row]} == $symbol && ${board[$row+2]} == $symbol && ${board[$row+1]} == $((row+2)) ]]
			then
        		board[$row+1]=$computer
			checkConditions
   		elif [[ ${board[$row+1]} == $symbol && ${board[$row+2]} == $symbol && ${board[$row]} == $((row+1)) ]]
   		then
        		board[$row]=$computer
        		checkConditions
   		fi
	done
}

function computerDiagonalWin(){
	local symbol=$1
	diagonal=0
	if [[ ${board[$diagonal+2]} == $symbol && ${board[$diagonal+4]} == $symbol && ${board[$diagonal+6]} == $((diagonal+7)) ]]
	then
     		board[$diagonal+6]=$computer
		checkConditions
   	elif [[ ${board[$diagonal+2]} == $symbol && ${board[$diagonal+6]} == $symbol && ${board[$diagonal+4]} == $((diagonal+5)) ]]
   	then
		board[$diagonal+4]=$computer
		checkConditions
   	elif [[ ${board[$diagonal+4]} == $symbol && ${board[$diagonal+6]} == $symbol && ${board[$diagonal+2]} == $((diagonal+3)) ]]
   	then
		board[$diagonal+2]=$computer
		checkConditions
   	elif [[ ${board[$diagonal]} == $symbol && ${board[$diagonal+4]} == $symbol && ${board[$diagonal+8]} == $((diagonal+9)) ]]
   	then
		board[$diagonal+8]=$computer
		checkConditions
   	elif [[ ${board[$diagonal]} == $symbol && ${board[$diagonal+8]} == $symbol && ${board[$diagonal+4]} == $((diagonal+5)) ]]
   	then
		board[$diagonal+4]=$computer
		checkConditions
   	elif [[ ${board[$diagonal+4]} == $symbol && ${board[$diagonal+8]} == $symbol && ${board[$diagonal]} == $((diagonal+1)) ]]
   	then
		board[$diagonal]=$computer
		checkConditions
   	fi
}

function checkCorner(){
	for((i=0;i<9;i=i+6))
	do
		if [[ ${board[$i]} == $((i+1)) ]]
		then
			board[$i]=$computer
			checkConditions
			break
		elif [[ ${board[$i+2]} == $((i+3)) ]]
		then
			board[$i+2]=$computer
			checkConditions
			break
		fi
	done
}

function checkCenter(){
	i=0
	if [[ ${board[$i+4]} -eq $((i+5)) ]]
	then
		board[$i+4]=$computer
		checkConditions
	fi
}

function checkSides() {
	for((i=0;i<8;i=i+2))
	do
		if [[ ${board[$i]} -eq $((i+1)) ]]
		then
			board[$i]=$computer
			checkConditions
		fi
	done
}

function checkConditions(){
	displayBoard
	flag=1
	((count++))
}

function userPlay(){
	if [[ $count -lt $MAX_CELL ]]
	then
		read -p "Enter Number Between 1 to 9:" position
		if [[ ${board[$position-1]} -eq $position ]]
		then
			board[$position-1]=$user	
			((count++))
			displayBoard
			rowColumnDiagonalWin
		else
			echo "Invalid Cell"
			userPlay
		fi
		computerPlay
	else
		echo "Game tie !!"
		exit
	fi
}

function computerPlay(){
	flag=0
	if [[ $count -lt $MAX_CELL ]]
	then
		echo "computer play" 
		winBlockCondition $computer 
		winBlockCondition $user 
		if [ $flag -eq 0 ]
		then
			checkCorner
		fi
		if [ $flag -eq 0 ]
		then
			checkCenter
		fi
		if [ $flag -eq 0 ]
		then
			checkSides
		fi
		rowColumnDiagonalWin
		userPlay
	else
		echo "Game tie !!"
		exit
	fi
}

displayBoard
assignSymbol
switchPlayer
