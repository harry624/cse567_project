#bin/bash
for dir in NAACL2019/NAACL2019_Portuguese/UD_Portuguese/; do
        echo "dir: $dir"
	singleModel="$(find $dir -name "*.fine_tuned.300d")"
        echo "load model: $singleModel"
	
	if [ "$singleModel" = "" ]
	then
		continue
	fi	
	modelName="$(cut -d'/' -f4 <<<"$singleModel")"
#	echo "$modelName"

	devFile="$(find $dir -name *-dev.conllu)"
	testFile="$(find $dir -name *-test.conllu)"
	echo "load dev file: $devFile"

	testFileName="$(cut -d'/' -f4 <<<"$testFile")"
#	echo "$testFileName"
	
	res="$(../udpipe --accuracy --tag --parse $singleModel $devFile)"

	#use regular expression to get LAS score
	score=${res: -6}  
	echo "$score"

	#TESTFILE-MODEL.parsed.score
	sep="-"
	suffix=".parsed.score"
	echo "==> $testFileName$sep$modelName$suffix <==" >> LAS_ft_dev.score
	echo "LAS F1 Score: $score" >> LAS_ft_dev.score
done
