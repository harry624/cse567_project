for dir in NAACL2019/NAACL2019_French; do
       echo $dir
	language="$(cut -d'/' -f2  <<<"$dir")"
	language="$(cut -d'_' -f2  <<<"$language")"
	echo $language	
	
	cat $dir/*/*train.conllu > $dir/$language.concat-train.conllu
	cat $dir/*/*dev.conllu > $dir/$language.concat-dev.conllu
done

declare -A dict
dict=(["Czech"]="cs" ["English"]="en" ["Finnish"]="fi" ["French"]="fr" ["Italian"]="it" ["Portuguese"]="pt" ["Russian"]="ru" ["Spanish"]="es" ["Swedish"]="sv" )

for dir in NAACL2019/*/; do

	lan="$(cut -d'/' -f2  <<<"$dir")"
	language="$(cut -d'_' -f2  <<<"$lan")"
#       echo $language
	
	lan="${dict["$language"]}"
#	echo "${dict["$language"]}"	
	trainfile="$(find $dir -name *concat-train.conllu)"
#        echo "$trainfile"

        devfile="$(find $dir -name *concat-dev.conllu)"
#        echo "$devfile"
	
	exist="$(find $dir -name *.concat.300d)"
#	size="$(stat -c%s "$exist")"
	if [ "$exist" = "" ]
#	if [ "$exist" = "" ] || [ $size = "0" ]
	then
		echo "$dir/model.$language.concat.300d is not trained"
		echo "loading training file: $trainfile"
		echo "loading dev file: $devfile"
		echo "loading embedding: cc.$lan.300.vec"
		model="model"
		../udpipe --train --tokenize --tag --parser  embedding_form_file=cc.$lan.300.vec --heldout=$devfile $dir$model.$language.concat.300d $trainfile
	else
		echo "model.$language.concat.300d is trained"
	fi
done
