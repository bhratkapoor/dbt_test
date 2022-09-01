{{
    config(
        materialized='incremental',
		unique_key=['DW_ALT_LOC_ID', 'ALTERNAT_LOC_ID'],
		database='Test',
		schema='CRS_Foundation',
        transient=true,
        post_hook={"sql":"delete from  TEST.TEMP_SCHEMA.TEMP_DW_ALTERNATE_LOCATION"
      
        }
    )
}}

select
TREF.DW_ALT_LOC_ID, TREF.ALTERNAT_LOC_ID, TREF.DW_SYS_REF_CD, TREF.ALT_LOC_NM, TREF.LOC_TYP_REF_ID, TREF.LOC_TYP_NM, TREF.ADR_LN1, TREF.ADR_LN2, TREF.CTY, TREF.ST, TREF.ZIP, TREF.TEL, TREF.DATA_SECUR_RULE_LIST, TREF.DATA_QLTY_ISS_LIST, TREF.DW_SRC_REC_STS_CD, TREF.DW_CREAT_DTTM, TREF.DW_CHG_DTTM

from "TEST"."TEMP_SCHEMA"."TEMP_DW_ALTERNATE_LOCATION" as TREF




