--liquibase formatted sql

--changeset esteban:ddl-fk-004-fk-vcmd-device
--comment: valve_commands.device_id -> devices.devices (cross-schema, ADR-002)
ALTER TABLE valve.valve_commands
    ADD CONSTRAINT FK_vcmd_device
    FOREIGN KEY (device_id) REFERENCES devices.devices (id);
--rollback ALTER TABLE valve.valve_commands DROP CONSTRAINT FK_vcmd_device;
