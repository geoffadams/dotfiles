hostname=$(hostname -s)

IS_HOME_MACHINE=0
if [[ "$hostname" == "macwarrior" ]]; then
  IS_HOME_MACHINE=1
fi

IS_WORK_MACHINE=0
if [[ "$hostname" == "mc-s083179" ]]; then
  IS_WORK_MACHINE=1
fi
