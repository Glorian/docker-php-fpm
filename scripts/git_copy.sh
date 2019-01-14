#!/usr/bin/env bash

TMP_DIR=/home/sync
SYNC_FILE_PATH="$TMP_DIR/git_all_files_tmp"
PROJECT_PATH="${2:-$PWD}"
DESTINATION_PATH="${1}"

list_all_files() {
	git ls-files -z > "$SYNC_FILE_PATH"
}

filter_ignore_files() {
	[ -f '.git-ftp-ignore' ] || return
	local patterns="$TMP_DIR/ignore_tmp"
	grep -v '^#.*$\|^\s*$' '.git-ftp-ignore' | tr -d '\r' > "$patterns"
	filter_file "$patterns" "$SYNC_FILE_PATH"
	rm -f "$patterns"
}

filter_file() {
	glob_filter "$1" < "$2" > "$TMP_DIR/filtered_tmp"
	mv "$TMP_DIR/filtered_tmp" "$2"
}

# Original implementation http://stackoverflow.com/a/27718468/3377535
glob_filter() {
	local patterns="$1"
	while IFS= read -r -d '' filename; do
		local hasmatch=0
		while IFS= read -r pattern; do
			case $filename in ($pattern) hasmatch=1; break ;; esac
		done < "$patterns"
		test $hasmatch = 1 || printf '%s\0' "$filename"
	done
}

copy_to() {
	[ -f "$SYNC_FILE_PATH" ] || return

	local TOTAL_ITEMS=$(cat "$SYNC_FILE_PATH" | tr -d -c '\0' | wc -c)

	if [[ ! -d "$DESTINATION_PATH" ]]; then
		mkdir -p "$DESTINATION_PATH"
	fi

	while IFS= read -r -d '' FILE_NAME; do
		cp --parents $FILE_NAME $DESTINATION_PATH
	done < "$SYNC_FILE_PATH"

	rm -f "$SYNC_FILE_PATH"
}

run() {
	cd $PROJECT_PATH

	list_all_files
	filter_ignore_files
	copy_to

	cd --
}

if [[ $# < 2 ]]; then
	echo "sync.sh <destination_path> <path_to_git_project>"
	exit 2
fi

run
