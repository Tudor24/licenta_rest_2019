 
 /*------------------------------------------------------------------------
    File        : DAParty
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Tudor
    Created     : Sat Apr 20 18:46:54 EEST 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS party.da.DAParty: 
    
    {party/include/dsParty.i}
    
    DEFINE DATA-SOURCE srcParty FOR Party.
    DEFINE PRIVATE STATIC VARIABLE myInstance AS party.da.DAParty NO-UNDO.
    
    METHOD PUBLIC STATIC party.da.DAParty GetInstance():
        
        DEFINE VARIABLE i AS INTEGER NO-UNDO.
        
        IF NOT VALID-OBJECT(myInstance) THEN
            myInstance = NEW party.da.DAParty ().
        RETURN myInstance.
        
        CATCH err AS Progress.Lang.Error :
            LOG-MANAGER:WRITE-MESSAGE ("ERROR in GetInstance of DAParty:").
            DO i = 1 TO err:NumMessages:
                LOG-MANAGER:WRITE-MESSAGE (SUBSTITUTE("   ** (&1) &2", err:GetMessageNum(i), err:GetMessage(i))).
            END.
            UNDO, THROW err.
        END CATCH.

    END METHOD.

    CONSTRUCTOR PRIVATE DAParty():
    END CONSTRUCTOR.
    
    METHOD PUBLIC VOID ReadParty(INPUT cWhereQuery AS CHARACTER, INPUT iMaxRows AS INTEGER, INPUT iSkipRows AS INTEGER, OUTPUT DATASET dsParty):
        
        DEFINE VARIABLE lUseReposition AS LOGICAL NO-UNDO.
        DEFINE VARIABLE hQuery         AS HANDLE  NO-UNDO.
        DEFINE VARIABLE iCount         AS INTEGER NO-UNDO.
        
        lUseReposition = iSkipRows <> ?.
        
        IF iMaxRows <> ? AND iMaxRows > 0 THEN
        DO:
            BUFFER ttParty:HANDLE:BATCH-SIZE = iMaxRows.
        END.
        ELSE 
        DO:
            BUFFER ttParty:HANDLE:BATCH-SIZE = 0.
        END.
        
        BUFFER ttParty:ATTACH-DATA-SOURCE(DATA-SOURCE srcParty:HANDLE).

        IF cWhereQuery <> "" AND cWhereQuery <> ? THEN DATA-SOURCE srcParty:FILL-WHERE-STRING = cWhereQuery.

        IF lUseReposition THEN
        DO:
            hQuery = DATA-SOURCE srcParty:QUERY.
            hQuery:QUERY-OPEN.
            IF iSkipRows <> ? AND iSkipRows > 0 THEN
            DO:
                    hQuery:REPOSITION-TO-ROW(iSkipRows).
                    IF NOT AVAILABLE Party THEN
                        hQuery:GET-NEXT () NO-ERROR.
            END.
            iCount = 0.
            REPEAT WHILE NOT hQuery:QUERY-OFF-END AND iCount < iMaxRows:
                hQuery:GET-NEXT () NO-ERROR.
                IF AVAILABLE Party THEN
                DO:
                    CREATE ttParty.
                    BUFFER-COPY Party TO ttParty.
                END.
                iCount = iCount + 1.
            END.
        END.
        ELSE 
        DO:
            DATASET dsParty:FILL().
        END.
        FINALLY:
            BUFFER ttParty:DETACH-DATA-SOURCE().
        END FINALLY.
            
    END METHOD.
    
    METHOD PUBLIC VOID CountParty(INPUT cWhereQuery AS CHARACTER, OUTPUT numRecs AS INTEGER):
        
        DEFINE VARIABLE qh AS HANDLE NO-UNDO.
        
        IF cWhereQuery = ? OR cWhereQuery = "?" THEN cWhereQuery = "".
        CREATE QUERY qh.
        qh:SET-BUFFERS(BUFFER Party:HANDLE).
        qh:QUERY-PREPARE("PRESELECT EACH Party " + cWhereQuery).
        qh:QUERY-OPEN ().
        numRecs = qh:NUM-RESULTS.
        
    END METHOD.
        
    METHOD PUBLIC VOID CreateParty(INPUT-OUTPUT DATASET dsParty):
        
        FOR EACH ttParty
             WHERE ROW-STATE(ttParty) = ROW-CREATED:
            
            CREATE Party.
            BUFFER-COPY ttParty TO Party.      
            Party.party_id = GUID.
            
        END.
        
    END METHOD.

    METHOD PUBLIC VOID UpdateParty(INPUT-OUTPUT DATASET dsParty):
        
        FOR EACH ttParty
                WHERE ROW-STATE(ttParty) = ROW-MODIFIED:
            
            FOR FIRST Party EXCLUSIVE-LOCK
                    WHERE Party.party_id = ttParty.party_id:
                BUFFER-COPY ttParty TO Party.      
            END.
        END.
        
    END METHOD.

    METHOD PUBLIC VOID DeleteParty(INPUT-OUTPUT DATASET dsParty):
        
        FOR EACH ttParty
                WHERE ROW-STATE(ttParty) = ROW-DELETED:
            
            FOR FIRST Party EXCLUSIVE-LOCK
                    WHERE Party.party_id = ttParty.party_id:
                DELETE Party.     
            END.
        END.
        
    END METHOD.
    
END CLASS.