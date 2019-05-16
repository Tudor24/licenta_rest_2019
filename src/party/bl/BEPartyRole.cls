 
 /*------------------------------------------------------------------------
    File        : DAPartyRole
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Tudor
    Created     : Sat Apr 20 18:59:23 EEST 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS party.bl.BEPartyRole INHERITS BusinessEntity: 
    
    {party/include/dsPartyRole.i}
    
    DEFINE                VARIABLE daPartyRole AS party.da.DAPartyRole         NO-UNDO.
    DEFINE PRIVATE STATIC VARIABLE myInstance  AS party.bl.BEPartyRole NO-UNDO.
        
    METHOD PUBLIC STATIC party.bl.BEPartyRole GetInstance():

        IF NOT VALID-OBJECT(myInstance) THEN
            myInstance = NEW party.bl.BEPartyRole ().
        RETURN myInstance.

    END METHOD.
    
    CONSTRUCTOR PRIVATE BEPartyRole():
        
        SUPER().
        daPartyRole = party.da.DAPartyRole:GetInstance().
        
    END CONSTRUCTOR.
    
    DESTRUCTOR BEPartyRole():
        
        DELETE OBJECT daPartyRole NO-ERROR.
        
    END DESTRUCTOR.
    
    METHOD PUBLIC VOID ReadPartyRole(INPUT filter AS CHARACTER, OUTPUT DATASET dsPartyRole):
        
        DEFINE VARIABLE cWhereQuery AS CHARACTER NO-UNDO.
        DEFINE VARIABLE iMaxRows    AS INTEGER   NO-UNDO.
        DEFINE VARIABLE iSkipRows   AS INTEGER   NO-UNDO.
        
        SUPER:ExtractABLFilter(INPUT filter, OUTPUT cWhereQuery, OUTPUT iMaxRows, OUTPUT iSkipRows).

        daPartyRole:ReadPartyRole(INPUT cWhereQuery, INPUT iMaxRows, INPUT iSkipRows, OUTPUT DATASET dsPartyRole BY-REFERENCE).
            
    END METHOD.
    
    METHOD PUBLIC VOID CreatePartyRole(INPUT-OUTPUT DATASET dsPartyRole):
        
        daPartyRole:CreatePartyRole(INPUT-OUTPUT DATASET dsPartyRole BY-REFERENCE).
        
    END METHOD.

    METHOD PUBLIC VOID UpdatePartyRole(INPUT-OUTPUT DATASET dsPartyRole):
        
        daPartyRole:UpdatePartyRole(INPUT-OUTPUT DATASET dsPartyRole BY-REFERENCE).
        
    END METHOD.

    METHOD PUBLIC VOID DeletePartyRole(INPUT-OUTPUT DATASET dsPartyRole):
        
        daPartyRole:DeletePartyRole(INPUT-OUTPUT DATASET dsPartyRole BY-REFERENCE).
        
    END METHOD.

    METHOD PUBLIC VOID SubmitPartyRole(INPUT-OUTPUT DATASET dsPartyRole):

        THIS-OBJECT:DeletePartyRole(DATASET dsPartyRole).
        THIS-OBJECT:UpdatePartyRole(DATASET dsPartyRole).
        THIS-OBJECT:CreatePartyRole(DATASET dsPartyRole).
        
    END METHOD.

    METHOD PUBLIC VOID CountPartyRole(INPUT filter AS CHARACTER, OUTPUT numRecs AS INTEGER):
     
        DEFINE VARIABLE cWhereQuery AS CHARACTER NO-UNDO.
        DEFINE VARIABLE iMaxRows    AS INTEGER   NO-UNDO.
        DEFINE VARIABLE iSkipRows   AS INTEGER   NO-UNDO.
        
        SUPER:ExtractABLFilter(INPUT filter, OUTPUT cWhereQuery, OUTPUT iMaxRows, OUTPUT iSkipRows).
        
        daPartyRole:CountPartyRole(INPUT cWhereQuery, OUTPUT numRecs).   
            
    END METHOD.
    
END CLASS.