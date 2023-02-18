#!/bin/bash

ep=$1

if [ ${#ep} = 0 ]; then
    echo "Usage: genmkv.sh EPISODE"
    exit 1
fi

if [ ! -d "episodes/$ep" ]; then
    echo "Invalid episode"
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

fontsfromfile episodes/$ep/fonts.conf

#
#   KARAOKE
#

cp ./episodes/$ep/${ep}_dialogue.ass gen_input_$$.ass
for karaoke in $(cat ./episodes/$ep/karaoke.conf); do
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

./merge.sh $ep gen_input_$$.ass "${fonts[@]}"

rm gen_input_$$.ass
