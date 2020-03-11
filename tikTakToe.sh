
#!/bin/bash -x
echo "****WEL-COME TO TIC TAC TOE GAME****"
declare -a board
board=(1 2 3 4 5 6 7 8 9)

#variable
count=0

#constatnt
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
		rowWinBlock $1
	fi
	if [ $flag -eq 0 ]
	then
		columnWinBlock $1
	fi
	if [ $flag -eq 0 ]
	then
		diagonalWinBlock $1
	fi
}

computerCondition(){
	displayBoard
	flag=1
	((count++))
}

function columnWinBlock(){
	local symbol=$1
	for((i=0;i<9;i=i+1))
	do
		if [[ ${board[$i]} == $symbol && ${board[$i+3]} == $symbol && ${board[$i+6]} == $((i+7)) ]]
		then
			board[$i+6]=$computer
			computerCondition
		elif [[ ${board[$i]} == $symbol && ${board[$i+6]} == $symbol && ${board[$i+3]} == $((i+4)) ]]
		then
			board[$i+3]=$computer
			computerCondition
		elif [[ ${board[$i+3]} == $symbol && ${board[$i+6]} == $symbol && ${board[$i]} == $((i+1)) ]]
		then
			board[$i]=$computer
			computerCondition
		fi
	done
}

function rowWinBlock(){
	local symbol=$1
	for((i=0;i<9;i=i+3))
	do
   		if [[ ${board[$i]} == $symbol && ${board[$i+1]} == $symbol && ${board[$i+2]} == $((i+3)) ]]
   		then
      			board[$i+2]=$computer
     			computerCondition
   		elif [[ ${board[$i]} == $symbol && ${board[$i+2]} == $symbol && ${board[$i+1]} == $((i+2)) ]]
   		then
      			board[$i+1]=$computer
      			computerCondition
   		elif [[ ${board[$i+1]} == $symbol && ${board[$i+2]} == $symbol && ${board[$i]} == $((i+1)) ]]
   		then
      			board[$i]=$computer
      			computerCondition
   		fi
	done
}

function diagonalWinBlock(){
	local symbol=$1
	i=0
   	if [[ ${board[$i+2]} == $symbol && ${board[$i+4]} == $symbol && ${board[$i+6]} == $((i+7)) ]]
  	then
     		board[$i+6]=$computer
		computerCondition
  	elif [[ ${board[$i+2]} == $symbol && ${board[$i+6]} == $symbol && ${board[$i+4]} == $((i+5)) ]]
   	then
     	 	board[$i+4]=$computer
      	 	computerCondition
   	elif [[ ${board[$i+4]} == $symbol && ${board[$i+6]} == $symbol && ${board[$i+2]} == $((i+3)) ]]
   	then
     	 	board[$i+2]=$computer
      		computerCondition
   	elif [[ ${board[$i]} == $symbol && ${board[$i+4]} == $symbol && ${board[$i+8]} == $((i+9)) ]]
   	then
      		board[$i+8]=$computer
      		computerCondition
   	elif [[ ${board[$i]} == $symbol && ${board[$i+8]} == $symbol && ${board[$i+4]} == $((i+5)) ]]
   	then
      		board[$i+4]=$computer
      		computerCondition
   	elif [[ ${board[$i+4]} == $symbol && ${board[$i+8]} == $symbol && ${board[$i]} == $((i+1)) ]]
   	then
      		board[$i]=$computer
      		computerCondition
   	fi
}

function userPlay(){
	read -p "Enter Number Between 1 to 9:" position
	if [[ ${board[$position-1]} -eq $position ]]
	then
		board[$position-1]=$user	
		((count++))
		displayBoard
		rowColumnDiagonalWin
	else
		echo "Cell already occupied !"
		userPlay
	fi
	computerPlay
}

function computerPlay(){
	flag=0
	computerWinCondition $computer
	computerWinCondition $user
	if [[ $flag -eq 0 ]]
	then
		randomVariable=$((RANDOM%9+1))
		echo "Random Number From Computer :$randomVariable"
		if [[ ${board[randomVariable-1]} -eq $randomVariable ]]
		then
			board[$randomVariable-1]=$computer
			((count++))
			displayBoard
		else
			echo "cell already occupied !"
			computerPlay
		fi
	fi
	rowColumnDiagonalWin
	userPlay
}

function checkValidCell(){
	displayBoard
	assignSymbol
	while  [[ $count -lt $MAXCELL ]]
	do
		switchPlayer
	done
	if [[ $count -eq $MAXCELL ]]
	then
		echo "Tie game"
	fi
}
checkValidCell
