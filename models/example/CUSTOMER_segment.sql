{{ config(materialized='table', transient=true) }}

with customers as (

  {{ test_macro('MACHINERY') }} 


)

select * from customers