#!/bin/bash
#
# Data-preparation script for Speaker-Age
# Corpus: Switchboard
# Requirements:
#     Place  LDC98S75 LDC99S79 LDC2002S06 LDC2001S13 LDC2004S07 under $LDC_DIR                                                                                                                 
#
#
# Usage:
#  ./prepFisher.sh <LDC_DIR>
#
# Expected output (nr of lines):
#   2631 spk2gender
#   2631 spk2yage
#  28012 utt2yage
#  28012 utt2spk
#  28012 wav.scp
#
# Interactions LLC. 2021
# A.Moreno
#
set -e
_tmpfiles=".wav.scp.1$$ .utt2spk.1$$ utt2filename filepaths "
trap 'rm -f $_tmpfiles ; trap - INT; kill -s INT "$$"' INT

[[ "$#" < 1 ]] && (>&2 echo -e "USAGE:\n $0 <LDC_DIR>\n;;; where LDC_DIR contains LDC98S75 LDC99S79 LDC2002S06 LDC2001S13 LDC2004S07." ) && exit 1;

LDC_DIR=/n/LDC/LDC2018/LDC2018E48_Comprehensive_Switchboard

#
# 5 switchboards:
#
#  swb2pI    LDC98S75 (phase I)
#  swb2pII   LDC99S79 (phase II)
#  swb2pIII  LDC2002S06 (phase III)
#
#  swbCpI   LDC2001S13 (cell part I)
#  swbCpII  LDC2004S07 (cell part II)
#


# SPK2YAGE
(
  cat $LDC_DIR/LDC98S75/docs/spkrinfo.tbl | cut -d, -f1,2,3 | awk -F',' '$3>0 {print "swb2pI"$1,$3}'
  cat $LDC_DIR/LDC99S79/docs/spkrinfo.tbl | cut -d, -f1,2,3 | awk -F',' '$3>0 {print "swb2pII"$1,$3}'
  cat $LDC_DIR/LDC2002S06/docs/spkrinfo.tbl | cut -d, -f1,2,3 | awk -F',' '$3>0 {print "swb2pIII"$1,$3}'
  cat $LDC_DIR/LDC2001S13/docs/swb_callsubjects.tbl | cut -d, -f1,2,3 | awk -F',' '$3>0 {print "swbCpI"$1,$3}'
  cat $LDC_DIR/LDC2004S07/docs/swb_callsubjects.tbl | cut -d, -f1,2,3 | awk -F',' '$3>0 {print "swbCpII"$1,$3}'
) | sort > spk2yage

# SPK2GENDER
(
  cat $LDC_DIR/LDC98S75/docs/spkrinfo.tbl | cut -d, -f1,2,3 | awk -F',' '$3>0 {print "swb2pI"$1,$2}'
  cat $LDC_DIR/LDC99S79/docs/spkrinfo.tbl | cut -d, -f1,2,3 | awk -F',' '$3>0 {print "swb2pII"$1,$2}'
  cat $LDC_DIR/LDC2002S06/docs/spkrinfo.tbl | cut -d, -f1,2,3 | awk -F',' '$3>0 {print "swb2pIII"$1,$2}'
  cat $LDC_DIR/LDC2001S13/docs/swb_callsubjects.tbl | cut -d, -f1,2,3 | awk -F',' '$3>0 {print "swbCpI"$1,$2}'
  cat $LDC_DIR/LDC2004S07/docs/swb_callsubjects.tbl | cut -d, -f1,2,3 | awk -F',' '$3>0 {print "swbCpII"$1,$2}'
) | sed -e "s/ F$/ f/" -e "s/ M$/ m/" | sort > spk2gender

(
  cat $LDC_DIR/LDC98S75/docs/callinfo.tbl \
    | cut -d, -f1,3,4 \
    | sed -e "s/^sw_//" -e "s/\.sph,/,/" \
    | awk -F',' '{print "swb2pI"$2"-"$1$3,"LDC98S75/data/sw_"$1".sph"}'

  cat $LDC_DIR/LDC99S79/docs/callinfo.tbl \
    | cut -d, -f1,3,4 \
    | sed -e "s/^sw_//" -e "s/\.sph,/,/" \
    | awk -F',' '{print "swb2pII"$2"-"$1$3,"LDC99S79/data/sw_"$1".sph"}'

  cat $LDC_DIR/LDC2002S06/docs/callinfo.tbl \
    | cut -d, -f1,3,4 \
    | sed -e "s/^sw_//" -e "s/\.sph,/,/" \
    | awk -F',' '{print "swb2pIII"$2"-"$1$3,"LDC2002S06/data/sw_"$1".sph"}'

  cat $LDC_DIR/LDC2001S13/docs/swb_callstats.tbl \
    | cut -d, -f1-5 \
    | awk -F',' '{print "swbCpI"$2"-"$1"A","LDC2001S13/data/sw_"$1".sph\nswbCpI"$3"-"$1"B","LDC2001S13/data/sw_"$1".sph"}'

  cat $LDC_DIR/LDC2004S07/docs/swb_callstats.tbl \
    | cut -d, -f1-5 \
    | awk -F',' '{print "swbCpII"$2"-"$1"A","LDC2004S07/data/sw_"$1".sph\nswbCpII"$3"-"$1"B","LDC2004S07/data/sw_"$1".sph"}'
) | sort | uniq > utt2filename


for x in $(cat utt2filename | awk '{print $NF}'); do
  ls $LDC_DIR/$x; 
done > filepaths

[[ "$(cat filepaths | wc -l)" == "$(cat utt2filename | wc -l)" ]] || (>&2 echo "Missing audio files."; exit 1)

paste utt2filename filepaths \
  | awk '{print $1,$3}' \
  | sed -e "s/A\b/A sph2pipe -p -f wav -c 1/" -e "s/B\b/B sph2pipe -p -f wav -c 2/" \
  | awk '{print $0,"|"}' | sort | uniq > .wav.scp.1$$

#
# NOTE for swbCpI and swbCpII: 
#   Confirmed assumption that "CALLER/CALLEE" are on chan "A/B"
#   by observing how gender information provided in call_stats.tbl 
#   and callsubjects.tbl match.
#

cat .wav.scp.1$$ \
  | awk '{print $1,$1}' \
  | cut -d'-' -f1,2 > .utt2spk.1$$

# UTT2SPK
join -1 2 -2 1 .utt2spk.1$$ spk2yage \
  | awk '{print $2,$1}' \
  | sort \
  | uniq > utt2spk

# WAV.SCP
join -1 1 -2 1 utt2spk .wav.scp.1$$ \
  | cut -d' ' -f1,3- > wav.scp

# UTT2YAGE
join -1 2 -2 1 utt2spk spk2yage \
  | awk '{print $2,$3}' \
  | sort \
  | uniq > utt2yage


rm -f $_tmpfiles
(>&2
  echo "[INFO] Done. Output: spk2gender utt2yage utt2spk spk2yage wav.scp"
)
