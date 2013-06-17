
all: csv/economy.csv csv/environment.csv csv/industry.csv csv/population.csv \
	csv/economy.sorted.csv csv/environment.sorted.csv csv/industry.sorted.csv csv/population.sorted.csv \
	csv/all.csv


csv/economy.csv: sources/National\ Regional\ Profile\,\ Economy\,\ ASGS\,\ 2007\-2011.csv
	sed -e 's/Geography - Codes/region_id/' -e 's/Geography - Labels/region_name/'  -e 's/Year - Labels/year/' "$<" > $@

csv/economy.sorted.csv: csv/economy.csv
	sort -t , -n -k 1,1 $< > $@

csv/environment.csv: sources/National\ Regional\ Profile\,\ Environment\,\ ASGS\,\ 2007\-2011.csv
	sed -e 's/Geography - Codes/region_id/' -e 's/Geography - Labels/region_name/'  -e 's/Year - Labels/year/' "$<" > $@

csv/environment.sorted.csv: csv/environment.csv
	sort -t , -n -k 1,1 $< > $@

csv/industry.csv: sources/National\ Regional\ Profile\,\ Industry\,\ ASGS\,\ 2007\-2011.csv
	sed -e 's/Geography - Codes/region_id/' -e 's/Geography - Labels/region_name/'  -e 's/Calendar Year - Labels/year/' "$<" > $@

csv/industry.sorted.csv: csv/industry.csv
	sort -t , -n -k 1,1 $< > $@

csv/population.csv: sources/National\ Regional\ Profile\,\ Population\,\ ASGS\,\ 2007\-2011.csv
	sed -e 's/Regional Code - Codes/region_id/' -e 's/Regional Code - Labels/region_name/'  -e 's/At 30 June - Labels/year/' "$<" > $@

csv/population.sorted.csv: csv/population.csv
	sort -t , -n -k 1,1 $< > $@

csv/all.csv: csv/economy.sorted.csv csv/environment.sorted.csv 
	join -t , -1 0 -2 0 $^ > $@
#csv/industry.sorted.csv csv/population.sorted.csv
clean:
	rm csv/*

#Economy	Geography - Codes	Geography - Labels	Year - Labels
#Environment	Geography - Codes	Geography - Labels	Year - Labels
#Industry	Geography - Codes	Geography - Labels	Calendar Year - Labels
#Population	Regional Code - Codes	Regional Code - Labels	At 30 June - Labels

