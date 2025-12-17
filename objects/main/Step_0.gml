Store.Renewal("Step");

if(time >= 60){ mintime ++; time = 0 } else { time += 1/60 }
if(mintime >= 60){ hortime ++; mintime = 0 }