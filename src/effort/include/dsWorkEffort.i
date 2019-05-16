
/*------------------------------------------------------------------------
    File        : dsWorkEffort.i
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : Tudor
    Created     : Thu Apr 18 19:46:35 EEST 2019
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
DEFINE TEMP-TABLE ttWorkEffort BEFORE-TABLE bttWorkEffort
    FIELD work_effort_id                AS CHARACTER
    FIELD work_effort_type_id           AS CHARACTER LABEL "Type"
    FIELD work_effort_purpose_type_id   AS CHARACTER LABEL "Purpose Type"
    FIELD percent_complete              AS DECIMAL LABEL "Percent Complete"

    FIELD work_effort_name              AS CHARACTER LABEL "Work Effort Name"
    FIELD facility_id                   AS CHARACTER LABEL "Facility Id"
    
    FIELD last_updated_stamp           AS DATETIME-TZ
    FIELD created_stamp                AS DATETIME-TZ
    
    INDEX PK_work_effort_id IS PRIMARY UNIQUE work_effort_id
    INDEX SK_facility_id                      facility_id
    .

DEFINE DATASET dsWorkEffort FOR ttWorkEffort.