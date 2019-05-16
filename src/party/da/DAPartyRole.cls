 
 /*------------------------------------------------------------------------
    File        : DAPartyRole
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Tudor
    Created     : Sat Apr 20 18:59:23 EEST 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS party.da.DAPartyRole: 
    
    {party/include/dsPartyRole.i}
    
    DEFINE DATA-SOURCE srcPartyRole FOR party_role.
    DEFINE PRIVATE STATIC VARIABLE myInstance AS party.da.DAPartyRole NO-UNDO.
    
    METHOD PUBLIC STATIC party.da.DAPartyRole GetInstance():
        
        DEFINE VARIABLE i AS INTEGER NO-UNDO.
        
        IF NOT VALID-OBJECT(myInstance) THEN
            myInstance = NEW party.da.DAPartyRole ().        
        RETURN myInstance.
        
        CATCH err AS Progress.Lang.Error :
            LOG-MANAGER:WRITE-MESSAGE ("ERROR in GetInstance of DAPartyRole:").
            DO i = 1 TO err:NumMessages:
                LOG-MANAGER:WRITE-MESSAGE (SUBSTITUTE("   ** (&1) &2", err:GetMessageNum(i), err:GetMessage(i))).
            END.
            UNDO, THROW err.
        END CATCH.

    END METHOD.
    
    CONSTRUCTOR PRIVATE DAPartyRole():
    END CONSTRUCTOR.
    
    METHOD PUBLIC VOID ReadPartyRole(INPUT cWhereQuery AS CHARACTER, INPUT iMaxRows AS INTEGER, INPUT iSkipRows AS INTEGER, OUTPUT DATASET dsPartyRole):
        
        DEFINE VARIABLE lUseReposition AS LOGICAL NO-UNDO.
        DEFINE VARIABLE hQuery         AS HANDLE  NO-UNDO.
        DEFINE VARIABLE iCount         AS INTEGER NO-UNDO.
        
        lUseReposition = iSkipRows <> ?.
        
        IF iMaxRows <> ? AND iMaxRows > 0 THEN
        DO:
            BUFFER ttPartyRole:HANDLE:BATCH-SIZE = iMaxRows.
        END.
        ELSE 
        DO:
            BUFFER ttPartyRole:HANDLE:BATCH-SIZE = 0.
        END.
        
        BUFFER ttPartyRole:ATTACH-DATA-SOURCE(DATA-SOURCE srcPartyRole:HANDLE).

        IF cWhereQuery <> "" AND cWhereQuery <> ? THEN DATA-SOURCE srcPartyRole:FILL-WHERE-STRING = cWhereQuery.

        IF lUseReposition THEN
        DO:
            hQuery = DATA-SOURCE srcPartyRole:QUERY.
            hQuery:QUERY-OPEN.
            IF iSkipRows <> ? AND iSkipRows > 0 THEN
            DO:
                    hQuery:REPOSITION-TO-ROW(iSkipRows).
                    IF NOT AVAILABLE party_role THEN
                        hQuery:GET-NEXT () NO-ERROR.
            END.
            iCount = 0.
            REPEAT WHILE NOT hQuery:QUERY-OFF-END AND iCount < iMaxRows:
                hQuery:GET-NEXT () NO-ERROR.
                IF AVAILABLE party_role THEN
                DO:
                    CREATE ttPartyRole.
                    BUFFER-COPY party_role TO ttPartyRole.
                END.
                iCount = iCount + 1.
            END.
        END.
        ELSE 
        DO:
            DATASET dsPartyRole:FILL().
        END.
        FINALLY:
            BUFFER ttPartyRole:DETACH-DATA-SOURCE().
        END FINALLY.
            
    END METHOD.
    
    METHOD PUBLIC VOID CountPartyRole(INPUT cWhereQuery AS CHARACTER, OUTPUT numRecs AS INTEGER):
        
        DEFINE VARIABLE qh AS HANDLE NO-UNDO.
        
        IF cWhereQuery = ? OR cWhereQuery = "?" THEN cWhereQuery = "".
        CREATE QUERY qh.
        qh:SET-BUFFERS(BUFFER Party:HANDLE).
        qh:QUERY-PREPARE("PRESELECT EACH party_role " + cWhereQuery).
        qh:QUERY-OPEN ().
        numRecs = qh:NUM-RESULTS.
        
    END METHOD.
        
    METHOD PUBLIC VOID CreatePartyRole(INPUT-OUTPUT DATASET dsPartyRole):
        
        FOR EACH ttPartyRole
             WHERE ROW-STATE(ttPartyRole) = ROW-CREATED:
            
            CREATE party_role.
            BUFFER-COPY ttPartyRole TO party_role.      
            party_role.party_role_id = GUID.
            
        END.
        
    END METHOD.

    METHOD PUBLIC VOID UpdatePartyRole(INPUT-OUTPUT DATASET dsPartyRole):
        
        FOR EACH ttPartyRole
                WHERE ROW-STATE(ttPartyRole) = ROW-MODIFIED:
            
            FOR FIRST party_role EXCLUSIVE-LOCK
                    WHERE party_role.party_role_id = ttPartyRole.party_role_id:
                BUFFER-COPY ttPartyRole TO party_role.      
            END.
        END.
        
    END METHOD.

    METHOD PUBLIC VOID DeletePartyRole(INPUT-OUTPUT DATASET dsPartyRole):
        
        FOR EACH ttPartyRole
                WHERE ROW-STATE(ttPartyRole) = ROW-DELETED:
            
            FOR FIRST party_role EXCLUSIVE-LOCK
                    WHERE party_role.party_role_id = ttPartyRole.party_role_id:
                DELETE party_role.     
            END.
        END.
        
    END METHOD.
    
END CLASS.