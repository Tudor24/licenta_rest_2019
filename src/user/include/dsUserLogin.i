
/*------------------------------------------------------------------------
    File        : dsUserLogin.i
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : Tudor
    Created     : Thu Apr 18 19:45:18 EEST 2019
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
DEFINE TEMP-TABLE ttUserLogin BEFORE-TABLE bttUserLogin
    FIELD user_login_id           AS CHARACTER   
    FIELD user_name               AS CHARACTER   LABEL "user Name"
    FIELD current_password        AS CHARACTER   LABEL "Current Password"
    FIELD password_hint           AS CHARACTER   LABEL "Password Hint"
    FIELD enabled                 AS LOGICAL     LABEL "Enabled"
    FIELD has_logged_out          AS LOGICAL
    FIELD require_password_change AS LOGICAL
    FIELD party_id                AS CHARACTER

    FIELD last_updated_stamp      AS DATETIME-TZ
    FIELD created_stamp           AS DATETIME-TZ
    
    INDEX PK_user_login_id IS PRIMARY UNIQUE user_login_id
    INDEX IDX_party_id                       party_id
    INDEX IDX_user_name                      user_name
    .

DEFINE DATASET dsUserLogin FOR ttUserLogin.