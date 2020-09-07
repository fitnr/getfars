# getfars

Download [FARS (Fatality Analysis Reporting System)](https://www.nhtsa.gov/research-data/fatality-analysis-reporting-system-fars) data and load it into a PostgreSQL database.

This repo also contains many look-up tables derived from the [FARS User’s Manual](https://crashstats.nhtsa.dot.gov/Api/Public/ViewPublication/812448).

Requires: make, postgresql (9.3+).

## Usage

First, clone or download the repo. Then [download the FARS CSV zip file from the NHTSA](https://www.nhtsa.gov/node/97996/251). Place the resulting file, which should have a name like `FARS2018NationalCSV.zip` .

To set up the database and load into the database:

````bash
make init load YEAR=2018
````

This assumes that your Postgres database has the same name as your system user. To customize Postgres connection options, use the [Postgres environment variables](https://www.postgresql.org/docs/current/libpq-envars.html):
```bash
export PGDATABASE=my_database_name PGHOST=db.remote.com PGUSER=myname
```

By default, the database tables will be created in a schema named `fars`. To customize the schema name, use the make variable `SCHEMA`:
```bash
make init load SCHEMA=myschema
```

The load task will attempt to create a `geometry`-type column in the `fars.accident` table, but if you're not using PosGIS, that step will fail and you can safely ignore the error.

## Data consistency

The current table schema is valid for the most recent year available (2018), and may be fail for previous years. Even when table structures haven't changes, the meaning of the various attribute may have been altered.

## Example queries

These queries are meant to demonstrate the relationships between the different tables in FARS.

First run the following to add the `fars` schema into the search path: 
```sql
set search_path to public, fars;
```

Retrieve information about a crash:
````sql
select
    st_case,
    state.name state,
    make_timestamp(a.year, a.month, a.day, a.hour, a.minute, 0) as timestamp,
    route.name route_type,
    owner.name road_owner,
    func_sys.name functional_system,
    nullif(sj.name, 'No Special Jurisdiction (Includes National Forests)') special_jurisdiction,
    man_coll.name manner_of_collision,
    harmful_event.name first_harmful_event,
    lgt.name as lighting_condition,
    rur_urb.name rur_urb,
    rel_road.name relation_to_road,
    concat_ws('; ', weather1.name, nullif(weather2.name, 'No Additional Atmospheric Conditions')) weather,
    concat_ws('; ', rcf1.name, nullif(rcf2.name, 'None'), nullif(rcf3.name, 'None')) relatedfactors
from accident as a
    left join state using (state)
    left join route using (route)
    left join functional_system func_sys using (func_sys)
    left join road_owner owner using (rd_owner)
    left join special_jurisdiction sj using (sp_jur)
    left join harmful_event using (harm_ev)
    left join manner_of_collision man_coll using (man_coll)
    left join light_condition lgt using (lgt_cond)
    left join atmospheric_condition weather1 on (weather1.weather = a.weather1)
    left join atmospheric_condition weather2 on (weather2.weather = a.weather2)
    left join related_factors_crash rcf1 on (rcf1.cf = a.cf1)
    left join related_factors_crash rcf2 on (rcf2.cf = a.cf2)
    left join related_factors_crash rcf3 on (rcf3.cf = a.cf3)
    left join rural_urban rur_urb using (rur_urb)
    left join relation_to_road rel_road using (rel_road)
where st_case = 10845;
````

Retrieve information about persons involved in a particular crash:
````sql
select a.st_case,
    make_date(a.year, a.month, a.day) as date,
    make_time(nullif(a.hour, '99'), a.minute, 0) as timestamp,
    veh_no,
    per_no,
    str_veh struck,
    person_type.name persontype,
    person.age,
    sex.name as sex,
    nullif(race.name, 'Not A Fatality (Not Applicable)') as race,
    nullif(hispanic_origin.name, 'Not A Fatality (Not Applicable)') as hispanic_origin,
    tt.name,
    restraint_use.name as restraint_use,
    air_bag,
    alc_det.name as alcohol_determination_method,
    drinking as police_reported_alcohol_involvement,
    alc_test.name alc_test_status,
    seating.name,
    injury_severity.name injury_severity,
    make_date(nullif(death_yr, 8888), nullif(death_mo, 88), nullif(death_da, 88)) death_date,
    coalesce(nullif(crash_group_bike.name, 'Not a Cyclist'), crash_group_pedestrian.name) crash_group,
    concat_ws('; ', sf1.name, nullif(sf2.name, 'None/Not Applicable-Driver'), nullif(sf3.name, 'None/Not Applicable-Driver')) relatedfactors,
    concat_ws('; ', nullif(drugres1.name, 'Not Tested for Drugs'), nullif(drugres2.name, 'Not Tested for Drugs'), nullif(drugres3.name, 'Not Tested for Drugs')) drug_test_result
from accident as a
    left join person using (st_case)
    left join pbtype pb using (st_case, veh_no, per_no)
    left join person_type using (per_typ)
    left join sex using (sex)
    left join race using (race)
    left join hispanic_origin using (hispanic)
    left join vehicle using (st_case, veh_no)
    left join transported_treatment tt using (hospital)
    left join crash_group_pedestrian using (pedcgp)
    left join crash_group_bike using (bikecgp)
    left join injury_severity using (inj_sev)
    left join seating_position seating using (seat_pos)
    left join restraint_use using (rest_use)
    left join alc_test using (alc_status)
    left join method_alc_det alc_det using (alc_det)
    left join drug_test_result drugres1 on (person.drugres1 = drugres1.drugres)
    left join drug_test_result drugres2 on (person.drugres2 = drugres2.drugres)
    left join drug_test_result drugres3 on (person.drugres3 = drugres3.drugres)
    left join related_factors_person sf1 on (p_sf1 = sf1.p_sf)
    left join related_factors_person sf2 on (p_sf2 = sf2.p_sf)
    left join related_factors_person sf3 on (p_sf3 = sf3.p_sf)
where st_case = 40792;
````

Query vehicles involved in a crash:
````sql
select
    a.st_case,
    veh_no,
    vin,
    v.deaths,
    make.name make,
    model,
    body_type.name body_type,
    trafficway.name trafficway,
    roadway_surface.name roadway_surface,
    nullif(nullif(trav_sp, '0'), '999')::numeric as travel_speed,
    numoccs occupants,
    owner.name as owner,
    dr_drink driver_drinking,
    state.name registration,
    dr_zip drivers_zipcode,
    towing.name trailing_vehicle,
    haz.name hazardous_material,
    bus_use.name as bus_use,
    speeding.name speeding,
    pre_event_movement.name pre_event_movement,
    critical_precrash_event.name critical_precrash_event,
    attempted_avoidance.name attempted_avoidance,
    man_coll.name as manner_of_collision,
    concat_ws('; ', vsf1.name, nullif(vsf2.name, 'None'), nullif(vsf3.name, 'None'), nullif(vsf4.name, 'None')) driver_related_factors,
    harmful_event.name most_harmful_event,
    damage_extent.name as damage_extent,
    accident_type.name as accident_type,
    vin.bodystyl_t bodystyle,
    vin.drivetyp_t drivetype,
    vin.msrp,
    vin.fuel_t fueltype

from accident as a
    left join vehicle v using (st_case)
    left join vindecode vin using (st_case, veh_no)
    left join pre_event_movement using (p_crash1)
    left join critical_precrash_event using (p_crash2)
    left join attempted_avoidance using (p_crash3)
    left join vehicle_owner owner using (owner)
    left join vehicle_make make using (make)
    left join state on (state.state = l_state)
    left join body_type using (body_typ)
    left join trailing_vehicle towing using (tow_veh)
    left join hazardous_material_class haz using (haz_cno)
    left join bus_use using (bus_use)
    left join harmful_event on (m_harm=harmful_event.harm_ev)
    left join manner_of_collision man_coll on (v.man_coll=man_coll.man_coll)
    left join related_factors_driver vsf1 on (vsf1.dr_sf = v.dr_sf1)
    left join related_factors_driver vsf2 on (vsf2.dr_sf = v.dr_sf2)
    left join related_factors_driver vsf3 on (vsf3.dr_sf = v.dr_sf3)
    left join related_factors_driver vsf4 on (vsf4.dr_sf = v.dr_sf4)
    left join roadway_surface using (vsurcond)
    left join speeding using (speedrel)
    left join trafficway trafficway using (vtrafway)
    left join accident_type using (acc_type)
    left join damage_extent using (deformed)

where a.st_case = 10845
order by veh_no asc;
````

Query information about the sequence of events in a crash:
````sql
select
    eventnum,
    vnumber1,
    v1.vin,
    m1.name vehicle1make,
    b1.name body_type1,
    s1.name reg_state,
    v1.model v1model,
    v1.trav_sp travel_speed,
    v1.vspd_lim speed_limit,
    aoi1.name area_of_impact1,
    soe.name as event,
    NULLIF(NULLIF(vnumber2, 5555), 9999) vnumber2,
    m2.name vehicle2make,
    b2.name body_type2,
    aoi2.name area_of_impact2
from cevent c
    left join sequence_events soe using (soe)
    -- vehicle 1
    left join vehicle v1 on (c.st_case = v1.st_case and c.vnumber1 = v1.veh_no)
    left join area_of_impact aoi1 on (aoi1=aoi)
    left join state s1 on (s1.state = v1.reg_stat)
    left join vehicle_make m1 on (v1.make = m1.make)
    left join body_type b1 on (v1.body_typ = b1.body_typ)
    -- vehicle 2
    left join vehicle v2 on (c.st_case = v2.st_case and c.vnumber2 = v2.veh_no)
    left join area_of_impact aoi2 on (c.aoi2 = aoi2.aoi)
    left join state s2 on (s2.state = v2.reg_stat)
    left join vehicle_make m2 on (v2.make = m2.make)
    left join body_type b2 on (v2.body_typ = b2.body_typ)

where c.st_case = 40399;
````

Retrieve the number of pedestrian and bicyclist fatalities for different crash situations:
````sql
SELECT
    person_type.name person_type,
    COALESCE(NULLIF(bcg.name, 'Not a Cyclist'), pcg.name) crash_group,
    COUNT(*)
FROM person
    INNER JOIN pbtype USING (st_case, veh_no)
    LEFT JOIN person_type USING (per_typ)
    LEFT JOIN crash_group_pedestrian pcg USING (pedcgp)
    LEFT JOIN crash_group_bike bcg USING (bikecgp)
WHERE inj_sev = 4 -- fatal injury
GROUP BY person_type.name, COALESCE(NULLIF(bcg.name, 'Not a Cyclist'), pcg.name)
ORDER BY 3 DESC;
````

Retrieve information about violations:
```sql
SELECT st_case, veh_no, name
FROM fars.violatn
    LEFT JOIN violations_charged USING (mviolatn)
WHERE st_case = 63300
    AND veh_no = 1;
```

Retrieve information about safety equipment:
```sql
SELECT *
FROM fars.safetyeq
    LEFT JOIN safety_equipment USING (msafeqmt)
WHERE st_case = 62269
ORDER BY per_no
```

Get non-motorist actions:
```sql
SELECT st_case, veh_no, per_no, nonmotorist_action.name
    FROM fars.nmprior
    LEFT JOIN nonmotorist_action USING (mpr_act)
WHERE st_case = 220455
ORDER BY per_no;
```

Select non-motorist actions for a specific crash:
```sql
SELECT st_case, veh_no, per_no, name
FROM nmcrash
    LEFT JOIN nonmotorist_contributing USING (mtm_crsh)
    WHERE st_case = 40079
ORDER BY veh_no, per_no
```

Select damage to vehicles for a specific crash:
```sql
SELECT st_case, veh_no, name
FROM damage
    LEFT JOIN damaged_area USING (mdareas)
WHERE st_case = 10041
ORDER BY veh_no;
```

Get driver distractions for a specific crash:
```sql
SELECT st_case, veh_no, name
FROM distract
    LEFT JOIN driver_distracted using (mdrdstrd)
WHERE st_case = 100024
ORDER BY veh_no;
```

Get vehicle factors
```sql
SELECT st_case, veh_no, name
FROM factor
    LEFT JOIN motor_vehicle_factor USING (mfactor)
WHERE st_case = 10024
ORDER BY veh_no;
```

Get driver impairments relavent to a crash:
```sql
SELECT st_case, veh_no, name
FROM drimpair
    LEFT JOIN impairment on (drimpair = impair)
WHERE st_case = 10079
ORDER BY veh_no;
```

Get vehicle maneuvers prior to a crash:
```sql
SELECT st_case, veh_no, name
FROM maneuver
    LEFT JOIN driver_maneuver using (mdrmanav)
WHERE st_case = 10134
ORDER BY veh_no;
```
