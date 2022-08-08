
{% macro test_macro(c_mktsegment) %}


select
    c_custkey,
    sum(case when c_mktsegment = '{{c_mktsegment}}' then c_acctbal end) as {{c_mktsegment}}_amount
from  "SNOWFLAKE_SAMPLE_DATA"."TPCH_SF1"."CUSTOMER"
group by 1

{% endmacro %}