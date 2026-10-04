--liquibase formatted sql

--changeset esteban:ddl-table-002-valve-commands
--comment: HU-020/021/022 every order to the valve, who gave it and how it ended. Never deleted (audit). The id is created by valve-service and travels to the ESP32, which sends it back when it obeys
CREATE TABLE valve.valve_commands (
    id                  UNIQUEIDENTIFIER NOT NULL,
    place_id            UNIQUEIDENTIFIER NOT NULL,
    device_id           UNIQUEIDENTIFIER NOT NULL,
    action              NVARCHAR(10)     NOT NULL,
    origin              NVARCHAR(10)     NOT NULL CONSTRAINT DF_vcmd_origin        DEFAULT (N'MANUAL'),
    status              NVARCHAR(15)     NOT NULL CONSTRAINT DF_vcmd_status        DEFAULT (N'SENT'),
    requested_by        UNIQUEIDENTIFIER NULL,
    requested_by_name   NVARCHAR(200)    NULL,
    confirmed_with_code BIT              NOT NULL CONSTRAINT DF_vcmd_code          DEFAULT (0),
    created_at          DATETIME2        NOT NULL CONSTRAINT DF_vcmd_created_at    DEFAULT (SYSUTCDATETIME()),
    sent_at             DATETIME2        NULL,
    timeout_at          DATETIME2        NOT NULL,
    acknowledged_at     DATETIME2        NULL,
    failure_reason      NVARCHAR(500)    NULL,
    CONSTRAINT PK_valve_commands PRIMARY KEY (id),
    CONSTRAINT CK_vcmd_action    CHECK (action IN (N'OPEN', N'CLOSE')),
    CONSTRAINT CK_vcmd_origin    CHECK (origin IN (N'MANUAL', N'AUTO_LEAK')),
    CONSTRAINT CK_vcmd_status    CHECK (status IN (N'SENT', N'ACK_SUCCESS', N'ACK_TIMEOUT', N'FAILED')),
    -- HU-020: closing by hand always needs the e-mailed code
    CONSTRAINT CK_vcmd_close_code CHECK (NOT (action = N'CLOSE' AND origin = N'MANUAL' AND confirmed_with_code = 0)),
    CONSTRAINT CK_vcmd_ack       CHECK ((status = N'ACK_SUCCESS') OR (acknowledged_at IS NULL) OR (status = N'FAILED')),
    CONSTRAINT CK_vcmd_timeout   CHECK (timeout_at > created_at)
);
--rollback DROP TABLE valve.valve_commands;
