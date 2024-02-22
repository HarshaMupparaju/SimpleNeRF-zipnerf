#!/bin/bash

EXP_NUM=7152
SET_NUM=04
SPARSE_DEPTH_SET_NUM=24

# declare -a scenes=("bonsai" "counter" "garden" "kitchen" "room" "stump")
# declare -a scenes=("bicycle" "bonsai" "kitchen")
declare -a scenes=("bonsai")
for SCENE in "${scenes[@]}"
do

  EXPERIMENT="$EXP_NUM"/"$SCENE"
  DATA_ROOT=data/"$i"

  #Training
    # rm exp/"$EXPERIMENT"/*
  accelerate launch train.py --gin_configs=configs/360.gin \
    --gin_bindings="Config.camera_data_dir = 'data/MipNeRF360/360_v2/${SCENE}'" \
    --gin_bindings="Config.data_dir = 'data/MipNeRF360/all/database_data/${SCENE}'" \
    --gin_bindings="Config.exp_name = '${EXPERIMENT}'" \
    --gin_bindings="Config.scene_name = '${SCENE}'" \
    --gin_bindings="Config.sparse_depth_dir = 'data/MipNeRF360/all/estimated_depths/DEL001_DE${SPARSE_DEPTH_SET_NUM}/${SCENE}'" \
    --gin_bindings="Config.train_test_split_dir = 'data/MipNeRF360/train_test_sets/set${SET_NUM}'" \
    --gin_bindings="Config.sparse_depth_batch_size = 2048" \
    --gin_bindings="Config.factor = 4" \
    --gin_bindings="Config.batch_size = 8192" \
    --gin_bindings="Config.render_chunk_size = 8192" 

  #Rendering 

  accelerate launch render.py \
    --gin_configs=configs/360.gin \
    --gin_bindings="Config.camera_data_dir = 'data/MipNeRF360/360_v2/${SCENE}'" \
    --gin_bindings="Config.data_dir = 'data/MipNeRF360/all/database_data/${SCENE}'" \
    --gin_bindings="Config.exp_name = '${EXPERIMENT}'" \
    --gin_bindings="Config.scene_name = '${SCENE}'" \
    --gin_bindings="Config.train_test_split_dir = 'data/MipNeRF360/train_test_sets/set${SET_NUM}'" \
    --gin_bindings="Config.render_path = True" \
    --gin_bindings="Config.render_path_frames = 120" \
    --gin_bindings="Config.render_video_fps = 15" \
    --gin_bindings="Config.factor = 4" \
    --gin_bindings="Config.render_chunk_size = 8192" 

  #Evaluation
  accelerate launch eval.py \
    --gin_configs=configs/360.gin \
    --gin_bindings="Config.camera_data_dir = 'data/MipNeRF360/360_v2/${SCENE}'" \
    --gin_bindings="Config.data_dir = 'data/MipNeRF360/all/database_data/${SCENE}'" \
    --gin_bindings="Config.train_test_split_dir = 'data/MipNeRF360/train_test_sets/set${SET_NUM}'" \
    --gin_bindings="Config.exp_name = '${EXPERIMENT}'" \
    --gin_bindings="Config.scene_name = '${SCENE}'" \
    --gin_bindings="Config.factor = 4" \
    --gin_bindings="Config.render_chunk_size = 8192"
  
done


