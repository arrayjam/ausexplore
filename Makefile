sources = csv/economy.csv csv/environment.csv csv/industry.csv csv/population.csv
id_field = SA2_MAIN

TOPOJSON = node --max_old_space_size=8192 /usr/bin/topojson

all: data/sa2_2011.json data/national_regional_profile.csv

csv/economy.csv: sources/National\ Regional\ Profile\,\ Economy\,\ ASGS\,\ 2007\-2011.csv
	sed \
		-e 's/Geography - Codes/$(id_field)/' \
		-e 's/Geography - Labels/region_name/'  \
		-e 's/Year - Labels/year/' \
		-e 's/ - at 30 June//g' \
		-e 's/ - year ended 30 June//g' \
		-e 's/ - Year ended 30 June//g' \
		-e 's/ - 2011 Census//g' \
		"$<" > $@

csv/environment.csv: sources/National\ Regional\ Profile\,\ Environment\,\ ASGS\,\ 2007\-2011.csv
	sed \
		-e 's/Geography - Codes/$(id_field)/' \
		-e 's/Geography - Labels/region_name/'  \
		-e 's/Year - Labels/year/' \
		-e 's/ - year ended 30 June//g' \
		"$<" > $@

csv/industry.csv: sources/National\ Regional\ Profile\,\ Industry\,\ ASGS\,\ 2007\-2011.csv
	sed \
		-e 's/Geography - Codes/$(id_field)/' \
		-e 's/Geography - Labels/region_name/'  \
		-e 's/Calendar Year - Labels/year/' \
		-e 's/ - year ended 30 June//g' \
		-e 's/(year ended 30 June)//g' \
		-e 's/ - Census 2011//g' \
		"$<" > $@

csv/population.csv: sources/National\ Regional\ Profile\,\ Population\,\ ASGS\,\ 2007\-2011.csv
	sed \
		-e 's/Regional Code - Codes/$(id_field)/' \
		-e 's/Regional Code - Labels/region_name/'  \
		-e 's/At 30 June - Labels/year/' \
		-e 's/ - at 30 June//g' \
		-e 's/ - year ended 31 December//g' \
		-e 's/ - Census 2011//g' \
		-e 's/ - CENSUS 2011//g' \
		-e 's/ (Census 2011)//g' \
		-e 's/Born in/BORN ELSEWHERE - /g' \
		"$<" > $@

data/national_regional_profile.csv: $(sources)
	node lib/nrp --year 2011 -o $@ -- $^

data/sa2_2011.json: shp/SA2_2011_AUST.dbf shp/SA2_2011_AUST.prj shp/SA2_2011_AUST.shp shp/SA2_2011_AUST.shx
	#$(TOPOJSON) --id-property SA2_MAIN -e csv/sa2_2011.csv -p "region_name,internet=HOME INTERNET ACCESS (Census 2011) - Total internet connections (Percent)" -q 10000 --simplify-proportion 0.1 -o $@ -- sa2=shp/SA2_2011_AUST.shp
	$(TOPOJSON) --id-property SA2_MAIN -q 10000 --simplify-proportion 0.4 -o $@ -- sa2=shp/SA2_2011_AUST.shp

clean:
	rm csv/* data/*
