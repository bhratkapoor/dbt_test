{{ config(
  materialized='table',
  database='Test',
  schema='temp_schema'
) }}



{%- set query %} select cast('M' as string) as number

{% endset -%} 


{% set results = run_query(query) %}

{% if execute %}

{% set results_list = results.columns[0].values()[0] %}

  

        {% if results_list|string  == 'N' %}

          select   'result is bigger' as a
        {% else %}

           select  'result is smaller' as b
        
        {% endif %}
    




{% endif %}