--liquibase formatted sql

--changeset esteban:ddl-index-002-ux-valve-commands-pending
--comment: At most ONE order in progress per place: two phones pressing "Cerrar" at the same time cannot both send
CREATE UNIQUE INDEX UX_vcmd_place_pending ON valve.valve_commands (place_id) WHERE status = N'SENT';
--rollback DROP INDEX UX_vcmd_place_pending ON valve.valve_commands;
