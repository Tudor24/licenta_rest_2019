 
 /*------------------------------------------------------------------------
    File        : DAPartyRelationship
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Tudor
    Created     : Sat Apr 20 18:56:23 EEST 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS party.da.DAPartyRelationship: 
    
    {party/include/dsPartyRelationship.i}
    
    DEFINE DATA-SOURCE srcPartyRelationship FOR party_relationship.
    DEFINE PRIVATE STATIC VARIABLE myInstance AS party.da.DAPartyRelationship NO-UNDO.
    
    METHOD PUBLIC STATIC party.da.DAPartyRelationship GetInstance():
        
        DEFINE VARIABLE i AS INTEGER NO-UNDO.
        
        IF NOT VALID-OBJECT(myInstance) THEN
            myInstance = NEW party.da.DAPartyRelationship ().        
        RETURN myInstance.
        
        CATCH err AS Progress.Lang.Error :
            LOG-MANAGER:WRITE-MESSAGE ("ERROR in GetInstance of DAPartyRelationship:").
            DO i = 1 TO err:NumMessages:
                LOG-MANAGER:WRITE-MESSAGE (SUBSTITUTE("   ** (&1) &2", err:GetMessageNum(i), err:GetMessage(i))).
            END.
            UNDO, THROW err.
        END CATCH.

    END METHOD.
    
    CONSTRUCTOR PRIVATE DAPartyRelationship():
    END CONSTRUCTOR.
    
    METHOD PUBLIC VOID ReadPartyRelationship(INPUT cWhereQuery AS CHARACTER, INPUT iMaxRows AS INTEGER, INPUT iSkipRows AS INTEGER, OUTPUT DATASET dsPartyRelationship):
        
        DEFINE VARIABLE lUseReposition AS LOGICAL NO-UNDO.
        DEFINE VARIABLE hQuery         AS HANDLE  NO-UNDO.
        DEFINE VARIABLE iCount         AS INTEGER NO-UNDO.
        
        lUseReposition = iSkipRows <> ?.
        
        IF iMaxRows <> ? AND iMaxRows > 0 THEN
        DO:
            BUFFER ttPartyRelationship:HANDLE:BATCH-SIZE = iMaxRows.
        END.
        ELSE 
        DO:
            BUFFER ttPartyRelationship:HANDLE:BATCH-SIZE = 0.
        END.
        
        BUFFER ttPartyRelationship:ATTACH-DATA-SOURCE(DATA-SOURCE srcPartyRelationship:HANDLE).

        IF cWhereQuery <> "" AND cWhereQuery <> ? THEN DATA-SOURCE srcPartyRelationship:FILL-WHERE-STRING = cWhereQuery.

        IF lUseReposition THEN
        DO:
            hQuery = DATA-SOURCE srcPartyRelationship:QUERY.
            hQuery:QUERY-OPEN.
            IF iSkipRows <> ? AND iSkipRows > 0 THEN
            DO:
                    hQuery:REPOSITION-TO-ROW(iSkipRows).
                    IF NOT AVAILABLE party_relationship THEN
                        hQuery:GET-NEXT () NO-ERROR.
            END.
            iCount = 0.
            REPEAT WHILE NOT hQuery:QUERY-OFF-END AND iCount < iMaxRows:
                hQuery:GET-NEXT () NO-ERROR.
                IF AVAILABLE party_relationship THEN
                DO:
                    CREATE ttPartyRelationship.
                    BUFFER-COPY party_relationship TO ttPartyRelationship.
                END.
                iCount = iCount + 1.
            END.
        END.
        ELSE 
        DO:
            DATASET dsPartyRelationship:FILL().
        END.
        FINALLY:
            BUFFER ttPartyRelationship:DETACH-DATA-SOURCE().
        END FINALLY.
            
    END METHOD.
    
    METHOD PUBLIC VOID CountPartyRelationship(INPUT cWhereQuery AS CHARACTER, OUTPUT numRecs AS INTEGER):
        
        DEFINE VARIABLE qh AS HANDLE NO-UNDO.
        
        IF cWhereQuery = ? OR cWhereQuery = "?" THEN cWhereQuery = "".
        CREATE QUERY qh.
        qh:SET-BUFFERS(BUFFER Party:HANDLE).
        qh:QUERY-PREPARE("PRESELECT EACH party_relationship " + cWhereQuery).
        qh:QUERY-OPEN ().
        numRecs = qh:NUM-RESULTS.
        
    END METHOD.
        
    METHOD PUBLIC VOID CreatePartyRelationship(INPUT-OUTPUT DATASET dsPartyRelationship):
        
        FOR EACH ttPartyRelationship
             WHERE ROW-STATE(ttPartyRelationship) = ROW-CREATED:
            
            CREATE party_relationship.
            BUFFER-COPY ttPartyRelationship TO party_relationship.      
            party_relationship.party_relationship_id = GUID.
            
        END.
        
    END METHOD.

    METHOD PUBLIC VOID UpdatePartyRelationship(INPUT-OUTPUT DATASET dsPartyRelationship):
        
        FOR EACH ttPartyRelationship
                WHERE ROW-STATE(ttPartyRelationship) = ROW-MODIFIED:
            
            FOR FIRST party_relationship EXCLUSIVE-LOCK
                    WHERE party_relationship.party_relationship_id = ttPartyRelationship.party_relationship_id:
                BUFFER-COPY ttPartyRelationship TO party_relationship.      
            END.
        END.
        
    END METHOD.

    METHOD PUBLIC VOID DeletePartyRelationship(INPUT-OUTPUT DATASET dsPartyRelationship):
        
        FOR EACH ttPartyRelationship
                WHERE ROW-STATE(ttPartyRelationship) = ROW-DELETED:
            
            FOR FIRST party_relationship EXCLUSIVE-LOCK
                    WHERE party_relationship.party_relationship_id = ttPartyRelationship.party_relationship_id:
                DELETE party_relationship.     
            END.
        END.
        
    END METHOD.
    
END CLASS.