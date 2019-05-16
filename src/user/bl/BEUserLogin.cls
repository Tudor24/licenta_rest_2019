 
 /*------------------------------------------------------------------------
    File        : DAUserLogin
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Tudor
    Created     : Sat Apr 20 20:00:57 EEST 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS user.bl.BEUserLogin INHERITS BusinessEntity: 
    
    {user/include/dsUserLogin.i}
    
    DEFINE                VARIABLE daUserLogin AS user.da.DAUserLogin     NO-UNDO.
    DEFINE PRIVATE STATIC VARIABLE myInstance  AS user.bl.BEUserLogin NO-UNDO.
    
    METHOD PUBLIC STATIC user.bl.BEUserLogin GetInstance():
        
        DEFINE VARIABLE i AS INTEGER NO-UNDO.
        
        IF NOT VALID-OBJECT(myInstance) THEN
            myInstance = NEW user.bl.BEUserLogin ().        
        RETURN myInstance.
        
        CATCH err AS Progress.Lang.Error :
            LOG-MANAGER:WRITE-MESSAGE ("ERROR in GetInstance of BEUserLogin:").
            DO i = 1 TO err:NumMessages:
                LOG-MANAGER:WRITE-MESSAGE (SUBSTITUTE("   ** (&1) &2", err:GetMessageNum(i), err:GetMessage(i))).
            END.
            UNDO, THROW err.
        END CATCH.

    END METHOD.
    
    CONSTRUCTOR PRIVATE BEUserLogin():
    END CONSTRUCTOR.
    
    DESTRUCTOR BEUserLogin():
        
        DELETE OBJECT daUserLogin NO-ERROR.
        
    END DESTRUCTOR.
    
    METHOD PUBLIC VOID ReadUserLogin(INPUT filter AS CHARACTER, OUTPUT DATASET dsUserLogin):
        
        DEFINE VARIABLE cWhereQuery AS CHARACTER NO-UNDO.
        DEFINE VARIABLE iMaxRows    AS INTEGER   NO-UNDO.
        DEFINE VARIABLE iSkipRows   AS INTEGER   NO-UNDO.
        
        SUPER:ExtractABLFilter(INPUT filter, OUTPUT cWhereQuery, OUTPUT iMaxRows, OUTPUT iSkipRows).

        daUserLogin:ReadUserLogin(INPUT cWhereQuery, INPUT iMaxRows, INPUT iSkipRows, OUTPUT DATASET dsUserLogin BY-REFERENCE).
            
    END METHOD.
    
    METHOD PUBLIC VOID CreateUserLogin(INPUT-OUTPUT DATASET dsUserLogin):
        
        daUserLogin:CreateUserLogin(INPUT-OUTPUT DATASET dsUserLogin BY-REFERENCE).
        
    END METHOD.

    METHOD PUBLIC VOID UpdateUserLogin(INPUT-OUTPUT DATASET dsUserLogin):
        
        daUserLogin:UpdateUserLogin(INPUT-OUTPUT DATASET dsUserLogin BY-REFERENCE).
        
    END METHOD.

    METHOD PUBLIC VOID DeleteUserLogin(INPUT-OUTPUT DATASET dsUserLogin):
        
        daUserLogin:DeleteUserLogin(INPUT-OUTPUT DATASET dsUserLogin BY-REFERENCE).
        
    END METHOD.

    METHOD PUBLIC VOID SubmitUserLogin(INPUT-OUTPUT DATASET dsUserLogin):

        THIS-OBJECT:DeleteUserLogin(DATASET dsUserLogin).
        THIS-OBJECT:UpdateUserLogin(DATASET dsUserLogin).
        THIS-OBJECT:CreateUserLogin(DATASET dsUserLogin).
        
    END METHOD.

    METHOD PUBLIC VOID CountUserLogin(INPUT filter AS CHARACTER, OUTPUT numRecs AS INTEGER):
     
        DEFINE VARIABLE cWhereQuery AS CHARACTER NO-UNDO.
        DEFINE VARIABLE iMaxRows    AS INTEGER   NO-UNDO.
        DEFINE VARIABLE iSkipRows   AS INTEGER   NO-UNDO.
        
        SUPER:ExtractABLFilter(INPUT filter, OUTPUT cWhereQuery, OUTPUT iMaxRows, OUTPUT iSkipRows).
        
        daUserLogin:CountUserLogin(INPUT cWhereQuery, OUTPUT numRecs).   
            
    END METHOD.
    
END CLASS.