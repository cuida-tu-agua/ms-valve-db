--liquibase formatted sql

--changeset esteban:ddl-fk-002-fk-vstate-device
--comment: valve_states.device_id -> devices.devices (cross-schema, ADR-002)
ALTER TABLE valve.valve_states
    ADD CONSTRAINT FK_vstate_device
    FOREIGN KEY (device_id) REFERENCES devices.devices (id);
--rollback ALTER TABLE valve.valve_states DROP CONSTRAINT FK_vstate_device;
