#!/bin/bash

dir=$(dirname $0)
doc_db_path="$dir/doc_db"


generate_db () {
	truncate -s 0 "$doc_db_path"

	find . -print0 | while IFS= read -r -d '' fpath
	do 
		if [[ -f "$fpath" ]]; then
			fname=$(basename "$fpath")
			fsize=$(stat --printf="%s" "$fpath")
			parent=$(dirname "$fpath")

			if [[ "$parent" == *_files ]]; then
				echo "skip $fpath, HTML SUBDIR"
			else
				echo "$fpath;$fsize;$fname" >> "$doc_db_path"
			fi
		fi
	done

	echo "Generated DB:$doc_db_path"
}

db_path_arr=()
db_size_arr=()
db_name_arr=()

read_db () {
	while IFS='' read -r line || [[ -n "$line" ]]; do

		IFS=';' read -ra line_arr <<< "$line"
		db_path=${line_arr[0]}
		db_size=${line_arr[1]}
		db_name=${line_arr[2]}
		echo "PATH=$db_path SIZE=$db_size NAME=$db_name"
		db_path_arr+=("$db_path")
		db_size_arr+=("$db_size")
		db_name_arr+=("$db_name")

	done < "$doc_db_path"

	db_arr_len=${#db_path_arr[@]}
}

traverse () {
	find . -print0 | while IFS= read -r -d '' fpath
	do 
		if [[ -f "$fpath" ]]; then
			fname=$(basename "$fpath")
			fsize=$(stat --printf="%s" "$fpath")
			parent=$(dirname "$fpath")

			if [[ "$parent" == *_files ]]; then
				echo "SKIP HTML:$fpath"
			else
				# try to find in DB
				msg=""
				for ((i = 0; i < $db_arr_len; ++i)); do
					db_path=${db_path_arr[i]}
					db_size=${db_size_arr[i]}
					db_name=${db_name_arr[i]}
					#if [ "$db_name" = "$fname" ]; then
					if [ "$db_name" == "$fname" ]; then
						if [ "$db_size" -eq "$fsize" ]; then
							msg="OK"
							break
						else
							msg="$msg $db_path($db_size);"
						fi
					fi
				done

				if [ "$msg" == "OK" ] ; then
					echo "FOUND in DB: $fname $fsize"
				elif [[ !  -z  $msg  ]]; then
					echo "$fpath differs in size from $msg"
				else
					echo "$fpath not found"
				fi
			fi
		fi
	done
}

#generate_db
read_db
traverse
exit 0

IFS=';' read -ra line_arr <<< "$line"
for i in "${line_arr[@]}"; do
    # process "$i"
done
echo "${line_arr[0]}"


