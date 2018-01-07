YEAR = 2016

PG_DATABASE ?= $(USER)
PSQLFLAGS = $(PG_DATABASE)

ifdef PG_HOST
PSQLFLAGS += -h $(PG_HOST)
endif

ifdef PG_PORT
PSQLFLAGS += -p $(PG_PORT)
endif

ifdef PG_USER
PSQLFLAGS += -U $(PG_USER)
endif

PSQL = psql $(PSQLFLAGS)

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
		$(PSQL) -c "\copy fars.$* FROM STDIN WITH (FORMAT CSV, HEADER TRUE)"

init: init-schema $(addprefix init-,$(lookups))

init-%: data/%.txt
	$(PSQL) -c "\copy fars.$* from '$<' (FORMAT TEXT)"

init-schema:; $(PSQL) -f sql/fars_schema.sql

clean:; $(PSQL) -c "DROP SCHEMA fars CASCADE"

fars-$(YEAR).zip:
	curl ftp://ftp.nhtsa.dot.gov/fars/$(YEAR)/National/FARS$(YEAR)NationalCSV.zip -o $@
