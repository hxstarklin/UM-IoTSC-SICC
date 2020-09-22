#!/bin/bash
#SBATCH --job-name              testing
#SBATCH --time                  24:00:00
#SBATCH --gpus                  1
#SBATCH --output                output.txt

bash scripts.sh
