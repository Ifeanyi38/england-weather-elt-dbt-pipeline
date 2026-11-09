#!/bin/bash
# Runs once on first start (empty data volume): creates separate users and databases
# for Airflow's metadata and the weather data. Values come from .env via compose.yaml.

# Stop at the first error so a partial setup doesn't look like success.
set -e

# ON_ERROR_STOP makes psql fail on a bad SQL statement; connect to the default "postgres" database.
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname postgres <<-EOSQL
    -- Airflow metadata
    CREATE USER "$AIRFLOW_DB_USER" WITH PASSWORD '$AIRFLOW_DB_PASSWORD';
    CREATE DATABASE "$AIRFLOW_DB_NAME" OWNER "$AIRFLOW_DB_USER";

    -- Weather data (owner can create schemas and tables without the superuser)
    CREATE USER "$WEATHER_DB_USER" WITH PASSWORD '$WEATHER_DB_PASSWORD';
    CREATE DATABASE "$WEATHER_DB_NAME" OWNER "$WEATHER_DB_USER";
EOSQL