
/*------------------------------------------------------------------------
    File        : dsParty.i
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : Tudor
    Created     : Thu Apr 18 19:43:40 EEST 2019
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE TEMP-TABLE ttParty BEFORE-TABLE bttParty
    FIELD party_id              AS CHARACTER 
    FIELD party_type_id         AS CHARACTER   LABEL "Party Type"
    FIELD description           AS CHARACTER   LABEL "Description"
    FIELD status_id             AS CHARACTER   LABEL "Status"
    FIELD name                  AS CHARACTER   LABEL "Name"
    FIELD firstName             AS CHARACTER   LABEL "First Name"
    FIELD lastName              AS CHARACTER   LABEL "Last Name"
    FIELD last_updated_stamp    AS DATETIME-TZ
    FIELD created_stamp         AS DATETIME-TZ
        
    INDEX IDX_party_id IS PRIMARY UNIQUE party_id
    .

DEFINE DATASET dsParty FOR ttParty.
