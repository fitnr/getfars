YEAR = 2016

PGDATABASE ?= $(USER)
PGUSER ?= $(USER)
psql = psql $(PSQLFLAGS)
export PGUSER PGDATABASE

tables = accident vehicle person \
	cevent damage distract \
	drimpair factor maneuver \
	nmcrash nmimpair nmprior \
	parkwork pbtype safetyeq \
	vevent vindecode \
	violatn vision vsoe 

lookups = $(notdir $(basename $(wildcard data/*.txt)))

.PHONY: load load-% init

load: $(addprefix load-,$(tables))

load-%: fars-$(YEAR).zip
	unzip -Cp $< $*.csv | \
		$(psql) -c "\copy fars.$* FROM STDIN WITH (FORMAT CSV, HEADER TRUE)"

init: init-schema $(addprefix init-,$(lookups))

init-%: data/%.txt
	$(psql) -c "\copy fars.$* from '$<' (FORMAT TEXT)"

init-schema: sql/fars_schema.sql sql/lookups.txt
	$(psql) -c "CREATE SCHEMA IF NOT EXISTS fars;"
	awk -F " " '{ print "CREATE TABLE IF NOT EXISTS fars." $$2 \
	  " (" $$3 " INT PRIMARY KEY, name TEXT); \
	  COMMENT ON TABLE fars." $$2 " IS '\''" $$1 "'\'';" }' sql/lookups.txt \
	| $(psql)
	$(psql) -f sql/fars_schema.sql

clean:; $(psql) -c "DROP SCHEMA fars CASCADE"

fars-$(YEAR).zip:
	curl ftp://ftp.nhtsa.dot.gov/fars/$(YEAR)/National/FARS$(YEAR)NationalCSV.zip -o $@
