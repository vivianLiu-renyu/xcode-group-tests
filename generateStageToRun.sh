#!/bin/bash

function addOnlyTestingCasesTo() {
	stageName=$1
	lines=$2
	fileName=$3
	path=$4

	name=`sed "${lines}q;d" $file | sed s/"func "/"/g" | cut -d '(' -f1 | sed s/" "/"/g" `
	echo "-only-testing:UITests/$fileName/$name" >> $path"/$stageName.txt"
}

function addSkipTestingCasesTo() {
	stageName=$1
	lines=$2
	fileName=$3
	path=$4

	name=`sed "${lines}q;d" $file | sed s/"func "/"/g" | cut -d '(' -f1 | sed s/" "/"/g" `
	echo "-skip-testing:UITests/$fileName/$name" >> $path"/$stageName.txt"
}

files=`ls | grep Test.swift`

for file in $files;
do
	count=1
	fileName=`echo $file | cut -d"." -f 1`
	exec < $file
	
	while read line
	do
		if [[ $line =~ (\/\/ {0,2}acceptance) ]]; then
			addOnlyTestingCasesTo acceptance $((count+1)) $fileName $1
		fi

		if [[ $line =~ (\/\/ {0,2}functional) ]]; then
			addOnlyTestingCasesTo functional $((count+1)) $fileName $1
		fi

		if [[ $line =~ (\/\/ {0,2}flaky) ]]; then
			addSkipTestingCasesTo flaky $((count+1)) $fileName $1
		fi

		if [[ $line == *"func test"* ]]; then
			prevLineNum=$((count-1))
			prevLine=`sed "${prevLineNum}q;d" $file | sed s/" "/"/g" `

			if [[ $prevLine == "" ]]; then
				addOnlyTestingCasesTo functional $count $fileName $1
			fi
		fi
		count=$((count+1))
	done
done