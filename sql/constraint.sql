SET search_path to :schema;

CREATE INDEX IF NOT EXISTS damage_idx ON damage (st_case, veh_no);
CREATE INDEX IF NOT EXISTS distract_idx ON distract (st_case, veh_no);
CREATE INDEX IF NOT EXISTS drimpair_idx ON drimpair (st_case, veh_no);
CREATE INDEX IF NOT EXISTS factor_idx ON factor (st_case, veh_no);
CREATE INDEX IF NOT EXISTS maneuver_idx ON maneuver (st_case, veh_no);
CREATE INDEX IF NOT EXISTS nmcrash_idx ON nmcrash (st_case, veh_no, per_no);
CREATE INDEX IF NOT EXISTS nmimpair_idx ON nmimpair (st_case, veh_no, per_no);
CREATE INDEX IF NOT EXISTS nmprior_idx ON nmprior (st_case, veh_no, per_no);
CREATE INDEX IF NOT EXISTS safetyeq_idx ON safetyeq (st_case, veh_no, per_no);
CREATE INDEX IF NOT EXISTS violatn_idx ON violatn (st_case, veh_no);
CREATE INDEX IF NOT EXISTS vision_idx ON vision (st_case, veh_no);

ALTER TABLE accident ADD CONSTRAINT accident_state_fkey FOREIGN KEY (state) REFERENCES state (state);
ALTER TABLE accident ADD CONSTRAINT accident_rur_urb_fkey FOREIGN KEY (rur_urb) REFERENCES rural_urban (rur_urb);
ALTER TABLE accident ADD CONSTRAINT accident_func_sys_fkey FOREIGN KEY (func_sys) REFERENCES functional_system (func_sys);
ALTER TABLE accident ADD CONSTRAINT accident_rd_owner_fkey FOREIGN KEY (rd_owner) REFERENCES road_owner (rd_owner);
ALTER TABLE accident ADD CONSTRAINT accident_route_fkey FOREIGN KEY (route) REFERENCES route (route);
ALTER TABLE accident ADD CONSTRAINT accident_sp_jur_fkey FOREIGN KEY (sp_jur) REFERENCES special_jurisdiction (sp_jur);
ALTER TABLE accident ADD CONSTRAINT accident_harm_ev_fkey FOREIGN KEY (harm_ev) REFERENCES harmful_event (harm_ev);
ALTER TABLE accident ADD CONSTRAINT accident_man_coll_fkey FOREIGN KEY (man_coll) REFERENCES manner_of_collision (man_coll);
ALTER TABLE accident ADD CONSTRAINT accident_rel_road_fkey FOREIGN KEY (rel_road) REFERENCES relation_to_road (rel_road);
ALTER TABLE accident ADD CONSTRAINT accident_lgt_cond_fkey FOREIGN KEY (lgt_cond) REFERENCES light_condition (lgt_cond);
ALTER TABLE accident ADD CONSTRAINT accident_weather1_fkey FOREIGN KEY (weather1) REFERENCES atmospheric_condition (weather);
ALTER TABLE accident ADD CONSTRAINT accident_weather2_fkey FOREIGN KEY (weather2) REFERENCES atmospheric_condition (weather);
ALTER TABLE accident ADD CONSTRAINT accident_weather_fkey FOREIGN KEY (weather) REFERENCES atmospheric_condition (weather);
ALTER TABLE accident ADD CONSTRAINT accident_cf1_fkey FOREIGN KEY (cf1) REFERENCES related_factors_crash (cf);
ALTER TABLE accident ADD CONSTRAINT accident_cf2_fkey FOREIGN KEY (cf2) REFERENCES related_factors_crash (cf);
ALTER TABLE accident ADD CONSTRAINT accident_cf3_fkey FOREIGN KEY (cf3) REFERENCES related_factors_crash (cf);
ALTER TABLE cevent ADD CONSTRAINT cevent_state_fkey FOREIGN KEY (state) REFERENCES state (state);
ALTER TABLE cevent ADD CONSTRAINT cevent_aoi1_fkey FOREIGN KEY (aoi1) REFERENCES area_of_impact (aoi);
ALTER TABLE cevent ADD CONSTRAINT cevent_soe_fkey FOREIGN KEY (soe) REFERENCES sequence_events (soe);
ALTER TABLE cevent ADD CONSTRAINT cevent_aoi2_fkey FOREIGN KEY (aoi2) REFERENCES area_of_impact (aoi);
ALTER TABLE damage ADD CONSTRAINT damage_state_fkey FOREIGN KEY (state) REFERENCES state (state);
ALTER TABLE damage ADD CONSTRAINT damage_st_case_fkey FOREIGN KEY (st_case) REFERENCES accident (st_case);
ALTER TABLE damage ADD CONSTRAINT damage_mdareas_fkey FOREIGN KEY (mdareas) REFERENCES damaged_area (mdareas);
ALTER TABLE distract ADD CONSTRAINT distract_state_fkey FOREIGN KEY (state) REFERENCES state (state);
ALTER TABLE distract ADD CONSTRAINT distract_st_case_fkey FOREIGN KEY (st_case) REFERENCES accident (st_case);
ALTER TABLE distract ADD CONSTRAINT distract_mdrdstrd_fkey FOREIGN KEY (mdrdstrd) REFERENCES driver_distracted (mdrdstrd);
ALTER TABLE drimpair ADD CONSTRAINT drimpair_state_fkey FOREIGN KEY (state) REFERENCES state (state);
ALTER TABLE drimpair ADD CONSTRAINT drimpair_st_case_fkey FOREIGN KEY (st_case) REFERENCES accident (st_case);
ALTER TABLE drimpair ADD CONSTRAINT drimpair_drimpair_fkey FOREIGN KEY (drimpair) REFERENCES impairment (impair);
ALTER TABLE factor ADD CONSTRAINT factor_state_fkey FOREIGN KEY (state) REFERENCES state (state);
ALTER TABLE factor ADD CONSTRAINT factor_st_case_fkey FOREIGN KEY (st_case) REFERENCES accident (st_case);
ALTER TABLE factor ADD CONSTRAINT factor_mfactor_fkey FOREIGN KEY (mfactor) REFERENCES motor_vehicle_factor (mfactor);
ALTER TABLE maneuver ADD CONSTRAINT maneuver_state_fkey FOREIGN KEY (state) REFERENCES state (state);
ALTER TABLE maneuver ADD CONSTRAINT maneuver_st_case_fkey FOREIGN KEY (st_case) REFERENCES accident (st_case);
ALTER TABLE maneuver ADD CONSTRAINT maneuver_mdrmanav_fkey FOREIGN KEY (mdrmanav) REFERENCES driver_maneuver (mdrmanav);
ALTER TABLE nmcrash ADD CONSTRAINT nmcrash_state_fkey FOREIGN KEY (state) REFERENCES state (state);
ALTER TABLE nmcrash ADD CONSTRAINT nmcrash_st_case_fkey FOREIGN KEY (st_case) REFERENCES accident (st_case);
ALTER TABLE nmcrash ADD CONSTRAINT nmcrash_mtm_crsh_fkey FOREIGN KEY (mtm_crsh) REFERENCES nonmotorist_contributing (mtm_crsh);
ALTER TABLE nmimpair ADD CONSTRAINT nmimpair_state_fkey FOREIGN KEY (state) REFERENCES state (state);
ALTER TABLE nmimpair ADD CONSTRAINT nmimpair_st_case_fkey FOREIGN KEY (st_case) REFERENCES accident (st_case);
ALTER TABLE nmimpair ADD CONSTRAINT nmimpair_nmimpair_fkey FOREIGN KEY (nmimpair) REFERENCES impairment (impair);
ALTER TABLE nmprior ADD CONSTRAINT nmprior_state_fkey FOREIGN KEY (state) REFERENCES state (state);
ALTER TABLE nmprior ADD CONSTRAINT nmprior_st_case_fkey FOREIGN KEY (st_case) REFERENCES accident (st_case);
ALTER TABLE nmprior ADD CONSTRAINT nmprior_mpr_act_fkey FOREIGN KEY (mpr_act) REFERENCES nonmotorist_action (mpr_act);
ALTER TABLE parkwork ADD CONSTRAINT parkwork_state_fkey FOREIGN KEY (state) REFERENCES state (state);
ALTER TABLE parkwork ADD CONSTRAINT parkwork_st_case_fkey FOREIGN KEY (st_case) REFERENCES accident (st_case);
ALTER TABLE parkwork ADD CONSTRAINT parkwork_pman_coll_fkey FOREIGN KEY (pman_coll) REFERENCES manner_of_collision (man_coll);
ALTER TABLE parkwork ADD CONSTRAINT parkwork_phit_run_fkey FOREIGN KEY (phit_run) REFERENCES hit_run (hit_run);
ALTER TABLE parkwork ADD CONSTRAINT parkwork_powner_fkey FOREIGN KEY (powner) REFERENCES vehicle_owner (owner);
ALTER TABLE parkwork ADD CONSTRAINT parkwork_pmake_fkey FOREIGN KEY (pmake) REFERENCES vehicle_make (make);
ALTER TABLE parkwork ADD CONSTRAINT parkwork_pbodytyp_fkey FOREIGN KEY (pbodytyp) REFERENCES body_type (body_typ);
ALTER TABLE parkwork ADD CONSTRAINT parkwork_pv_config_fkey FOREIGN KEY (pv_config) REFERENCES vehicle_config (v_config);
ALTER TABLE parkwork ADD CONSTRAINT parkwork_phaz_cno_fkey FOREIGN KEY (phaz_cno) REFERENCES hazardous_material_class (haz_cno);
ALTER TABLE parkwork ADD CONSTRAINT parkwork_pbus_use_fkey FOREIGN KEY (pbus_use) REFERENCES bus_use (bus_use);
ALTER TABLE parkwork ADD CONSTRAINT parkwork_psp_use_fkey FOREIGN KEY (psp_use) REFERENCES special_use (spec_use);
ALTER TABLE parkwork ADD CONSTRAINT parkwork_pem_use_fkey FOREIGN KEY (pem_use) REFERENCES emergency_use (emer_use);
ALTER TABLE parkwork ADD CONSTRAINT parkwork_pimpact1_fkey FOREIGN KEY (pimpact1) REFERENCES area_of_impact (aoi);
ALTER TABLE parkwork ADD CONSTRAINT parkwork_pm_harm_fkey FOREIGN KEY (pm_harm) REFERENCES harmful_event (harm_ev);
ALTER TABLE parkwork ADD CONSTRAINT parkwork_pveh_sc1_fkey FOREIGN KEY (pveh_sc1) REFERENCES related_factors_vehicle (sc);
ALTER TABLE parkwork ADD CONSTRAINT parkwork_pveh_sc2_fkey FOREIGN KEY (pveh_sc2) REFERENCES related_factors_vehicle (sc);
ALTER TABLE pbtype ADD CONSTRAINT pbtype_state_fkey FOREIGN KEY (state) REFERENCES state (state);
ALTER TABLE pbtype ADD CONSTRAINT pbtype_st_case_fkey FOREIGN KEY (st_case) REFERENCES accident (st_case);
ALTER TABLE pbtype ADD CONSTRAINT pbtype_pbptype_fkey FOREIGN KEY (pbptype) REFERENCES person_type (per_typ);
ALTER TABLE pbtype ADD CONSTRAINT pbtype_pbsex_fkey FOREIGN KEY (pbsex) REFERENCES sex (sex);
ALTER TABLE pbtype ADD CONSTRAINT pbtype_pedctype_fkey FOREIGN KEY (pedctype) REFERENCES ped_crash_type (pedctype);
ALTER TABLE pbtype ADD CONSTRAINT pbtype_bikectype_fkey FOREIGN KEY (bikectype) REFERENCES bike_crash_type (bikectype);
ALTER TABLE pbtype ADD CONSTRAINT pbtype_pedloc_fkey FOREIGN KEY (pedloc) REFERENCES ped_location (pedloc);
ALTER TABLE pbtype ADD CONSTRAINT pbtype_bikeloc_fkey FOREIGN KEY (bikeloc) REFERENCES bike_location (bikeloc);
ALTER TABLE pbtype ADD CONSTRAINT pbtype_pedpos_fkey FOREIGN KEY (pedpos) REFERENCES ped_position (pedpos);
ALTER TABLE pbtype ADD CONSTRAINT pbtype_bikepos_fkey FOREIGN KEY (bikepos) REFERENCES bike_position (bikepos);
ALTER TABLE pbtype ADD CONSTRAINT pbtype_pedcgp_fkey FOREIGN KEY (pedcgp) REFERENCES crash_group_pedestrian (pedcgp);
ALTER TABLE pbtype ADD CONSTRAINT pbtype_bikecgp_fkey FOREIGN KEY (bikecgp) REFERENCES crash_group_bike (bikecgp);
ALTER TABLE person ADD CONSTRAINT person_state_fkey FOREIGN KEY (state) REFERENCES state (state);
ALTER TABLE person ADD CONSTRAINT person_st_case_fkey FOREIGN KEY (st_case) REFERENCES accident (st_case);
ALTER TABLE person ADD CONSTRAINT person_rur_urb_fkey FOREIGN KEY (rur_urb) REFERENCES rural_urban (rur_urb);
ALTER TABLE person ADD CONSTRAINT person_man_coll_fkey FOREIGN KEY (man_coll) REFERENCES manner_of_collision (man_coll);
ALTER TABLE person ADD CONSTRAINT person_make_fkey FOREIGN KEY (make) REFERENCES vehicle_make (make);
ALTER TABLE person ADD CONSTRAINT person_body_typ_fkey FOREIGN KEY (body_typ) REFERENCES body_type (body_typ);
ALTER TABLE person ADD CONSTRAINT person_tow_veh_fkey FOREIGN KEY (tow_veh) REFERENCES trailing_vehicle (tow_veh);
ALTER TABLE person ADD CONSTRAINT person_spec_use_fkey FOREIGN KEY (spec_use) REFERENCES special_use (spec_use);
ALTER TABLE person ADD CONSTRAINT person_emer_use_fkey FOREIGN KEY (emer_use) REFERENCES emergency_use (emer_use);
ALTER TABLE person ADD CONSTRAINT person_impact1_fkey FOREIGN KEY (impact1) REFERENCES area_of_impact (aoi);
ALTER TABLE person ADD CONSTRAINT person_sex_fkey FOREIGN KEY (sex) REFERENCES sex (sex);
ALTER TABLE person ADD CONSTRAINT person_per_typ_fkey FOREIGN KEY (per_typ) REFERENCES person_type (per_typ);
ALTER TABLE person ADD CONSTRAINT person_inj_sev_fkey FOREIGN KEY (inj_sev) REFERENCES injury_severity (inj_sev);
ALTER TABLE person ADD CONSTRAINT person_seat_pos_fkey FOREIGN KEY (seat_pos) REFERENCES seating_position (seat_pos);
ALTER TABLE person ADD CONSTRAINT person_air_bag_fkey FOREIGN KEY (air_bag) REFERENCES air_bag (air_bag);
ALTER TABLE person ADD CONSTRAINT person_ejection_fkey FOREIGN KEY (ejection) REFERENCES ejection (ejection);
ALTER TABLE person ADD CONSTRAINT person_ej_path_fkey FOREIGN KEY (ej_path) REFERENCES ejection_path (ej_path);
ALTER TABLE person ADD CONSTRAINT person_alc_det_fkey FOREIGN KEY (alc_det) REFERENCES method_alc_det (alc_det);
ALTER TABLE person ADD CONSTRAINT person_alc_status_fkey FOREIGN KEY (alc_status) REFERENCES alc_test (alc_status);
ALTER TABLE person ADD CONSTRAINT person_drugres1_fkey FOREIGN KEY (drugres1) REFERENCES drug_test_result (drugres);
ALTER TABLE person ADD CONSTRAINT person_drugres2_fkey FOREIGN KEY (drugres2) REFERENCES drug_test_result (drugres);
ALTER TABLE person ADD CONSTRAINT person_drugres3_fkey FOREIGN KEY (drugres3) REFERENCES drug_test_result (drugres);
ALTER TABLE person ADD CONSTRAINT person_hospital_fkey FOREIGN KEY (hospital) REFERENCES transported_treatment (hospital);
ALTER TABLE person ADD CONSTRAINT person_p_sf1_fkey FOREIGN KEY (p_sf1) REFERENCES related_factors_person (p_sf);
ALTER TABLE person ADD CONSTRAINT person_p_sf2_fkey FOREIGN KEY (p_sf2) REFERENCES related_factors_person (p_sf);
ALTER TABLE person ADD CONSTRAINT person_p_sf3_fkey FOREIGN KEY (p_sf3) REFERENCES related_factors_person (p_sf);
ALTER TABLE person ADD CONSTRAINT person_hispanic_fkey FOREIGN KEY (hispanic) REFERENCES hispanic_origin (hispanic);
ALTER TABLE person ADD CONSTRAINT person_race_fkey FOREIGN KEY (race) REFERENCES race (race);
ALTER TABLE person ADD CONSTRAINT person_location_fkey FOREIGN KEY (location) REFERENCES location (location);
ALTER TABLE safetyeq ADD CONSTRAINT safetyeq_state_fkey FOREIGN KEY (state) REFERENCES state (state);
ALTER TABLE safetyeq ADD CONSTRAINT safetyeq_st_case_fkey FOREIGN KEY (st_case) REFERENCES accident (st_case);
ALTER TABLE vehicle ADD CONSTRAINT vehicle_state_fkey FOREIGN KEY (state) REFERENCES state (state);
ALTER TABLE vehicle ADD CONSTRAINT vehicle_st_case_fkey FOREIGN KEY (st_case) REFERENCES accident (st_case);
ALTER TABLE vehicle ADD CONSTRAINT vehicle_harm_ev_fkey FOREIGN KEY (harm_ev) REFERENCES harmful_event (harm_ev);
ALTER TABLE vehicle ADD CONSTRAINT vehicle_man_coll_fkey FOREIGN KEY (man_coll) REFERENCES manner_of_collision (man_coll);
ALTER TABLE vehicle ADD CONSTRAINT vehicle_hit_run_fkey FOREIGN KEY (hit_run) REFERENCES hit_run (hit_run);
ALTER TABLE vehicle ADD CONSTRAINT vehicle_owner_fkey FOREIGN KEY (owner) REFERENCES vehicle_owner (owner);
ALTER TABLE vehicle ADD CONSTRAINT vehicle_make_fkey FOREIGN KEY (make) REFERENCES vehicle_make (make);
ALTER TABLE vehicle ADD CONSTRAINT vehicle_body_typ_fkey FOREIGN KEY (body_typ) REFERENCES body_type (body_typ);
ALTER TABLE vehicle ADD CONSTRAINT vehicle_tow_veh_fkey FOREIGN KEY (tow_veh) REFERENCES trailing_vehicle (tow_veh);
ALTER TABLE vehicle ADD CONSTRAINT vehicle_v_config_fkey FOREIGN KEY (v_config) REFERENCES vehicle_config (v_config);
ALTER TABLE vehicle ADD CONSTRAINT vehicle_cargo_bt_fkey FOREIGN KEY (cargo_bt) REFERENCES cargo_body_type (cargo_bt);
ALTER TABLE vehicle ADD CONSTRAINT vehicle_haz_cno_fkey FOREIGN KEY (haz_cno) REFERENCES hazardous_material_class (haz_cno);
ALTER TABLE vehicle ADD CONSTRAINT vehicle_bus_use_fkey FOREIGN KEY (bus_use) REFERENCES bus_use (bus_use);
ALTER TABLE vehicle ADD CONSTRAINT vehicle_spec_use_fkey FOREIGN KEY (spec_use) REFERENCES special_use (spec_use);
ALTER TABLE vehicle ADD CONSTRAINT vehicle_emer_use_fkey FOREIGN KEY (emer_use) REFERENCES emergency_use (emer_use);
ALTER TABLE vehicle ADD CONSTRAINT vehicle_deformed_fkey FOREIGN KEY (deformed) REFERENCES damage_extent (deformed);
ALTER TABLE vehicle ADD CONSTRAINT vehicle_m_harm_fkey FOREIGN KEY (m_harm) REFERENCES harmful_event (harm_ev);
ALTER TABLE vehicle ADD CONSTRAINT vehicle_l_state_fkey FOREIGN KEY (l_state) REFERENCES state (state);
ALTER TABLE vehicle ADD CONSTRAINT vehicle_speedrel_fkey FOREIGN KEY (speedrel) REFERENCES speeding (speedrel);
ALTER TABLE vehicle ADD CONSTRAINT vehicle_dr_sf1_fkey FOREIGN KEY (dr_sf1) REFERENCES related_factors_driver (dr_sf);
ALTER TABLE vehicle ADD CONSTRAINT vehicle_dr_sf2_fkey FOREIGN KEY (dr_sf2) REFERENCES related_factors_driver (dr_sf);
ALTER TABLE vehicle ADD CONSTRAINT vehicle_dr_sf3_fkey FOREIGN KEY (dr_sf3) REFERENCES related_factors_driver (dr_sf);
ALTER TABLE vehicle ADD CONSTRAINT vehicle_dr_sf4_fkey FOREIGN KEY (dr_sf4) REFERENCES related_factors_driver (dr_sf);
ALTER TABLE vehicle ADD CONSTRAINT vehicle_vtrafway_fkey FOREIGN KEY (vtrafway) REFERENCES trafficway (vtrafway);
ALTER TABLE vehicle ADD CONSTRAINT vehicle_vsurcond_fkey FOREIGN KEY (vsurcond) REFERENCES roadway_surface (vsurcond);
ALTER TABLE vehicle ADD CONSTRAINT vehicle_p_crash1_fkey FOREIGN KEY (p_crash1) REFERENCES pre_event_movement (p_crash1);
ALTER TABLE vehicle ADD CONSTRAINT vehicle_p_crash2_fkey FOREIGN KEY (p_crash2) REFERENCES critical_precrash_event (p_crash2);
ALTER TABLE vehicle ADD CONSTRAINT vehicle_p_crash3_fkey FOREIGN KEY (p_crash3) REFERENCES attempted_avoidance (p_crash3);
ALTER TABLE vehicle ADD CONSTRAINT vehicle_acc_type_fkey FOREIGN KEY (acc_type) REFERENCES accident_type (acc_type);
ALTER TABLE vevent ADD CONSTRAINT vevent_state_fkey FOREIGN KEY (state) REFERENCES state (state);
ALTER TABLE vevent ADD CONSTRAINT vevent_st_case_fkey FOREIGN KEY (st_case) REFERENCES accident (st_case);
ALTER TABLE vevent ADD CONSTRAINT vevent_aoi1_fkey FOREIGN KEY (aoi1) REFERENCES area_of_impact (aoi);
ALTER TABLE vevent ADD CONSTRAINT vevent_soe_fkey FOREIGN KEY (soe) REFERENCES sequence_events (soe);
ALTER TABLE vevent ADD CONSTRAINT vevent_aoi2_fkey FOREIGN KEY (aoi2) REFERENCES area_of_impact (aoi);
ALTER TABLE vindecode ADD CONSTRAINT vindecode_state_fkey FOREIGN KEY (state) REFERENCES state (state);
ALTER TABLE vindecode ADD CONSTRAINT vindecode_st_case_fkey FOREIGN KEY (st_case) REFERENCES accident (st_case);
ALTER TABLE violatn ADD CONSTRAINT violatn_state_fkey FOREIGN KEY (state) REFERENCES state (state);
ALTER TABLE violatn ADD CONSTRAINT violatn_st_case_fkey FOREIGN KEY (st_case) REFERENCES accident (st_case);
ALTER TABLE violatn ADD CONSTRAINT violatn_mviolatn_fkey FOREIGN KEY (mviolatn) REFERENCES violations_charged (mviolatn);
ALTER TABLE vision ADD CONSTRAINT vision_state_fkey FOREIGN KEY (state) REFERENCES state (state);
ALTER TABLE vision ADD CONSTRAINT vision_st_case_fkey FOREIGN KEY (st_case) REFERENCES accident (st_case);
ALTER TABLE vision ADD CONSTRAINT vision_mvisobsc_fkey FOREIGN KEY (mvisobsc) REFERENCES vision_obscured (mvisobsc);
ALTER TABLE vsoe ADD CONSTRAINT vsoe_state_fkey FOREIGN KEY (state) REFERENCES state (state);
ALTER TABLE vsoe ADD CONSTRAINT vsoe_st_case_fkey FOREIGN KEY (st_case) REFERENCES accident (st_case);
ALTER TABLE vsoe ADD CONSTRAINT vsoe_soe_fkey FOREIGN KEY (soe) REFERENCES sequence_events (soe);
ALTER TABLE vsoe ADD CONSTRAINT vsoe_aoi_fkey FOREIGN KEY (aoi) REFERENCES area_of_impact (aoi);