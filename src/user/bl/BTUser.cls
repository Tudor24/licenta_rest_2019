 
 /*------------------------------------------------------------------------
    File        : BTUser
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Tudor
    Created     : Mon Apr 29 18:33:31 EEST 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING src.common.Util FROM PROPATH.
USING common.Util FROM PROPATH.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS user.bl.BTUser INHERITS BusinessEntity: 
    
    {src/user/include/dsUserLogin.i}
    {src/user/include/dsSecurityGroup.i}
    {src/user/include/dsUserLoginHistory.i}
    {src/user/include/dsUserLoginSecurityGroup.i}
    
    DEFINE                VARIABLE beUserLogin              AS user.bl.BEUserLogin              NO-UNDO.
    DEFINE                VARIABLE beSecurityGroup          AS user.bl.BESecurityGroup          NO-UNDO.
    DEFINE                VARIABLE beUserLoginHistory       AS user.bl.BEUserLoginHistory       NO-UNDO.
    DEFINE                VARIABLE beUserLoginSecurityGroup AS user.bl.BEUserLoginSecurityGroup NO-UNDO.
    DEFINE PRIVATE STATIC VARIABLE myInstance               AS user.bl.BTUser                   NO-UNDO.
    
    METHOD PUBLIC STATIC user.bl.BTUser GetInstance():
        
        DEFINE VARIABLE i AS INTEGER NO-UNDO.
        
        IF NOT VALID-OBJECT(myInstance) THEN
            myInstance = NEW user.bl.BTUser ().        
        RETURN myInstance.
        
        CATCH err AS Progress.Lang.Error :
            LOG-MANAGER:WRITE-MESSAGE ("ERROR in GetInstance of BTUser:").
            DO i = 1 TO err:NumMessages:
                LOG-MANAGER:WRITE-MESSAGE (SUBSTITUTE("   ** (&1) &2", err:GetMessageNum(i), err:GetMessage(i))).
            END.
            UNDO, THROW err.
        END CATCH.

    END METHOD.
    
    CONSTRUCTOR PRIVATE BTUser():
        
        beUserLogin              = user.bl.BEUserLogin:GetInstance().             
        beSecurityGroup          = user.bl.BESecurityGroup:GetInstance().
        beUserLoginHistory       = user.bl.BEUserLoginHistory:GetInstance().
        beUserLoginSecurityGroup = user.bl.BEUserLoginSecurityGroup:GetInstance().
        
    END CONSTRUCTOR.
    
    DESTRUCTOR BTUser():
        
        DELETE OBJECT beUserLogin              NO-ERROR.
        DELETE OBJECT beSecurityGroup          NO-ERROR.
        DELETE OBJECT beUserLoginHistory       NO-ERROR.
        DELETE OBJECT beUserLoginSecurityGroup NO-ERROR.
        
    END DESTRUCTOR.
    
    METHOD PUBLIC LOGICAL Login(INPUT ipcFilter AS CHARACTER, OUTPUT DATASET dsUserLogin):
        
        DEFINE VARIABLE cUserName AS CHARACTER NO-UNDO.
        DEFINE VARIABLE cPassword AS CHARACTER NO-UNDO.
        
        IF Util:IsEmpty(ipcFilter) THEN
            RETURN FALSE.
            
        DATASET dsUserLogin:EMPTY-DATASET ().
        DATASET dsUserLoginHistory:EMPTY-DATASET ().
        
        beUserLogin:ReadUserLogin(INPUT ipcFilter, OUTPUT DATASET dsUserLogin BY-REFERENCE).
        
        /*extract user and pass from filter*/
        
        FIND FIRST ttUserLogin 
                WHERE ttUserLogin.user_name     = cUserName
                  AND ttUserLogin.password_hint = cPassword 
            NO-ERROR.
        
        /*no user available*/
        IF NOT AVAILABLE ttUserLogin THEN
        DO:
            beUserLoginHistory:CreateUserLoginHistory(INPUT "" /*ipcPartyId*/, INPUT cPassword, INPUT "" /*ipcUserLoginid*/, INPUT FALSE, INPUT NOW).
            RETURN FALSE.
        END.
        
        beUserLoginSecurityGroup:ReadUserLoginSecurityGroup(INPUT ipcfilter, OUTPUT DATASET dsUserLoginSecurityGroup BY-REFERENCE).
        FIND FIRST ttUserLoginSecurityGroup
            NO-ERROR.
                
        IF NOT AVAILABLE ttUserLoginSecurityGroup THEN
            RETURN FALSE.
        
        beSecurityGroup:GetSecurityGroup(INPUT ttUserLoginSecurityGroup.group_id, OUTPUT DATASET dsSecurityGroup BY-REFERENCE).
        FIND FIRST ttSecurityGroup
                WHERE ttSecurityGroup.security_group_id = ttUserLoginSecurityGroup.group_id
            NO-ERROR.
            
        IF NOT AVAILABLE ttSecurityGroup THEN
            RETURN FALSE.
        
        /*successful login*/
        beUserLoginHistory:CreateUserLoginHistory(INPUT ttUserLogin.party_id, INPUT cPassword, INPUT ttUserLogin.user_login_id, INPUT TRUE, INPUT ?).
        
        RETURN TRUE.
        
    END METHOD.
    
    METHOD PUBLIC VOID CreateUserLogin(INPUT-OUTPUT DATASET dsUserLogin):
        
        beUserLogin:CreateUserLogin(INPUT-OUTPUT DATASET dsUserLogin BY-REFERENCE).
        
    END METHOD.
        
    METHOD PUBLIC VOID UpdateUserLogin(INPUT-OUTPUT DATASET dsUserLogin):
        
        beUserLogin:UpdateUserLogin(INPUT-OUTPUT DATASET dsUserLogin BY-REFERENCE).
        
    END METHOD.
    
    METHOD PUBLIC VOID DeleteUserLogin(INPUT-OUTPUT DATASET dsUserLogin):
        
        beUserLogin:DeleteUserLogin(INPUT-OUTPUT DATASET dsUserLogin BY-REFERENCE).
        
    END METHOD.
    
END CLASS.