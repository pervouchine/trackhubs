.PHONY : all

all : hub/hg19/HepG2.bb hub/hg19/K562.bb
	git commit -m "bigBeds rebuilt"

clean :
	rm -f hub/hg19/HepG2.bed hub/hg19/HepG2.bb hub/hg19/K562.bed hub/hg19/K562.bb

hub/hg19/HepG2.bed hub/hg19/K562.bed : ~/Projects/cosi/HepG2_cosi.bed ~/Projects/cosi/K562_cosi.bed
	for cell in HepG2 K562; do awk -v OFS="\t" '{print $$1,$$2,$$3,$$4":nuc="$$7",cyt="$$8,1000,$$6,$$2,$$3, ($$4=="CO" ? "255,0,0" : ($$4=="POST" ? "0,0,255" : ($$4=="UNSPL" ? "0,255,0" : "0,0,0")))}' ~/Projects/cosi/$${cell}_cosi.bed | sort -k1,1 -k2,2n > hub/hg19/$${cell}.bed; done

hub/hg19/HepG2.bb hub/hg19/K562.bb : hub/hg19/HepG2.bed hub/hg19/K562.bed hub/hg19/hg19.chrom.sizes
	for cell in HepG2 K562; do ./bedToBigBed hub/hg19/$${cell}.bed hub/hg19/hg19.chrom.sizes hub/hg19/$${cell}.bb; git add hub/hg19/HepG2.bb; done;
