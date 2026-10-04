-- sqlserver-init/00-init.sql
-- Runs once as sa. The database comes from ms-iam-db, places.places from ms-places-db
-- and devices.devices from ms-device-db: run those three first.
IF DB_ID('sy-water-db') IS NULL
    THROW 50001, 'Database sy-water-db does not exist. Run ms-iam-db first.', 1;
GO

USE [sy-water-db];
GO

IF OBJECT_ID(N'places.places', N'U') IS NULL
    THROW 50002, 'Table places.places does not exist. Run ms-places-db first.', 1;
IF OBJECT_ID(N'devices.devices', N'U') IS NULL
    THROW 50003, 'Table devices.devices does not exist. Run ms-device-db first.', 1;
GO

IF SCHEMA_ID('valve') IS NULL
    EXEC('CREATE SCHEMA valve');
GO

-- Runtime user for valve-service
IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name='valve_app')
    CREATE LOGIN valve_app WITH PASSWORD='$(VALVE_APP_PASSWORD)';
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name='valve_app')
BEGIN
    CREATE USER valve_app FOR LOGIN valve_app
        WITH DEFAULT_SCHEMA = valve;
END
GO

-- Migration user for Liquibase
IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name='valve_migrator')
    CREATE LOGIN valve_migrator WITH PASSWORD='$(VALVE_MIGRATOR_PASSWORD)';
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name='valve_migrator')
BEGIN
    CREATE USER valve_migrator FOR LOGIN valve_migrator
        WITH DEFAULT_SCHEMA = valve;
END
GO

GRANT CONTROL ON SCHEMA::valve TO valve_migrator;
GRANT CREATE TABLE TO valve_migrator;
GRANT CREATE ROLE TO valve_migrator;
GRANT ALTER ANY ROLE TO valve_migrator;
GO

-- Needed to create the cross-schema FKs (places.places, devices.devices and security.users)
GRANT REFERENCES ON OBJECT::places.places   TO valve_migrator;
GRANT REFERENCES ON OBJECT::devices.devices TO valve_migrator;
GRANT REFERENCES ON OBJECT::security.users  TO valve_migrator;
GO
