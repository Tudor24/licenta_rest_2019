
/*------------------------------------------------------------------------
    File        : dsUserLoginSecurityGroup.i
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : Tudor
    Created     : Thu Apr 18 19:45:42 EEST 2019
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
DEFINE TEMP-TABLE ttUserLoginSecurityGroup BEFORE-TABLE bttUserLoginSecurityGroup
    FIELD user_login_security_group_id AS CHARACTER
    FIELD user_login_id                AS CHARACTER
    FIELD group_id                     AS CHARACTER
    FIELD description                  AS CHARACTER

    FIELD from_date                    AS DATETIME-TZ
    FIELD thru_date                    AS DATETIME-TZ
    
    FIELD last_updated_stamp           AS DATETIME-TZ
    FIELD created_stamp                AS DATETIME-TZ
    
    INDEX PK_user_login_security_group_id IS PRIMARY UNIQUE user_login_security_group_id
    INDEX sk_from_group_user                                from_date group_id user_login_id
    .

DEFINE DATASET dsUserLoginSecurityGroup FOR ttUserLoginSecurityGroup.