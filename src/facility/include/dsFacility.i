
/*------------------------------------------------------------------------
    File        : dsFacility.i
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : Tudor
    Created     : Thu Apr 18 19:46:11 EEST 2019
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
DEFINE TEMP-TABLE ttFacility BEFORE-TABLE bttFacility
    FIELD facility_id        AS CHARACTER
    FIELD facility_type_id   AS CHARACTER   LABEL "Facility Type"
    FIELD owner_party_id     AS CHARACTER   LABEL "Owner Party Id"
    FIELD facility_name      AS CHARACTER   LABEL "Facility Name"
    FIELD description        AS CHARACTER   LABEL "Description"
    FIELD last_updated_stamp AS DATETIME-TZ
    FIELD created_stamp      AS DATETIME-TZ
    
    INDEX IDX_name                       facility_name
    INDEX PK_facility IS PRIMARY UNIQUE facility_id
    .

DEFINE DATASET dsFacility FOR ttFacility.