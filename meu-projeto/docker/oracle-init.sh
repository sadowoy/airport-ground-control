#!/bin/bash
set -euo pipefail

echo "Iniciando criacao do banco Oracle..."

# O sqlplus usara as credenciais criadas pelo compose
for f in /scripts/oracle/01_ddl.sql; do
  echo "Executando $f..."
  
  # WHENEVER SQLERROR EXIT garante que o erro aborte a subida
  sqlplus -S "$APP_USER/$APP_PASSWORD@//localhost/XEPDB1" <<EOF
    WHENEVER SQLERROR EXIT SQL.SQLCODE;
    @$f
    EXIT;
EOF
done

echo "Banco Oracle criado com sucesso!"