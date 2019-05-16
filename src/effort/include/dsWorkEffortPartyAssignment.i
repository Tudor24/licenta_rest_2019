
/*------------------------------------------------------------------------
    File        : dsWorkEffortPartyAssignment.i
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : Tudor
    Created     : Thu Apr 18 19:46:46 EEST 2019
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
DEFINE TEMP-TABLE ttWorkEffortPartyAssignment BEFORE-TABLE bttWorkEffortPartyAssignment
    FIELD work_effort_id AS CHARACTER
    FIELD party_id       AS CHARACTER
    FIELD role_type_id   AS CHARACTER LABEL "Role Type"
    
    FIELD from_date           AS DATETIME-TZ
    FIELD thru_date           AS DATETIME-TZ
    
    FIELD last_updated_stamp  AS DATETIME-TZ
    FIELD created_stamp       AS DATETIME-TZ
    
    FIELD status_id           AS CHARACTER LABEL "Status"
    FIELD assigned_by_user_id AS CHARACTER LABEL "Assigned by User"
    
    INDEX PK_effort_party_role IS PRIMARY UNIQUE work_effort_id party_id role_type_id
    INDEX SK_created_stamp                       created_stamp
    .

DEFINE DATASET dsWorkEffortPartyAssignment FOR ttWorkEffortPartyAssignment.