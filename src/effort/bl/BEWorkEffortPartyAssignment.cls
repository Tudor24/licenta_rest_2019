 
 /*------------------------------------------------------------------------
    File        : DAWorkEffortPartyAssignmentPartyAssignmentPartyAssignment
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Tudor
    Created     : Sat Apr 20 20:10:52 EEST 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS effort.bl.BEWorkEffortPartyAssignment INHERITS BusinessEntity: 

    {effort/include/dsWorkEffortPartyAssignment.i}
    
    DEFINE                VARIABLE daWorkEffortPartyAssignment AS effort.da.DAWorkEffortPartyAssignment NO-UNDO.
    DEFINE PRIVATE STATIC VARIABLE myInstance                  AS effort.bl.BEWorkEffortPartyAssignment NO-UNDO.
    
    METHOD PUBLIC STATIC effort.bl.BEWorkEffortPartyAssignment GetInstance():
        
        DEFINE VARIABLE i AS INTEGER NO-UNDO.
        
        IF NOT VALID-OBJECT(myInstance) THEN
            myInstance = NEW effort.bl.BEWorkEffortPartyAssignment ().        
        RETURN myInstance.
        
        CATCH err AS Progress.Lang.Error :
            LOG-MANAGER:WRITE-MESSAGE ("ERROR in GetInstance of BEWorkEffortPartyAssignment:").
            DO i = 1 TO err:NumMessages:
                LOG-MANAGER:WRITE-MESSAGE (SUBSTITUTE("   ** (&1) &2", err:GetMessageNum(i), err:GetMessage(i))).
            END.
            UNDO, THROW err.
        END CATCH.

    END METHOD.
    
    CONSTRUCTOR PRIVATE BEWorkEffortPartyAssignment():
    END CONSTRUCTOR.
    
    DESTRUCTOR BEWorkEffortPartyAssignment():
        
        DELETE OBJECT daWorkEffortPartyAssignment NO-ERROR.
        
    END DESTRUCTOR.
    
    METHOD PUBLIC VOID ReadWorkEffortPartyAssignment(INPUT filter AS CHARACTER, OUTPUT DATASET dsWorkEffortPartyAssignment):
        
        DEFINE VARIABLE cWhereQuery AS CHARACTER NO-UNDO.
        DEFINE VARIABLE iMaxRows    AS INTEGER   NO-UNDO.
        DEFINE VARIABLE iSkipRows   AS INTEGER   NO-UNDO.
        
        SUPER:ExtractABLFilter(INPUT filter, OUTPUT cWhereQuery, OUTPUT iMaxRows, OUTPUT iSkipRows).

        daWorkEffortPartyAssignment:ReadWorkEffortPartyAssignment(INPUT cWhereQuery, INPUT iMaxRows, INPUT iSkipRows, OUTPUT DATASET dsWorkEffortPartyAssignment BY-REFERENCE).
            
    END METHOD.
    
    METHOD PUBLIC VOID CreateWorkEffortPartyAssignment(INPUT-OUTPUT DATASET dsWorkEffortPartyAssignment):
        
        daWorkEffortPartyAssignment:CreateWorkEffortPartyAssignment(INPUT-OUTPUT DATASET dsWorkEffortPartyAssignment BY-REFERENCE).
        
    END METHOD.

    METHOD PUBLIC VOID UpdateWorkEffortPartyAssignment(INPUT-OUTPUT DATASET dsWorkEffortPartyAssignment):
        
        daWorkEffortPartyAssignment:UpdateWorkEffortPartyAssignment(INPUT-OUTPUT DATASET dsWorkEffortPartyAssignment BY-REFERENCE).
        
    END METHOD.

    METHOD PUBLIC VOID DeleteWorkEffortPartyAssignment(INPUT-OUTPUT DATASET dsWorkEffortPartyAssignment):
        
        daWorkEffortPartyAssignment:DeleteWorkEffortPartyAssignment(INPUT-OUTPUT DATASET dsWorkEffortPartyAssignment BY-REFERENCE).
        
    END METHOD.

    METHOD PUBLIC VOID SubmitWorkEffortPartyAssignment(INPUT-OUTPUT DATASET dsWorkEffortPartyAssignment):

        THIS-OBJECT:DeleteWorkEffortPartyAssignment(DATASET dsWorkEffortPartyAssignment).
        THIS-OBJECT:UpdateWorkEffortPartyAssignment(DATASET dsWorkEffortPartyAssignment).
        THIS-OBJECT:CreateWorkEffortPartyAssignment(DATASET dsWorkEffortPartyAssignment).
        
    END METHOD.

    METHOD PUBLIC VOID CountWorkEffortPartyAssignment(INPUT filter AS CHARACTER, OUTPUT numRecs AS INTEGER):
     
        DEFINE VARIABLE cWhereQuery AS CHARACTER NO-UNDO.
        DEFINE VARIABLE iMaxRows    AS INTEGER   NO-UNDO.
        DEFINE VARIABLE iSkipRows   AS INTEGER   NO-UNDO.
        
        SUPER:ExtractABLFilter(INPUT filter, OUTPUT cWhereQuery, OUTPUT iMaxRows, OUTPUT iSkipRows).
        
        daWorkEffortPartyAssignment:CountWorkEffortPartyAssignment(INPUT cWhereQuery, OUTPUT numRecs).   
            
    END METHOD.

END CLASS.