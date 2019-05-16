 
 /*------------------------------------------------------------------------
    File        : DAPartyRelationshipRelationship
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Tudor
    Created     : Sat Apr 20 18:56:23 EEST 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS party.bl.BEPartyRelationship INHERITS BusinessEntity: 
    
    {party/include/dsPartyRelationship.i}
    
    DEFINE VARIABLE                daPartyRelationship AS party.da.DAPartyRelationship NO-UNDO.
    DEFINE PRIVATE STATIC VARIABLE myInstance          AS party.bl.BEPartyRelationship NO-UNDO.
    
    METHOD PUBLIC STATIC party.bl.BEPartyRelationship GetInstance():

        IF NOT VALID-OBJECT(myInstance) THEN
            myInstance = NEW party.bl.BEPartyRelationship ().        
        RETURN myInstance.

    END METHOD.
    
    CONSTRUCTOR PRIVATE BEPartyRelationship():
        
        SUPER().
        daPartyRelationship = party.da.DAPartyRelationship:GetInstance().
        
    END CONSTRUCTOR.
    
    DESTRUCTOR BEPartyRelationship():
        
        DELETE OBJECT daPartyRelationship NO-ERROR.
        
    END DESTRUCTOR.
    
    METHOD PUBLIC VOID ReadPartyRelationship(INPUT filter AS CHARACTER, OUTPUT DATASET dsPartyRelationship):
        
        DEFINE VARIABLE cWhereQuery AS CHARACTER NO-UNDO.
        DEFINE VARIABLE iMaxRows    AS INTEGER   NO-UNDO.
        DEFINE VARIABLE iSkipRows   AS INTEGER   NO-UNDO.
        
        SUPER:ExtractABLFilter(INPUT filter, OUTPUT cWhereQuery, OUTPUT iMaxRows, OUTPUT iSkipRows).

        daPartyRelationship:ReadPartyRelationship(INPUT cWhereQuery, INPUT iMaxRows, INPUT iSkipRows, OUTPUT DATASET dsPartyRelationship BY-REFERENCE).
            
    END METHOD.
    
    METHOD PUBLIC VOID CreatePartyRelationship(INPUT-OUTPUT DATASET dsPartyRelationship):
        
        daPartyRelationship:CreatePartyRelationship(INPUT-OUTPUT DATASET dsPartyRelationship BY-REFERENCE).
        
    END METHOD.

    METHOD PUBLIC VOID UpdatePartyRelationship(INPUT-OUTPUT DATASET dsPartyRelationship):
        
        daPartyRelationship:UpdatePartyRelationship(INPUT-OUTPUT DATASET dsPartyRelationship BY-REFERENCE).
        
    END METHOD.

    METHOD PUBLIC VOID DeletePartyRelationship(INPUT-OUTPUT DATASET dsPartyRelationship):
        
        daPartyRelationship:DeletePartyRelationship(INPUT-OUTPUT DATASET dsPartyRelationship BY-REFERENCE).
        
    END METHOD.

    METHOD PUBLIC VOID SubmitPartyRelationship(INPUT-OUTPUT DATASET dsPartyRelationship):

        THIS-OBJECT:DeletePartyRelationship(DATASET dsPartyRelationship).
        THIS-OBJECT:UpdatePartyRelationship(DATASET dsPartyRelationship).
        THIS-OBJECT:CreatePartyRelationship(DATASET dsPartyRelationship).
        
    END METHOD.

    METHOD PUBLIC VOID CountPartyRelationship(INPUT filter AS CHARACTER, OUTPUT numRecs AS INTEGER):
     
        DEFINE VARIABLE cWhereQuery AS CHARACTER NO-UNDO.
        DEFINE VARIABLE iMaxRows    AS INTEGER   NO-UNDO.
        DEFINE VARIABLE iSkipRows   AS INTEGER   NO-UNDO.
        
        SUPER:ExtractABLFilter(INPUT filter, OUTPUT cWhereQuery, OUTPUT iMaxRows, OUTPUT iSkipRows).
        
        daPartyRelationship:CountPartyRelationship(INPUT cWhereQuery, OUTPUT numRecs).   
            
    END METHOD.
    
END CLASS.