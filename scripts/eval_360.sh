#!/bin/bash

SCENE=counter
EXPERIMENT=360_v2/"$SCENE"
DATA_ROOT=data/360_v2
DATA_DIR="$DATA_ROOT"/"$SCENE"

accelerate launch eval.py \
  --gin_configs=configs/360.gin \
  --gin_bindings="Config.data_dir = '${DATA_DIR}'" \
  --gin_bindings="Config.poses_dir = 'data/360_v2/${SCENE}'" \
  --gin_bindings="Config.exp_name = '${EXPERIMENT}'" \
  --gin_bindings="Config.factor = 4" \
  --gin_bindings="Config.render_chunk_size = 8192" 
