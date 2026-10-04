--liquibase formatted sql

--changeset esteban:ddl-fk-001-fk-vstate-place
--comment: valve_states.place_id -> places.places (cross-schema, ADR-002)
ALTER TABLE valve.valve_states
    ADD CONSTRAINT FK_vstate_place
    FOREIGN KEY (place_id) REFERENCES places.places (id);
--rollback ALTER TABLE valve.valve_states DROP CONSTRAINT FK_vstate_place;
