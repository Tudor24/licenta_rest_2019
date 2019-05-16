 
 /*------------------------------------------------------------------------
    File        : SIWorkEffort
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Tudor
    Created     : Sat May 04 21:17:32 EEST 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

@program FILE(name="SIWorkEffort.cls", module="AppServer").
@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
@progress.service.resource FILE(name="SIWorkEffort", URI="/SIWorkEffort", schemaName="dsWorkEffort", schemaFile="").

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS effort.si.SIWorkEffort: 
    
    {effort\include\dsWorkEffort.i}
    {effort\include\dsWorkEffortPartyAssignment.i}
    
    DEFINE VARIABLE beWorkEffort AS effort.bl.BEWorkEffort NO-UNDO.
    DEFINE VARIABLE beWorkEffortPartyAssignment AS effort.bl.BEWorkEffortPartyAssignment NO-UNDO.
    
    CONSTRUCTOR SIWorkEffort():
        beWorkEffort                = effort.bl.BEWorkEffort:getInstance().
        beWorkEffortPartyAssignment = effort.bl.BEWorkEffortPartyAssignment:getInstance().
    END.
    
    /*------------------------------------------------------------------------------
    Purpose: Get one or more records, based on a filter string
    Notes:
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="read", URI="?filter=~{filter~}", alias="", mediaType="application/json").
    @openapi.openedge.method.property (name="mappingType", value="JFP").
    @openapi.openedge.method.property (name="capabilities", value="ablFilter,top,skip,id,orderBy").
    METHOD PUBLIC VOID ReadWorkEffort( INPUT filter AS CHARACTER, OUTPUT DATASET dsWorkEffort):
        
        DATASET dsWorkEffort:EMPTY-DATASET(). 
        
        MESSAGE "DEBUG SI: Start ReadWorkEffort".  
        
        beWorkEffort:ReadWorkEffort(INPUT filter, OUTPUT DATASET dsWorkEffort BY-REFERENCE).
       
        MESSAGE "DEBUG SI: End ReadWorkEffort".

    END METHOD.

    /*------------------------------------------------------------------------------
    Purpose: Create one or more new records
    Notes:
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="create", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID CreateWorkEffort(INPUT-OUTPUT DATASET dsWorkEffort):
         
        MESSAGE "DEBUG SI: Start CreateWorkEffort".  
         
        beWorkEffort:CreateWorkEffort(INPUT-OUTPUT DATASET dsWorkEffort BY-REFERENCE).
         
        MESSAGE "DEBUG SI: End CreateWorkEffort".  
         
    END METHOD.

    /*------------------------------------------------------------------------------
    Purpose: Update one or more records
    Notes:
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="update", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID UpdateWorkEffort(INPUT-OUTPUT DATASET dsWorkEffort):
        
        MESSAGE "DEBUG SI: Start UpdateWorkEffort".  
        
        beWorkEffort:UpdateWorkEffort(INPUT-OUTPUT DATASET dsWorkEffort BY-REFERENCE).
        
        MESSAGE "DEBUG SI: End UpdateWorkEffort". 
        
    END METHOD.

    /*------------------------------------------------------------------------------
    Purpose: Delete a record
    Notes:
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="delete", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID DeleteWorkEffort(INPUT-OUTPUT DATASET dsWorkEffort):
        
        MESSAGE "DEBUG SI: Start DeleteWorkEffort". 
        
        beWorkEffort:DeleteWorkEffort(INPUT-OUTPUT DATASET dsWorkEffort BY-REFERENCE).
        
        MESSAGE "DEBUG SI: End DeleteWorkEffort".
        
    END METHOD.

    /*------------------------------------------------------------------------------
    Purpose: Submit a record
    Notes:
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="submit", URI="/SubmitWorkEffort", alias="", mediaType="application/json").
    METHOD PUBLIC VOID SubmitWorkEffort(INPUT-OUTPUT DATASET dsWorkEffort):

        /* Do deletes first, next modifies, and finally creates */
        THIS-OBJECT:DeleteWorkEffort(DATASET dsWorkEffort BY-REFERENCE).
        THIS-OBJECT:UpdateWorkEffort(DATASET dsWorkEffort BY-REFERENCE).
        THIS-OBJECT:CreateWorkEffort(DATASET dsWorkEffort BY-REFERENCE).
        
    END METHOD.
    
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    @progress.service.resourceMapping(type="REST", operation="invoke", URI="/count?filter=~{filter~}", alias="", mediaType="application/json").
    METHOD PUBLIC VOID count( INPUT filter AS CHARACTER, OUTPUT numRecs AS INTEGER):
        
        beWorkEffort:CountWorkEffort(INPUT filter, OUTPUT numRecs).

    END METHOD.
    
    
    /*------------------------------------------------------------------------------
    Purpose: Get one or more records, based on a filter string
    Notes:
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="read", URI="?filter=~{filter~}", alias="", mediaType="application/json").
    @openapi.openedge.method.property (name="mappingType", value="JFP").
    @openapi.openedge.method.property (name="capabilities", value="ablFilter,top,skip,id,orderBy").
    METHOD PUBLIC VOID ReadWorkEffortPartyAssignment( INPUT filter AS CHARACTER, OUTPUT DATASET dsWorkEffortPartyAssignment):
        
        DATASET dsWorkEffort:EMPTY-DATASET(). 
        
        MESSAGE "DEBUG SI: Start ReadWorkEffortPartyAssignment".  
        
        beWorkEffortPartyAssignment:ReadWorkEffortPartyAssignment(INPUT filter, OUTPUT DATASET dsWorkEffortPartyAssignment BY-REFERENCE).
       
        MESSAGE "DEBUG SI: End ReadWorkEffortPartyAssignment".

    END METHOD.

    /*------------------------------------------------------------------------------
    Purpose: Create one or more new records
    Notes:
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="create", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID CreateWorkEffortPartyAssignment(INPUT-OUTPUT DATASET dsWorkEffortPartyAssignment):
         
        MESSAGE "DEBUG SI: Start CreateWorkEffortPartyAssignment".  
         
        beWorkEffortPartyAssignment:CreateWorkEffortPartyAssignment(INPUT-OUTPUT DATASET dsWorkEffortPartyAssignment BY-REFERENCE).
         
        MESSAGE "DEBUG SI: End CreateWorkEffortPartyAssignment".  
         
    END METHOD.

    /*------------------------------------------------------------------------------
    Purpose: Update one or more records
    Notes:
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="update", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID UpdateWorkEffortPartyAssignment(INPUT-OUTPUT DATASET dsWorkEffortPartyAssignment):
        
        MESSAGE "DEBUG SI: Start UpdateWorkEffortPartyAssignment".  
        
        beWorkEffortPartyAssignment:UpdateWorkEffortPartyAssignment(INPUT-OUTPUT DATASET dsWorkEffortPartyAssignment BY-REFERENCE).
        
        MESSAGE "DEBUG SI: End UpdateWorkEffortPartyAssignment". 
        
    END METHOD.

    /*------------------------------------------------------------------------------
    Purpose: Delete a record
    Notes:
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="delete", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID DeleteWorkEffortPartyAssignment(INPUT-OUTPUT DATASET dsWorkEffortPartyAssignment):
        
        MESSAGE "DEBUG SI: Start DeleteWorkEffortPartyAssignment". 
        
        beWorkEffortPartyAssignment:DeleteWorkEffortPartyAssignment(INPUT-OUTPUT DATASET dsWorkEffortPartyAssignment BY-REFERENCE).
        
        MESSAGE "DEBUG SI: End DeleteWorkEffortPartyAssignment".
        
    END METHOD.

    /*------------------------------------------------------------------------------
    Purpose: Submit a record
    Notes:
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="submit", URI="/SubmitWorkEffortPartyAssignment", alias="", mediaType="application/json").
    METHOD PUBLIC VOID SubmitWorkEffortPartyAssignment(INPUT-OUTPUT DATASET dsWorkEffortPartyAssignment):

        /* Do deletes first, next modifies, and finally creates */
        THIS-OBJECT:DeleteWorkEffortPartyAssignment(DATASET dsWorkEffortPartyAssignment BY-REFERENCE).
        THIS-OBJECT:UpdateWorkEffortPartyAssignment(DATASET dsWorkEffortPartyAssignment BY-REFERENCE).
        THIS-OBJECT:CreateWorkEffortPartyAssignment(DATASET dsWorkEffortPartyAssignment BY-REFERENCE).
        
    END METHOD.
    
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    @progress.service.resourceMapping(type="REST", operation="invoke", URI="/count?filter=~{filter~}", alias="", mediaType="application/json").
    METHOD PUBLIC VOID CountWorkEffortPartyAssignment( INPUT filter AS CHARACTER, OUTPUT numRecs AS INTEGER):
        
        beWorkEffortPartyAssignment:CountWorkEffortPartyAssignment(INPUT filter, OUTPUT numRecs).

    END METHOD.
    
END CLASS.