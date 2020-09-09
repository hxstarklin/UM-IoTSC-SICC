#!/bin/bash
#SBATCH --job-name              GroupN_jobname
#SBATCH --time                  48:00:00
#SBATCH --gpus                  4
#SBATCH --output                /your_home_directory/ouput.txt
#SBATCH --error                 /your_home_directory/error.txt

# asks SLURM to send the USR1 signal 120 seconds before end of the time limit
#SBATCH --signal=B:USR1@120

# define the handler function
# note that this is not executed here, but rather
# when the associated signal is sent
your_cleanup_function()
{
    echo "function your_cleanup_function called at $(date)"
    # do whatever cleanup you want here
    pkill -u your_username
}
# call your_cleanup_function once we receive USR1 signal
trap 'your_cleanup_function' USR1

bash scripts.sh
