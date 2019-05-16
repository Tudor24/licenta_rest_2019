 
 /*------------------------------------------------------------------------
    File        : DAUserLoginSecurityGroupSecurityGroup
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Tudor
    Created     : Sat Apr 20 20:05:03 EEST 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS user.da.DAUserLoginSecurityGroup: 

    {user/include/dsUserLoginSecurityGroup.i}
    
    DEFINE DATA-SOURCE srcUserLoginSecurityGroup FOR user_login_security_group.
    DEFINE PRIVATE STATIC VARIABLE myInstance AS user.da.DAUserLoginSecurityGroup NO-UNDO.
    
    METHOD PUBLIC STATIC user.da.DAUserLoginSecurityGroup GetInstance():
        
        DEFINE VARIABLE i AS INTEGER NO-UNDO.
        
        IF NOT VALID-OBJECT(myInstance) THEN
            myInstance = NEW user.da.DAUserLoginSecurityGroup ().        
        RETURN myInstance.
        
        CATCH err AS Progress.Lang.Error :
            LOG-MANAGER:WRITE-MESSAGE ("ERROR in GetInstance of DAUserLoginSecurityGroup:").
            DO i = 1 TO err:NumMessages:
                LOG-MANAGER:WRITE-MESSAGE (SUBSTITUTE("   ** (&1) &2", err:GetMessageNum(i), err:GetMessage(i))).
            END.
            UNDO, THROW err.
        END CATCH.

    END METHOD.
    
    CONSTRUCTOR PRIVATE DAUserLoginSecurityGroup():
    END CONSTRUCTOR.
    
    METHOD PUBLIC VOID ReadUserLoginSecurityGroup(INPUT cWhereQuery AS CHARACTER, INPUT iMaxRows AS INTEGER, INPUT iSkipRows AS INTEGER, OUTPUT DATASET dsUserLoginSecurityGroup):
        
        DEFINE VARIABLE lUseReposition AS LOGICAL NO-UNDO.
        DEFINE VARIABLE hQuery         AS HANDLE  NO-UNDO.
        DEFINE VARIABLE iCount         AS INTEGER NO-UNDO.
        
        lUseReposition = iSkipRows <> ?.
        
        IF iMaxRows <> ? AND iMaxRows > 0 THEN
        DO:
            BUFFER ttUserLoginSecurityGroup:HANDLE:BATCH-SIZE = iMaxRows.
        END.
        ELSE 
        DO:
            BUFFER ttUserLoginSecurityGroup:HANDLE:BATCH-SIZE = 0.
        END.
        
        BUFFER ttUserLoginSecurityGroup:ATTACH-DATA-SOURCE(DATA-SOURCE srcUserLoginSecurityGroup:HANDLE).

        IF cWhereQuery <> "" AND cWhereQuery <> ? THEN DATA-SOURCE srcUserLoginSecurityGroup:FILL-WHERE-STRING = cWhereQuery.

        IF lUseReposition THEN
        DO:
            hQuery = DATA-SOURCE srcUserLoginSecurityGroup:QUERY.
            hQuery:QUERY-OPEN.
            IF iSkipRows <> ? AND iSkipRows > 0 THEN
            DO:
                    hQuery:REPOSITION-TO-ROW(iSkipRows).
                    IF NOT AVAILABLE user_login_security_group THEN
                        hQuery:GET-NEXT () NO-ERROR.
            END.
            iCount = 0.
            REPEAT WHILE NOT hQuery:QUERY-OFF-END AND iCount < iMaxRows:
                hQuery:GET-NEXT () NO-ERROR.
                IF AVAILABLE user_login_security_group THEN
                DO:
                    CREATE ttUserLoginSecurityGroup.
                    BUFFER-COPY user_login_security_group TO ttUserLoginSecurityGroup.
                END.
                iCount = iCount + 1.
            END.
        END.
        ELSE 
        DO:
            DATASET dsUserLoginSecurityGroup:FILL().
        END.
        FINALLY:
            BUFFER ttUserLoginSecurityGroup:DETACH-DATA-SOURCE().
        END FINALLY.
            
    END METHOD.
    
    METHOD PUBLIC VOID CountUserLoginSecurityGroup(INPUT cWhereQuery AS CHARACTER, OUTPUT numRecs AS INTEGER):
        
        DEFINE VARIABLE qh AS HANDLE NO-UNDO.
        
        IF cWhereQuery = ? OR cWhereQuery = "?" THEN cWhereQuery = "".
        CREATE QUERY qh.
        qh:SET-BUFFERS(BUFFER user_login_security_group:HANDLE).
        qh:QUERY-PREPARE("PRESELECT EACH user_login_security_group " + cWhereQuery).
        qh:QUERY-OPEN ().
        numRecs = qh:NUM-RESULTS.
        
    END METHOD.
        
    METHOD PUBLIC VOID CreateUserLoginSecurityGroup(INPUT-OUTPUT DATASET dsUserLoginSecurityGroup):
        
        FOR EACH ttUserLoginSecurityGroup
             WHERE ROW-STATE(ttUserLoginSecurityGroup) = ROW-CREATED:
            
            CREATE user_login_security_group.
            BUFFER-COPY ttUserLoginSecurityGroup TO user_login_security_group.      
            user_login_security_group.user_login_security_group_id = GUID.
            
        END.
        
    END METHOD.

    METHOD PUBLIC VOID UpdateUserLoginSecurityGroup(INPUT-OUTPUT DATASET dsUserLoginSecurityGroup):
        
        FOR EACH ttUserLoginSecurityGroup
                WHERE ROW-STATE(ttUserLoginSecurityGroup) = ROW-MODIFIED:
            
            FOR FIRST user_login_security_group EXCLUSIVE-LOCK
                    WHERE user_login_security_group.user_login_security_group_id = ttUserLoginSecurityGroup.user_login_security_group_id:
                BUFFER-COPY ttUserLoginSecurityGroup TO user_login_security_group.      
            END.
        END.
        
    END METHOD.

    METHOD PUBLIC VOID DeleteUserLoginSecurityGroup(INPUT-OUTPUT DATASET dsUserLoginSecurityGroup):
        
        FOR EACH ttUserLoginSecurityGroup
                WHERE ROW-STATE(ttUserLoginSecurityGroup) = ROW-DELETED:
            
            FOR FIRST user_login_security_group EXCLUSIVE-LOCK
                    WHERE user_login_security_group.user_login_security_group_id = ttUserLoginSecurityGroup.user_login_security_group_id:
                DELETE user_login_security_group.     
            END.
        END.
        
    END METHOD.
    
END CLASS.