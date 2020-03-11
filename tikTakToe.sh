#!/bin/bash -x
echo "Wel-Come To Tic-Tac-Toe game"

declare -a board
board=(1 2 3 4 5 6 7 8 9)

#variable
count=0

#CONSTANT
MAXCELL=9

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
         echo "player $player Win"
         exit
      fi
      j=$((j+1))
   done
}

function userPlay(){
	if [[ $count -ne $MAXCELL ]]
	then
		read -p "Enter Number Between 1 to 9:" position
		if [[ ${board[$position-1]} -eq $position ]]
		then
			board[$position-1]=$user	
			((count++))
			displayBoard
			rowColumnDiagonalWin
		else
			echo "invalid cell !"
			userPlay
		fi
		computerPlay
	else
		echo "Game tie"
		exit
	fi
}

function computerPlay(){
	if [[ $count -ne $MAXCELL ]]
	then
		randomVariable=$((RANDOM%9+1))
		echo "Random Number From Computer :$randomVariable"
		if [[ ${board[randomVariable-1]} -eq $randomVariable ]]
		then
			board[$randomVariable-1]=$computer
   		((count++))
   		displayBoard
			rowColumnDiagonalWin
		else
			echo "invalid Cell !"
   		computerPlay
		fi
		userPlay
	else
		echo "Game Tie"
		exit
	fi
}

displayBoard
assignSymbol
switchPlayer
