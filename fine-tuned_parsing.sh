for i in NAACL2019/*
do
       	echo "parent: $i"
       	if [ "$i" == "NAACL2019/NAACL2019_English"]
	then
		continue
	fi

       	for j in $i/UD*
       	do
                echo "sub: $j"
       
                singleModel="$(find $j/ -name "model*.single.300d")"
		modelName="$(cut -d'/' -f4 <<<"$singleModel")"

                echo "model name: $modelName"

		#find the orginal train.conllu   
		trainfile="$(find $j -name *-train.conllu)"
		echo "trainfile: $trainfile"

		#get the rest treebanks in this language, and train it with the model
		#get the conllu.model.parsed file

		for k in $i/UD*
		do
			othertrainfile="$(find $k -name *-train.conllu)"
			echo "other train file: $othertrainfile"

			if [ "$trainfile" != "$othertrainfile" ]
			then
				fileName="$(cut -d'/' -f4 <<<"$othertrainfile")"

                   		#parsed result: TESTFILE.MODELNAME.parsed
			        #en-ud-test.conllu-model.ewt-ft.cc300d.parsed
		   		echo "other trainfile: $fileName"
				slash="/"
				sep="."
				suffix=".parsed"
				../udpipe --input=conllu --tag --parse $singleModel $othertrainfile --outfile=$j$slash$fileName$sep$modelName$suffix
				echo "$j$slash$fileName$sep$modelName$suffix is trained"
				#run the fine-tuned python to get a corpus_like.conllu

			fi
		done


	done
done
