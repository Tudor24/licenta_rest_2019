 
/*------------------------------------------------------------------------
   File        : DASecurityGroup
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : Tudor
   Created     : Sat Apr 20 20:06:25 EEST 2019
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS user.bl.BESecurityGroup INHERITS BusinessEntity: 
    
    {user/include/dsSecurityGroup.i}
    
    DEFINE                VARIABLE daSecurityGroup AS user.da.DASecurityGroup NO-UNDO.
    DEFINE PRIVATE STATIC VARIABLE myInstance      AS user.bl.BESecurityGroup NO-UNDO.
    
    METHOD PUBLIC STATIC user.bl.BESecurityGroup GetInstance():
        
        DEFINE VARIABLE i AS INTEGER NO-UNDO.
        
        IF NOT VALID-OBJECT(myInstance) THEN
            myInstance = NEW user.bl.BESecurityGroup ().        
        RETURN myInstance.
        
        CATCH err AS Progress.Lang.Error :
            LOG-MANAGER:WRITE-MESSAGE ("ERROR in GetInstance of BESecurityGroup:").
            DO i = 1 TO err:NumMessages:
                LOG-MANAGER:WRITE-MESSAGE (SUBSTITUTE("   ** (&1) &2", err:GetMessageNum(i), err:GetMessage(i))).
            END.
            UNDO, THROW err.
        END CATCH.

    END METHOD.
    
    CONSTRUCTOR PRIVATE BESecurityGroup():
    END CONSTRUCTOR.
    
    DESTRUCTOR BESecurityGroup():
        
        DELETE OBJECT daSecurityGroup NO-ERROR.
        
    END DESTRUCTOR.
    
    METHOD PUBLIC VOID ReadSecurityGroup(INPUT filter AS CHARACTER, OUTPUT DATASET dsSecurityGroup):
        
        DEFINE VARIABLE cWhereQuery AS CHARACTER NO-UNDO.
        DEFINE VARIABLE iMaxRows    AS INTEGER   NO-UNDO.
        DEFINE VARIABLE iSkipRows   AS INTEGER   NO-UNDO.
        
        SUPER:ExtractABLFilter(INPUT filter, OUTPUT cWhereQuery, OUTPUT iMaxRows, OUTPUT iSkipRows).

        daSecurityGroup:ReadSecurityGroup(INPUT cWhereQuery, INPUT iMaxRows, INPUT iSkipRows, OUTPUT DATASET dsSecurityGroup BY-REFERENCE).
            
    END METHOD.
    
    METHOD PUBLIC VOID GetSecurityGroup(INPUT ipcGroupId AS CHARACTER, OUTPUT DATASET dsSecurityGroup):
        
        DEFINE VARIABLE cWhereQuery AS CHARACTER NO-UNDO.
        DEFINE VARIABLE iMaxRows    AS INTEGER   NO-UNDO.
        DEFINE VARIABLE iSkipRows   AS INTEGER   NO-UNDO.

        daSecurityGroup:GetSecurityGroup(INPUT ipcGroupId, OUTPUT DATASET dsSecurityGroup BY-REFERENCE).
            
    END METHOD.
    
    METHOD PUBLIC VOID CreateSecurityGroup(INPUT-OUTPUT DATASET dsSecurityGroup):
        
        daSecurityGroup:CreateSecurityGroup(INPUT-OUTPUT DATASET dsSecurityGroup BY-REFERENCE).
        
    END METHOD.

    METHOD PUBLIC VOID UpdateSecurityGroup(INPUT-OUTPUT DATASET dsSecurityGroup):
        
        daSecurityGroup:UpdateSecurityGroup(INPUT-OUTPUT DATASET dsSecurityGroup BY-REFERENCE).
        
    END METHOD.

    METHOD PUBLIC VOID DeleteSecurityGroup(INPUT-OUTPUT DATASET dsSecurityGroup):
        
        daSecurityGroup:DeleteSecurityGroup(INPUT-OUTPUT DATASET dsSecurityGroup BY-REFERENCE).
        
    END METHOD.

    METHOD PUBLIC VOID SubmitSecurityGroup(INPUT-OUTPUT DATASET dsSecurityGroup):

        THIS-OBJECT:DeleteSecurityGroup(DATASET dsSecurityGroup).
        THIS-OBJECT:UpdateSecurityGroup(DATASET dsSecurityGroup).
        THIS-OBJECT:CreateSecurityGroup(DATASET dsSecurityGroup).
        
    END METHOD.

    METHOD PUBLIC VOID CountSecurityGroup(INPUT filter AS CHARACTER, OUTPUT numRecs AS INTEGER):
     
        DEFINE VARIABLE cWhereQuery AS CHARACTER NO-UNDO.
        DEFINE VARIABLE iMaxRows    AS INTEGER   NO-UNDO.
        DEFINE VARIABLE iSkipRows   AS INTEGER   NO-UNDO.
        
        SUPER:ExtractABLFilter(INPUT filter, OUTPUT cWhereQuery, OUTPUT iMaxRows, OUTPUT iSkipRows).
        
        daSecurityGroup:CountSecurityGroup(INPUT cWhereQuery, OUTPUT numRecs).   
            
    END METHOD.
    
END CLASS.