#!/bin/bash
export PYTHONPATH="$(pwd)"

# args: [model name] [lr] [wd]
eval_blindness() {
  hp_policy="$PWD/schedules/rcifar10_16_wrn.txt"
  local_dir="$PWD/results/"
  data_path="$PWD/datasets/blindness"

  size=2564
  dataset="blindness"
  name="eval_blindness_$1" # has 8 cutout size

  python pba/train.py \
    --local_dir "$local_dir" --data_path "$data_path" \
    --model_name "$1" --dataset "$dataset" \
    --train_size "$size" --val_size 0 \
    --checkpoint_freq 25 --gpu 1 --cpu 2 \
    --use_hp_policy --hp_policy "$hp_policy" \
    --hp_policy_epochs 200 \
    --aug_policy cifar10 --name "$name" \
    --lr "$2" --wd "$3"
}

if [ "$@" = "wrn_28_10" ]; then
  eval_blindness wrn_28_10 0.1 0.0005
elif [ "$@" = "ss_32" ]; then
  eval_blindness shake_shake_32 0.01 0.001
elif [ "$@" = "ss_96" ]; then
  eval_blindness shake_shake_96 0.01 0.001
elif [ "$@" = "ss_112" ]; then
  eval_blindness shake_shake_112 0.01 0.001
elif [ "$@" = "pyramid_net" ]; then
  eval_blindness pyramid_net 0.05 0.00005
else
  echo "invalid args"
fi
