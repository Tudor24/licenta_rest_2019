
/*------------------------------------------------------------------------
    File        : dsPartyRelationship.i
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : Tudor
    Created     : Thu Apr 18 19:44:32 EEST 2019
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
DEFINE TEMP-TABLE ttPartyRelationship BEFORE-TABLE bttPartyRelationship
    FIELD party_relationship_id        AS CHARACTER 
    FIELD party_id_from                AS CHARACTER   LABEL "Party Id From"
    FIELD party_id_to                  AS CHARACTER   LABEL "Party Id To"
    FIELD role_type_id_from            AS CHARACTER   LABEL "Role Type From"
    FIELD role_type_id_to              AS CHARACTER   LABEL "Role Type To"
    FIELD from_date                    AS DATETIME-TZ LABEL "From Date"
    FIELD thru_date                    AS DATETIME-TZ LABEL "Thru Date"    
    FIELD status_id                    AS CHARACTER   LABEL "Status"
    FIELD last_updated_stamp           AS DATETIME-TZ 
    FIELD created_stamp                AS DATETIME-TZ
    
    INDEX IDX_party_relationship_id IS PRIMARY UNIQUE party_relationship_id
    INDEX IDX_party_from party_id_from ASC
    INDEX IDX_party_to   party_id_to   ASC
    INDEX IDX_sys        from_date party_id_from party_id_to role_type_id_from role_type_id_to
    .

DEFINE DATASET dsPartyRelationship FOR ttPartyRelationship.