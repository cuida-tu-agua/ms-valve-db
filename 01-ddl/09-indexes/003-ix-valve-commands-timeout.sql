--liquibase formatted sql

--changeset esteban:ddl-index-003-ix-valve-commands-timeout
--comment: The sweeper looks every 5 s for orders still SENT after their 30 s
CREATE INDEX IX_vcmd_pending_timeout ON valve.valve_commands (timeout_at) WHERE status = N'SENT';
--rollback DROP INDEX IX_vcmd_pending_timeout ON valve.valve_commands;
