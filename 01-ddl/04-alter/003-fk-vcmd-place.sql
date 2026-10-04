--liquibase formatted sql

--changeset esteban:ddl-fk-003-fk-vcmd-place
--comment: valve_commands.place_id -> places.places (cross-schema, ADR-002)
ALTER TABLE valve.valve_commands
    ADD CONSTRAINT FK_vcmd_place
    FOREIGN KEY (place_id) REFERENCES places.places (id);
--rollback ALTER TABLE valve.valve_commands DROP CONSTRAINT FK_vcmd_place;
