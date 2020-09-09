# SICC-DGX2: Slurm Job Scheduler Quick User Guide


## About Slurm

Slurm is a resource manager and job scheduler. Through Slurm, users submit jobs that are scheduled and allocated resources (CPU time, memory, GPU, etc.) to run in the computing cluster. Please record your job submission [here](https://forms.office.com/Pages/ResponsePage.aspx?id=RuzudkD-G06rQh1tn5G4qWXKXvHUnFVFuBJG5SUPRN9UMU0zR1VSMzlNQUVIWjExR0lCU0hXWEtaNS4u).

## Rules

 - Every account can only have 1 job submitted at the same time.
 - Every job can only use up to 4 GPUs
 - The running time for every job should be <= 48 hours
 - Every job submitted should be recorded first [here](https://forms.office.com/Pages/ResponsePage.aspx?id=RuzudkD-G06rQh1tn5G4qWXKXvHUnFVFuBJG5SUPRN9UMU0zR1VSMzlNQUVIWjExR0lCU0hXWEtaNS4u)
 - **If you do not follow the rules, the IoTSC-SICC operators might cancel your job without notification.**

Important parameters:

| Parameter | Name |
| ------ | ------ |
| Cluster | SICC-DGX2 |
| Job Submit | mgmt |
| GPU compute nodes | DGX2 |

## Login to submit jobs

    $ ssh username@10.113.178.130 

## Run one task in compute node (Must submit jobs through Slurm):

    $ srun --gres=gpu:1   // allocate 1 GPU and invoke a shell directly
    $ srun --time=5    // time limitation

## Run commands in an interactive allocation:

    $ salloc --gres=gpu:1       // request one GPU  
    salloc: Pending job allocation 12332
    salloc: job 12332 queued and waiting for resources
    blocks here until job runs

    salloc: job 12332 has been allocated resources
    salloc: Granted job allocation 12332

    $ srun hostname

    $ srun nvidia-smi 

    $ srun --pty bash   // run a shell in compute node
    compute-node$   hostname
    compute-node$   nvidia-smi
    compute-node$   exit

    $ exit
    exit
    salloc: Relinquishing job allocation 12332
    salloc: Job allocation 12332 has been revoked.

Once the job starts and the prompt shows up, further commands can be run on the allocated resources until `exit` is invoked.

## Create a batch job script and submit the job:

    sjob.sh:
    -------------------------------------------------
    #!/bin/bash
    #SBATCH --job-name=GroupN_jobname
    #SBATCH --output=/your_home_directory/ouput.txt
    #SBATCH --nodelist=gpu01 # if you need to run job in a specify node
    #SBATCH --gres=gpu:1
    #SBATCH --time=5

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

    # source your environment
    source activate myenv

    # your program goes below
    ## Below is the commands to run, for this example,
    ## Create a sample helloworld.py and Run the sample python file 
    ## Results are stored at the --output file above
    echo "print('Hello world')">>helloworld.py
    python helloworld.py

    -------------------------------------------------

    $ sbatch sjob.sh             //submit the job
    Submitted batch job 123123

## Create your environment:

Create your own environment, for example: using anaconda virtual environment.

## List the jobs running/pending in the queue:

    $ squeue

## Cancel a job, whether it is pending in the queue or running:

    $ scancel "job_ID"

## Display the queues available

    $ sinfo

More information: 
https://slurm.schedmd.com
https://slurm.schedmd.com/documentation.html