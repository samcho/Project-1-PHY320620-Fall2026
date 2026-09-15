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
prod_prefix=step5_production
prod_step=step5

# Running production for 10 nanoseconds
cnt=1
cntmax=30

while [[ ${cnt} -le ${cntmax} ]]; do

    # go to home directory
    cd ${HOMEDIR}

    # create scratch directory
    mkdir -p ${SCRATCHDIR}


    # create appropriate input file using ${prod_prefix}.inp as template
    if [[ ${cnt} -eq 1 ]]; then
        outputname="${prod_step}_${cnt}"
        # change only the output name
        sed "s/${prod_prefix}/${outputname}/g" ${HOMEDIR}/${prod_prefix}.inp > ${SCRATCHDIR}/${prod_step}_run.inp
	
	# copy files for running simulations over to scratch directory
	cp -r step3_input.psf step3_input.pdb step4_equilibration.coor step4_equilibration.vel step4_equilibration.xsc toppar ${SCRATCHDIR}

    else
        cntprev=$((cnt - 1))
        inputname="${prod_step}_${cntprev}"
        outputname="${prod_step}_${cnt}"
        # change input and output names from template file
        sed "s/${equi_prefix}/${inputname}/g" ${HOMEDIR}/${prod_prefix}.inp | \
            sed "s/${prod_prefix}/${outputname}/g" > ${SCRATCHDIR}/${prod_step}_run.inp

	# copy files for running simulations over to scratch directory
	cp -r step3_input.psf step3_input.pdb ${inputname}.coor ${inputname}.vel ${inputname}.xsc toppar ${SCRATCHDIR}

    fi

    # run the simulation for 1 nanosecond
    namd3 +auto-provision ${SCRATCHDIR}/${prod_step}_run.inp > ${SCRATCHDIR}/${outputname}.out

    # copy files back to home directory
    cp ${SCRATCHDIR}/${outputname}* ${HOMEDIR}

    # go to home directory
    cd ${HOMEDIR}

    # delete scratch directory and its contents
    rm -rf ${SCRATCHDIR}
    
    cnt=$((cnt + 1))
done

