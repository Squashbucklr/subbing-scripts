#!/bin/bash

ep=$1
folder=$2
epfolder=$ep

if [ ${#ep} = 0 ]; then
    echo "Usage: genmkv.sh EPISODE"
    exit 1
fi

if [ ${#folder} -ne 0 ]; then
    epfolder="${folder}/${ep}"
fi

if [ ! -d "episodes/$epfolder" ]; then
    echo "Episode folder does not exist"
    exit 1
fi

echo "Making episode $ep"

#
#   FONTS
#

fonts=()

fontsfromfile () {
    fontsfile=$1
    pref=$2
    for font in $(cat $fontsfile); do
        echo "${pref}Preparing font: $font"
        mime=$(file -b --mime-type ./fonts/$font)
        fonts=( "${fonts[@]}" --attachment-mime-type $mime --attach-file ./fonts/$font )
    done
    echo "${pref}Fonts prepared"
}

#
#   EPISODE SPECIFIC FONTS
#

fontsfromfile episodes/$epfolder/fonts.conf

#
#   KARAOKE
#

cp ./episodes/$epfolder/${ep}_dialogue.ass gen_input_$$.ass
for karaoke in $(cat ./episodes/$epfolder/karaoke.conf); do
    echo "Merging karaoke: $karaoke"
    ./karaoke.sh karaoke/$karaoke/${karaoke}.ass gen_input_$$.ass > gen_output_$$.ass
    rm gen_input_$$.ass
    mv gen_output_$$.ass gen_input_$$.ass
    fontsfromfile karaoke/$karaoke/fonts.conf "    "
done
echo "Karaoke merged"

#
#   MERGE
#

./merge.sh $ep $epfolder gen_input_$$.ass "${fonts[@]}"

rm gen_input_$$.ass
