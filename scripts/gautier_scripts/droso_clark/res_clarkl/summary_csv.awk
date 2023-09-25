BEGIN{
 FS=","
 if(!nmin_kmer){nmin_kmer=1} #minimum number of kmer for a sequence to be considered assigned
 if(!conf_thr){conf_thr=0.9}  #min conf threshold (varie par construction de 0.5 à 1 car = nmpaaedkmer_best/(nkmerbest + nkmer2nd) 
}{
 if(NR>1){
  if($4=="NA"){
    cnt_na++
  }else{
     if($5>=nmin_kmer && $NF>conf_thr){
     cnt[$4]++
     nsel++
        }else{
         nelim++
        }
      }
 }
}END{
 {print "Nseq/Nseq_na/Nseq_elim\t"NR-1"\t"cnt_na"\t"nelim}
 for(i in cnt){
  print i"\t"cnt[i]"\t"cnt[i]/nsel"\t"cnt[i]/(NR-1)
}
}
