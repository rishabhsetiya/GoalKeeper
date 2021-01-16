#!/bin/bash

DIRECTION="l"

FIRSTROW=5                              # First row of game area
FIRSTCOL=0                              # First col of game area
LASTCOL=190                             # Last col of game area
LASTROW=50                              # Last row of game area
WALLCHAR="X"                            # Character to use for wall
x=1
y=$LASTROW

SCOREX=192
SCOREY=10
ballx=50
bally=10
BALLDIRX="l"
BALLDIRY="u"
SCORE=0
drawborder() {
   # Draw top
   tput setaf 2
   tput cup $FIRSTROW $FIRSTCOL
   x=$FIRSTCOL
   while [ "$x" -le "$LASTCOL" ];
   do
      printf %b "$WALLCHAR"
      x=$(( $x + 1 ));
   done

   # Draw sides
   x=$FIRSTROW
   while [ "$x" -le "$LASTROW" ];
   do
      tput cup $x $FIRSTCOL; printf %b "$WALLCHAR"
      tput cup $x $LASTCOL; printf %b "$WALLCHAR"
      x=$(( $x + 1 ));
   done

   tput setaf 20
}

move(){	
	if [ $DIRECTION = "l" ] && [ $x -gt 1 ];
		then 	tput cup $y $(($x+5))
			printf %b " "	
			x=$(($x-1))
			tput cup $y $x
			printf %b "$PLAYERCHAR"
	fi
	if [ $DIRECTION = "r" ] && [ $x -lt $(($LASTCOL-6)) ];
		then 	tput cup $y $x
			printf %b " "	
			x=$(($x+1))
			tput cup $y $(($x+5))
			printf %b "$PLAYERCHAR"
	fi	
}

moveball(){
	tput cup $bally $ballx
	printf %b " "	
	if [ $BALLDIRY = "u" ];
		then bally=$(($bally-1))
	else bally=$(($bally+1))
	fi
	if [ $BALLDIRX = "r" ] && [ $(($RANDOM % 2)) = 1 ];
		then ballx=$(($ballx+1))
	elif [ $BALLDIRX = "l" ] && [ $(($RANDOM % 2)) = 1 ];
		then ballx=$(($ballx-1))
	fi
	
	if [ $bally = $(($FIRSTROW+1)) ] && [ $BALLDIRY = "u" ];
		then BALLDIRY="d"
	fi
	
	if [ $bally = $(($LASTROW-1)) ] && [ $BALLDIRY = "d" ] && [ $ballx -ge $(($x-2)) ] && [ $ballx -le $(($x+7)) ];
		then BALLDIRY="u"
		     SCORE=$(($SCORE+50))
		     tput cup $SCOREY $(($SCOREX+7))
		     printf %b "$SCORE"
	elif [ $bally = $(($LASTROW-1)) ] && [ $BALLDIRY = "d" ];
		then
		     tput cup $(( $LASTROW + 1 )) 0
      		     stty echo
      		     echo " GAME OVER! You missed the ball!"
      		     sleep 2
      		     gameover	
	fi
	
	if [ $ballx -le 1 ] && [ $BALLDIRX = "l" ];
		then BALLDIRX="r"
	fi
	
	if [ $ballx -ge $(($LASTCOL-1)) ] && [ $BALLDIRX = "r" ];
		then BALLDIRX="l"
	fi
	
	tput cup $bally $ballx
	printf %b "$BALLCHAR"		
}

gameover() {
   stty echo
   echo "Quitting..."
   sleep 2
   tput cvvis
   tput reset
   exit
}

PLAYERCHAR="~" 
BALLCHAR="O"

stty -echo
tput civis
tput bold
clear
drawborder
tput cup 2 100
printf %b "GOAL KEEPER"	
tput cup $SCOREY $SCOREX
printf %b "SCORE"		

while :
do
   read -s -n 1 -t 0.0001 key
   case "$key" in
   a)   DIRECTION="l"
   	move;;
   d)   DIRECTION="r"
   	move;;
   x)   tput cup $(( $LASTROW + 1 )) 0
   	gameover
        ;;
   *)   sleep 0.1
   	moveball;;
   esac
done  
