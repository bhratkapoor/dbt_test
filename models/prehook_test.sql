{{ config(
  materialized='table',
  database='Test',
  schema='temp_schema'
) }}

{% set query1 %}
        select 5 
    {% endset %}
{% set count2 = run_query(query1) %}  

{% if execute %}
{% if (count2.rows|length) > 2 %}
select current_date as a
{% else %}
select 2  as a
{% endif %}
{% endif %}