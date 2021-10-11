#!/bin/bash
#
# Data-preparation script for Speaker-Age
# Corpus: MX6
# Requirements:
#     Place LDC2013S03 under $LDC_DIR
#
# Usage:
#  ./prepMX6Speech.sh <LDC_DIR>
#
# Expected output (nr of lines):
#    589 spk2gender
#    589 spk2yage
#   8776 utt2spk
#   8776 utt2yage
#   8776 wav.scp
#
# Interactions LLC. 2021
# A.Moreno
#
set -e
_tmpfiles=".spk.dob.utt.date$$ .y_dob2date$$ .utt2date.1$$ .spk2yob$$ .spk2dob$$ .utt2spk.1$$ .paths$$ "
trap 'rm -f $_tmpfiles ; trap - INT; kill -s INT "$$"' INT

[[ "$#" != 1 ]] && (>&2 echo -e "USAGE:\n $0 <LDC_DIR>\n;;; where LDC_DIR contains LDC2013S03." ) && exit 1;

LDC_DIR=/n/LDC/LDC2018/mx6_speech_LDC2013S03

ddiff() {
    d1=$(date -d "$1" +%s)
    d2=$(date -d "$2" +%s)
    echo $(( (d1 - d2) / 86400 / 365 ))
}

#
# Filter: dob must be a number and gender must be in {F,M}.
# SPK2GENDER
cat $LDC_DIR/LDC2013S03/docs/mx6_subjs.csv \
  | grep -v subjid \
  | cut -d, -f1,2,3 \
  | awk -F',' '$3>0 && ($2=="F" || $2=="M") {print "mx6_"$1,$2}' \
  | sed -e "s/ F$/ f/" -e "s/ M$/ m/" \
  | sort > spk2gender
cat $LDC_DIR/LDC2013S03/docs/mx6_subjs.csv \
  | grep -v subjid \
  | cut -d, -f1,2,3 \
  | awk -F',' '$3>0 && ($2=="F" || $2=="M") {print "mx6_"$1,$3}' \
  | sort > .spk2yob$$
#
#
# NOTE: Calls were placed between 2009-09-28 and 2010-03-04 (a 6 month period),
#       therefore speakers did not change years of age (yage).
#
# -->  Simplification: everyone's DOB is YOB-06-01
#
cat .spk2yob$$ \
  | awk '{print $0"-06-01"}' > .spk2dob$$


cat $LDC_DIR/LDC2013S03/docs/mx6_calls.csv \
  | grep -v call_id \
  | cut -d, -f1,2,5,13 \
  | awk -F',' '{print "mx6_"$3"-"$1"A",$2"\nmx6_"$4"-"$1"B",$2}' \
  | cut -d'_' -f1,2 \
  | sort > .utt2date.1$$

cat $LDC_DIR/LDC2013S03/docs/mx6_calls.csv \
  | grep -v call_id \
  | cut -d, -f1,2,5,13 \
  | awk -F',' '{print "mx6_"$3"-"$1"A","mx6_"$3"\nmx6_"$4"-"$1"B","mx6_"$4}' \
  | sort | uniq > .utt2spk.1$$

# mx6_103187 1984-06-01 mx6_103187-1010B 2009-09-28
cat .utt2date.1$$ \
  | awk '{print $1,$2,$1}' \
  | cut -d'-' -f1-4 \
  | join -1 1 -2 3 .spk2dob$$ - > .spk.dob.utt.date$$

#cat .spk.dob.utt.date$$ \
#  | awk '{print $3,$4}' > utt2date

cat .spk.dob.utt.date$$ \
  | while IFS=" " read spk dob utt date; do 
  t1sec=$(date +%s -d"$dob");
  t2sec=$(date +%s -d"$date");
  echo $((($t2sec-$t1sec)/60/60/24/365));
done > .y_dob2date$$

# SPK2YAGE
paste .spk.dob.utt.date$$ .y_dob2date$$ \
  | awk '{print $1,$NF}' \
  | sort \
  | uniq > spk2yage

# UTT2YAGE
paste .spk.dob.utt.date$$ .y_dob2date$$ \
  | awk '{print $3,$NF}' \
  | sort \
  | uniq > utt2yage

join -1 1 -2 1 utt2yage .utt2spk.1$$ \
  | awk '{print $1,$NF}' > utt2spk


cat utt2spk \
  | awk '{print $1}' \
  | cut -d- -f2 \
  | sed -e "s/[AB]$//" \
  | awk '{print "ls /n/LDC/LDC2018/mx6_speech_LDC2013S03/mx6_speech/data/ulaw_sphere/*_"$1".sph"}' \
  | sh > .paths$$


# WAV.SCP
paste utt2spk .paths$$ \
  | awk '{print $1, "sph2pipe -p -f wav -c",substr($1,length($1)), $NF" |"}' \
  | sed -e "s/ -c A / -c 1 /" -e "s/ -c B / -c 2 /" > wav.scp


rm -f $_tmpfiles
(>&2
  echo "[INFO] Done. Output: spk2gender utt2yage utt2spk spk2yage wav.scp"
)
