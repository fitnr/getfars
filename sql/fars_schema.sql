-- todo: vehicle configuration, cargo body type, bus use, special use, emergency use

CREATE SCHEMA IF NOT EXISTS fars;

create table fars.state (
    state int primary key,
    name text,
    fips char(2)
);

create table fars.route (
    route int primary key,
    name text
);

create table fars.functional_system (
    func_sys int primary key,
    name text
);

create table fars.road_owner (
    rd_owner int primary key,
    name text
);

create table fars.special_jurisdiction (
    sp_jur int primary key,
    name text
);

create table fars.harmful_event (
    harm_ev int primary key,
    name text
);

create table fars.manner_of_collision (
    man_coll int primary key,
    name text
);

create table fars.light_condition (
    lgt_cond int primary key,
    name text
);

create table fars.atmospheric_condition (
    weather int primary key,
    name text
);

create table fars.related_factors_crash (
    cf int primary key,
    name text
);

create table fars.vehicle_owner (
    owner int primary key,
    name text
);

create table fars.vehicle_make (
    make int primary key,
    name text
);

create table fars.body_type (
    body_typ int primary key,
    name text
);

create table fars.trailing_vehicle (
    tow_veh int primary key,
    name text
);

create table fars.hazardous_material_class (
    haz_cno int primary key,
    name text
);

create table fars.safety_equipment (
    msafeqmt int primary key,
    name text
);

create table fars.ped_crash_type (
    pedctype int primary key,
    name text
);

create table fars.bike_crash_type (
    bikectype int primary key,
    name text
);

create table fars.related_factors_driver (
    dr_sf integer primary key,
    name text
);

create table fars.trafficway (
    vtrafway int primary key,
    name text
);

create table fars.related_factors_person (
    p_sf int primary key,
    name text
);

create table fars.person_type (
    per_typ int PRIMARY KEY,
    name TEXT
);

create table fars.sequence_events (
    soe int primary key,
    name text
);

create table fars.area_of_impact (
    aoi int primary key,
    name text
);

create table fars.driver_distracted (
    mdrdstrd int primary key,
    name text
);

create table fars.driver_impairment (
    drimpair int primary key,
    name text
);

create table fars.motor_vehicle_factor (
    mfactor int primary key,
    name text
);

create table fars.driver_maneuver (
    mdrmanav int primary key,
    name text
);

create table fars.vision_obscured (
    mvisobsc int primary key,
    name text
);

create table fars.violations_charged (
    mviolatn int primary key,
    name text
);

create table fars.crash_group_bike (
    bikecgp int primary key,
    name text
);

create table fars.crash_group_pedestrian (
    pedcgp int primary key,
    name text
);

create table fars.injury_severity (
    inj_sev int primary key,
    name text
);

create table fars.restraint_use (
    rest_use int primary key,
    name text
);

create table fars.accident_type (
    acc_type int primary key,
    name text
);

create table fars.drug_test_result (
    drugres int primary key,
    name text
);

create table fars.rural_urban (
    rur_urb int primary key,
    name text
);

create table fars.bus_use (
    bus_use int primary key,
    name text
);

create table fars.relation_to_road (
    rel_road int primary key,
    name text
);

create table fars.roadway_surface (
    vsurcond int primary key,
    name text
);

create table fars.pre_event_movement (
    p_crash1 int primary key,
    name text
);

create table fars.critical_precrash_event (
    p_crash2 int primary key,
    name text
);

create table fars.attempted_avoidance (
    p_crash3 int primary key,
    name text
);

CREATE TABLE fars.accident (
    state integer references fars.state (state),
    st_case integer PRIMARY KEY,
    ve_total integer,
    ve_forms integer,
    pvh_invl integer,
    peds integer,
    pernotmvit integer,
    permvit integer,
    persons integer,
    county integer,
    city integer,
    day integer,
    month integer,
    year integer,
    day_week integer,
    hour integer,
    minute integer,
    nhs integer,
    rur_urb integer references fars.rural_urban (rur_urb),
    func_sys integer references fars.functional_system (func_sys),
    rd_owner integer references fars.road_owner (rd_owner),
    route integer references fars.route (route),
    tway_id text,
    tway_id2 text,
    milept integer,
    latitude double precision,
    longitud double precision,
    sp_jur integer references fars.special_jurisdiction (sp_jur),
    harm_ev integer references fars.harmful_event (harm_ev),
    man_coll integer references fars.manner_of_collision (man_coll),
    reljct1 integer,
    reljct2 integer,
    typ_int integer,
    wrk_zone integer,
    rel_road integer references fars.relation_to_road (rel_road),
    lgt_cond integer references fars.light_condition (lgt_cond),
    weather1 integer references fars.atmospheric_condition (weather),
    weather2 integer references fars.atmospheric_condition (weather),
    weather integer references fars.atmospheric_condition (weather),
    sch_bus integer,
    rail text,
    not_hour integer,
    not_min integer,
    arr_hour integer,
    arr_min integer,
    hosp_hr integer,
    hosp_mn integer,
    cf1 integer references fars.related_factors_crash (cf),
    cf2 integer references fars.related_factors_crash (cf),
    cf3 integer references fars.related_factors_crash (cf),
    fatals integer,
    drunk_dr integer
);

CREATE TABLE fars.cevent (
    state integer references fars.state (state),
    st_case integer,
    eventnum integer,
    vnumber1 integer,
    aoi1 integer references fars.area_of_impact (aoi),
    soe integer references fars.sequence_events (soe),
    vnumber2 integer,
    aoi2 integer references fars.area_of_impact (aoi),
    constraint fars_cevent_pk primary key (st_case, eventnum)
);

CREATE TABLE fars.damage (
    state integer references fars.state (state),
    st_case integer references fars.accident (st_case),
    veh_no integer,
    mdareas integer
);
create index on fars.damage (st_case, veh_no);

CREATE TABLE fars.distract (
    state integer references fars.state (state),
    st_case integer references fars.accident (st_case),
    veh_no integer,
    mdrdstrd integer references fars.driver_distracted (mdrdstrd)
);
create index on fars.distract (st_case, veh_no);

CREATE TABLE fars.drimpair (
    state integer references fars.state (state),
    st_case integer references fars.accident (st_case),
    veh_no integer,
    drimpair integer references fars.driver_impairment (drimpair)
);
create index on fars.drimpair (st_case, veh_no);

CREATE TABLE fars.factor (
    state integer references fars.state (state),
    st_case integer references fars.accident (st_case),
    veh_no integer,
    mfactor integer references fars.motor_vehicle_factor (mfactor)
);
create index on fars.factor (st_case, veh_no);

CREATE TABLE fars.maneuver (
    state integer references fars.state (state),
    st_case integer references fars.accident (st_case),
    veh_no integer,
    mdrmanav integer references fars.driver_maneuver (mdrmanav)
);
create index on fars.maneuver (st_case, veh_no);

CREATE TABLE fars.nmcrash (
    state integer references fars.state (state),
    st_case integer references fars.accident (st_case),
    veh_no integer,
    per_no integer,
    mtm_crsh integer
);
create index on fars.nmcrash (st_case, veh_no, per_no);

CREATE TABLE fars.nmimpair (
    state integer references fars.state (state),
    st_case integer references fars.accident (st_case),
    veh_no integer,
    per_no integer,
    nmimpair integer
);
create index on fars.nmimpair (st_case, veh_no, per_no);

CREATE TABLE fars.nmprior (
    state integer references fars.state (state),
    st_case integer references fars.accident (st_case),
    veh_no integer,
    per_no integer,
    mpr_act integer
);
create index on fars.nmprior (st_case, veh_no, per_no);

CREATE TABLE fars.parkwork (
    state integer references fars.state (state),
    st_case integer references fars.accident (st_case),
    veh_no integer,
    pve_forms integer,
    pnumoccs integer,
    pday integer,
    pmonth integer,
    phour integer,
    pminute integer,
    pharm_ev integer,
    pman_coll integer references fars.manner_of_collision (man_coll),
    ptype integer,
    phit_run integer,
    preg_stat integer,
    powner integer references fars.vehicle_owner (owner),
    pmake integer references fars.vehicle_make (make),
    pmodel integer,
    pmak_mod integer,
    pbodytyp integer,
    pmodyear integer,
    pvin text,
    pvin_1 text,
    pvin_2 text,
    pvin_3 text,
    pvin_4 text,
    pvin_5 text,
    pvin_6 text,
    pvin_7 text,
    pvin_8 text,
    pvin_9 text,
    pvin_10 text,
    pvin_11 text,
    pvin_12 text,
    ptrailer integer,
    pmcarr_i1 text,
    pmcarr_i2 text,
    pmcarr_id text,
    pgvwr integer,
    pv_config integer,
    pcargtyp integer,
    phaz_inv integer,
    phazplac integer,
    phaz_id integer,
    phaz_cno integer references fars.hazardous_material_class (haz_cno),
    phaz_rel integer,
    pbus_use integer references fars.bus_use (bus_use),
    psp_use integer,
    pem_use integer,
    punderide integer,
    pimpact1 integer,
    pveh_sev integer,
    ptowed integer,
    pm_harm integer references fars.harmful_event (harm_ev),
    pveh_sc1 integer,
    pveh_sc2 integer,
    pfire integer,
    pdeaths integer,
    ptrlr1vin text,
    ptrlr2vin text,
    ptrlr3vin text,
    constraint fars_parkwork_pk primary key (st_case, veh_no)
);

CREATE TABLE fars.pbtype (
    state integer references fars.state (state),
    st_case integer references fars.accident (st_case),
    veh_no integer,
    per_no integer,
    pbptype integer references fars.person_type (per_typ),
    pbage integer,
    pbsex integer,
    pbcwalk integer,
    pbswalk integer,
    pbszone integer,
    pedctype integer references fars.ped_crash_type (pedctype),
    bikectype integer references fars.bike_crash_type (bikectype),
    pedloc integer,
    bikeloc integer,
    pedpos integer,
    bikepos integer,
    peddir integer,
    bikedir integer,
    motdir integer,
    motman integer,
    pedleg integer,
    pedsnr text,
    pedcgp integer references crash_group_pedestrian (pedcgp),
    bikecgp integer references crash_group_bike (bikecgp),
    constraint fars_pbtype_pk primary key (st_case, per_no)
);

CREATE TABLE fars.person (
    state integer references fars.state (state),
    st_case integer references fars.accident (st_case),
    ve_forms integer,
    veh_no integer,
    per_no integer,
    str_veh integer,
    county integer,
    day integer,
    month integer,
    hour integer,
    minute integer,
    rur_urb integer references fars.rural_urban (rur_urb),
    func_sys integer,
    harm_ev integer,
    man_coll integer,
    sch_bus integer,
    make integer references fars.vehicle_make (make),
    mak_mod integer,
    body_typ integer references fars.body_type (body_typ),
    mod_year integer,
    tow_veh integer references fars.trailing_vehicle (tow_veh),
    spec_use integer,
    emer_use integer,
    rollover integer,
    impact1 integer,
    fire_exp integer,
    age integer,
    sex integer,
    per_typ integer references fars.person_type (per_typ),
    inj_sev integer references fars.injury_severity (inj_sev),
    seat_pos integer,
    rest_use integer,
    rest_mis integer,
    air_bag integer,
    ejection integer,
    ej_path integer,
    extricat integer,
    drinking integer,
    alc_det integer,
    alc_status integer,
    atst_typ integer,
    alc_res integer,
    drugs integer,
    drug_det integer,
    dstatus integer,
    drugtst1 integer,
    drugtst2 integer,
    drugtst3 integer,
    drugres1 integer references fars.drug_test_result (drugres),
    drugres2 integer references fars.drug_test_result (drugres),
    drugres3 integer references fars.drug_test_result (drugres),
    hospital integer,
    doa integer,
    death_da integer,
    death_mo integer,
    death_yr integer,
    death_hr integer,
    death_mn integer,
    death_tm integer,
    lag_hrs integer,
    lag_mins integer,
    p_sf1 integer references fars.related_factors_person (p_sf),
    p_sf2 integer references fars.related_factors_person (p_sf),
    p_sf3 integer references fars.related_factors_person (p_sf),
    work_inj integer,
    hispanic integer,
    race integer,
    location integer,
    constraint fars_person_pk primary key (st_case, veh_no, per_no)
);

CREATE TABLE fars.safetyeq (
    state integer references fars.state (state),
    st_case integer references fars.accident (st_case),
    veh_no integer,
    per_no integer,
    msafeqmt integer references fars.safety_equipment (msafeqmt)
);
create index on fars.safetyeq (st_case, veh_no, per_no);

CREATE TABLE fars.vehicle (
    state integer references fars.state (state),
    st_case integer references fars.accident (st_case),
    veh_no integer,
    ve_forms integer,
    numoccs integer,
    day integer,
    month integer,
    hour integer,
    minute integer,
    harm_ev integer,
    man_coll integer,
    unittype integer,
    hit_run integer,
    reg_stat integer,
    owner integer references fars.vehicle_owner (owner),
    make integer references fars.vehicle_make (make),
    model integer,
    mak_mod integer,
    body_typ integer references fars.body_type (body_typ),
    mod_year integer,
    vin text,
    vin_1 text,
    vin_2 text,
    vin_3 text,
    vin_4 text,
    vin_5 text,
    vin_6 text,
    vin_7 text,
    vin_8 text,
    vin_9 text,
    vin_10 text,
    vin_11 text,
    vin_12 text,
    tow_veh integer references fars.trailing_vehicle (tow_veh),
    j_knife integer,
    mcarr_i1 integer,
    mcarr_i2 text,
    mcarr_id text,
    gvwr integer,
    v_config integer,
    cargo_bt integer,
    haz_inv integer,
    haz_plac integer,
    haz_id integer,
    haz_cno integer references fars.hazardous_material_class (haz_cno),
    haz_rel integer,
    bus_use integer references fars.bus_use (bus_use),
    spec_use integer,
    emer_use integer,
    trav_sp integer,
    underide integer,
    rollover integer,
    rolinloc integer,
    impact1 integer,
    deformed integer,
    towed integer,
    m_harm integer references fars.harmful_event (harm_ev),
    veh_sc1 integer,
    veh_sc2 integer,
    fire_exp integer,
    dr_pres integer,
    l_state integer references fars.state (state),
    dr_zip text,
    l_status integer,
    l_type integer,
    cdl_stat integer,
    l_endors integer,
    l_compl integer,
    l_restri integer,
    dr_hgt integer,
    dr_wgt integer,
    prev_acc integer,
    prev_sus integer,
    prev_dwi integer,
    prev_spd integer,
    prev_oth integer,
    first_mo integer,
    first_yr integer,
    last_mo integer,
    last_yr integer,
    speedrel integer,
    dr_sf1 integer references fars.related_factors_driver (dr_sf),
    dr_sf2 integer references fars.related_factors_driver (dr_sf),
    dr_sf3 integer references fars.related_factors_driver (dr_sf),
    dr_sf4 integer references fars.related_factors_driver (dr_sf),
    vtrafway integer references fars.trafficway (vtrafway),
    vnum_lan integer,
    vspd_lim integer,
    valign integer,
    vprofile integer,
    vpavetyp integer,
    vsurcond integer references fars.roadway_surface (vsurcond),
    vtrafcon integer,
    vtcont_f integer,
    p_crash1 integer references fars.pre_event_movement (p_crash1),
    p_crash2 integer references fars.critical_precrash_event (p_crash2),
    p_crash3 integer references fars.attempted_avoidance (p_crash3),
    pcrash4 integer,
    pcrash5 integer,
    acc_type integer references fars.accident_type (acc_type),
    trlr1vin text,
    trlr2vin text,
    trlr3vin text,
    deaths integer,
    dr_drink integer,
    constraint fars_vehicle_pk primary key (st_case, veh_no)
);

CREATE TABLE fars.vevent (
    state integer references fars.state (state),
    st_case integer references fars.accident (st_case),
    eventnum integer,
    veh_no integer,
    veventnum integer,
    vnumber1 integer,
    aoi1 integer references fars.area_of_impact (aoi),
    soe integer references fars.sequence_events (soe),
    vnumber2 integer,
    aoi2 integer references fars.area_of_impact (aoi),
    constraint fars_vevent_pk primary key (st_case, veh_no, eventnum)
);

CREATE TABLE fars.vindecode (
    state integer references fars.state (state),
    st_case integer references fars.accident (st_case),
    veh_no integer,
    ncicmake text,
    vinyear integer,
    vehtype text,
    vehtype_t text,
    vinmake_t text,
    vinmodel_t text,
    vintrim_t text,
    vintrim1_t text,
    vintrim2_t text,
    vintrim3_t text,
    vintrim4_t text,
    bodystyl text,
    bodystyl_t text,
    doors integer,
    wheels integer,
    drivwhls integer,
    mfg text,
    mfg_t text,
    displci integer,
    displcc integer,
    cylndrs text,
    cycles integer,
    fuel text,
    fuel_t text,
    fuelinj text,
    fuelinj_t text,
    carbtype text,
    carbtype_t text,
    carbbrls text,
    gvwrange integer,
    gvwrange_t text,
    whlbsh double precision,
    whlblg double precision,
    tiredesc_f text,
    psi_f integer,
    tiresz_f text,
    tiresz_f_t text,
    tiredesc_r text,
    psi_r integer,
    rearsize integer,
    rearsize_t text,
    tonrating text,
    shipweight integer,
    msrp integer,
    drivetyp text,
    drivetyp_t text,
    salectry text,
    salectry_t text,
    abs text,
    abs_t text,
    security text,
    security_t text,
    drl text,
    drl_t text,
    rstrnt text,
    rstrnt_t text,
    tkcab text,
    tkcab_t text,
    tkaxlef text,
    tkaxlef_t text,
    tkaxler text,
    tkaxler_t text,
    tkbrak text,
    tkbrak_t text,
    engmfg text,
    engmfg_t text,
    engmodel text,
    tkduty text,
    tkduty_t text,
    tkbedl text,
    tkbedl_t text,
    segmnt text,
    segmnt_t text,
    plant text,
    plntctry_t text,
    plntcity text,
    plntctry text,
    plntstat text,
    plntstat_t text,
    origin text,
    origin_t text,
    dispclmt double precision,
    blocktype text,
    enghead text,
    enghead_t text,
    vlvclndr integer,
    vlvtotal integer,
    engvincd text,
    incomplt boolean,
    battyp text,
    battyp_t text,
    batkwrtg text,
    batvolt double precision,
    supchrgr text,
    supchrgr_t text,
    turbo text,
    turbo_t text,
    engvvt text,
    mcyusage text,
    mcyusage_t text,
    constraint fars_vindecode_pk primary key (st_case, veh_no)
);

CREATE TABLE fars.violatn (
    state integer references fars.state (state),
    st_case integer references fars.accident (st_case),
    veh_no integer,
    mviolatn integer references violations_charged (mviolatn)
);
create index on fars.violatn (st_case, veh_no);

CREATE TABLE fars.vision (
    state integer references fars.state (state),
    st_case integer references fars.accident (st_case),
    veh_no integer,
    mvisobsc integer references fars.vision_obscured (mvisobsc)
);
create index on fars.vision (st_case, veh_no);

CREATE TABLE fars.vsoe (
    state integer references fars.state (state),
    st_case integer references fars.accident (st_case),
    veh_no integer,
    veventnum integer,
    soe integer,
    aoi integer,
    constraint fars_vsoe_pk primary key (st_case, veh_no, veventnum)
);
