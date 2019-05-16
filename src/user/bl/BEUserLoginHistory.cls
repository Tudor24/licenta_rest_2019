 
 /*------------------------------------------------------------------------
    File        : DAUserLoginHistoryHistory
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Tudor
    Created     : Sat Apr 20 20:03:33 EEST 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS user.bl.BEUserLoginHistory INHERITS BusinessEntity: 
    
    {user/include/dsUserLoginHistory.i}
    
    DEFINE                VARIABLE daUserLoginHistory AS user.da.DAUserLoginHistory NO-UNDO.
    DEFINE PRIVATE STATIC VARIABLE myInstance         AS user.bl.BEUserLoginHistory NO-UNDO.
    
    METHOD PUBLIC STATIC user.bl.BEUserLoginHistory GetInstance():
        
        DEFINE VARIABLE i AS INTEGER NO-UNDO.
        
        IF NOT VALID-OBJECT(myInstance) THEN
            myInstance = NEW user.bl.BEUserLoginHistory ().        
        RETURN myInstance.
        
        CATCH err AS Progress.Lang.Error :
            LOG-MANAGER:WRITE-MESSAGE ("ERROR in GetInstance of BEUserLoginHistory:").
            DO i = 1 TO err:NumMessages:
                LOG-MANAGER:WRITE-MESSAGE (SUBSTITUTE("   ** (&1) &2", err:GetMessageNum(i), err:GetMessage(i))).
            END.
            UNDO, THROW err.
        END CATCH.

    END METHOD.
    
    CONSTRUCTOR PRIVATE BEUserLoginHistory():
    END CONSTRUCTOR.
    
    DESTRUCTOR BEUserLoginHistory():
        
        DELETE OBJECT daUserLoginHistory NO-ERROR.
        
    END DESTRUCTOR.
    
    METHOD PUBLIC VOID ReadUserLoginHistory(INPUT filter AS CHARACTER, OUTPUT DATASET dsUserLoginHistory):
        
        DEFINE VARIABLE cWhereQuery AS CHARACTER NO-UNDO.
        DEFINE VARIABLE iMaxRows    AS INTEGER   NO-UNDO.
        DEFINE VARIABLE iSkipRows   AS INTEGER   NO-UNDO.
        
        SUPER:ExtractABLFilter(INPUT filter, OUTPUT cWhereQuery, OUTPUT iMaxRows, OUTPUT iSkipRows).

        daUserLoginHistory:ReadUserLoginHistory(INPUT cWhereQuery, INPUT iMaxRows, INPUT iSkipRows, OUTPUT DATASET dsUserLoginHistory BY-REFERENCE).
            
    END METHOD.
    
    METHOD PUBLIC VOID CreateUserLoginHistory(INPUT-OUTPUT DATASET dsUserLoginHistory):
        
        daUserLoginHistory:CreateUserLoginHistory(INPUT-OUTPUT DATASET dsUserLoginHistory BY-REFERENCE).
        
    END METHOD.

    METHOD PUBLIC VOID CreateUserLoginHistory(INPUT ipcPartyId AS CHARACTER, INPUT ipcPassword AS CHARACTER, INPUT ipcUserLoginid AS CHARACTER, INPUT iplIsSuccessful AS LOGICAL, INPUT ipdtzThruDate AS DATETIME-TZ):
        
        daUserLoginHistory:CreateUserLoginHistory(INPUT ipcPartyId, INPUT ipcPassword, INPUT ipcUserLoginid, INPUT iplIsSuccessful, INPUT ipdtzThruDate).
        
    END METHOD.
    
    METHOD PUBLIC VOID RecordLogout(INPUT ipcWhereQuery AS CHARACTER):
        
        daUserLoginHistory:ReadUserLoginHistory(INPUT ipcWhereQuery, INPUT 1, INPUT 0, OUTPUT DATASET dsUserLoginHistory BY-REFERENCE).
        
        DATASET dsUserLoginHistory:TRACKING-CHANGES = TRUE.
        
        FOR FIRST ttUserLoginHistory:
            ttUserLoginHistory.thru_date = NOW.
        END.
        
        DATASET dsUserLoginHistory:TRACKING-CHANGES = FALSE.
        
        daUserLoginHistory:UpdateUserLoginHistory(INPUT DATASET dsUserLoginHistory BY-REFERENCE).        
        
    END METHOD.

    METHOD PUBLIC VOID CountUserLoginHistory(INPUT filter AS CHARACTER, OUTPUT numRecs AS INTEGER):
     
        DEFINE VARIABLE cWhereQuery AS CHARACTER NO-UNDO.
        DEFINE VARIABLE iMaxRows    AS INTEGER   NO-UNDO.
        DEFINE VARIABLE iSkipRows   AS INTEGER   NO-UNDO.
        
        SUPER:ExtractABLFilter(INPUT filter, OUTPUT cWhereQuery, OUTPUT iMaxRows, OUTPUT iSkipRows).
        
        daUserLoginHistory:CountUserLoginHistory(INPUT cWhereQuery, OUTPUT numRecs).   
            
    END METHOD.

END CLASS.