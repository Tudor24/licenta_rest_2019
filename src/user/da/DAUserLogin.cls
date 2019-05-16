 
 /*------------------------------------------------------------------------
    File        : DAUserLogin
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Tudor
    Created     : Sat Apr 20 20:00:57 EEST 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS user.da.DAUserLogin: 
    
    {user/include/dsUserLogin.i}
    
    DEFINE DATA-SOURCE srcUserLogin FOR user_login.
    DEFINE PRIVATE STATIC VARIABLE myInstance AS user.da.DAUserLogin NO-UNDO.
    
    METHOD PUBLIC STATIC user.da.DAUserLogin GetInstance():
        
        DEFINE VARIABLE i AS INTEGER NO-UNDO.
        
        IF NOT VALID-OBJECT(myInstance) THEN
            myInstance = NEW user.da.DAUserLogin ().        
        RETURN myInstance.
        
        CATCH err AS Progress.Lang.Error :
            LOG-MANAGER:WRITE-MESSAGE ("ERROR in GetInstance of DAUserLogin:").
            DO i = 1 TO err:NumMessages:
                LOG-MANAGER:WRITE-MESSAGE (SUBSTITUTE("   ** (&1) &2", err:GetMessageNum(i), err:GetMessage(i))).
            END.
            UNDO, THROW err.
        END CATCH.

    END METHOD.
    
    CONSTRUCTOR PRIVATE DAUserLogin():
    END CONSTRUCTOR.
    
    METHOD PUBLIC VOID ReadUserLogin(INPUT cWhereQuery AS CHARACTER, INPUT iMaxRows AS INTEGER, INPUT iSkipRows AS INTEGER, OUTPUT DATASET dsUserLogin):
        
        DEFINE VARIABLE lUseReposition AS LOGICAL NO-UNDO.
        DEFINE VARIABLE hQuery         AS HANDLE  NO-UNDO.
        DEFINE VARIABLE iCount         AS INTEGER NO-UNDO.
        
        lUseReposition = iSkipRows <> ?.
        
        IF iMaxRows <> ? AND iMaxRows > 0 THEN
        DO:
            BUFFER ttUserLogin:HANDLE:BATCH-SIZE = iMaxRows.
        END.
        ELSE 
        DO:
            BUFFER ttUserLogin:HANDLE:BATCH-SIZE = 0.
        END.
        
        BUFFER ttUserLogin:ATTACH-DATA-SOURCE(DATA-SOURCE srcUserLogin:HANDLE).

        IF cWhereQuery <> "" AND cWhereQuery <> ? THEN DATA-SOURCE srcUserLogin:FILL-WHERE-STRING = cWhereQuery.

        IF lUseReposition THEN
        DO:
            hQuery = DATA-SOURCE srcUserLogin:QUERY.
            hQuery:QUERY-OPEN.
            IF iSkipRows <> ? AND iSkipRows > 0 THEN
            DO:
                    hQuery:REPOSITION-TO-ROW(iSkipRows).
                    IF NOT AVAILABLE user_login THEN
                        hQuery:GET-NEXT () NO-ERROR.
            END.
            iCount = 0.
            REPEAT WHILE NOT hQuery:QUERY-OFF-END AND iCount < iMaxRows:
                hQuery:GET-NEXT () NO-ERROR.
                IF AVAILABLE user_login THEN
                DO:
                    CREATE ttUserLogin.
                    BUFFER-COPY user_login TO ttUserLogin.
                END.
                iCount = iCount + 1.
            END.
        END.
        ELSE 
        DO:
            DATASET dsUserLogin:FILL().
        END.
        FINALLY:
            BUFFER ttUserLogin:DETACH-DATA-SOURCE().
        END FINALLY.
            
    END METHOD.
    
    METHOD PUBLIC VOID CountUserLogin(INPUT cWhereQuery AS CHARACTER, OUTPUT numRecs AS INTEGER):
        
        DEFINE VARIABLE qh AS HANDLE NO-UNDO.
        
        IF cWhereQuery = ? OR cWhereQuery = "?" THEN cWhereQuery = "".
        CREATE QUERY qh.
        qh:SET-BUFFERS(BUFFER user_login:HANDLE).
        qh:QUERY-PREPARE("PRESELECT EACH user_login " + cWhereQuery).
        qh:QUERY-OPEN ().
        numRecs = qh:NUM-RESULTS.
        
    END METHOD.
        
    METHOD PUBLIC VOID CreateUserLogin(INPUT-OUTPUT DATASET dsUserLogin):
        
        FOR EACH ttUserLogin
             WHERE ROW-STATE(ttUserLogin) = ROW-CREATED:
            
            CREATE user_login.
            BUFFER-COPY ttUserLogin TO user_login.      
            user_login.user_login_id = GUID.
            
        END.
        
    END METHOD.

    METHOD PUBLIC VOID UpdateUserLogin(INPUT-OUTPUT DATASET dsUserLogin):
        
        FOR EACH ttUserLogin
                WHERE ROW-STATE(ttUserLogin) = ROW-MODIFIED:
            
            FOR FIRST user_login EXCLUSIVE-LOCK
                    WHERE user_login.User_Login_id = ttUserLogin.User_Login_id:
                BUFFER-COPY ttUserLogin TO user_login.      
            END.
        END.
        
    END METHOD.

    METHOD PUBLIC VOID DeleteUserLogin(INPUT-OUTPUT DATASET dsUserLogin):
        
        FOR EACH ttUserLogin
                WHERE ROW-STATE(ttUserLogin) = ROW-DELETED:
            
            FOR FIRST user_login EXCLUSIVE-LOCK
                    WHERE user_login.User_Login_id = ttUserLogin.User_Login_id:
                DELETE user_login.     
            END.
        END.
        
    END METHOD.
    
END CLASS.