#!/bin/bash
#SBATCH --partition=large
#SBATCH --job-name="multinode_job"
#SBATCH --nodes=1
#SBATCH --tasks-per-node=16
#SBATCH --cpus-per-task=1
#SBATCH --time=5-00:00:00
#SBATCH --account="classes"
#SBATCH --output="multinode_job.o"
#SBATCH --error="multinode_job.e"
#SBATCH --mem=2000mb
#SBATCH --constraint=intel

# load the NAMD module
module load apps/namd/3.0b6

# set home directory
HOMEDIR=$(pwd)
# set scratch directory
SCRATCHDIR=/scratch/$SLURM_JOBID

equi_prefix=step4_equilibration

# go to home directory
cd ${HOMEDIR}

# create scratch directory
rm -rf ${SCRATCHDIR}; mkdir -p ${SCRATCHDIR}

# copy files for running simulations over to scratch directory
cp -r step3_input.psf step3_input.pdb ../step3_pbcsetup.str toppar restraints ${SCRATCHDIR}

# edit the default step3_pbcsetup.str path
sed "s|\.\./||g" ${HOMEDIR}/${equi_prefix}.inp > ${SCRATCHDIR}/${equi_prefix}.inp

# Running equilibration step
namd3 +auto-provision ${SCRATCHDIR}/${equi_prefix}.inp > ${SCRATCHDIR}/${equi_prefix}.out

# copy files back to home directory
cp ${SCRATCHDIR}/${equi_prefix}* ${HOMEDIR}

# go to home directory
cd ${HOMEDIR}

# delete scratch directory and its contents
rm -rf ${SCRATCHDIR}

