--liquibase formatted sql

--changeset esteban:ddl-table-001-valve-states
--comment: HU-019 one row per place with a linked device. state = what the DEVICE last confirmed (never the last order)
CREATE TABLE valve.valve_states (
    id                UNIQUEIDENTIFIER NOT NULL CONSTRAINT DF_vstate_id         DEFAULT (NEWID()),
    place_id          UNIQUEIDENTIFIER NOT NULL,
    device_id         UNIQUEIDENTIFIER NOT NULL,
    state             NVARCHAR(10)     NOT NULL CONSTRAINT DF_vstate_state      DEFAULT (N'UNKNOWN'),
    last_confirmed_at DATETIME2        NULL,
    created_at        DATETIME2        NOT NULL CONSTRAINT DF_vstate_created_at DEFAULT (SYSUTCDATETIME()),
    updated_at        DATETIME2        NOT NULL CONSTRAINT DF_vstate_updated_at DEFAULT (SYSUTCDATETIME()),
    CONSTRAINT PK_valve_states   PRIMARY KEY (id),
    CONSTRAINT UQ_vstate_place   UNIQUE (place_id),
    CONSTRAINT UQ_vstate_device  UNIQUE (device_id),
    CONSTRAINT CK_vstate_state   CHECK (state IN (N'OPEN', N'CLOSED', N'UNKNOWN')),
    -- UNKNOWN until the first report; after a report there is always a date
    CONSTRAINT CK_vstate_confirm CHECK ((state = N'UNKNOWN') OR (last_confirmed_at IS NOT NULL))
);
--rollback DROP TABLE valve.valve_states;
