 
 /*------------------------------------------------------------------------
    File        : DAWorkEffort
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Tudor
    Created     : Sat Apr 20 20:09:56 EEST 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS effort.da.DAWorkEffort: 
    
    {effort/include/dsWorkEffort.i}
    
    DEFINE DATA-SOURCE srcWorkEffort FOR work_effort.
    DEFINE PRIVATE STATIC VARIABLE myInstance AS effort.da.DAWorkEffort NO-UNDO.
    
    METHOD PUBLIC STATIC effort.da.DAWorkEffort GetInstance():
        
        DEFINE VARIABLE i AS INTEGER NO-UNDO.
        
        IF NOT VALID-OBJECT(myInstance) THEN
            myInstance = NEW effort.da.DAWorkEffort ().        
        RETURN myInstance.
        
        CATCH err AS Progress.Lang.Error :
            LOG-MANAGER:WRITE-MESSAGE ("ERROR in GetInstance of DAWorkEffort:").
            DO i = 1 TO err:NumMessages:
                LOG-MANAGER:WRITE-MESSAGE (SUBSTITUTE("   ** (&1) &2", err:GetMessageNum(i), err:GetMessage(i))).
            END.
            UNDO, THROW err.
        END CATCH.

    END METHOD.
    
    CONSTRUCTOR PRIVATE DAWorkEffort():
    END CONSTRUCTOR.
    
    METHOD PUBLIC VOID ReadWorkEffort(INPUT cWhereQuery AS CHARACTER, INPUT iMaxRows AS INTEGER, INPUT iSkipRows AS INTEGER, OUTPUT DATASET dsWorkEffort):
        
        DEFINE VARIABLE lUseReposition AS LOGICAL NO-UNDO.
        DEFINE VARIABLE hQuery         AS HANDLE  NO-UNDO.
        DEFINE VARIABLE iCount         AS INTEGER NO-UNDO.
        
        lUseReposition = iSkipRows <> ?.
        
        IF iMaxRows <> ? AND iMaxRows > 0 THEN
        DO:
            BUFFER ttWorkEffort:HANDLE:BATCH-SIZE = iMaxRows.
        END.
        ELSE 
        DO:
            BUFFER ttWorkEffort:HANDLE:BATCH-SIZE = 0.
        END.
        
        BUFFER ttWorkEffort:ATTACH-DATA-SOURCE(DATA-SOURCE srcWorkEffort:HANDLE).

        IF cWhereQuery <> "" AND cWhereQuery <> ? THEN DATA-SOURCE srcWorkEffort:FILL-WHERE-STRING = cWhereQuery.

        IF lUseReposition THEN
        DO:
            hQuery = DATA-SOURCE srcWorkEffort:QUERY.
            hQuery:QUERY-OPEN.
            IF iSkipRows <> ? AND iSkipRows > 0 THEN
            DO:
                    hQuery:REPOSITION-TO-ROW(iSkipRows).
                    IF NOT AVAILABLE work_effort THEN
                        hQuery:GET-NEXT () NO-ERROR.
            END.
            iCount = 0.
            REPEAT WHILE NOT hQuery:QUERY-OFF-END AND iCount < iMaxRows:
                hQuery:GET-NEXT () NO-ERROR.
                IF AVAILABLE work_effort THEN
                DO:
                    CREATE ttWorkEffort.
                    BUFFER-COPY work_effort TO ttWorkEffort.
                END.
                iCount = iCount + 1.
            END.
        END.
        ELSE 
        DO:
            DATASET dsWorkEffort:FILL().
        END.
        FINALLY:
            BUFFER ttWorkEffort:DETACH-DATA-SOURCE().
        END FINALLY.
            
    END METHOD.
    
    METHOD PUBLIC VOID CountWorkEffort(INPUT cWhereQuery AS CHARACTER, OUTPUT numRecs AS INTEGER):
        
        DEFINE VARIABLE qh AS HANDLE NO-UNDO.
        
        IF cWhereQuery = ? OR cWhereQuery = "?" THEN cWhereQuery = "".
        CREATE QUERY qh.
        qh:SET-BUFFERS(BUFFER work_effort:HANDLE).
        qh:QUERY-PREPARE("PRESELECT EACH work_effort " + cWhereQuery).
        qh:QUERY-OPEN ().
        numRecs = qh:NUM-RESULTS.
        
    END METHOD.
        
    METHOD PUBLIC VOID CreateWorkEffort(INPUT-OUTPUT DATASET dsWorkEffort):
        
        FOR EACH ttWorkEffort
             WHERE ROW-STATE(ttWorkEffort) = ROW-CREATED:
            
            CREATE work_effort.
            BUFFER-COPY ttWorkEffort TO work_effort.      
            work_effort.work_effort_id = GUID.
            
        END.
        
    END METHOD.

    METHOD PUBLIC VOID UpdateWorkEffort(INPUT-OUTPUT DATASET dsWorkEffort):
        
        FOR EACH ttWorkEffort
                WHERE ROW-STATE(ttWorkEffort) = ROW-MODIFIED:
            
            FOR FIRST work_effort EXCLUSIVE-LOCK
                    WHERE work_effort.work_effort_id = ttWorkEffort.work_effort_id:
                BUFFER-COPY ttWorkEffort TO work_effort.      
            END.
        END.
        
    END METHOD.

    METHOD PUBLIC VOID DeleteWorkEffort(INPUT-OUTPUT DATASET dsWorkEffort):
        
        FOR EACH ttWorkEffort
                WHERE ROW-STATE(ttWorkEffort) = ROW-DELETED:
            
            FOR FIRST work_effort EXCLUSIVE-LOCK
                    WHERE work_effort.work_effort_id = ttWorkEffort.work_effort_id:
                DELETE work_effort.     
            END.
        END.
        
    END METHOD.
    
END CLASS.