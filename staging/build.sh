#!/bin/bash
set -e

for x in spk2gender spk2yage utt2yage utt2spk wav.scp; do
  ls */$x
  cat */$x | sort > $x; 
done
wc -l spk2gender spk2yage utt2yage utt2spk wav.scp
echo "done!."
