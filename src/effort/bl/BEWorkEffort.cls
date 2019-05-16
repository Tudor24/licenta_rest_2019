 
 /*------------------------------------------------------------------------
    File        : BEWorkEffort
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Tudor
    Created     : Sat Apr 20 20:09:56 EEST 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS effort.bl.BEWorkEffort INHERITS BusinessEntity: 
    
    {effort/include/dsWorkEffort.i}
    
    DEFINE                VARIABLE daWorkEffort AS effort.da.DAWorkEffort NO-UNDO.
    DEFINE PRIVATE STATIC VARIABLE myInstance   AS effort.bl.BEWorkEffort NO-UNDO.
    
    METHOD PUBLIC STATIC effort.bl.BEWorkEffort GetInstance():
        
        DEFINE VARIABLE i AS INTEGER NO-UNDO.
        
        IF NOT VALID-OBJECT(myInstance) THEN
            myInstance = NEW effort.bl.BEWorkEffort ().        
        RETURN myInstance.
        
        CATCH err AS Progress.Lang.Error :
            LOG-MANAGER:WRITE-MESSAGE ("ERROR in GetInstance of BEWorkEffort:").
            DO i = 1 TO err:NumMessages:
                LOG-MANAGER:WRITE-MESSAGE (SUBSTITUTE("   ** (&1) &2", err:GetMessageNum(i), err:GetMessage(i))).
            END.
            UNDO, THROW err.
        END CATCH.

    END METHOD.
    
    CONSTRUCTOR PRIVATE BEWorkEffort():
    END CONSTRUCTOR.
    
    DESTRUCTOR BEWorkEffort():
        
        DELETE OBJECT daWorkEffort NO-ERROR.
        
    END DESTRUCTOR.
    
    METHOD PUBLIC VOID ReadWorkEffort(INPUT filter AS CHARACTER, OUTPUT DATASET dsWorkEffort):
        
        DEFINE VARIABLE cWhereQuery AS CHARACTER NO-UNDO.
        DEFINE VARIABLE iMaxRows    AS INTEGER   NO-UNDO.
        DEFINE VARIABLE iSkipRows   AS INTEGER   NO-UNDO.
        
        SUPER:ExtractABLFilter(INPUT filter, OUTPUT cWhereQuery, OUTPUT iMaxRows, OUTPUT iSkipRows).

        daWorkEffort:ReadWorkEffort(INPUT cWhereQuery, INPUT iMaxRows, INPUT iSkipRows, OUTPUT DATASET dsWorkEffort BY-REFERENCE).
            
    END METHOD.
    
    METHOD PUBLIC VOID CreateWorkEffort(INPUT-OUTPUT DATASET dsWorkEffort):
        
        daWorkEffort:CreateWorkEffort(INPUT-OUTPUT DATASET dsWorkEffort BY-REFERENCE).
        
    END METHOD.

    METHOD PUBLIC VOID UpdateWorkEffort(INPUT-OUTPUT DATASET dsWorkEffort):
        
        daWorkEffort:UpdateWorkEffort(INPUT-OUTPUT DATASET dsWorkEffort BY-REFERENCE).
        
    END METHOD.

    METHOD PUBLIC VOID DeleteWorkEffort(INPUT-OUTPUT DATASET dsWorkEffort):
        
        daWorkEffort:DeleteWorkEffort(INPUT-OUTPUT DATASET dsWorkEffort BY-REFERENCE).
        
    END METHOD.

    METHOD PUBLIC VOID SubmitWorkEffort(INPUT-OUTPUT DATASET dsWorkEffort):

        THIS-OBJECT:DeleteWorkEffort(DATASET dsWorkEffort).
        THIS-OBJECT:UpdateWorkEffort(DATASET dsWorkEffort).
        THIS-OBJECT:CreateWorkEffort(DATASET dsWorkEffort).
        
    END METHOD.

    METHOD PUBLIC VOID CountWorkEffort(INPUT filter AS CHARACTER, OUTPUT numRecs AS INTEGER):
     
        DEFINE VARIABLE cWhereQuery AS CHARACTER NO-UNDO.
        DEFINE VARIABLE iMaxRows    AS INTEGER   NO-UNDO.
        DEFINE VARIABLE iSkipRows   AS INTEGER   NO-UNDO.
        
        SUPER:ExtractABLFilter(INPUT filter, OUTPUT cWhereQuery, OUTPUT iMaxRows, OUTPUT iSkipRows).
        
        daWorkEffort:CountWorkEffort(INPUT cWhereQuery, OUTPUT numRecs).   
            
    END METHOD.
    
END CLASS.