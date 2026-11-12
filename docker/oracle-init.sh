#!/bin/bash
set -euo pipefail

echo "Iniciando criacao do banco Oracle..."

for f in /scripts/oracle/01_ddl.sql /scripts/oracle/02_inserts.sql /scripts/oracle/03_consultas.sql /scripts/procedures/oracle_procedures.sql; do
  echo "Executando $f..."
  
  # A correção está na variável de senha desta linha abaixo:
  sqlplus -S "$APP_USER/$APP_USER_PASSWORD@//localhost/XEPDB1" <<EOF
    WHENEVER SQLERROR EXIT SQL.SQLCODE;
    @$f
    EXIT;
EOF
done

echo "Banco Oracle criado com sucesso!"