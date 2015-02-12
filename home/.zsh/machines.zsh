hostname=$(hostname -s)

export IS_HOME_MACHINE=0
if [[ "$hostname" == "macwarrior" ]]; then
  export IS_HOME_MACHINE=1
fi

export IS_WORK_MACHINE=0
if [[ "$hostname" == "mc-s083333" ]]; then
  export IS_WORK_MACHINE=1
fi
