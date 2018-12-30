for dir in NAACL2019/NAACL2019_English/UD_English*/; do
       # echo $dir

        trainfile="$(find $dir -name *train.conllu0.1)"
        echo "$trainfile"
	if [ "$trainfile" = "" ]
	then
		continue
	fi
        devfile="$(find $dir -name *-dev.conllu)"


        language="$(cut -d'/' -f4 <<<"$devfile")"
        lan="${language:0:2}"
#        echo "$lan"

        corpus="$(cut -d'_' -f2 <<<"$language")"
        corpus="$(cut -d'-' -f1 <<<"$corpus")"
#        echo "$corpus"
	
	exist="$(find $dir -name "model.$corpus.noise_reduction.0.1.300d")"
	echo "$exist"
# 	size="$(stat -c%s "$exist")"
#	echo "$size"
	if [ "$exist" = "" ]
#	if [ "$exist" = "" ] || [ $size = "0" ]
	then
		model="model"
		echo "$trainfile not trained"
		echo "loading training file: $trainfile"
		echo "loading dev file: $devfile"
		echo "loading embedding file: cc.$lan.300.vec"
  		../udpipe --train --tokenize --tag --parser  embedding_form_file=cc.$lan.300.vec --heldout=$devfile $dir$model.$corpus.noise_reduction.0.1.300d $trainfile
	else
		echo "model.$corpus.noise_reduction.0.1.300d is trained"
	fi
done
