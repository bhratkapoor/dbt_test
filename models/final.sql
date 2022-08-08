{{ config(
  materialized='incremental',
  transient=false,
  database='Test',
  schema='temp_schema',
  alias='final'
  
) }}

SELECT * FROM {{ref('test')}}
UNION ALL
SELECT * FROM {{ref('test1')}}
