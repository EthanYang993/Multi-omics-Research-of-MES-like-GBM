## inputs
f_loom_grn=input/mc_mat_for_step1.loom
f_loom_aucell=input/raw_count_mat_for_step3.loom

## outputs
grn_output=output/s1_adj.tsv
ctx_output=output/s2_reg.tsv
aucell_output=output/s3_aucell.loom

## create output folder
mkdir output

## reference
f_tfs=/media/work_data/pySCENIC_rescource/human/hsa_hgnc_tfs.txt
f_motif_path=/media/work_data/pySCENIC_rescource/human/motifs-v9-nr.hgnc-m0.001-o0.0.tbl
f_db_names=`find /media/work_data/pySCENIC_rescource/human/ -name "hg38*.feather"`

#### 1. build GRN
arboreto_with_multiprocessing.py \
$f_loom_grn \
$f_tfs \
--method grnboost2 \
--output $grn_output \
--num_workers 28 \
--seed 777


#### 2. cisTarget
pyscenic ctx \
$grn_output \
$f_db_names \
--annotations_fname $f_motif_path \
--expression_mtx_fname $f_loom_grn \
--output $ctx_output \
--num_workers 28


#### 3. AUCell

## set TMPDIR to current path, in case of no enough disk space on /tmp/
export TMPDIR=`pwd`

pyscenic aucell \
$f_loom_aucell \
$ctx_output \
--output $aucell_output \
--num_workers 28 \
--seed 777
