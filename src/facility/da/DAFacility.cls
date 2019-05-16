 
 /*------------------------------------------------------------------------
    File        : DAFacility
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Tudor
    Created     : Sat Apr 20 19:00:38 EEST 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS facility.da.DAFacility: 
    
    {facility/include/dsFacility.i}
    
    DEFINE DATA-SOURCE srcFacility FOR facility.
    DEFINE PRIVATE STATIC VARIABLE myInstance AS facility.da.DAFacility NO-UNDO.
    
    METHOD PUBLIC STATIC facility.da.DAFacility GetInstance():
        
        DEFINE VARIABLE i AS INTEGER NO-UNDO.
        
        IF NOT VALID-OBJECT(myInstance) THEN
            myInstance = NEW facility.da.DAFacility ().        
        RETURN myInstance.
        
        CATCH err AS Progress.Lang.Error :
            LOG-MANAGER:WRITE-MESSAGE ("ERROR in GetInstance of DAFacility:").
            DO i = 1 TO err:NumMessages:
                LOG-MANAGER:WRITE-MESSAGE (SUBSTITUTE("   ** (&1) &2", err:GetMessageNum(i), err:GetMessage(i))).
            END.
            UNDO, THROW err.
        END CATCH.

    END METHOD.
    
    CONSTRUCTOR PRIVATE DAFacility():
    END CONSTRUCTOR.
    
    DESTRUCTOR PUBLIC DAFacility():
        myInstance = ?
        .
/*        DELETE OBJECT myInstance     NO-ERROR.*/
    /*        myInstance = ?.*/
        
    END.
    
    METHOD PUBLIC VOID ReadFacility(INPUT cWhereQuery AS CHARACTER, INPUT iMaxRows AS INTEGER, INPUT iSkipRows AS INTEGER, OUTPUT DATASET dsFacility):
        
        DEFINE VARIABLE lUseReposition AS LOGICAL NO-UNDO.
        DEFINE VARIABLE hQuery         AS HANDLE  NO-UNDO.
        DEFINE VARIABLE iCount         AS INTEGER NO-UNDO.
        
        EMPTY TEMP-TABLE ttFacility.
        
        lUseReposition = iSkipRows <> ?.
        IF iMaxRows <> ? AND iMaxRows > 0 THEN
        DO:
            BUFFER ttFacility:HANDLE:BATCH-SIZE = iMaxRows.
        END.
        ELSE 
        DO:
            BUFFER ttFacility:HANDLE:BATCH-SIZE = 0.
        END.
        
        BUFFER ttFacility:ATTACH-DATA-SOURCE(DATA-SOURCE srcFacility:HANDLE).

        IF cWhereQuery <> "" AND cWhereQuery <> ? THEN DATA-SOURCE srcFacility:FILL-WHERE-STRING = cWhereQuery.

        IF lUseReposition THEN
        DO:
            hQuery = DATA-SOURCE srcFacility:QUERY.
            hQuery:QUERY-OPEN.
            IF iSkipRows <> ? AND iSkipRows > 0 THEN
            DO:
                    hQuery:REPOSITION-TO-ROW(iSkipRows).
                    IF NOT AVAILABLE facility THEN
                        hQuery:GET-NEXT () NO-ERROR.
            END.
            iCount = 0.
            REPEAT WHILE NOT hQuery:QUERY-OFF-END AND iCount < iMaxRows:
                hQuery:GET-NEXT () NO-ERROR.
                IF AVAILABLE facility THEN
                DO:
                    FIND FIRST ttFacility 
                            WHERE ttFacility.facility_id = facility.facility_id
                        NO-ERROR.
                    IF NOT AVAILABLE ttFacility THEN

                        CREATE ttFacility.
                    BUFFER-COPY facility TO ttFacility.
                END.
                iCount = iCount + 1.
            END.
        END.
        ELSE 
        DO:
            DATASET dsFacility:FILL().
        END.
        
        FINALLY:
            BUFFER ttFacility:DETACH-DATA-SOURCE().
        END FINALLY.
            
    END METHOD.
    
    METHOD PUBLIC VOID CountFacility(INPUT cWhereQuery AS CHARACTER, OUTPUT numRecs AS INTEGER):
        
        DEFINE VARIABLE qh AS HANDLE NO-UNDO.
        
        IF cWhereQuery = ? OR cWhereQuery = "?" THEN cWhereQuery = "".
        CREATE QUERY qh.
        qh:SET-BUFFERS(BUFFER Party:HANDLE).
        qh:QUERY-PREPARE("PRESELECT EACH facility " + cWhereQuery).
        qh:QUERY-OPEN ().
        numRecs = qh:NUM-RESULTS.
        
    END METHOD.
        
    METHOD PUBLIC VOID CreateFacility(INPUT-OUTPUT DATASET dsFacility):
        
        FOR EACH ttFacility
             WHERE ROW-STATE(ttFacility) = ROW-CREATED:
            
            CREATE facility.
            BUFFER-COPY ttFacility TO facility.      
            facility.facility_id = GUID.
            
        END.
        
    END METHOD.

    METHOD PUBLIC VOID UpdateFacility(INPUT-OUTPUT DATASET dsFacility):
        
        FOR EACH ttFacility
                WHERE ROW-STATE(ttFacility) = ROW-MODIFIED:
            
            FOR FIRST facility EXCLUSIVE-LOCK
                    WHERE facility.facility_id = ttFacility.facility_id:
                BUFFER-COPY ttFacility TO facility.      
            END.
        END.
        
    END METHOD.

    METHOD PUBLIC VOID DeleteFacility(INPUT-OUTPUT DATASET dsFacility):
        
        FOR EACH ttFacility
                WHERE ROW-STATE(ttFacility) = ROW-DELETED:
            
            FOR FIRST facility EXCLUSIVE-LOCK
                    WHERE facility.facility_id = ttFacility.facility_id:
                DELETE facility.     
            END.
        END.
        
    END METHOD.
    
END CLASS.