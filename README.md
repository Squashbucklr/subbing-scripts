# SUBBING SCRIPTS

It is recommended that you `ln -s` these into a subbing workspace

## karaoke.sh
Copy styles and dialogue from one .ass file (karaoke) into another (dialogue)

## genmkv.sh
Generate an mkv in a workspace using the following structure

* episodes
    * ep code or number (\${ep})
        * \${ep}\_dialogue.ass
        * fonts.conf
        * karaoke.conf
        * source.mkv
    * ...
* fonts
    * ...
* karaoke
    * karaoke name (\${karaoke})
        * \${karaoke}.ass
        * fonts.conf
    * ...
* output
    * ...
* merge.sh

fonts.conf are a list of font names with extension that are in the fonts folder.

karaoke.conf are a list of karaoke names (\${karaoke})

source.mkv is probably symlinked from another release

output is a folder for resulting mkvs to be stored in

merge.sh is the mkvmerge script, given arguments:
* \$1 = ep code (\${ep})
* $2 = gensub, the generated (temporary) subtitle file from genmkv.sh

untested with spaced font names
