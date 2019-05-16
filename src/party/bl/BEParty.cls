 
 /*------------------------------------------------------------------------
    File        : DAParty
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Tudor
    Created     : Sat Apr 20 18:46:54 EEST 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING party.da.DAParty FROM PROPATH.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS party.bl.BEParty INHERITS BusinessEntity: 
    
    {party/include/dsParty.i}
    
    DEFINE PRIVATE STATIC VARIABLE myInstance AS party.bl.BEParty NO-UNDO.
    DEFINE VARIABLE daParty                   AS party.da.DAParty NO-UNDO.
    
    METHOD PUBLIC STATIC party.bl.BEParty GetInstance():

        IF NOT VALID-OBJECT(myInstance) THEN
            myInstance = NEW party.bl.BEParty ().
        RETURN myInstance.

    END METHOD.
    
    CONSTRUCTOR PRIVATE BEParty():
        
        SUPER().
        daParty = party.da.DAParty:GetInstance().
        
    END CONSTRUCTOR.
    
    DESTRUCTOR BEParty():
        
        DELETE OBJECT daParty NO-ERROR.
        
    END DESTRUCTOR.
    
    METHOD PUBLIC VOID ReadParty(INPUT filter AS CHARACTER, OUTPUT DATASET dsParty):
        
        DEFINE VARIABLE cWhereQuery AS CHARACTER NO-UNDO.
        DEFINE VARIABLE iMaxRows    AS INTEGER   NO-UNDO.
        DEFINE VARIABLE iSkipRows   AS INTEGER   NO-UNDO.
        
        SUPER:ExtractABLFilter(INPUT filter, OUTPUT cWhereQuery, OUTPUT iMaxRows, OUTPUT iSkipRows).

        daParty:ReadParty(INPUT cWhereQuery, INPUT iMaxRows, INPUT iSkipRows, OUTPUT DATASET dsParty BY-REFERENCE).
            
    END METHOD.
    
    METHOD PUBLIC VOID CreateParty(INPUT-OUTPUT DATASET dsParty):
        
        daParty:CreateParty(INPUT-OUTPUT DATASET dsParty BY-REFERENCE).
        
    END METHOD.

    METHOD PUBLIC VOID UpdateParty(INPUT-OUTPUT DATASET dsParty):
        
        daParty:UpdateParty(INPUT-OUTPUT DATASET dsParty BY-REFERENCE).
        
    END METHOD.

    METHOD PUBLIC VOID DeleteParty(INPUT-OUTPUT DATASET dsParty):
        
        daParty:DeleteParty(INPUT-OUTPUT DATASET dsParty BY-REFERENCE).
        
    END METHOD.

    METHOD PUBLIC VOID SubmitParty(INPUT-OUTPUT DATASET dsParty):

        THIS-OBJECT:DeleteParty(DATASET dsParty).
        THIS-OBJECT:UpdateParty(DATASET dsParty).
        THIS-OBJECT:CreateParty(DATASET dsParty).
        
    END METHOD.

    METHOD PUBLIC VOID CountParty(INPUT filter AS CHARACTER, OUTPUT numRecs AS INTEGER):
     
        DEFINE VARIABLE cWhereQuery AS CHARACTER NO-UNDO.
        DEFINE VARIABLE iMaxRows    AS INTEGER   NO-UNDO.
        DEFINE VARIABLE iSkipRows   AS INTEGER   NO-UNDO.
        
        SUPER:ExtractABLFilter(INPUT filter, OUTPUT cWhereQuery, OUTPUT iMaxRows, OUTPUT iSkipRows).
        
        daParty:CountParty(INPUT cWhereQuery, OUTPUT numRecs).   
            
    END METHOD.
    
END CLASS.