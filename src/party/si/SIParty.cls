 
 /*------------------------------------------------------------------------
    File        : SIParty
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Tudor
    Created     : Sat May 04 21:18:28 EEST 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS party.si.SIParty: 

    {party\include\dsParty.i}
    
    DEFINE VARIABLE beParty AS party.bl.BEParty NO-UNDO.
    
    CONSTRUCTOR SIParty():
        beParty = party.bl.BEParty:getInstance().
    END.
    
    /*------------------------------------------------------------------------------
    Purpose: Get one or more records, based on a filter string
    Notes:
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="read", URI="?filter=~{filter~}", alias="", mediaType="application/json").
    @openapi.openedge.method.property (name="mappingType", value="JFP").
    @openapi.openedge.method.property (name="capabilities", value="ablFilter,top,skip,id,orderBy").
    METHOD PUBLIC VOID ReadParty( INPUT filter AS CHARACTER, OUTPUT DATASET dsParty):
        
        DATASET dsParty:EMPTY-DATASET(). 
        
        MESSAGE "DEBUG SI: Start ReadParty".  
        
        beParty:ReadParty(INPUT filter, OUTPUT DATASET dsParty BY-REFERENCE).
       
        MESSAGE "DEBUG SI: End ReadParty".

    END METHOD.

    /*------------------------------------------------------------------------------
    Purpose: Create one or more new records
    Notes:
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="create", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID CreateParty(INPUT-OUTPUT DATASET dsParty):
         
        MESSAGE "DEBUG SI: Start CreateParty".  
         
        beParty:CreateParty(INPUT-OUTPUT DATASET dsParty BY-REFERENCE).
         
        MESSAGE "DEBUG SI: End CreateParty".  
         
    END METHOD.

    /*------------------------------------------------------------------------------
    Purpose: Update one or more records
    Notes:
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="update", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID UpdateParty(INPUT-OUTPUT DATASET dsParty):
        
        MESSAGE "DEBUG SI: Start UpdateParty".  
        
        beParty:UpdateParty(INPUT-OUTPUT DATASET dsParty BY-REFERENCE).
        
        MESSAGE "DEBUG SI: End UpdateParty". 
        
    END METHOD.

    /*------------------------------------------------------------------------------
    Purpose: Delete a record
    Notes:
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="delete", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID DeleteParty(INPUT-OUTPUT DATASET dsParty):
        
        MESSAGE "DEBUG SI: Start DeleteParty". 
        
        beParty:DeleteParty(INPUT-OUTPUT DATASET dsParty BY-REFERENCE).
        
        MESSAGE "DEBUG SI: End DeleteParty".
        
    END METHOD.

    /*------------------------------------------------------------------------------
    Purpose: Submit a record
    Notes:
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="submit", URI="/SubmitParty", alias="", mediaType="application/json").
    METHOD PUBLIC VOID SubmitParty(INPUT-OUTPUT DATASET dsParty):

        /* Do deletes first, next modifies, and finally creates */
        THIS-OBJECT:DeleteParty(DATASET dsParty BY-REFERENCE).
        THIS-OBJECT:UpdateParty(DATASET dsParty BY-REFERENCE).
        THIS-OBJECT:CreateParty(DATASET dsParty BY-REFERENCE).
        
    END METHOD.
    
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    @progress.service.resourceMapping(type="REST", operation="invoke", URI="/count?filter=~{filter~}", alias="", mediaType="application/json").
    METHOD PUBLIC VOID count( INPUT filter AS CHARACTER, OUTPUT numRecs AS INTEGER):
        
        beParty:CountParty(INPUT filter, OUTPUT numRecs).

    END METHOD.
    
END CLASS.