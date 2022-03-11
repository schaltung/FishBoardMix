# FishBoardMix corpus for Speaker Age Estimation

##### Table of Contents  
* [About](#about)  
* [Requirements](#requirements)  
* [Getting Started with FishBoardMix](#getting-started)
  * [Step by Step Example](#step-by-step-example)
* [Related Corpora](#related-corpora-for-speaker-age-estimation)
  * [VoxCeleb](#voxceleb)
  * [SRE08/10](#sre0810)

-------

## About

The FishBoardMix corpus is designed to explore Speaker-Age estimation technology.
Motivated by the improvements brought by the team behind the [Age-VoxCeleb](#voxceleb) project, FishBoardMix includes a large number of speakers with a relatively balanced age/gender coverage.
It combines audio and meta-data from 3 popular LDC corpora: Fisher, Mix6 and Switchboard; where participants have provided their gender and age.

Despite data preparation being a time consuming and tedious task, it is essential for the reproducibility of experimental research.
This project contains the scripts necessary to assemble the FishBoardMix corpus from original copies of LDC corpora, publicly available from [LDC portal](https://www.ldc.upenn.edu/).


\  | FSH | SWB | MIX6 | Tot
--- | --- | --- | --- | ---
\# Speakers (f, m) | 11606 (6712, 4894) | 2631 (1431, 1200) | 589 (300, 289) | 14826 (8443, 6383)
Recordings | 22320 | 28012 | 8776 | 59108

The FishBoardMix corpus consists of 59k recordings from 14.8k age-labeled speakers, 8.4k female and 6.4k male. 
These recordings are 249 seconds long on average.



[↑top](#fishboardmix-corpus-for-speaker-age-estimation)


### Known caveats and work-arounds

Call recordings from the Fisher corpus were initiated by an automated dial-up platform, therefore the identity of speakers picking up these calls may or may not match the subjects who actually registered with LDC. 
In order to mitigate this inconsistency, FishBoardMix makes use of the _manual audit files_ included in Fisher to discard any subject with conflicting meta-data.



[↑top](#fishboardmix-corpus-for-speaker-age-estimation)


## Requirements
Corpus | LDC Catalog No.
--- | ---
Fisher | [LDC2004T19](https://catalog.ldc.upenn.edu/LDC2004T19),[LDC2004S13](https://catalog.ldc.upenn.edu/LDC2004S13),[LDC2005T19](https://catalog.ldc.upenn.edu/LDC2005T19),[LDC2005S13](https://catalog.ldc.upenn.edu/LDC2005S13).
Switchboard | [LDC98S75](https://catalog.ldc.upenn.edu/LDC98S75),[LDC99S79](https://catalog.ldc.upenn.edu/LDC99S79),[LDC2002S06](https://catalog.ldc.upenn.edu/LDC2002S06),[LDC2001S13](https://catalog.ldc.upenn.edu/LDC2001S13),[LDC2004S07](https://catalog.ldc.upenn.edu/LDC2004S07).
MIX6 | [LDC2013S03](https://catalog.ldc.upenn.edu/LDC2013S03).

Must download, unpack and place (a symlink to) these folders in one directory.

[↑top](#fishboardmix-corpus-for-speaker-age-estimation)

----------
## Getting Started

This data preparation task creates several list-files with information relevant to conduct experiments for Speaker-Age estimation.
This task is split into three steps.

1. Process each individual corpus creating 5 list: `spk2gender`, `utt2yage`, `utt2spk`, `spk2yage`, `wav.scp`.
2. Aggregate the list files.
3. Partition into Train, Eval and Dev randomly ensuring speakers .



[↑top](#fishboardmix-corpus-for-speaker-age-estimation)


### Step by Step Example

#### 1. Process each individual corpus.
Individually go to `FishBoardMix/staging/SWB`, `FishBoardMix/staging/FSH` and `FishBoardMix/staging/MIX6`, and run the `build.sh` scripts included.

Run the `build.sh` script without arguments to see the help message:
```
% cd FishBoardMix/staging/SWB
% ./build.sh 
USAGE:
 ./build.sh <LDC_DIR>
;;; where LDC_DIR contains LDC98S75 LDC99S79 LDC2002S06 LDC2001S13 LDC2004S07.

% $ ls -ld /path/to/LDC/swb/*
/path/to/LDC/swb/LDC98S75
/path/to/LDC/swb/LDC99S79
/path/to/LDC/swb/LDC2002S06
/path/to/LDC/swb/LDC2001S13
/path/to/LDC/swb/LDC2004S07

% ./build.sh /path/to/LDC/swb
[INFO] Done. Output: spk2gender utt2yage utt2spk spk2yage wav.scp
%
```

```
% cd FishBoardMix/staging/FSH
% ./build.sh 
USAGE:
 ./build.sh <LDC_DIR>
;;; where LDC_DIR contains LDC200{4,5}T19 and LDC200{4,5}S13.

% $ ls -ld /path/to/LDC/fsh/*
/path/to/LDC/fsh/LDC2004T19
/path/to/LDC/fsh/LDC2005T19
/path/to/LDC/fsh/LDC2004S13
/path/to/LDC/fsh/LDC2005S13


% ./build.sh /path/to/LDC/fsh
[INFO] LDC_DIR: /path/to/LDC/fsh
[INFO] Fisher pindata.tbl: /path/to/LDC/fsh/LDC2004T19/fe_03_p1_tran/doc/fe_03_pindata.tbl
[INFO] Fisher pindata.tbl: /path/to/LDC/fsh/LDC2005T19/fe_03_p2_tran/doc/fe_03_pindata.tbl
[INFO]     spk2yage    (1/5) [done]
[INFO]     spk2gender  (2/5) [done]
[INFO]     utt2spk     (3/5) [done]
[INFO]     utt2yage    (4/5) [done]
[INFO]     wav.scp     (5/5) [done]
[INFO] Done. Output: spk2gender utt2yage utt2spk spk2yage wav.scp
%
```


```
% cd FishBoardMix/staging/MIX6
% ./build.sh 
USAGE:
 ./build.sh <LDC_DIR>
;;; where LDC_DIR contains LDC2013S03.

% $ ls -ld /path/to/LDC/mix/*
/path/to/LDC/mix/LDC2013S03

% ./build.sh /path/to/LDC/mix/
[INFO] Done. Output: spk2gender utt2yage utt2spk spk2yage wav.scp
%
```

[↑top](#fishboardmix-corpus-for-speaker-age-estimation)

#### 2. Aggregate.

Consolidate files:

```
% cd FishBoardMix/staging/
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
[↑top](#fishboardmix-corpus-for-speaker-age-estimation)



#### 3. Partitions.

Since there is no single "correct" way to split the data, FishBoardMix supports multiple versions of the partitioning.
The default (and currently only) parition is `v18to70-2203`, however, the scripts that generate this parition can be easily modified to create custom ones.

```
% cd v18to70-2203/
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
[↑top](#fishboardmix-corpus-for-speaker-age-estimation)

----------
# Related corpora for Speaker Age Estimation

## VoxCeleb

### Age-VOX-Celeb
With nearly 5k speakers and 168k clips from 22k videos, Age-VOX-Celeb is the largest _freely available_ corpus labeled for age estimation. The age labels were obtained from multiple data sources.
* GITHUB Repository: [AgeVoxCeleb](https://github.com/nttcslab-sp/agevoxceleb)
* Article: [Age-VOX-Celeb: Multi-Modal Corpus for Facial and Speech Estimation. Tawara et al.](https://ieeexplore.ieee.org/abstract/document/9414272)

### VoxCeleb Enrichment for Age and Gender Recognition
This is a closely related corpus independently done that automates the annotation of age labels more liberally than [Age-VOX-Celeb](#age-vox-celeb).
* GITHUB Repository: [VoxCelebEnrichment](https://github.com/hechmik/voxceleb_enrichment_age_gender)
* Article: [VoxCeleb Enrichment for Age and Gender Recognition. Hechmi, et al.](https://arxiv.org/abs/2109.13510)

## SRE08/10
This corpus has been used in recent years, however, its small number of speakers (1658) and unbalanced distribution across age groups renders it for limited use.
Refer to Table 1 in [this article](https://ieeexplore.ieee.org/abstract/document/9414272) for an enlightening review of corpora available for research on age estimation.

[↑top](#fishboardmix-corpus-for-speaker-age-estimation)
