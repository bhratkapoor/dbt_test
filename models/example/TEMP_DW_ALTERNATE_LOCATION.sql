{{ config(
  materialized='table',
  database='Test',
  schema='temp_schema'
) }}

WITH ctrl_dt AS (
  select to_varchar(T1.START_DTTM, 'YYYY-MM-DD HH:MI:SS') as start_dt, to_varchar(T1.CURR_TIME, 'YYYY-MM-DD HH:MI:SS') as end_dt from (select TO_TIMESTAMP_NTZ(max(START_DTTM)) START_DTTM, TO_TIMESTAMP_NTZ(CURRENT_TIMESTAMP(0)) CURR_TIME 
  from TEST.CRS_ETL.DATE_CNTL WHERE TABLE_NM = 'DW_ALTERNATE_LOCATION') T1
  ),
  temp as (
  SELECT
concat('HSH' || a.OtherLocation_ID) as DW_ALT_LOC_ID
,a.OtherLocation_ID as ALTERNAT_LOC_ID
,'HSH' as DW_SYS_REF_CD
,a.Location_Name as ALT_LOC_NM
,a.Location_Type_Code as LOC_TYP_REF_ID
,b.Value as LOC_TYP_NM
,a.Address_Line1 as ADR_LN1
,a.Address_Line2 as ADR_LN2
,a.CITY as CTY
,a.STATE as ST
,a.ZIP as ZIP
,a.PHONE as TEL
,NULL as DATA_SECUR_RULE_LIST
,NULL as DATA_QLTY_ISS_LIST
,case when a.operation = 'DELETE' THEN FALSE ELSE TRUE end as DW_SRC_REC_STS_CD
,TO_TIMESTAMP_NTZ(CURRENT_TIMESTAMP(0)) as DW_CREAT_DTTM
,TO_TIMESTAMP_NTZ(CURRENT_TIMESTAMP(0)) as DW_CHG_DTTM
FROM  {{source('SCHEDULE', 'EHC_SCH_OtherLocations')}} as a
left join  {{source('SCHEDULE', 'EHC_REFERENCE_MASTER')}} as b
on a.Location_Type_Code = b.Reference_Master_ID
left join ctrl_dt
on 1=1
where  a.SNOWFLAKECREATEDTTM >= 'ctrl_dt.start_dt' and a.SNOWFLAKECREATEDTTM <= 'ctrl_dt.end_dt'
)
select * from temp