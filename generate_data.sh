#!/bin/bash

# Set default values for variables
VISIBLE_DEVICE=${VISIBLE_DEVICE:-1}
MODEL=${MODEL:-meta-llama/Llama-3.1-8B-Instruct}
PORT=${PORT:-8001}
DATA_PATH=${DATA_PATH:-data/math/train.jsonl}
ENV=${ENV:-math}
LOG_DIR=${LOG_DIR:-log/math/}
MAX_TURNS=${MAX_TURNS:-2}
NUM_OF_SAMPLES=${NUM_OF_SAMPLES:-1 16}
MODELS=${MODELS:-meta-llama/Llama-3.1-8B-Instruct meta-llama/Llama-3.1-8B-Instruct}

# Start the server
CUDA_VISIBLE_DEVICES=$VISIBLE_DEVICE vllm serve $MODEL --enable_prefix_caching --port $PORT &

# Get the PID of the server process
SERVER_PID=$!

# Function to stop the server
function stop_server {
    kill $SERVER_PID
}

# Trap to ensure the server is stopped when the script exits
trap stop_server EXIT

sleep 60

# Run the Python program
python workflow_gen.py --controller_address $PORT \
    --data_path $DATA_PATH \
    --env $ENV \
    --log_dir $LOG_DIR \
    --max_turns $MAX_TURNS \
    --num_of_samples $NUM_OF_SAMPLES \
    --models $MODELS

# Stop the server
stop_server