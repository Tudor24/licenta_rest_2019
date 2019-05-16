
/*------------------------------------------------------------------------
    File        : dsSecurityGroup.i
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : Tudor
    Created     : Thu Apr 18 19:45:53 EEST 2019
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
DEFINE TEMP-TABLE ttSecurityGroup BEFORE-TABLE bttSecurityGroup
    FIELD security_group_id AS CHARACTER
    FIELD description         AS CHARACTER

    FIELD last_updated_stamp    AS DATETIME-TZ
    FIELD created_stamp         AS DATETIME-TZ
    
    INDEX PK_security_group_id IS PRIMARY UNIQUE security_group_id
    INDEX SK_description                         description
    .

DEFINE DATASET dsSecurityGroup FOR ttSecurityGroup.