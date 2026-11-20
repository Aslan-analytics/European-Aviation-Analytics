-- View: public.vw_airport_operations

-- DROP VIEW public.vw_airport_operations;

CREATE OR REPLACE VIEW public.vw_airport_operations
 AS
 SELECT t.year,
    t.month_num,
    t.flt_date,
    t.apt_icao,
    t.apt_name,
    t.state_name,
    t.flt_dep_1,
    t.flt_arr_1,
    t.flt_tot_1,
    d.flt_dep_ifr_2,
    d.dly_all_pre_2
   FROM airport_traffic t
     LEFT JOIN airport_delays d ON t.flt_date = d.flt_date AND t.apt_icao::text = d.apt_icao::text;

ALTER TABLE public.vw_airport_operations
    OWNER TO postgres;

