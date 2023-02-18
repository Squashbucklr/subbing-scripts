#!/bin/bash

karaoke=$1
subtitles=$2

kevents=$(grep -n "\\[Events\\]" $karaoke | awk -F: '{ print $1 }')
kstyles=$(grep -n "\\[V4\\+.*Styles\\]" $karaoke | awk -F: '{ print $1 }')

sevents=$(grep -n "\\[Events\\]" $subtitles | awk -F: '{ print $1 }')
sstyles=$(grep -n "\\[V4\\+.*Styles\\]" $subtitles | awk -F: '{ print $1 }')

cat $subtitles | head -$(($sevents - 2))

# karaoke styles
cat $karaoke | head -$(($kevents - 2)) | tail +$(($kstyles + 2))

cat $subtitles | tail +$(($sevents - 1))

# karaoke (sans generator)
cat $karaoke | grep "^Dialogue:"
