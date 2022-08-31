{{
    config(
        materialized='incremental',
		database='test',
		schema='CRS_COMPACT',
        transient=true,
		alias = 'sample2'
        
    )
}}  
  
  
  select current_date as col1