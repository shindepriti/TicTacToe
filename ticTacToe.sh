#!/bin/bash -x

#variable
player="O"
computer="O"
isEmptyFlag=0
madeMoveFlag=0
move=0
turn=0
winFlag=0
block=0
echo "Welcome to Tic tac toe"

declare -A board
read -p "Enter Row Do You Want " ROW
read -p "Enter Column Do you Want " COLUMN
matrix=$(($ROW*$COLUMN))
function initializeBoard(){
	for((row=0;row<$ROW;row++))
	do
		for((column=0;column<$COLUMN;column++))
		do
			board[$row,$column]="-"
		done
	done
}


function displayBoard(){
	echo "YOU:"$player
	echo "OPPONENT:"$computer
	for((row=0;row<$ROW;row++))
	do
		echo "  "
		for((column=0;column<$COLUMN;column++))
		do
			echo -n " " ${board[$row,$column]} "|" " " 
		done
		echo -e 	
	done
	echo " "
}

#Assign letter and decide who will play first
function toss(){
	if(( $((RANDOM %2)) == 1 ))
	then
		player="X"
		echo "player will play first"
	else
		computer="X"
		echo "Opponent  will play first"
	fi
}

#check Empty cell
function isEmpty(){
	if [[ ${board[$1,$2]} == "-" ]]
	then
		isEmptyFlag=1
		((move++))
	fi
}

#display Winner 
function displayWinner(){
	local sign=$1
	if [ $winFlag -eq 1 ]
	then
		echo  $sign "winner"
		displayBoard
		exit
	fi
}

# for player  move
function playMove(){
#check  is empty
	isEmpty $1 $2
	if [[ $isEmptyFlag == 1 ]]
	then
		board[$1,$2]=$3
		isEmptyFlag=0
		madeMoveFlag=1
	fi
}


function checkWinner(){
	local sign=$1
	leftDiagonal=0
	rightDiagonal=0

	for((row=0;row<$ROW;row++))
	do
		rowCount=0
		columnCount=0
		for((column=0;column<$COLUMN;column++))
		do
			#row check
			if [[ ${board[$row,$column]} == $sign ]]
			then
				((rowCount++))
			fi
			#col check
			if [[ ${board[$column,$row]} == $sign ]]
			then
				((columnCount++))
			fi
			#leftDiagonal
			if [[ $row -eq $column && ${board[$row,$column]} == $sign ]]
			then	
				((leftDiagonal++))
			fi
			#right Diagonal
			if [[ $(($row + $column)) -eq $(($ROW-1)) && ${board[$row,$column]} == $sign ]]
			then
				((rightDiagonal++))
			fi
			if [[ $rowCount -eq $ROW || $columnCount -eq $COLUMN || $rightDiagonal -eq $ROW || $leftDiagonal -eq $ROW ]]
			then
				winFlag=1
			fi
		done
	done
}


#to play first turn
function playFirst(){
	if [[ $player == "X" ]]
	then
		playerMove
		turn=$computer
	else
		checkCorner
		turn=$player
	fi
	displayBoard
}

# To place sign to board 
function playerMove(){
	madeMoveFlag=0
	while (( $madeMoveFlag == 0 ))
	do
		read -p "provide row no like 0,1,2,3,4,5,6,7,8,9" row
		read -p "provide col no like 0,1,2,3,4,5,6,7,8,9" column
		#check for valid condiation
		if (( $row > $ROW && $column > $COLUMN ))
		then
			echo "Not a valid row or column"
		fi
		playMove $row $column $player
	done
}

#check If computer can win
function  checkForWinAndBlockCondition(){
	local sign=$1
	local rows
	local columns
	block=0
	madeMoveFlag=0
	for (( rows=0; rows<$ROW; rows++ ))
	do
		for (( columns=0; columns<$COLUMN; columns++ ))
		do
			if [[ ${board[$rows,$columns]} == "-" ]]
			then
				board[$rows,$columns]=$sign
				checkWinner $sign
				if [[ $winFlag -eq 1 &&  $sign == $computer ]]
				then
					 displayWinner $sign
				elif [[ $winFlag -eq 1 && $sign == $player ]]
				then
					board[$rows,$columns]=$computer
					block=1
 					((move++))
					winFlag=0
					break
				else
					board[$rows,$columns]="-"
				fi
			fi
		done
		if [ $block -eq 1 ]
		then
			madeMoveFlag=1
			break
		fi
	done
}

#check for tie
function tie(){
	if (( $winFlag != 1 ))
	then
		echo "Tie"
	fi
}

#check for corner move
function checkCorner()
{
	madeMoveFlag=0
	for ((row=0;row<$matrix;row+=$(($ROW-1)) ))
	do
		for((column=0;column<$matrix;column+=$(($COLUMN-1)) ))
		do
			if [ $madeMoveFlag -eq 1 ]
			then
				break	
			fi
			playMove $row $column $computer
		done
		if [ $madeMoveFlag -eq 1 ]
		then
			break 
		fi 
	done

}

#check for side move
function checkSide()
{
	madeMoveFlag=0
	for ((rows=0;rows<$ROW;rows++))
	do
		columns=1;	
		if [ $madeMoveFlag -eq 0 ]
		then
			#echo "one two " $rows $columns
			playMove $rows $columns $computer
		fi

		if [ $madeMoveFlag -eq 0 ]
		then
			#echo "swap " $columns $rows
			playMove  $columns $rows $computer
		fi
	done
}

initializeBoard
toss
playFirst


#start game until all cell is occupied
function main(){
	while (( $move != $matrix ))
	do
		madeMoveFlag=0
		if [[ $turn == $player ]]
		then
			playerMove
			turn=$computer
 			checkWinner $player
			displayWinner $player
		else
			checkForWinAndBlockCondition $computer
			checkForWinAndBlockCondition $player
			if [ $madeMoveFlag -eq 0 ]
			then
				checkCorner
			fi

			if [ $madeMoveFlag -eq 0 ]
			then
				row=$(($(($ROW-1))/2))
				playMove $row $row $computer
			fi

			if [ $madeMoveFlag -eq 0 ]
			then
				checkSide
			fi
			turn=$player
			block=0
			checkWinner $computer
			displayWinner $computer
		fi
		displayBoard
	done

tie
}
main
