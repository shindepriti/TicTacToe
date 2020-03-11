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
   k=0
   j=0
   for((i=0;i<9;i=i+3))
   do
      if [[ ${board[$i]} == ${board[$i+1]} && ${board[$i+1]} == ${board[$i+2]} ]] ||
         [[ ${board[$j]} == ${board[$j+3]} && ${board[$j+3]} ==  ${board[$j+6]} ]] || 
         [[ ${board[$k]} == ${board[$k+4]} && ${board[$k+4]} == ${board[$k+8]} ]] ||
         [[ ${board[$k+2]} == ${board[$k+4]} && ${board[$k+4]} == ${board[$k+6]} ]]
      then  
         echo "$player Win"
         exit
      fi
      j=$((j+1))
   done
}


function computerWinCondition(){
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
	for((i=0;i<9;i=i+1))
	do
		if [[ ${board[$i]} == $symbol && ${board[$i+3]} == $symbol && ${board[$i+6]} == $((i+7)) ]]
		then
			board[$i+6]=$computer
			checkConditions
		elif [[ ${board[$i]} == $symbol && ${board[$i+6]} == $symbol && ${board[$i+3]} == $((i+4)) ]]
		then
			board[$i+3]=$computer
			checkConditions
		elif [[ ${board[$i+3]} == $symbol && ${board[$i+6]} == $symbol && ${board[$i]} == $((i+1)) ]]
		then
			board[$i]=$computer
			checkConditions
		fi
	done
}

function computerRowWin(){
	local symbol=$1
	for((i=0;i<9;i=i+3))
	do
   		if [[ ${board[$i]} == $symbol && ${board[$i+1]} == $symbol && ${board[$i+2]} == $((i+3)) ]]
   		then
			board[$i+2]=$computer
			checkConditions
   		elif [[ ${board[$i]} == $symbol && ${board[$i+2]} == $symbol && ${board[$i+1]} == $((i+2)) ]]
		then
        		board[$i+1]=$computer
			checkConditions
   		elif [[ ${board[$i+1]} == $symbol && ${board[$i+2]} == $symbol && ${board[$i]} == $((i+1)) ]]
   		then
        		board[$i]=$computer
        		checkConditions
   		fi
	done
}

function computerDiagonalWin(){
	local symbol=$1
	i=0
	if [[ ${board[$i+2]} == $symbol && ${board[$i+4]} == $symbol && ${board[$i+6]} == $((i+7)) ]]
	then
     		board[$i+6]=$computer
		checkConditions
   	elif [[ ${board[$i+2]} == $symbol && ${board[$i+6]} == $symbol && ${board[$i+4]} == $((i+5)) ]]
   	then
		board[$i+4]=$computer
		checkConditions
   	elif [[ ${board[$i+4]} == $symbol && ${board[$i+6]} == $symbol && ${board[$i+2]} == $((i+3)) ]]
   	then
		board[$i+2]=$computer
		checkConditions
   	elif [[ ${board[$i]} == $symbol && ${board[$i+4]} == $symbol && ${board[$i+8]} == $((i+9)) ]]
   	then
		board[$i+8]=$computer
		checkConditions
   	elif [[ ${board[$i]} == $symbol && ${board[$i+8]} == $symbol && ${board[$i+4]} == $((i+5)) ]]
   	then
		board[$i+4]=$computer
		checkConditions
   	elif [[ ${board[$i+4]} == $symbol && ${board[$i+8]} == $symbol && ${board[$i]} == $((i+1)) ]]
   	then
		board[$i]=$computer
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
		computerWinCondition $computer 
		computerWinCondition $user 
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
