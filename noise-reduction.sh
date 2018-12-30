#bin/bas
for dir in NAACL2019/NAACL2019_Portuguese/UD_Portuguese-BR/; do
        echo "directory: $dir"

	#find fine-tuned train.conllu
        ftfile="$(find $dir -name *like_merge-train.conllu)"
	echo "fine-tuned: $ftfile"
        devfile="$(find $dir -name *-dev.conllu)"
	echo "dev: $devfile"
	language="$(cut -d'/' -f4 <<<"$devfile")"
        lan="${language:0:2}"
#        echo "$lan"

        corpus="$(cut -d'_' -f2 <<<"$language")"
        corpus="$(cut -d'-' -f1 <<<"$corpus")"
#        echo "$corpus"

	exist="$(find $dir -name *fine_tuned.300d.st)"
	if [ "$exist" != "" ]
	then
		echo"$exist is trained"
		continue
	fi

	#make noise-reduction similartiy
	model="$(find $dir -name *fine_tuned.300d)"
        if [ "$model" = "" ]
	then
		echo "fine tuned moedl not trained"
		continue
	fi

	echo "find model: $model"	
            
		#$l = result relation files
               l=`echo $ftfile | sed 's/train\.conllu/rel/g'`
               echo $l

               java -cp noisy_reduction_ft/unling-conll2017.jar MakeRel $ftfile > $ftfile".rel"
              java -cp noisy_reduction_ft/unling-conll2017.jar MakeRel $devfile > $devfile".rel"
             cat $devfile".rel" | sort | uniq -c > $devfile".rel.uniq"
             cat $dir*.rel | sort | uniq > $l
              java -cp noisy_reduction_ft/unling-conll2017.jar CalcRELVecSimil $l $devfile".rel.uniq" $ftfile 0.1  > $ftfile.similarity.0.1


	#self training
	model="$(find $dir -name *fine_tuned.300d)"
	echo "find model: $model"
	merge=$ftfile.similarity.0.1
	echo "loading self training conllu: $merge"
	echo "parse corpus"
	../udpipe --input=conllu --tag --parse $model $merge > $merge.st
	java Intersection $merge $merge.st > $merge-intersetion
	echo "intersection done, start training"
	../udpipe --train --tokenize --tag --parser "embedding_form_file=cc.$lan.300.vec" --heldout=$devfile  $model.st $merge-intersetion
#	model=$model.st
#	../udpipe --accuracy --tag --parse $model.st en-ud-dev.conllu > en-ud-dev.conllu.score.$k
	
	
done
