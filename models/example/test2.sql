{{
    config(
        materialized='incremental',
		unique_key='DW_CALL_QUE_REC_ID',
		database='test',
		schema='CRS_Foundation',
        transient=true,
		alias = 'DW_CALL_QUEUE',
        pre_hook=["update TEST.CRS_ETL.DATE_CNTL as t1 set TABLE_NM = 'abcd'
        from TEST.CRS_ETL.DATE_CNTL t2
        where t1.TABLE_NM = t2.TABLE_NM"],
        post_hook="INSERT INTO TEST.CRS_ETL.DATE_CNTL (TABLE_NM,START_DTTM,END_DTTM,LAYER) VALUES('DW_CALL_QUEUE',current_timestamp(),'9999-12-31 00:00:00.000','CTC')"
    )
}}

WITH ctrl_dt AS (
 select to_varchar(T1.START_DTTM, 'YYYY-MM-DD HH:MI:SS') as start_dt, 
        to_varchar(T1.CURR_TIME, 'YYYY-MM-DD HH:MI:SS') as end_dt
 from (select TO_TIMESTAMP_NTZ(max(START_DTTM)) START_DTTM, TO_TIMESTAMP_NTZ(CURRENT_TIMESTAMP(0)) CURR_TIME 
 from Test.CRS_ETL.DATE_CNTL WHERE TABLE_NM = 'DW_CALL_QUEUE') T1

  ),
  temp as (
 SELECT
concat('HSH' || a.MEMBER_CALL_QUEUE_ID) as DW_CALL_QUE_REC_ID
,a.MEMBER_CALL_QUEUE_ID as CALL_QUE_ID
,'HSH' as DW_SYS_REF_CD
,a.DM_PATIENT_REF as INDV_SRC_ID
,a.PLN_ID as PLN_HIER_ID
,a.CDO_ID as CDO_ID
,a.CURRENT_STATUS_LKUP as CURR_STS_REF_ID
,a.CURRENT_SUBSTATUS_LKUP as CURR_SUBSTS_REF_ID
,a.TIME_ZONE_LKUP as TM_ZONE_REF_ID
,a.SOURCE_LKUP as SRC_REF_ID
,a.CYCLE_YEAR as CYC_YR
,a.CREATED_ON as CREAT_ON_DT
,a.CREATED_BY as CREAT_BY_USER_ID
,a.LAST_ATTEMPTED_ON as LST_ATMPTED_ON_DT
,a.LAST_ATTEMPTED_USER as LST_ATMPTED_USER_ID
,a.ZONE_MASTER_REF as GEO_ZONE_ID
,a.CALL_QUEUE_ZIP_CODE as ZIP_CD
,b.CMS_STATE_COUNTY_ID as ST_CNTY_ID
,a.HC_NUMBER as CYC_YR_QUE_CNTR
,a.CLIENT_PRIORITY as CLI_PRR
,a.REMARK as RMRK
,NULL as DATA_SECUR_RULE_LIST
,NULL as DATA_QLTY_ISS_LIST
,CASE WHEN a.VALID_FLAG = 0 THEN FALSE WHEN a.OPERATION = 'DELETE' THEN FALSE ELSE TRUE END as DW_SRC_REC_STS_CD
,TO_TIMESTAMP_NTZ((select end_dt from ctrl_dt)) as DW_CREAT_DTTM
,TO_TIMESTAMP_NTZ((select end_dt from ctrl_dt)) as DW_CHG_DTTM
FROM TEST.CRS_COMPACT.EHC_SCH_MEMBER_CALL_QUEUE as a
left join TEST.CRS_COMPACT.EHC_CMS_STATE_COUNTIES as b
on a.CALLQUEUE_STATE_COUNTY_CODE = b.STATE_COUNTY_CODE
where  a.SNOWFLAKECREATEDTTM >= (select start_dt from ctrl_dt) and a.SNOWFLAKECREATEDTTM <=(select end_dt from ctrl_dt)
  )
select * from temp