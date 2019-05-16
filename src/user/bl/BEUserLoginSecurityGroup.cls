 
 /*------------------------------------------------------------------------
    File        : DAUserLoginSecurityGroupSecurityGroup
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Tudor
    Created     : Sat Apr 20 20:05:03 EEST 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS user.bl.BEUserLoginSecurityGroup INHERITS BusinessEntity: 

    {user/include/dsUserLoginSecurityGroup.i}
    
    DEFINE                VARIABLE daUserLoginSecurityGroup AS user.da.DAUserLoginSecurityGroup NO-UNDO.
    DEFINE PRIVATE STATIC VARIABLE myInstance               AS user.bl.BEUserLoginSecurityGroup NO-UNDO.
    
    METHOD PUBLIC STATIC user.bl.BEUserLoginSecurityGroup GetInstance():
        
        DEFINE VARIABLE i AS INTEGER NO-UNDO.
        
        IF NOT VALID-OBJECT(myInstance) THEN
            myInstance = NEW user.bl.BEUserLoginSecurityGroup ().        
        RETURN myInstance.
        
        CATCH err AS Progress.Lang.Error :
            LOG-MANAGER:WRITE-MESSAGE ("ERROR in GetInstance of BEUserLoginSecurityGroup:").
            DO i = 1 TO err:NumMessages:
                LOG-MANAGER:WRITE-MESSAGE (SUBSTITUTE("   ** (&1) &2", err:GetMessageNum(i), err:GetMessage(i))).
            END.
            UNDO, THROW err.
        END CATCH.

    END METHOD.
    
    CONSTRUCTOR PRIVATE BEUserLoginSecurityGroup():
    END CONSTRUCTOR.
    
    DESTRUCTOR BEUserLoginSecurityGroup():
        
        DELETE OBJECT daUserLoginSecurityGroup NO-ERROR.
        
    END DESTRUCTOR.

    METHOD PUBLIC VOID ReadUserLoginSecurityGroup(INPUT filter AS CHARACTER, OUTPUT DATASET dsUserLoginSecurityGroup):
        
        DEFINE VARIABLE cWhereQuery AS CHARACTER NO-UNDO.
        DEFINE VARIABLE iMaxRows    AS INTEGER   NO-UNDO.
        DEFINE VARIABLE iSkipRows   AS INTEGER   NO-UNDO.
        
        SUPER:ExtractABLFilter(INPUT filter, OUTPUT cWhereQuery, OUTPUT iMaxRows, OUTPUT iSkipRows).

        daUserLoginSecurityGroup:ReadUserLoginSecurityGroup(INPUT cWhereQuery, INPUT iMaxRows, INPUT iSkipRows, OUTPUT DATASET dsUserLoginSecurityGroup BY-REFERENCE).
            
    END METHOD.
    
    METHOD PUBLIC VOID CreateUserLoginSecurityGroup(INPUT-OUTPUT DATASET dsUserLoginSecurityGroup):
        
        daUserLoginSecurityGroup:CreateUserLoginSecurityGroup(INPUT-OUTPUT DATASET dsUserLoginSecurityGroup BY-REFERENCE).
        
    END METHOD.

    METHOD PUBLIC VOID UpdateUserLoginSecurityGroup(INPUT-OUTPUT DATASET dsUserLoginSecurityGroup):
        
        daUserLoginSecurityGroup:UpdateUserLoginSecurityGroup(INPUT-OUTPUT DATASET dsUserLoginSecurityGroup BY-REFERENCE).
        
    END METHOD.

    METHOD PUBLIC VOID DeleteUserLoginSecurityGroup(INPUT-OUTPUT DATASET dsUserLoginSecurityGroup):
        
        daUserLoginSecurityGroup:DeleteUserLoginSecurityGroup(INPUT-OUTPUT DATASET dsUserLoginSecurityGroup BY-REFERENCE).
        
    END METHOD.

    METHOD PUBLIC VOID SubmitUserLoginSecurityGroup(INPUT-OUTPUT DATASET dsUserLoginSecurityGroup):

        THIS-OBJECT:DeleteUserLoginSecurityGroup(DATASET dsUserLoginSecurityGroup).
        THIS-OBJECT:UpdateUserLoginSecurityGroup(DATASET dsUserLoginSecurityGroup).
        THIS-OBJECT:CreateUserLoginSecurityGroup(DATASET dsUserLoginSecurityGroup).
        
    END METHOD.

    METHOD PUBLIC VOID CountUserLoginSecurityGroup(INPUT filter AS CHARACTER, OUTPUT numRecs AS INTEGER):
     
        DEFINE VARIABLE cWhereQuery AS CHARACTER NO-UNDO.
        DEFINE VARIABLE iMaxRows    AS INTEGER   NO-UNDO.
        DEFINE VARIABLE iSkipRows   AS INTEGER   NO-UNDO.
        
        SUPER:ExtractABLFilter(INPUT filter, OUTPUT cWhereQuery, OUTPUT iMaxRows, OUTPUT iSkipRows).
        
        daUserLoginSecurityGroup:CountUserLoginSecurityGroup(INPUT cWhereQuery, OUTPUT numRecs).   
            
    END METHOD.
    
END CLASS.