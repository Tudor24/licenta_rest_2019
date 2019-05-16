 
 /*------------------------------------------------------------------------
    File        : DASecurityGroup
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Tudor
    Created     : Sat Apr 20 20:06:25 EEST 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS user.da.DASecurityGroup: 
    
    {user/include/dsSecurityGroup.i}
    
    DEFINE DATA-SOURCE srcSecurityGroup FOR security_group.
    DEFINE PRIVATE STATIC VARIABLE myInstance AS user.da.DASecurityGroup NO-UNDO.
    
    METHOD PUBLIC STATIC user.da.DASecurityGroup GetInstance():
        
        DEFINE VARIABLE i AS INTEGER NO-UNDO.
        
        IF NOT VALID-OBJECT(myInstance) THEN
            myInstance = NEW user.da.DASecurityGroup ().        
        RETURN myInstance.
        
        CATCH err AS Progress.Lang.Error :
            LOG-MANAGER:WRITE-MESSAGE ("ERROR in GetInstance of DAUserLogin:").
            DO i = 1 TO err:NumMessages:
                LOG-MANAGER:WRITE-MESSAGE (SUBSTITUTE("   ** (&1) &2", err:GetMessageNum(i), err:GetMessage(i))).
            END.
            UNDO, THROW err.
        END CATCH.

    END METHOD.
    
    CONSTRUCTOR PRIVATE DASecurityGroup():
    END CONSTRUCTOR.
    
    METHOD PUBLIC VOID ReadSecurityGroup(INPUT cWhereQuery AS CHARACTER, INPUT iMaxRows AS INTEGER, INPUT iSkipRows AS INTEGER, OUTPUT DATASET dsSecurityGroup):
        
        DEFINE VARIABLE lUseReposition AS LOGICAL NO-UNDO.
        DEFINE VARIABLE hQuery         AS HANDLE  NO-UNDO.
        DEFINE VARIABLE iCount         AS INTEGER NO-UNDO.
        
        lUseReposition = iSkipRows <> ?.
        
        IF iMaxRows <> ? AND iMaxRows > 0 THEN
        DO:
            BUFFER ttSecurityGroup:HANDLE:BATCH-SIZE = iMaxRows.
        END.
        ELSE 
        DO:
            BUFFER ttSecurityGroup:HANDLE:BATCH-SIZE = 0.
        END.
        
        BUFFER ttSecurityGroup:ATTACH-DATA-SOURCE(DATA-SOURCE srcSecurityGroup:HANDLE).

        IF cWhereQuery <> "" AND cWhereQuery <> ? THEN DATA-SOURCE srcSecurityGroup:FILL-WHERE-STRING = cWhereQuery.

        IF lUseReposition THEN
        DO:
            hQuery = DATA-SOURCE srcSecurityGroup:QUERY.
            hQuery:QUERY-OPEN.
            IF iSkipRows <> ? AND iSkipRows > 0 THEN
            DO:
                    hQuery:REPOSITION-TO-ROW(iSkipRows).
                    IF NOT AVAILABLE security_group THEN
                        hQuery:GET-NEXT () NO-ERROR.
            END.
            iCount = 0.
            REPEAT WHILE NOT hQuery:QUERY-OFF-END AND iCount < iMaxRows:
                hQuery:GET-NEXT () NO-ERROR.
                IF AVAILABLE security_group THEN
                DO:
                    CREATE ttSecurityGroup.
                    BUFFER-COPY security_group TO ttSecurityGroup.
                END.
                iCount = iCount + 1.
            END.
        END.
        ELSE 
        DO:
            DATASET dsSecurityGroup:FILL().
        END.
        FINALLY:
            BUFFER ttSecurityGroup:DETACH-DATA-SOURCE().
        END FINALLY.
            
    END METHOD.
    
    METHOD PUBLIC VOID CountSecurityGroup(INPUT cWhereQuery AS CHARACTER, OUTPUT numRecs AS INTEGER):
        
        DEFINE VARIABLE qh AS HANDLE NO-UNDO.
        
        IF cWhereQuery = ? OR cWhereQuery = "?" THEN cWhereQuery = "".
        CREATE QUERY qh.
        qh:SET-BUFFERS(BUFFER security_group:HANDLE).
        qh:QUERY-PREPARE("PRESELECT EACH security_group " + cWhereQuery).
        qh:QUERY-OPEN ().
        numRecs = qh:NUM-RESULTS.
        
    END METHOD.
        
    METHOD PUBLIC VOID CreateSecurityGroup(INPUT-OUTPUT DATASET dsSecurityGroup):
        
        FOR EACH ttSecurityGroup
             WHERE ROW-STATE(ttSecurityGroup) = ROW-CREATED:
            
            CREATE security_group.
            BUFFER-COPY ttSecurityGroup TO security_group.      
            security_group.security_group_id = GUID.
            
        END.
        
    END METHOD.

    METHOD PUBLIC VOID UpdateSecurityGroup(INPUT-OUTPUT DATASET dsSecurityGroup):
        
        FOR EACH ttSecurityGroup
                WHERE ROW-STATE(ttSecurityGroup) = ROW-MODIFIED:
            
            FOR FIRST security_group EXCLUSIVE-LOCK
                    WHERE security_group.security_group_id = ttSecurityGroup.security_group_id:
                BUFFER-COPY ttSecurityGroup TO security_group.      
            END.
        END.
        
    END METHOD.

    METHOD PUBLIC VOID DeleteSecurityGroup(INPUT-OUTPUT DATASET dsSecurityGroup):
        
        FOR EACH ttSecurityGroup
                WHERE ROW-STATE(ttSecurityGroup) = ROW-DELETED:
            
            FOR FIRST security_group EXCLUSIVE-LOCK
                    WHERE security_group.security_group_id = ttSecurityGroup.security_group_id:
                DELETE security_group.     
            END.
        END.
        
    END METHOD.
    
    METHOD PUBLIC VOID GetSecurityGroup(INPUT ipcGroupId AS CHARACTER, OUTPUT DATASET dsSecurityGroup):
        
        EMPTY TEMP-TABLE ttSecurityGroup.
        
        FOR EACH security_group NO-LOCK
                WHERE security_group.security_group_id = ipcGroupId:
                    
            CREATE ttSecurityGroup.
            BUFFER-COPY security_group TO ttSecurityGroup.
        END.
        
    END.
    
END CLASS.