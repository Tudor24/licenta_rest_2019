 
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

CLASS user.da.DAUserLoginHistory: 
    
    {user/include/dsUserLoginHistory.i}
    
    DEFINE DATA-SOURCE srcUserLoginHistory FOR user_login_history.
    DEFINE PRIVATE STATIC VARIABLE myInstance AS user.da.DAUserLoginHistory NO-UNDO.
    
    METHOD PUBLIC STATIC user.da.DAUserLoginHistory GetInstance():
        
        DEFINE VARIABLE i AS INTEGER NO-UNDO.
        
        IF NOT VALID-OBJECT(myInstance) THEN
            myInstance = NEW user.da.DAUserLoginHistory ().        
        RETURN myInstance.
        
        CATCH err AS Progress.Lang.Error :
            LOG-MANAGER:WRITE-MESSAGE ("ERROR in GetInstance of DAUserLoginHistory:").
            DO i = 1 TO err:NumMessages:
                LOG-MANAGER:WRITE-MESSAGE (SUBSTITUTE("   ** (&1) &2", err:GetMessageNum(i), err:GetMessage(i))).
            END.
            UNDO, THROW err.
        END CATCH.

    END METHOD.
    
    CONSTRUCTOR PRIVATE DAUserLoginHistory():
    END CONSTRUCTOR.
    
    METHOD PUBLIC VOID ReadUserLoginHistory(INPUT cWhereQuery AS CHARACTER, INPUT iMaxRows AS INTEGER, INPUT iSkipRows AS INTEGER, OUTPUT DATASET dsUserLoginHistory):
        
        DEFINE VARIABLE lUseReposition AS LOGICAL NO-UNDO.
        DEFINE VARIABLE hQuery         AS HANDLE  NO-UNDO.
        DEFINE VARIABLE iCount         AS INTEGER NO-UNDO.
        
        lUseReposition = iSkipRows <> ?.
        
        IF iMaxRows <> ? AND iMaxRows > 0 THEN
        DO:
            BUFFER ttUserLoginHistory:HANDLE:BATCH-SIZE = iMaxRows.
        END.
        ELSE 
        DO:
            BUFFER ttUserLoginHistory:HANDLE:BATCH-SIZE = 0.
        END.
        
        BUFFER ttUserLoginHistory:ATTACH-DATA-SOURCE(DATA-SOURCE srcUserLoginHistory:HANDLE).

        IF cWhereQuery <> "" AND cWhereQuery <> ? THEN DATA-SOURCE srcUserLoginHistory:FILL-WHERE-STRING = cWhereQuery.

        IF lUseReposition THEN
        DO:
            hQuery = DATA-SOURCE srcUserLoginHistory:QUERY.
            hQuery:QUERY-OPEN.
            IF iSkipRows <> ? AND iSkipRows > 0 THEN
            DO:
                    hQuery:REPOSITION-TO-ROW(iSkipRows).
                    IF NOT AVAILABLE user_login_history THEN
                        hQuery:GET-NEXT () NO-ERROR.
            END.
            iCount = 0.
            REPEAT WHILE NOT hQuery:QUERY-OFF-END AND iCount < iMaxRows:
                hQuery:GET-NEXT () NO-ERROR.
                IF AVAILABLE user_login_history THEN
                DO:
                    CREATE ttUserLoginHistory.
                    BUFFER-COPY user_login_history TO ttUserLoginHistory.
                END.
                iCount = iCount + 1.
            END.
        END.
        ELSE 
        DO:
            DATASET dsUserLoginHistory:FILL().
        END.
        FINALLY:
            BUFFER ttUserLoginHistory:DETACH-DATA-SOURCE().
        END FINALLY.
            
    END METHOD.
    
    METHOD PUBLIC VOID CountUserLoginHistory(INPUT cWhereQuery AS CHARACTER, OUTPUT numRecs AS INTEGER):
        
        DEFINE VARIABLE qh AS HANDLE NO-UNDO.
        
        IF cWhereQuery = ? OR cWhereQuery = "?" THEN cWhereQuery = "".
        CREATE QUERY qh.
        qh:SET-BUFFERS(BUFFER user_login_history:HANDLE).
        qh:QUERY-PREPARE("PRESELECT EACH user_login_history " + cWhereQuery).
        qh:QUERY-OPEN ().
        numRecs = qh:NUM-RESULTS.
        
    END METHOD.
        
    METHOD PUBLIC VOID CreateUserLoginHistory(INPUT-OUTPUT DATASET dsUserLoginHistory):
        
        FOR EACH ttUserLoginHistory
             WHERE ROW-STATE(ttUserLoginHistory) = ROW-CREATED:
            
            CREATE user_login_history.
            BUFFER-COPY ttUserLoginHistory TO user_login_history.      
            user_login_history.user_login_history_id = GUID.
            
        END.
        
    END METHOD.

    METHOD PUBLIC VOID CreateUserLoginHistory(INPUT ipcPartyId AS CHARACTER, INPUT ipcPassword AS CHARACTER, INPUT ipcUserLoginid AS CHARACTER, INPUT iplIsSuccessful AS LOGICAL, INPUT ipdtzThruDate AS DATETIME-TZ):
    
        CREATE user_login_history.
        ASSIGN
            user_login_history.created_stamp         = NOW
            user_login_history.last_updated_stamp    = NOW
            user_login_history.from_date             = NOW
            user_login_history.thru_date             = ipdtzThruDate   
            user_login_history.party_id              = ipcPartyId
            user_login_history.password_used         = ipcPassword
            user_login_history.successful_login      = iplIsSuccessful
            user_login_history.user_login_history_id = GUID
            user_login_history.user_login_id         = ipcUserLoginId
            .
        
    END METHOD.
    
    METHOD PUBLIC VOID UpdateUserLoginHistory(INPUT DATASET dsUserLoginHistory):
        
        FOR EACH ttUserLoginHistory
             WHERE ROW-STATE(ttUserLoginHistory) = ROW-MODIFIED:
            
            FOR FIRST user_login_history EXCLUSIVE-LOCK
                    WHERE user_login_history.user_login_history_id = ttUserLoginHistory.user_login_history_id:
                
                BUFFER-COPY ttUserLoginHistory TO user_login_history.   
                ASSIGN
                    user_login_history.last_updated_stamp = NOW.    
            END.              
        END.
        
    END METHOD.
    
END CLASS.