{{ config(
  materialized='table',
  database='Test',
  schema='temp_schema',
  alias='testing1'
) }}

select * from "SNOWFLAKE_SAMPLE_DATA"."TPCH_SF1"."CUSTOMER" where C_Nationkey=13