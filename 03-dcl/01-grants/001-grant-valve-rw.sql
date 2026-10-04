--liquibase formatted sql

--changeset esteban:dcl-grant-001-valve-rw runInTransaction:false
--comment: The state of a valve disappears when its device is unlinked (DELETE allowed); the orders are an audit trail (no DELETE)
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::valve TO valve_rw;
DENY  DELETE                 ON OBJECT::valve.valve_commands        TO valve_rw;
DENY  INSERT, UPDATE, DELETE ON OBJECT::valve.DATABASECHANGELOG     TO valve_rw;
DENY  INSERT, UPDATE, DELETE ON OBJECT::valve.DATABASECHANGELOGLOCK TO valve_rw;
--rollback REVOKE INSERT, UPDATE, DELETE ON OBJECT::valve.DATABASECHANGELOGLOCK FROM valve_rw;
--rollback REVOKE INSERT, UPDATE, DELETE ON OBJECT::valve.DATABASECHANGELOG     FROM valve_rw;
--rollback REVOKE DELETE                 ON OBJECT::valve.valve_commands        FROM valve_rw;
--rollback REVOKE SELECT, INSERT, UPDATE, DELETE ON SCHEMA::valve FROM valve_rw;
