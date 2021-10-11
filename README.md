# FishBoardMix


## Getting Started

#### 1. Staging of the individual corpora.
Go to `staging/` and build each sub-corpus individually by running its own `build.sh` script.

Each `build.sh` script requires one argument with the path to a folder containing the original LDC corpora needed.


```
% cd staging/SWB
% ./build.sh 
USAGE:
 ./build.sh <LDC_DIR>
;;; where LDC_DIR contains LDC98S75 LDC99S79 LDC2002S06 LDC2001S13 LDC2004S07.


% ./build.sh /path/to/LDC/data
[INFO] Done. Output: spk2gender utt2yage utt2spk spk2yage wav.scp
%
```

```
% cd staging/FSH
% ./build.sh 
USAGE:
 ./build.sh <LDC_DIR>
;;; where LDC_DIR contains LDC200{45}T19 and LDC200{45}S13.

% ./build.sh /path/to/LDC/data
[INFO] LDC_DIR: /path/to/LDC/data
[INFO] Fisher pindata.tbl: /path/to/LDC/data/LDC2004T19/fe_03_p1_tran/doc/fe_03_pindata.tbl
[INFO] Fisher pindata.tbl: /path/to/LDC/data/LDC2005T19/fe_03_p2_tran/doc/fe_03_pindata.tbl
[INFO]     spk2yage    (1/5) [done]
[INFO]     spk2gender  (2/5) [done]
[INFO]     utt2spk     (3/5) [done]
[INFO]     utt2yage    (4/5) [done]
[INFO]     wav.scp     (5/5) [done]
[INFO] Done. Output: spk2gender utt2yage utt2spk spk2yage wav.scp
%
```


```
% cd staging/MIX6
% ./build.sh 
USAGE:
 ./build.sh <LDC_DIR>
;;; where LDC_DIR contains LDC2013S03.


% ./build.sh /path/to/LDC/data/
[INFO] Done. Output: spk2gender utt2yage utt2spk spk2yage wav.scp
%
```




#### 2. Assembly of FishBoardMix.

##### Consolidate files:
```
% cd staging/
% ./build.sh
FSH/spk2gender	MIX6/spk2gender  SWB/spk2gender
FSH/spk2yage  MIX6/spk2yage  SWB/spk2yage
FSH/utt2yage  MIX6/utt2yage  SWB/utt2yage
FSH/utt2spk  MIX6/utt2spk  SWB/utt2spk
FSH/wav.scp  MIX6/wav.scp  SWB/wav.scp
   14826 spk2gender
   14826 spk2yage
   59108 utt2yage
   59108 utt2spk
   59108 wav.scp
  206976 total
done!.
```

##### Partition FishBoardMix:

For the v18to70 version, run `v18to70/build.sh`. Modify this script to create any other version.

```
% cd v18to70
% ./build.sh ../staging/

  14195 train/spk2gender
  14195 train/spk2yage
  53834 train/utt2spk
  53834 train/utt2yage
  53834 train/wav.scp
 189892 total

   318 eval/spk2gender
   318 eval/spk2yage
  2712 eval/utt2spk
  2712 eval/utt2yage
  2712 eval/wav.scp
  8772 total

   313 dev/spk2gender
   313 dev/spk2yage
  2562 dev/utt2spk
  2562 dev/utt2yage
  2562 dev/wav.scp
  8312 total

done!
%
```
