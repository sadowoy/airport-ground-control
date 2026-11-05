#!/bin/bash
set -euo pipefail

echo "Iniciando criacao do banco PostgreSQL..."

# A flag -v ON_ERROR_STOP=1 faz o processo abortar se houver erro no SQL
for f in /scripts/postgresql/01_ddl.sql; do
  echo "Executando $f..."
  psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d "$POSTGRES_DB" -f "$f"
done

echo "Banco PostgreSQL criado com sucesso!"