# Host model with vllm
```python
vllm serve meta-llama/Llama-3.1-8B-Instruct --enable_prefix_caching --port 8001
```

# Run data collection
```python
python workflow_gen.py \
    --controller_address 8001 \
    --data_path data/math/train.jsonl \
    --env math \
    --log_dir log/math/ \
    --max_turns 2 \
    --num_of_samples 1 16 \
    --models meta-llama/Llama-3.1-8B-Instruct meta-llama/Llama-3.1-8B-Instruct
```