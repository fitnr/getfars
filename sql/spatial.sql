alter table fars.accident add column geom Geometry;

create index on fars.accident using gist (geom);

create or replace function fars.add_geom() returns trigger
as $$
    begin
        new.geom = st_setsrid(
            st_makepoint(nullif(new.longitud, 999.9999), nullif(new.latitude, 99.9999)),
            4326);
        return new;
    end;
$$ language plpgsql;

create trigger accident_geom_trigger before insert on fars.accident
    for each row when (NEW.geom is null) execute procedure fars.add_geom();
