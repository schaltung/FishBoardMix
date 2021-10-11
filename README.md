# FishBoardMix


## Getting Started

#### 1. Staging the individual corpora.
Go to `staging/` and build each individual corpus by running its own `build.sh` script.

Each `build.sh` script requires one argument: the path to a folder containing the original LDC corpora needed.


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
% cd v18to70/
% ./build.sh ../staging/

  14195 train/spk2gender
  14195 train/spk2yage
  54022 train/utt2spk
  54022 train/utt2yage
  54022 train/wav.scp
 190456 total
23e3d406c1d812161dc8a2e33e9ce482  train/spk2gender
30b5abaad6df709a28233a2112ea6cf1  train/spk2yage
0a96921b2fab22c5aaed7cb61e757c13  train/utt2spk
067cb49845652549703dbfc3bd430bcd  train/utt2yage
de85481070df08a5b385aab1a979554a  train/wav.scp

   318 eval/spk2gender
   318 eval/spk2yage
  2273 eval/utt2spk
  2273 eval/utt2yage
  2273 eval/wav.scp
  7455 total
ae7a14a64e75a4c96cc21dceb10deb17  eval/spk2gender
66d54268fd4f0b884a706d079c077a96  eval/spk2yage
0ed49cd8a4c9a17797dd22ad8a57bab6  eval/utt2spk
ba1bbba6d6f1aa47c319f7874ea62519  eval/utt2yage
410e9f2ba3afe7f7dfb0e3b137aca58a  eval/wav.scp

   313 dev/spk2gender
   313 dev/spk2yage
  2813 dev/utt2spk
  2813 dev/utt2yage
  2813 dev/wav.scp
  9065 total
262a7c38209361613281caad9efbae30  dev/spk2gender
56580ce8d2efaf5ca865377cb3eb1e83  dev/spk2yage
969f91c82ad8a075680af6231f487dd6  dev/utt2spk
86aff46edfeeb9d6b41b92115abeac1f  dev/utt2yage
db8182b9f10090f9f7c44ac54f9eeadd  dev/wav.scp

done!
%
```
