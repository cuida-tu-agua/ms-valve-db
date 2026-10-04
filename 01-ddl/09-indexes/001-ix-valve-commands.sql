--liquibase formatted sql

--changeset esteban:ddl-index-001-ix-valve-commands
--comment: HU-022 history of a place by date, newest first
CREATE INDEX IX_vcmd_place_time ON valve.valve_commands (place_id, created_at DESC);
--rollback DROP INDEX IX_vcmd_place_time ON valve.valve_commands;
