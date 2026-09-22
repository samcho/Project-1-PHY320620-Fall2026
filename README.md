# Project 1: MD Simulations of TCF4 Variants in Pitt-Hopkins Syndrome

## Motivation & Background

**Pitt-Hopkins Syndrome (PTHS)** is a rare neurodevelopmental disorder characterized by intellectual disability, developmental delay, distinct facial features, and autonomic nervous system dysfunction (such as hyperventilation followed by apnea). 

PTHS is caused by haploinsufficiency, point mutations, or deletions in the **TCF4** gene (Transcription Factor 4). TCF4 is a basic helix-loop-helix (bHLH) transcription factor that forms homodimers or heterodimers to bind specific DNA sequences (E-boxes) and regulate genes vital for brain development and neuronal maturation.

Pathogenic missense mutations often target the bHLH domain, disrupting either DNA binding affinity or dimerization stability.

In this practical, we will study the structural dynamics of the TCF4 bHLH region using experimental coordinates resolved by [[**Yang et al. (*Nucleic Acids Research*, 2019)**]](https://academic.oup.com/nar/article/47/16/8375/5488531?login=true):

> **Reference:** Yang, J., et al. (2019). Structural basis for preferential binding of human TCF4 to DNA containing 5-carboxylcytosine. *Nucleic Acids Research*, 47(16), 8375–8387.  
> **PDB ID:** **[6OD3](https://www.rcsb.org/structure/6OD3), [6OD4](https://www.rcsb.org/structure/6OD4), [6OD5](https://www.rcsb.org/structure/6OD)** *(TCF4 bHLH domain bound to E-box DNA)*

## Assigned PDB Structures:
* Tanor Andre: [6OD3](https://www.rcsb.org/structure/6OD3) (Biological Assembly 1)
* Luna Basnet: [6OD3](https://www.rcsb.org/structure/6OD3) (Biological Assembly 2)
* Jayrus Hurdle: [6OD4](https://www.rcsb.org/structure/6OD4) (Biological Assembly 1)
* Grace Miller: [6OD3](https://www.rcsb.org/structure/6OD3) R576W mutant (Biological Assembly 1)
* Gabby Tamayo: [6OD3](https://www.rcsb.org/structure/6OD3) R576W mutant (Biological Assembly 2)
* Bohao Wang: [6OD4](https://www.rcsb.org/structure/6OD4) R576W mutant (Biological Assembly 1)

Using Molecular Dynamics (MD) simulations, we can analyze the structural stability, hydrogen-bonding networks, and dynamic behavior of wild-type and mutant TCF4-DNA complexes at atomistic resolution.

---

## Prerequisites & Requirements
* An active account on the DEAC cluster.
* Access to a web browser (for CHARMM-GUI and the RCSB PDB).
* An SSH client / terminal to access the cluster.
* Access to class [DEAC OnDemand Dashboard](https://phy320.deac.wfu.edu/pun/sys/dashboard).
* A file transfer tool (e.g., `scp`, [FileZilla](https://filezilla-project.org/)) to upload/download files to the cluster.

---

## Part 1 Instructions

### Step 0: Create an account on Github and clone this repository
1. Go to the [Github](https://github.com/) website and create an account.
2. Use an SSH client / terminal to log into the DEAC cluster using your username (same as your email before @wfu.edu):
    ```bash
    ssh -Y [username]@artemis.deac.wfu.edu
3. Go to your directory and clone this repository:
    ```bash
    cd /deac/phy/classes/phy320-fa-2026/[username]
    git clone https://github.com/samcho/Project-1-PHY320620-Fall2026.git
    cd Project-1-PHY320620-Fall2026/

### Step 1: Download the TCF4 PDB Structure
1. Go to the [RCSB Protein Data Bank](https://www.rcsb.org/) for your assigned PDB structure.
2. Click **Download Files** $\rightarrow$ and selected the appropriate Biological Assembly in **PDB Format** and save it to your local machine.
3. Inspect the structure locally in VMD to identify the bHLH chains, DNA duplex, and crystal waters.

### Step 2: Prepare Input Files with CHARMM-GUI
1. Navigate to [CHARMM-GUI](https://www.charmm-gui.org/), register, and log in.
2. Select **Input Generator** $\rightarrow$ **Solution Builder**.
3. **PDB Option:** Upload your PDB file (do not download the PDB file directly) and click **Next**.
4. **Model/Chain Selection:** 
   * Select the TCF4 protein chains and the complementary DNA strands you wish to simulate. (default)
   * Select the crystal waters (not default)
5. **Solvation & Ions:**
   * Select a **Rectangular** water box. (default)
   * Set the edge distance (minimum 10 Å padding around the protein-DNA complex). (default)
   * Add ions $\text{KCl}$) to neutralize the system and set physiological concentration (e.g., $0.15\text{ M}$). (default)
6. **Input Generator Options:**
   * Select **CHARMM36m** as the force field (optimized for nucleic acid-protein complexes). (default)
   * Under **MD Software**, select **NAMD**. (not default)
   * Set target temperature (e.g., $310.15\text{ K}$ for physiological conditions). (not default)
7. Click **Generate Input Files** and download the resulting archive (`charmm-gui.tgz` or `.zip`).

### Step 3: Transfer & Unpack Files on the Cluster
1. Transfer the archive to your cluster directory:
   ```bash
   scp charmm-gui.tgz username@artemis.deac.wfu.edu:/deac/phy/classes/phy320-fa-2026/username
2. Unpack files and create directories for 3 independent trajectories:
   ```bash
   ssh -Y username@artemis.deac.wfu.edu
   cd /deac/phy/classes/phy320-fa-2026/username/Project-1-PHY320620-Fall2026/
   tar -xvzf charmm-gui.tgz; mv charmm-gui-* 1
   tar -xvzf charmm-gui.tgz; mv charmm-gui-* 2
   tar -xvzf charmm-gui.tgz; mv charmm-gui-* 3

### Step 4: Edit the dcdfreq in Step5_production.inp
1. Edit the `step5_production.inp` file so that the trajectory printing frequency is 10x less:
   ```bash
   cd 1/namd/
   nano step5_production.inp

2. Edit the `step5_production.inp` file so that the `dcdfreq` is changed from 50000 to 5000.

3. Repeat steps 1 and 2 for directories 2 and 3 too.

### 5. How to use the SLURM queuing system: Three main commands:

    sbatch -> submit to the queue.
    squeue -> check the status of the queue.
    scancel -> cancel a submission to the queue.

1. Copy the slurm scripts to your directory:
   ```bash
   cp ../../../md*.slurm .
2. To submit your md-equil.slurm script to the DEAC cluster, type “sbatch md-equil.slurm”. The check on whether everything is okay, type “squeue –u [username]” where [username] is your username. 
3. Wait until md-equil.slurm is finished by using the `squeue` command and verify by opening and checking the `step4_equilibration.out` file to see that the simulation continued until the end (look for "End of program" message at the end of the file). 
4. Submit the md-dyna.slurm script to the DEAC cluster. This should take about 5 days. Every 4 hours or so, your directory will be filled with about 1 ns of MD simulation. Check to make sure that each trajectory completed successfully. 
5. After the first md-dyna.slurm script is finished, use `nano` to edit lines 27 and 28 to reflect the next set of MD simulations. Re-submit the md-dyna.slurm script to the DEAC cluster, wait until it ends, and check to make sure that each trajectory completed successfully. Keep repeating this step until 250 ns of MD simulations has completed.
