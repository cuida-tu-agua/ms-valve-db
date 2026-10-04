--liquibase formatted sql

--changeset esteban:dcl-role-001-valve-rw runInTransaction:false
--comment: DB role for app read/write + valve_app membership
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name='valve_rw' AND type='R')
    CREATE ROLE valve_rw;
ALTER ROLE valve_rw ADD MEMBER valve_app;
--rollback ALTER ROLE valve_rw DROP MEMBER valve_app;
--rollback DROP ROLE valve_rw;
