read_info() {
  rs=`cat /proc/diskstats | grep $1 | grep -w $1 | awk '{print $4}'`
  echo $rs
  return 0
}
read_time() {
  rt=`cat /proc/diskstats | grep $1 | grep -w $1 | awk '{print $7}'`
  echo $rt
  return 0
}
write_info() {
  rs=`cat /proc/diskstats | grep $1 | grep -w $1 | awk '{print $8}'`
  echo $rs
  return 0
}
write_time() {
  rt=`cat /proc/diskstats | grep $1 | grep -w $1 | awk '{print $11}'`
  echo $rt
  return 0
}
io_time() {
  rt=`cat /proc/diskstats | grep $1 | grep -w $1 | awk '{print $13}'`
  echo $rt
  return 0
}

#names=`cat /proc/diskstats | awk '{print $3}'`
hddnames=("sdb" "sdc" "sdd" "sde" "sdf" "sdg" "sdh" )
names=("nvme0n1" "nvme1n1" "nvme2n1" "nvme3n1" )
ls_date=`date +%Y-%m-%d/%H:%M:%S`

while true; do

  ris=()
  rts=()
  wis=()
  wts=()
  its=()
  for item in ${names[*]}; do
    ri=$(read_info $item)
    rt=$(read_time $item)
    wi=$(write_info $item)
    wt=$(write_time $item)

    ris[${#ris[*]}]=$ri
    rts[${#rts[*]}]=$rt
    wis[${#wis[*]}]=$wi
    wts[${#wts[*]}]=$wt
  done

  for item in ${hddnames[*]}; do
    it=$(io_time $item)
    its[${#its[*]}]=$it
  done

  sleep 3s

  ri_name="~"
  ri_max=0.0
  wi_name="~"
  wi_max=0.0
  ii_name="~"
  ii_max=0.0

  cnt=0
  for item in ${names[*]}; do
    ri=$(read_info $item)
    rt=$(read_time $item)
    wi=$(write_info $item)
    wt=$(write_time $item)


    read_bytes=`expr $ri \- ${ris[$cnt]}`
    read_time=`expr $rt \- ${rts[$cnt]}`
    if [ $read_bytes -gt 0 ]; then
      rim=`echo "scale=6; $read_time / $read_bytes" | bc`
    else
      rim=`echo "scale=6; $read_time / 1" | bc`
    fi
    if [ $(echo "$rim > $ri_max" | bc) -eq 1 ]; then
      ri_max=$rim
      ri_name=$item
    fi
    #alx
    if [ $(echo "$rim > 10" | bc) -eq 1 ]; then
      ls_date=`date +%Y-%m-%d/%H:%M:%S`
      echo "read:: $item  >>>   $rim -- $ls_date" >> alx.txt
    fi

    write_bytes=`expr $wi \- ${wis[$cnt]}`
    write_time=`expr $wt \- ${wts[$cnt]}`
    if [ $write_bytes -gt 0 ]; then
      wim=`echo "scale=6; $write_time / $write_bytes" | bc`
    else
      wim=`echo "scale=6; $write_time / 1" | bc`
    fi
    if [ $(echo "$wim > $wi_max" | bc) -eq 1 ]; then
      wi_max=$wim
      wi_name=$item
    fi
    if [ $(echo "$wim > 100" | bc) -eq 1 ]; then
        ls_date=`date +%Y-%m-%d/%H:%M:%S`
      echo "Write:: $item  >>>   $wim -- $ls_date" >> alx.txt
    fi

    
  done

  for item in ${hddnames[*]}; do
   
    it=$(io_time $item)


    io_time=`expr $it \- ${its[$cnt]}`
    iim=`echo "scale=2; $io_time / 3000" | bc`
    if [ $(echo "$iim > $ii_max" | bc) -eq 1 ]; then
      ii_max=$iim
      ii_name=$item
    fi
    if [ $(echo "$iim > 0.95" | bc) -eq 1 ]; then
      ls_date=`date +%Y-%m-%d/%H:%M:%S`
      echo "io:: $item  >>>   $iim -- $ls_date" >> alx.txt
    fi
    let cnt++
  done
done