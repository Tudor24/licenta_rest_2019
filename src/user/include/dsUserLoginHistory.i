
/*------------------------------------------------------------------------
    File        : dsUserLoginHistory.i
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : Tudor
    Created     : Thu Apr 18 19:45:28 EEST 2019
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
DEFINE TEMP-TABLE ttUserLoginHistory BEFORE-TABLE bttUserLoginHistory
    FIELD user_login_history_id AS CHARACTER
    FIELD user_login_id         AS CHARACTER
    
    FIELD from_date             AS DATETIME-TZ
    FIELD thru_date             AS DATETIME-TZ
    
    FIELD password_used         AS CHARACTER   LABEL "Password Used"
    FIELD successful_login      AS LOGICAL     LABEL "Successful"
    FIELD party_id              AS CHARACTER
    
    FIELD last_updated_stamp    AS DATETIME-TZ
    FIELD created_stamp         AS DATETIME-TZ
    
    INDEX PK_user_login_history_id IS PRIMARY UNIQUE user_login_history_id
    INDEX SK_from_date                               from_date
    INDEX SK_party_id                                party_id
    INDEX SK_user_login_id                           user_login_id
    .

DEFINE DATASET dsUserLoginHistory FOR ttUserLoginHistory.