# FishBoardMix corpus for Speaker Age Estimation

##### Table of Contents  
* [About](#about)  
* [Requirements](#requirements)  
* [Related Corpora](#related-corpora-for-speaker-age-estimation)
  * [VoxCeleb](#voxceleb)
  * [SRE08/10](#sre0810)
* [Getting Started with FishBoardMix](#getting-started)  


## About

The FishBoardMix is a corpus designed to study Speaker-Age estimation technology.
Motivated by the improvements and lessons learned in [Age-VoxCeleb](#voxceleb), this corpus has a large number of speakers with a relatively balanced age-coverage.
It combines audio and meta-data from 3 popular LDC corpora: Fisher, Mix6 and Switchboard; where participants have provided their gender and age.

While data preparation is a time consuming and often tedious task, it is essential for the reproducibility of experimental research.
This project contains the scripts necessary to assemble the FishBoardMix corpus from original copies of LDC corpora, publicly available from [LDC portal](https://www.ldc.upenn.edu/).



\  | FSH | SWB | MX6 | Tot
--- | --- | --- | --- | ---
\# Speakers (f, m) | 11606 (6712, 4894) | 2631 (1431, 1200) | 589 (300, 289) | 14826 (8443, 6383)
Recordings | 22320 | 28012 | 8776 | 59108

The FishBoardMix corpus consists of 59k recordings from 14.8k age-labeled speakers, 8.4k female and 6.4k male. 
The recordings from FishBoardMix are 249 seconds long on average.



[↑top](#fishboardmix-corpus-for-speaker-age-estimation)


### Known caveats and work-arounds

Call recordings from the Fisher corpus were initiated by the LDC automated dial-up platform, therefore speakers picking up these calls may or may not be the subjects who actually registered with LDC. 
In order to mitigate this inconsistency, the manual audit files included in Fisher helped to discard any subject with conflicting meta-data.



[↑top](#fishboardmix-corpus-for-speaker-age-estimation)


# Requirements
Corpus | LDC Catalog No.
--- | ---
Fisher | [LDC2004T19](https://catalog.ldc.upenn.edu/LDC2004T19),[LDC2004S13](https://catalog.ldc.upenn.edu/LDC2004S13),[LDC2005T19](https://catalog.ldc.upenn.edu/LDC2005T19),[LDC2005S13](https://catalog.ldc.upenn.edu/LDC2005S13).
Switchboard | [LDC98S75](https://catalog.ldc.upenn.edu/LDC98S75),[LDC99S79](https://catalog.ldc.upenn.edu/LDC99S79),[LDC2002S06](https://catalog.ldc.upenn.edu/LDC2002S06),[LDC2001S13](https://catalog.ldc.upenn.edu/LDC2001S13),[LDC2004S07](https://catalog.ldc.upenn.edu/LDC2004S07).
MIX6 | [LDC2013S03](https://catalog.ldc.upenn.edu/LDC2013S03).

Must download, unpack and place (a symlink to) these folders in one directory.

[↑top](#fishboardmix-corpus-for-speaker-age-estimation)

## Getting Started

This data preparation task creates several list-files with information relevant to conduct experiments for Speaker-Age estimation.
This task is split into two steps.

#### Step1: Process each individual corpus.

Data preparation creates the following 5 files for each of the 3 corpora: FSH, SWB and MIX6.

* `spk2gender`: it maps speaker-id to the gender label provided.
* `utt2yage`: it maps the recording-id to the age label in years provided.
* `utt2spk`: it maps the recording-id to the speaker-id.
* `spk2yage`: it maps the speaker-id to the age label in years provided.
* `wav.scp`: it maps the recording id to a read-specifier of the wav file (Kaldi style).

#### Step2: Aggregate.
The step simply concatenates to unify the list files above.


[↑top](#fishboardmix-corpus-for-speaker-age-estimation)


### An Illustrative Example.

#### 1. Process each individual corpus.
Individually go to `staging/SWB`, `staging/FSH` and `staging/MIX6`, and run the `build.sh` script.

Run the `build.sh` script without arguments to see the help message:
```
% cd staging/SWB
% ./build.sh 
USAGE:
 ./build.sh <LDC_DIR>
;;; where LDC_DIR contains LDC98S75 LDC99S79 LDC2002S06 LDC2001S13 LDC2004S07.

% $ ls -ld /path/to/LDC/data1/*
/path/to/LDC/data1/LDC98S75
/path/to/LDC/data1/LDC99S79
/path/to/LDC/data1/LDC2002S06
/path/to/LDC/data1/LDC2001S13
/path/to/LDC/data1/LDC2004S07

% ./build.sh /path/to/LDC/data1
[INFO] Done. Output: spk2gender utt2yage utt2spk spk2yage wav.scp
%
```

```
% cd staging/FSH
% ./build.sh 
USAGE:
 ./build.sh <LDC_DIR>
;;; where LDC_DIR contains LDC200{4,5}T19 and LDC200{4,5}S13.

% $ ls -ld /path/to/LDC/data2/*
/path/to/LDC/data2/LDC2004T19
/path/to/LDC/data2/LDC2005T19
/path/to/LDC/data2/LDC2004S13
/path/to/LDC/data2/LDC2005S13


% ./build.sh /path/to/LDC/data2
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

% $ ls -ld /path/to/LDC/data3/*
/path/to/LDC/data3/LDC2013S03

% ./build.sh /path/to/LDC/data3/
[INFO] Done. Output: spk2gender utt2yage utt2spk spk2yage wav.scp
%
```

[↑top](#fishboardmix-corpus-for-speaker-age-estimation)

#### 2. Aggregate.

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
[↑top](#fishboardmix-corpus-for-speaker-age-estimation)



### Partitions



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
[↑top](#fishboardmix-corpus-for-speaker-age-estimation)


# Related corpora for Speaker Age Estimation

## VoxCeleb

### Age-VOX-Celeb
With nearly 5k speakers and 168k clips from 22k videos, Age-VOX-Celeb is the largest _freely available_ corpus labeled for age estimation. The age labels were obtained from multiple data sources.
* GITHUB Repository: [AgeVoxCeleb](https://github.com/nttcslab-sp/agevoxceleb)
* Article: [Age-VOX-Celeb: Multi-Modal Corpus for Facial and Speech Estimation. Tawara et al.](https://ieeexplore.ieee.org/abstract/document/9414272)


### VoxCeleb Enrichment for Age and Gender Recognition
This is a closely related corpus independently done by automating the annotation of age labels with a more liberal method.
* GITHUB Repository: [VoxCelebEnrichment](https://github.com/hechmik/voxceleb_enrichment_age_gender)
* Article: [VoxCeleb Enrichment for Age and Gender Recognition. Hechmi, et al.](https://arxiv.org/abs/2109.13510)


## SRE08/10
This corpus has been used in recent years, however, its small number of speakers (1658) and unbalanced distribution across age groups renders it for limited use.
Refer to Table 1 in [this article](https://ieeexplore.ieee.org/abstract/document/9414272) for an enlightening review of corpora available for research on age estimation.


[↑top](#fishboardmix-corpus-for-speaker-age-estimation)


