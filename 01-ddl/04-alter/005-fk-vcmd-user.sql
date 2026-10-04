--liquibase formatted sql

--changeset esteban:ddl-fk-005-fk-vcmd-user
--comment: valve_commands.requested_by -> security.users (cross-schema, ADR-002)
ALTER TABLE valve.valve_commands
    ADD CONSTRAINT FK_vcmd_user
    FOREIGN KEY (requested_by) REFERENCES security.users (id);
--rollback ALTER TABLE valve.valve_commands DROP CONSTRAINT FK_vcmd_user;
