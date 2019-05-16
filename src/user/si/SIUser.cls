 
 /*------------------------------------------------------------------------
    File        : SIUser
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Tudor
    Created     : Sat May 04 21:18:10 EEST 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

@program FILE(name="SIUser.cls", module="AppServer").
@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
@progress.service.resource FILE(name="SIUser", URI="/SIUser", schemaName="dsUser", schemaFile="").

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS user.si.SIUser: 
    
    {user\include\dsUserLogin.i}
    
    DEFINE VARIABLE btUser AS user.bl.BTUser NO-UNDO.
    
    CONSTRUCTOR SIUser():
        btUser = user.bl.BTUser:getInstance().
    END.
    
    /*------------------------------------------------------------------------------
    Purpose: Get one or more records, based on a filter string
    Notes:
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="read", URI="?filter=~{filter~}", alias="", mediaType="application/json").
    @openapi.openedge.method.property (name="mappingType", value="JFP").
    @openapi.openedge.method.property (name="capabilities", value="ablFilter,top,skip,id,orderBy").
    METHOD PUBLIC VOID ReadUserLogin( INPUT filter AS CHARACTER, OUTPUT DATASET dsUserLogin):
        
        DATASET dsUserLogin:EMPTY-DATASET(). 
        
        MESSAGE "DEBUG SI: Start ReadUser".
        
        btUser:Login(INPUT filter, OUTPUT DATASET dsUserLogin BY-REFERENCE).
       
        MESSAGE "DEBUG SI: End ReadUser".

    END METHOD.

    /*------------------------------------------------------------------------------
    Purpose: Create one or more new records
    Notes:
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="create", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID CreateUserLogin(INPUT-OUTPUT DATASET dsUserLogin):
         
        MESSAGE "DEBUG SI: Start CreateUser".  
         
        btUser:CreateUserLogin(INPUT-OUTPUT DATASET dsUserLogin BY-REFERENCE).
         
        MESSAGE "DEBUG SI: End CreateUser".  
         
    END METHOD.
    
    /*------------------------------------------------------------------------------
    Purpose: Create one or more new records
    Notes:
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="update", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID UpdateUserLogin(INPUT-OUTPUT DATASET dsUserLogin):
         
        MESSAGE "DEBUG SI: Start UpdateUser".  
         
        btUser:UpdateUserLogin(INPUT-OUTPUT DATASET dsUserLogin BY-REFERENCE).
         
        MESSAGE "DEBUG SI: End UpdateUser".  
         
    END METHOD.
    
    /*------------------------------------------------------------------------------
    Purpose: Create one or more new records
    Notes:
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="delete", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID DeleteUserLogin(INPUT-OUTPUT DATASET dsUserLogin):
         
        MESSAGE "DEBUG SI: Start DeleteUser".  
         
        btUser:DeleteUserLogin(INPUT-OUTPUT DATASET dsUserLogin BY-REFERENCE).
         
        MESSAGE "DEBUG SI: End DeleteUser".  
         
    END METHOD.
    
END CLASS.