#!/bin/sh
echo -e "\t\tSGPA Calculator"
echo -----------------------------------

semPHY1=(18MATx1 18PHYx2 18ELEx3 18CIVx4 18EGDLx5 18PHYLx6 18ELELx7 18EGHx8)
subPHY1=(MATH Physics ELE Civil EGDLAB PHYLAB ELELAB EGH-I)
credPHY1=(4 4 3 3 3 1 1 1)

semCHE1=(18MATx1 18CHEx2 18CPSx3 18ELNx4 18MEx5 18CHELx6 18CPLx7 18EGHx8)
subCHE1=(MATH CHEMIC CPS ELN EME CHELAB CPLAB EGH-II)
credCHE1=(4 4 3 3 3 1 1 1)

semCS3=(18MAT31 18CS32 18CS33 18CS34 18CS35 18CS36 18CSL37 18CSL38 18xxx39)
subCS3=(MATH-3 DSA ADE CO SE DMS ADELAB DSLAB KxA-CPC)
credCS3=(3 4 3 3 3 3 2 2 1)

semCS4=(18MAT41 18CS42 18CS43 18CS44 18CS45 18CS46 18CSL47 18CSL48 18xxx49)
subCS4=(MATH-4 DAA OS MCES OOC DC DAALAB MCESLAB KxA-CPC)
credCS4=(3 4 3 3 3 3 2 2 1)

semCS5=(18CS51 18CS52 18CS53 18CS54 18CS55 18CS56 18CSL57 18CSL58 18CIV59)
subCS5=(ME CNS DBMS ATCI ADP UNIX CNSLAB DBMSLAB EVS)
credCS5=(3 4 4 3 3 3 2 2 1)

semCS6=(18CS61 18CS62 18CS63 18CS64X 18CS65X 18CSL66 18CSL67 18CSMP68)
subCS6=(SSC CGV WebTech ProfEle OpenEle SSLAB CGVLAB MAD)
credCS6=(4 4 4 3 3 2 2 2)

semCS7=(18CS71 18CS72 18CS73X 18CS74X 18CS75X 18CSL76 18CSP77)
subCS7=(AIML BDA ProEle2 ProEle3 OpenEle AIMLLAB Proj-I)
credCS7=(4 4 3 3 3 2 1)

semCS8=(18CS81 18CS82X 18CSP83 18CSS84 18CSI85)
subCS8=(IoT ProEle4 Proj-II Seminar Intern)
credCS8=(3 3 8 1 3)

branchHandler () {
	echo "Select Branch :"
	echo "1) Physics-Cycle"
	echo "2) Chemisty-Cycle"
	echo "3) Computer Science and Engineering"
	echo -e "\nUse option 1 or 2 for 1st and 2nd Semester of all Branch"
	read -p "Enter choice : " choice
	case $choice in
		1) branch="PHY";semester="1";;
		2) branch="CHE";semester="1";;
		3) branch="CS";read -p "Enter semester : " semester;;
		*) echo Invalid choice;exit;;
	esac
}

branchHandler
echo

sem="sem"$branch$semester[*]
sub="sub"$branch$semester[*]
cred="cred"$branch$semester[*]

readMarks () {
	declare -a subject='('${!sub}')'
	count=0
	marks=""
	echo "Enter final marks of each subject : "
	for s in ${!sem} ;
	do
		printf "%-8s- %-7s: " $s ${subject[${count}]}
		read m
		count=$(($count + 1))
		grade $m
		g=$?

		if (( $g < 0 || $g > 10 )) 
		then
     			echo invalid number
			return 1
		elif [ $g == 0 ]
		then
			echo "Failed in $s"
			marks+=" $g"
		else
			marks+=" $g"
		fi
	done
	calSGPA $marks
}
grade () {
	m=$1
	case $m in
		100) return 10;;
		[9][0-9]) return 10;;
		[8][0-9]) return 9;;
		[7][0-9]) return 8;;
		[6][0-9]) return 7;;
		[5][0-9]) return 6;;
		[4][5-9]) return 6;;
		[4][0-4]) return 4;;
		[0123][0-9]) return 0;;
		[0-9]) return 0;;
		*) return -1;;
	esac
}
calSGPA () {
	declare -a marks='('$*')'
	count=0
	credObt=0
	totalCred=0
	for c in ${!cred} ;
	do
		credObt=`expr $c \* ${marks[$count]} + $credObt`
		totalCred=`expr $c \* 10 + $totalCred`
		count=$(($count + 1))
	done	
	echo Total Credits : $totalCred
	echo Credits Obtained : $credObt
	echo SGPA : `echo "scale=2;$credObt * 10 / $totalCred" | bc`
}

readMarks



