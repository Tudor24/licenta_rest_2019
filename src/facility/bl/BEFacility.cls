@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
@progress.service.resource FILE(name="BEFacility", URI="/BEFacility", schemaName="", schemaFile="").
 /*------------------------------------------------------------------------
    File        : DAFacility
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Tudor
    Created     : Sat Apr 20 19:00:38 EEST 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING facility.da.DAFacility FROM PROPATH.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS facility.bl.BEFacility INHERITS BusinessEntity: 
    
    {facility/include/dsFacility.i}
    
    DEFINE                VARIABLE daFacility AS facility.da.DAFacility NO-UNDO.
    DEFINE PRIVATE STATIC VARIABLE myInstance AS facility.bl.BEFacility NO-UNDO.
    
    METHOD PUBLIC STATIC facility.bl.BEFacility GetInstance():
        
        DEFINE VARIABLE i AS INTEGER NO-UNDO.
        
        IF NOT VALID-OBJECT(myInstance) THEN
            myInstance = NEW facility.bl.BEFacility ().
        RETURN myInstance.
        
        CATCH err AS Progress.Lang.Error :
            LOG-MANAGER:WRITE-MESSAGE ("ERROR in GetInstance of BEFacility:").
            DO i = 1 TO err:NumMessages:
                LOG-MANAGER:WRITE-MESSAGE (SUBSTITUTE("   ** (&1) &2", err:GetMessageNum(i), err:GetMessage(i))).
            END.
            UNDO, THROW err.
        END CATCH.

    END METHOD.
    
    CONSTRUCTOR PUBLIC BEFacility():
        
        daFacility = facility.da.DAFacility:GetInstance().
        
    END CONSTRUCTOR.
    
    DESTRUCTOR BEFacility():
        Delete object daFacility NO-ERROR.        
        facility.bl.BEFacility:myInstance = ?.
/*        daFacility = ?.*/
        
    END DESTRUCTOR.
    
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="read", URI="?filter=~{filter~}", alias="", mediaType="application/json").
    @openapi.openedge.method.property (name="mappingType", value="JFP").
    @openapi.openedge.method.property (name="capabilities", value="ablFilter,top,skip,id,orderBy").
    METHOD PUBLIC VOID ReadFacility(INPUT filter AS CHARACTER, OUTPUT DATASET dsFacility):
        
        DEFINE VARIABLE cWhereQuery AS CHARACTER NO-UNDO.
        DEFINE VARIABLE iMaxRows    AS INTEGER   NO-UNDO.
        DEFINE VARIABLE iSkipRows   AS INTEGER   NO-UNDO.
        
        SUPER:ExtractABLFilter(INPUT filter, OUTPUT cWhereQuery, OUTPUT iMaxRows, OUTPUT iSkipRows).
        daFacility:ReadFacility(INPUT cWhereQuery, INPUT iMaxRows, INPUT iSkipRows, OUTPUT DATASET dsFacility BY-REFERENCE).
        
    END METHOD.
    
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID CreateFacility(INPUT-OUTPUT DATASET dsFacility):
        
        daFacility:CreateFacility(INPUT-OUTPUT DATASET dsFacility BY-REFERENCE).
        
    END METHOD.

    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID UpdateFacility(INPUT-OUTPUT DATASET dsFacility):
        
        daFacility:UpdateFacility(INPUT-OUTPUT DATASET dsFacility BY-REFERENCE).
        
    END METHOD.

    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID DeleteFacility(INPUT-OUTPUT DATASET dsFacility):
        
        daFacility:DeleteFacility(INPUT-OUTPUT DATASET dsFacility BY-REFERENCE).    
        
    END METHOD.

    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID SubmitFacility(INPUT-OUTPUT DATASET dsFacility):

        THIS-OBJECT:DeleteFacility(DATASET dsFacility).
        THIS-OBJECT:UpdateFacility(DATASET dsFacility).
        THIS-OBJECT:CreateFacility(DATASET dsFacility).
        
    END METHOD.

    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID CountFacility(INPUT filter AS CHARACTER, OUTPUT numRecs AS INTEGER):
     
        DEFINE VARIABLE cWhereQuery AS CHARACTER NO-UNDO.
        DEFINE VARIABLE iMaxRows    AS INTEGER   NO-UNDO.
        DEFINE VARIABLE iSkipRows   AS INTEGER   NO-UNDO.
        
        SUPER:ExtractABLFilter(INPUT filter, OUTPUT cWhereQuery, OUTPUT iMaxRows, OUTPUT iSkipRows).
        
        daFacility:CountFacility(INPUT cWhereQuery, OUTPUT numRecs).   
            
    END METHOD.
    
END CLASS.