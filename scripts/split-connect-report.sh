#
## sudo apt install jq wcstools

if [ $# -lt 1 ]
then
    echo "Usage: $0 <gzipped_report_filename>"
    exit
fi

declare -a SECTIONS
SECTIONS=($(zcat $1 | jq -r '.[] | keys | join(" ")'))
#echo "sections: ${SECTIONS[*]}"

filename=$(basename "$1")
filename=$(basename "${filename%.*}")
filename=$(basename "${filename%.*}")
#echo "basename: $filename"

for section in "${SECTIONS[@]}"
do
    section_filename="$filename.$section.json"
    echo "$section --> $section_filename"
    zcat $1 | jq --arg section "$section" '.[][$section]' > $section_filename
done
