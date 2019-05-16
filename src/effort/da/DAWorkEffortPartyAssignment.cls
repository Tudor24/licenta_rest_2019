 
 /*------------------------------------------------------------------------
    File        : DAWorkEffortPartyAssignmentPartyAssignment
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Tudor
    Created     : Sat Apr 20 20:10:52 EEST 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS effort.da.DAWorkEffortPartyAssignment: 

    {effort/include/dsWorkEffortPartyAssignment.i}
    
    DEFINE DATA-SOURCE srcWorkEffortPartyAssignment FOR work_effort_party_assignment.
    DEFINE PRIVATE STATIC VARIABLE myInstance AS effort.da.DAWorkEffortPartyAssignment NO-UNDO.
    
    METHOD PUBLIC STATIC effort.da.DAWorkEffortPartyAssignment GetInstance():
        
        DEFINE VARIABLE i AS INTEGER NO-UNDO.
        
        IF NOT VALID-OBJECT(myInstance) THEN
            myInstance = NEW effort.da.DAWorkEffortPartyAssignment ().        
        RETURN myInstance.
        
        CATCH err AS Progress.Lang.Error :
            LOG-MANAGER:WRITE-MESSAGE ("ERROR in GetInstance of DAWorkEffortPartyAssignment:").
            DO i = 1 TO err:NumMessages:
                LOG-MANAGER:WRITE-MESSAGE (SUBSTITUTE("   ** (&1) &2", err:GetMessageNum(i), err:GetMessage(i))).
            END.
            UNDO, THROW err.
        END CATCH.

    END METHOD.
    
    CONSTRUCTOR PRIVATE DAWorkEffortPartyAssignment():
    END CONSTRUCTOR.
    
    METHOD PUBLIC VOID ReadWorkEffortPartyAssignment(INPUT cWhereQuery AS CHARACTER, INPUT iMaxRows AS INTEGER, INPUT iSkipRows AS INTEGER, OUTPUT DATASET dsWorkEffortPartyAssignment):
        
        DEFINE VARIABLE lUseReposition AS LOGICAL NO-UNDO.
        DEFINE VARIABLE hQuery         AS HANDLE  NO-UNDO.
        DEFINE VARIABLE iCount         AS INTEGER NO-UNDO.
        
        lUseReposition = iSkipRows <> ?.
        
        IF iMaxRows <> ? AND iMaxRows > 0 THEN
        DO:
            BUFFER ttWorkEffortPartyAssignment:HANDLE:BATCH-SIZE = iMaxRows.
        END.
        ELSE 
        DO:
            BUFFER ttWorkEffortPartyAssignment:HANDLE:BATCH-SIZE = 0.
        END.
        
        BUFFER ttWorkEffortPartyAssignment:ATTACH-DATA-SOURCE(DATA-SOURCE srcWorkEffortPartyAssignment:HANDLE).

        IF cWhereQuery <> "" AND cWhereQuery <> ? THEN DATA-SOURCE srcWorkEffortPartyAssignment:FILL-WHERE-STRING = cWhereQuery.

        IF lUseReposition THEN
        DO:
            hQuery = DATA-SOURCE srcWorkEffortPartyAssignment:QUERY.
            hQuery:QUERY-OPEN.
            IF iSkipRows <> ? AND iSkipRows > 0 THEN
            DO:
                    hQuery:REPOSITION-TO-ROW(iSkipRows).
                    IF NOT AVAILABLE work_effort_party_assignment THEN
                        hQuery:GET-NEXT () NO-ERROR.
            END.
            iCount = 0.
            REPEAT WHILE NOT hQuery:QUERY-OFF-END AND iCount < iMaxRows:
                hQuery:GET-NEXT () NO-ERROR.
                IF AVAILABLE work_effort_party_assignment THEN
                DO:
                    CREATE ttWorkEffortPartyAssignment.
                    BUFFER-COPY work_effort_party_assignment TO ttWorkEffortPartyAssignment.
                END.
                iCount = iCount + 1.
            END.
        END.
        ELSE 
        DO:
            DATASET dsWorkEffortPartyAssignment:FILL().
        END.
        FINALLY:
            BUFFER ttWorkEffortPartyAssignment:DETACH-DATA-SOURCE().
        END FINALLY.
            
    END METHOD.
    
    METHOD PUBLIC VOID CountWorkEffortPartyAssignment(INPUT cWhereQuery AS CHARACTER, OUTPUT numRecs AS INTEGER):
        
        DEFINE VARIABLE qh AS HANDLE NO-UNDO.
        
        IF cWhereQuery = ? OR cWhereQuery = "?" THEN cWhereQuery = "".
        CREATE QUERY qh.
        qh:SET-BUFFERS(BUFFER work_effort_party_assignment:HANDLE).
        qh:QUERY-PREPARE("PRESELECT EACH work_effort_party_assignment " + cWhereQuery).
        qh:QUERY-OPEN ().
        numRecs = qh:NUM-RESULTS.
        
    END METHOD.
        
    METHOD PUBLIC VOID CreateWorkEffortPartyAssignment(INPUT-OUTPUT DATASET dsWorkEffortPartyAssignment):
        
        FOR EACH ttWorkEffortPartyAssignment
             WHERE ROW-STATE(ttWorkEffortPartyAssignment) = ROW-CREATED:
            
            CREATE work_effort_party_assignment.
            BUFFER-COPY ttWorkEffortPartyAssignment TO work_effort_party_assignment.      
            
        END.
        
    END METHOD.

    METHOD PUBLIC VOID UpdateWorkEffortPartyAssignment(INPUT-OUTPUT DATASET dsWorkEffortPartyAssignment):
        
        FOR EACH ttWorkEffortPartyAssignment
                WHERE ROW-STATE(ttWorkEffortPartyAssignment) = ROW-MODIFIED:
            
            FOR FIRST work_effort_party_assignment EXCLUSIVE-LOCK
                    WHERE work_effort_party_assignment.work_effort_id = ttWorkEffortPartyAssignment.work_effort_id
                      AND work_effort_party_assignment.party_id       = ttWorkEffortPartyAssignment.party_id
                      AND work_effort_party_assignment.role_type_id   = ttWorkEffortPartyAssignment.role_type_id:
                BUFFER-COPY ttWorkEffortPartyAssignment TO work_effort_party_assignment.      
            END.
        END.
        
    END METHOD.

    METHOD PUBLIC VOID DeleteWorkEffortPartyAssignment(INPUT-OUTPUT DATASET dsWorkEffortPartyAssignment):
        
        FOR EACH ttWorkEffortPartyAssignment
                WHERE ROW-STATE(ttWorkEffortPartyAssignment) = ROW-DELETED:
            
            FOR FIRST work_effort_party_assignment EXCLUSIVE-LOCK
                    WHERE work_effort_party_assignment.work_effort_id = ttWorkEffortPartyAssignment.work_effort_id
                      AND work_effort_party_assignment.party_id       = ttWorkEffortPartyAssignment.party_id
                      AND work_effort_party_assignment.role_type_id   = ttWorkEffortPartyAssignment.role_type_id:
                DELETE work_effort_party_assignment.     
            END.
        END.
        
    END METHOD.

END CLASS.