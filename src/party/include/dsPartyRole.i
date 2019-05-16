
/*------------------------------------------------------------------------
    File        : dsPartyRole.i
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : Tudor
    Created     : Thu Apr 18 19:44:22 EEST 2019
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
DEFINE TEMP-TABLE ttPartyRole BEFORE-TABLE bttPartyRole
    FIELD party_role_id      AS CHARACTER   LABEL "Party Role Type"
    FIELD party_id           AS CHARACTER   LABEL "Party Id"
    FIELD role_type_id       AS CHARACTER   LABEL "Role Type"
    FIELD last_updated_stamp AS DATETIME-TZ
    FIELD created_stamp      AS DATETIME-TZ
   
    INDEX IDX_party_role IS PRIMARY UNIQUE party_role_id
    INDEX IDX_sys                          party_id role_type_id
    .

DEFINE DATASET dsPartyRole FOR ttPartyRole.