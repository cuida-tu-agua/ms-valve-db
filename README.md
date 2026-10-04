# ms-valve-db

Repositorio de **base de datos** del dominio de Control de Válvula (BC-07) de **Sy Water**. Administra el schema `valve` de `sy-water-db` con **Liquibase**. valve-service solo se conecta, no crea tablas.

## Requisitos

- `ms-iam-db`, `ms-places-db` y `ms-device-db` aplicados (FKs a `security.users`, `places.places` y `devices.devices`).
- Contenedor `sy_water_db_dev` arriba (puerto 1433).

## Puesta en marcha

```powershell
Copy-Item .env.example .env        # fill in passwords (same sa as ms-iam-db)
docker compose up                  # sqlserver-init + liquibase update
```

## Releases

| Tag | Contenido |
|-----|-----------|
| `v1.0-baseline` | `valve.valve_states` (estado confirmado por el equipo, uno por lugar), `valve.valve_commands` (órdenes: quién, cuándo, cómo terminó), FKs, índice de historial, una sola orden en curso por lugar, rol `valve_rw` |

## Reglas

- No editar un changeset ya aplicado. Todo cambio nuevo va en `06-releases/vX.Y/`.
- Nunca subir `.env`.
