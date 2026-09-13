SHELL = /bin/bash

YEAR = 2018

PGUSER ?= $(USER)
PGDATABASE ?= $(PGUSER)
SCHEMA = fars

psql = psql $(PSQLFLAGS)

tables = accident vehicle person \
	cevent damage distract \
	drimpair factor maneuver \
	nmcrash nmimpair nmprior \
	parkwork pbtype safetyeq \
	vevent violatn vision \
	vsoe 

lookups = $(notdir $(basename $(wildcard data/*.txt)))

.PHONY: load load-% init

load: $(addprefix load-,$(tables))
	$(psql) -v schema=$(SCHEMA) -f sql/constraint.sql
	-$(psql) -v schema=$(SCHEMA) -f sql/spatial.sql

load-%: FARS$(YEAR)NationalCSV.zip
	./src/copy.sh $< $(SCHEMA) $* $(YEAR)

init: init-schema $(addprefix init-,$(lookups))

init-%: data/%.txt
	$(psql) -c "\copy $(SCHEMA).$* from '$<' (FORMAT TEXT)"

init-schema: sql/schema.sql sql/lookups.txt
	$(psql) -c "CREATE SCHEMA IF NOT EXISTS $(SCHEMA);"
	awk -F " " '{ print "CREATE TABLE IF NOT EXISTS $(SCHEMA)." $$2 \
	  " (" $$3 " INT PRIMARY KEY, name TEXT); \
	  COMMENT ON TABLE $(SCHEMA)." $$2 " IS '\''" $$1 "'\'';" }' sql/lookups.txt \
	| $(psql)
	$(psql) -v schema=$(SCHEMA) -f sql/schema.sql

clean:; $(psql) -c "DROP SCHEMA $(SCHEMA) CASCADE"
