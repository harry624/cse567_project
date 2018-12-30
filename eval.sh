#bin/bash
for dir in NAACL2019/*/*/; do
        echo "dir: $dir"
	singleModel="$(find $dir -name "*.300d")"
        echo "load model: $singleModel"
	
	modelName="$(cut -d'/' -f4 <<<"$singleModel")"
#	echo "$modelName"

	testFile="$(find $dir -name *-test.conllu)"
	echo "load test file: $testFile"

	testFileName="$(cut -d'/' -f4 <<<"$testFile")"
#	echo "$testFileName"
	
	res="$(../udpipe --accuracy --tag --parse $singleModel $testFile)"

	#use regular expression to get LAS score
	score=${res: -6}  
	echo "$score"

	#TESTFILE-MODEL.parsed.score
	sep="-"
	suffix=".parsed.score"
	echo "==> $testFileName$sep$modelName$suffix <==" >> LAS.score
	echo "LAS F1 Score: $score" >> LAS.score
done
