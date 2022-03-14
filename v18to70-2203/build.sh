#!/bin/bash
#
# Data-preparation script for paritioning FishBoardMix for Speaker-Age.
#
# Requirements:
#     Your [aggregated] corpus located in some folder consisting of these 5 files: spk2gender, spk2yage, utt2yage, utt2spk, wav.scp.
#
# Usage:
#  ./build.sh <SOURCE_CORPUS_DIR>
#
# Interactions LLC. 2021
# A.Moreno
#
set -e
_tmpfiles=" .spklist$$ eval/.spklist$$ dev/.spklist$$ train/.spklist$$ .tot-spklist$$ "
trap 'rm -f $_tmpfiles ; trap - INT; kill -s INT "$$"' INT

[[ "$#" < 1 ]] && (>&2 echo -e "USAGE:\n $0 <SOURCE_CORPUS_DIR>\n;;; where SOURCE_CORPUS_DIR contains spk2gender, spk2yage, utt2yage, utt2spk, wav.scp." ) && exit 1;

# Directory of aggregated FishBoardMix.
D=$1

# Age values of interest.
TEST_AGES=$(seq 18 70)
# Speakers/age left aside for eval and dev sets.
NR_SPK_PER_YAGE=12


GENDERS="f m"
CORPORA="swb mx6 fsh"


mkdir -p eval dev train

# Select $NR_SPK_PER_YAGE different speakers for each $TEST_AGES.
(
  for AGE in $TEST_AGES; do
    candidates=""
    for GENDER in $GENDERS; do
      for CORPUS in $CORPORA; do
        candidates="$candidates $(join -1 1 -2 1 $D/spk2yage $D/spk2gender | awk '{print substr($1,0,3),$2,$3,$1}' | grep " $AGE " | grep " $GENDER " | grep $CORPUS | shuf --random-source=._random_source | awk '{print $4}' | head -n 4)"
      done
    done
    echo $candidates \
      | sed -e "s/ /\n/g" \
      | shuf --random-source=._random_source \
      | head -n $NR_SPK_PER_YAGE \
      | awk '{print NR, $0}'
  done
) > .spklist$$

# EVAL,DEV
cat .spklist$$ \
  | awk '$1<=6 {print $2}' \
  | sort > eval/.spklist$$
cat .spklist$$ \
  | awk '$1>6 {print $2}' \
  | sort > dev/.spklist$$

# overwrite:
cat eval/.spklist$$ dev/.spklist$$ \
  | sort > .spklist$$
cat $D/spk2gender \
  | awk '{print $1}' \
  | sort > .tot-spklist$$

# TRAIN
diff .spklist$$ .tot-spklist$$ \
  | grep '>' \
  | awk '{print $2}' \
  | sort > train/.spklist$$



for part in dev eval train; do
    join -1 1 -2 1 $part/.spklist$$ $D/spk2yage > $part/spk2yage
    join -1 1 -2 1 $part/.spklist$$ $D/spk2gender > $part/spk2gender

    cat $D/utt2spk \
      | sort -k2 \
      | join -1 2 -2 1 - $part/spk2yage  \
      | awk '{print $2,$1}' \
      | sort > $part/utt2spk
    cat $D/utt2spk \
      | sort -k2 \
      | join -1 2 -2 1 - $part/spk2yage \
      | awk '{print $2,$3}' \
      | sort > $part/utt2yage

    join -1 1 -2 1 $D/wav.scp $part/utt2spk \
      | sed -e "s/|.*/|/" \
      | sort > $part/wav.scp
done


rm -f $_tmpfiles
echo
for x in train eval dev; do
  wc -l $x/*
  md5sum $x/*
  echo
done
echo "done!"
