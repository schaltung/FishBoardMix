#!/bin/bash
#
# Data-preparation script for paritioning Speaker-Age
# Requirements:
#     Your [aggregated] corpus in some folder with the files: spk2gender, spk2yage, utt2yage, utt2spk, wav.scp.
#
# Usage:
#  ./prep.sh <ORIG_CORPUS_DIR>
#
# Interactions LLC. 2021
# A.Moreno
#
set -e
_tmpfiles=" .spklist$$ eval/.spklist$$ dev/.spklist$$ train/.spklist$$ .tot-spklist$$ "
trap 'rm -f $_tmpfiles ; trap - INT; kill -s INT "$$"' INT

[[ "$#" < 1 ]] && (>&2 echo -e "USAGE:\n $0 <ORIG_CORPUS_DIR>\n;;; where ORIG_CORPUS_DIR contains spk2gender, spk2yage, utt2yage, utt2spk, wav.scp." ) && exit 1;

D=$1

GENDERS="f m"
CORPORA="swb mx6 fsh"
TEST_AGES="18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70"

NR_SPK_PER_YAGE=12


(
  for AGE in $TEST_AGES; do
    candidates=""
    for GENDER in $GENDERS; do
      for CORPUS in $CORPORA; do
        candidates="$candidates $(join -1 1 -2 1 $D/spk2yage $D/spk2gender | awk '{print substr($1,0,3),$2,$3,$1}' | grep " $AGE " | grep " $GENDER " | grep $CORPUS | shuf | awk '{print $4}' | head -n 4)"
      done
    done
    echo $candidates | sed -e "s/ /\n/g" | shuf | head -n $NR_SPK_PER_YAGE | awk '{print NR, $0}'
  done
) > .spklist$$

# EVAL,DEV
cat .spklist$$ | awk '$1<=6 {print $2}' | sort > eval/.spklist$$
cat .spklist$$ | awk '$1>6 {print $2}' | sort > dev/.spklist$$

# overwrite:
cat eval/.spklist$$ dev/.spklist$$ | sort > .spklist$$
cat $D/spk2gender | awk '{print $1}' | sort > .tot-spklist$$

# TRAIN
diff .spklist$$ .tot-spklist$$ | grep '>' | awk '{print $2}' | sort > train/.spklist$$



for part in dev eval train; do
    join -1 1 -2 1 $part/.spklist$$ $D/spk2yage > $part/spk2yage
    join -1 1 -2 1 $part/.spklist$$ $D/spk2gender > $part/spk2gender

    cat $D/utt2spk | sort -k2 | join -1 2 -2 1 - $part/spk2yage  | awk '{print $2,$1}' | sort > $part/utt2spk
    cat $D/utt2spk | sort -k2 | join -1 2 -2 1 - $part/spk2yage  | awk '{print $2,$3}' | sort > $part/utt2yage

    join -1 1 -2 1 $D/wav.scp $part/utt2spk | sed -e "s/|.*/|/" | sort > $part/wav.scp

done


rm -f $_tmpfiles
