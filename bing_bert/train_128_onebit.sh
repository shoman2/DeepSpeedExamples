#!/bin/bash

base_dir=`pwd`
local_dir=/cl
nfs_dir=/home/conglli
th_dir=/turing-hdd/users/conglli
ts_dir=/turing-ssd/users/conglli

# Where should we save checkpoints and tensorboard events?
JOB_NAME=$1
CONFIG_NAME=$2
#OUTPUT_DIR=${base_dir}/bert_model_outputs
#OUTPUT_DIR=${local_dir}/bert_model_outputs
#OUTPUT_DIR=${nfs_dir}/bert_model_outputs
#OUTPUT_DIR=${th_dir}/bert_model_outputs
OUTPUT_DIR=${ts_dir}/bert_model_outputs

mkdir -p $OUTPUT_DIR

NCCL_TREE_THRESHOLD=0 deepspeed --launcher=openmpi ${base_dir}/deepspeed_train.py \
--cf ${base_dir}/bert_large_lamb.json \
--max_seq_length 128 \
--output_dir $OUTPUT_DIR \
--deepspeed_mpi \
--deepspeed \
--deepspeed_transformer_kernel \
--print_steps 100 \
--lr_schedule "EE" \
--lr_offset 10e-4 \
--job_name $JOB_NAME \
--deepspeed_config ${base_dir}/${CONFIG_NAME}.json \
--data_path_prefix /turing-ssd/users/conglli/bert_data \
--ckpt_to_save 150 \
&> $OUTPUT_DIR/${JOB_NAME}.log
#--ckpt_to_save 150 \
