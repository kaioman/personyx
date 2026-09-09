#!/bin/sh
set -eu

pg_isready -U postgres -d postgres

result="$(
  psql -U postgres -d personyx_pg12 -tAc \
    "SELECT EXISTS (
      SELECT 1
      FROM pg_namespace
      WHERE nspname = 'personyx'    
    );"
)"

[ "$result" = "t" ]
