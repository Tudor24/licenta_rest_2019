/*------------------------------------------------------------------------
   File        : SIFacility
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : Tudor
   Created     : Sat May 04 19:07:38 EEST 2019
   Notes       : 
 ----------------------------------------------------------------------*/

@program FILE(name="SIFacility.cls", module="AppServer").
@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
@progress.service.resource FILE(name="SIFacility", URI="/SIFacility", schemaName="dsFacility", schemaFile="").

USING Progress.Lang.*.
USING facility.si.SIFacility FROM PROPATH.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS facility.si.SIFacility: 
    
    {facility\include\dsFacility.i}
    
    DEFINE VARIABLE beFacility AS facility.bl.BEFacility NO-UNDO.
    
    CONSTRUCTOR SIFacility():
        beFacility = facility.bl.BEFacility:GetInstance().
    END.
    
    DESTRUCTOR SIFacility():
        DELETE OBJECT befacility NO-ERROR.
/*        beFacility = ?.*/
    END.
    
    /*------------------------------------------------------------------------------
    Purpose: Get one or more records, based on a filter string
    Notes:
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="read", URI="?filter=~{filter~}", alias="", mediaType="application/json").
    @openapi.openedge.method.property (name="mappingType", value="JFP").
    @openapi.openedge.method.property (name="capabilities", value="ablFilter,top,skip,id,orderBy").
    METHOD PUBLIC VOID ReadFacility( INPUT filter AS CHARACTER, OUTPUT DATASET dsFacility):
        
        DATASET dsFacility:EMPTY-DATASET(). 
        
        MESSAGE "DEBUG SI: Start ReadFacility".  
        
        beFacility:ReadFacility(INPUT filter, OUTPUT DATASET dsFacility BY-REFERENCE).
       
        MESSAGE "DEBUG SI: End ReadFacility".

    END METHOD.

    /*------------------------------------------------------------------------------
    Purpose: Create one or more new records
    Notes:
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="create", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID CreateFacility(INPUT-OUTPUT DATASET dsFacility):
         
        MESSAGE "DEBUG SI: Start CreateFacility".  
         
        beFacility:CreateFacility(INPUT-OUTPUT DATASET dsFacility BY-REFERENCE).
         
        MESSAGE "DEBUG SI: End CreateFacility".  
         
    END METHOD.

    /*------------------------------------------------------------------------------
    Purpose: Update one or more records
    Notes:
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="update", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID UpdateFacility(INPUT-OUTPUT DATASET dsFacility):
        
        MESSAGE "DEBUG SI: Start UpdateFacility".  
        
        beFacility:UpdateFacility(INPUT-OUTPUT DATASET dsFacility BY-REFERENCE).
        
        MESSAGE "DEBUG SI: End UpdateFacility". 
        
    END METHOD.

    /*------------------------------------------------------------------------------
    Purpose: Delete a record
    Notes:
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="delete", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID DeleteFacility(INPUT-OUTPUT DATASET dsFacility):
        
        MESSAGE "DEBUG SI: Start DeleteFacility". 
        
        beFacility:DeleteFacility(INPUT-OUTPUT DATASET dsFacility BY-REFERENCE).
        
        MESSAGE "DEBUG SI: End DeleteFacility".
        
    END METHOD.

    /*------------------------------------------------------------------------------
    Purpose: Submit a record
    Notes:
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="submit", URI="/SubmitFacility", alias="", mediaType="application/json").
    METHOD PUBLIC VOID SubmitFacility(INPUT-OUTPUT DATASET dsFacility):

        /* Do deletes first, next modifies, and finally creates */
        THIS-OBJECT:DeleteFacility(DATASET dsFacility BY-REFERENCE).
        THIS-OBJECT:UpdateFacility(DATASET dsFacility BY-REFERENCE).
        THIS-OBJECT:CreateFacility(DATASET dsFacility BY-REFERENCE).
        
    END METHOD.
    
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    @progress.service.resourceMapping(type="REST", operation="invoke", URI="/count?filter=~{filter~}", alias="", mediaType="application/json").
    METHOD PUBLIC VOID count( INPUT filter AS CHARACTER, OUTPUT numRecs AS INTEGER):
        
        beFacility:CountFacility(INPUT filter, OUTPUT numRecs).

    END METHOD.
    
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    METHOD PUBLIC VOID Test(OUTPUT opcMessage AS CHARACTER):
        
       opcMessage = "zzz".

    END METHOD.
    
END CLASS.