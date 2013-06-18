sources = csv/economy.csv csv/environment.csv csv/industry.csv csv/population.csv
id_field = SA2_MAIN

TOPOJSON = node --max_old_space_size=8192 /usr/bin/topojson

all: data/sa2_2011.json

csv/economy.csv: sources/National\ Regional\ Profile\,\ Economy\,\ ASGS\,\ 2007\-2011.csv
	sed \
		-e 's/Geography - Codes/$(id_field)/' \
		-e 's/Geography - Labels/region_name/'  \
		-e 's/Year - Labels/year/' \
		"$<" > $@

csv/environment.csv: sources/National\ Regional\ Profile\,\ Environment\,\ ASGS\,\ 2007\-2011.csv
	sed \
		-e 's/Geography - Codes/$(id_field)/' \
		-e 's/Geography - Labels/region_name/'  \
		-e 's/Year - Labels/year/' \
		"$<" > $@

csv/industry.csv: sources/National\ Regional\ Profile\,\ Industry\,\ ASGS\,\ 2007\-2011.csv
	sed \
		-e 's/Geography - Codes/$(id_field)/' \
		-e 's/Geography - Labels/region_name/'  \
		-e 's/Calendar Year - Labels/year/' \
		"$<" > $@

csv/population.csv: sources/National\ Regional\ Profile\,\ Population\,\ ASGS\,\ 2007\-2011.csv
	sed \
		-e 's/Regional Code - Codes/$(id_field)/' \
		-e 's/Regional Code - Labels/region_name/'  \
		-e 's/At 30 June - Labels/year/' \
		"$<" > $@

csv/sa2_2011.csv: $(sources)
	node nrp --year 2011 -o $@ -- $^

data/sa2_2011.json: csv/sa2_2011.csv shp/SA2_2011_AUST.dbf shp/SA2_2011_AUST.prj shp/SA2_2011_AUST.shp shp/SA2_2011_AUST.shx
	$(TOPOJSON) --id-property SA2_MAIN -e csv/sa2_2011.csv -p -q 10000 --simplify-proportion 0.1 -o $@ -- sa2=shp/SA2_2011_AUST.shp

clean:
	rm csv/* data/*
