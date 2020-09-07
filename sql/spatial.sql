alter table :schema.accident add column geom Geometry;

CREATE INDEX IF NOT EXISTS accident_geom_idx
    ON :schema.accident using gist (geom);

create or replace function :schema.add_geom() returns trigger
as $$
    begin
        new.geom = st_setsrid(
            st_makepoint(nullif(new.longitud, 999.9999), nullif(new.latitude, 99.9999)),
            4326);
        return new;
    end;
$$ language plpgsql;

create trigger accident_geom_trigger before insert on :schema.accident
    for each row when (NEW.geom is null) execute procedure :schema.add_geom();
