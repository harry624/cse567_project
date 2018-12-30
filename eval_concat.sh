#bin/bash
for dir in NAACL2019/*/; do
        echo "dir: $dir"
        singleModel="$(find $dir -name model.*concat.300d)"
       echo "model path: $singleModel"
	
	modelName="$(cut -d'/' -f3 <<<"$singleModel")"
       	echo "loading model: $modelName"

	for subdir in $dir*/; do
		echo "subdir: $subdir"
		testFile="$(find $subdir -name *-test.conllu)"
		
		testFileName="$(cut -d'/' -f4 <<<"$testFile")"
	        echo "loading testFile: $testFileName"

		res="$(../udpipe --accuracy --tag --parse $singleModel $testFile)"
       		#use regular expression to get LAS score
        	score=${res: -6}
        	echo "$score"

        	#TESTFILE-MODEL.parsed.score
        	sep="-"
        	suffix=".parsed.score"
        	echo "==> $testFileName$sep$modelName$suffix <==" >> concat_LAS.score
        	echo "LAS F1 Score: $score" >> concat_LAS.score
	done	
done
