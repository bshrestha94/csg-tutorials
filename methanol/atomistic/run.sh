#! /bin/bash -e

grompp -v

mdrun -v

echo Running g_energy
equi=2000
echo equi = $equi
echo -e "Pressure" | g_energy -b $equi

echo Calculating distributions
csg_stat --top topol.tpr --trj traj.trr --cg methanol.xml --options settings.xml --nt 3

echo "Mapping confout.gro to get configuration for coarse-grained run"
csg_map --top topol.tpr --trj confout.gro --cg methanol.xml --out conf_cg.gro 

echo "Running force matching"
csg_fmatch --top topol.tpr --trj traj.trr --begin $equi  --options fmatch.xml --cg methanol.xml
