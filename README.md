# generadorInpRotor
rm energies.dat; touch energies.dat; for i in $(ls *.log);do echo $i >> energies.dat; grep "SCF Done" $i | awk '{print $5}' | tail -n 1 >> energies.dat; done
