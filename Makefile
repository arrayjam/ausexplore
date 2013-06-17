
all: economy.csv environment.csv industry.csv population.csv

economy.csv: sources/National\ Regional\ Profile\,\ Economy\,\ ASGS\,\ 2007\-2011.csv
	sed -e 's/Geography - Codes/region_id/' -e 's/Geography - Labels/region_name/'  -e 's/Year - Labels/year/' "$<" > csv/$@

environment.csv: sources/National\ Regional\ Profile\,\ Environment\,\ ASGS\,\ 2007\-2011.csv
	sed -e 's/Geography - Codes/region_id/' -e 's/Geography - Labels/region_name/'  -e 's/Year - Labels/year/' "$<" > csv/$@

industry.csv: sources/National\ Regional\ Profile\,\ Industry\,\ ASGS\,\ 2007\-2011.csv
	sed -e 's/Geography - Codes/region_id/' -e 's/Geography - Labels/region_name/'  -e 's/Calendar Year - Labels/year/' "$<" > csv/$@

population.csv: sources/National\ Regional\ Profile\,\ Population\,\ ASGS\,\ 2007\-2011.csv
	sed -e 's/Regional Code - Codes/region_id/' -e 's/Regional Code - Labels/region_name/'  -e 's/At 30 June - Labels/year/' "$<" > csv/$@

clean:
	rm csv/*

#Economy	Geography - Codes	Geography - Labels	Year - Labels
#Environment	Geography - Codes	Geography - Labels	Year - Labels
#Industry	Geography - Codes	Geography - Labels	Calendar Year - Labels
#Population	Regional Code - Codes	Regional Code - Labels	At 30 June - Labels

