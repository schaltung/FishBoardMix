#!/bin/bash
#
# Data-preparation script for Speaker-Age: FishBoardMix
# Corpus: Fisher
# Requirements:
#     Must place LDC200{45}T19 and LDC200{45}S13 (or a symlink) under $LDC_DIR/
#
# Usage:
#  ./prepFisher.sh <LDC_DIR>
#
#
# Expected output (nr of lines):
#    11606 spk2gender
#    11606 spk2yage
#    22320 utt2spk
#    22320 utt2yage
#    22320 wav.scp
#
# A.Moreno
#
set -e
_tmpfiles="._list.1$$ ._list.2$$ .uttids$$ .sph.paths$$ .sphfiles$$"
trap 'rm -f $_tmpfiles ; trap - INT; kill -s INT "$$"' INT

[[ "$#" != 1 ]] && (>&2 echo -e "USAGE:\n $0 <LDC_DIR>\n;;; where LDC_DIR contains LDC200{45}T19 and LDC200{45}S13." ) && exit 1;

LDC_DIR=$1

(>&2
  echo "[INFO] LDC_DIR: $LDC_DIR"
  for pindata in $LDC_DIR/LDC200?T19/fe_03_p?_tran/doc/fe_03_pindata.tbl; do
    echo "[INFO] Fisher pindata.tbl: $pindata"
  done
)

cat $LDC_DIR/LDC200?T19/fe_03_p?_tran/doc/fe_03_pindata.tbl \
    | sort \
    | uniq \
    | cut -d, -f1,2,3,8 \
    | awk -F"," '$3 != "NA" {print $0}' \
    | grep -v PIN > ._list.1$$
cat ._list.1$$ \
    | sed -e "s/;/,/g" -e "s/\// /g" \
    | awk -F"," '{for (i=4; i<=NF; ++i) {print $1,$2,$3,$i}}' \
    | sed -e "s/\./ /" | sed -e "s/ m / M /" -e "s/ f / F /" > ._list.2$$

# SPK2YAGE
cat ._list.2$$ \
  | awk '$2==$5 {print "fsh"$1"-"$2$5, $3}' | sort | uniq > spk2yage
(>&2 echo "[INFO]     spk2yage    (1/5) [done]" )

cat spk2yage \
  | sed -e "s/-MM\b.*/-MM m/" -e "s/-FF\b.*/-FF f/" > spk2gender
(>&2 echo "[INFO]     spk2gender  (2/5) [done]" )

cat ._list.2$$ \
  | awk '$2==$5 {print "fsh"$1"-"$2$5"-"$4}' \
  | sed -e "s/_/-/" | sort > .uttids$$

# UTT2SPK
paste .uttids$$  .uttids$$ \
  | cut -d'-' -f1-5 > utt2spk
(>&2 echo "[INFO]     utt2spk     (3/5) [done]" )

# UTT2YAGE
cat ._list.2$$ \
  | awk '$2==$5 {print "fsh"$1"-"$2$5"-"$4, $3}' | sort > utt2yage
(>&2 echo "[INFO]     utt2yage    (4/5) [done]" )

sphfiles=.sphfiles$$
cat ._list.2$$ \
  | awk '$2==$5 {print $4}' \
  | awk -F"_" '{print substr($1,0,3)"/fe_03_"$1".sph"}' > $sphfiles

for sph in $(cat $sphfiles); do
  ls $LDC_DIR/*/*/audio/$sph
done > .sph.paths$$

# WAV.SCP
paste -d ' ' .uttids$$  .sph.paths$$ \
  | sed -e "s/\-\([AB]\)\b/-\1 sph2pipe -p -f wav -c \1/" \
  | sed -e "s/ A\b/ 1/" -e "s/ B\b/ 2/" \
  | awk '{print $0,"|"}' \
  | sort > wav.scp
(>&2 echo "[INFO]     wav.scp     (5/5) [done]" )

rm -f $_tmpfiles
(>&2
  echo "[INFO] Done. Output: spk2gender utt2yage utt2spk spk2yage wav.scp"
)
