 
/*------------------------------------------------------------------------
   File        : BusinessEntity
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : Tudor
   Created     : Tue Apr 23 20:20:06 EEST 2019
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING Progress.Json.ObjectModel.*.
USING src.common.Util FROM PROPATH.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS BusinessEntity: 

    METHOD PUBLIC VOID ExtractABLFilter(INPUT ipcFilter AS CHARACTER, OUTPUT cWhereQuery AS CHARACTER, OUTPUT iMaxRows AS INTEGER, OUTPUT iSkipRows AS INTEGER):
        
        DEFINE VARIABLE ablFilter  AS CHARACTER         NO-UNDO.
        
        DEFINE VARIABLE jsonParser AS ObjectModelParser NO-UNDO.
        DEFINE VARIABLE jsonObject AS JsonObject        NO-UNDO.
        DEFINE VARIABLE cOrderBy   AS CHARACTER         NO-UNDO INITIAL "".
                
        IF ipcFilter BEGINS "WHERE " THEN
            cWhereQuery = ipcFilter.
        ELSE 
        IF ipcFilter BEGINS "~{" THEN
        DO:
            jsonParser = NEW ObjectModelParser().
            jsonObject = CAST(jsonParser:Parse(ipcFilter), jsonObject).
            iMaxRows   = jsonObject:GetInteger("top") NO-ERROR.
            iSkipRows  = jsonObject:GetInteger("skip") NO-ERROR.
            ablFilter  = jsonObject:GetCharacter("ablFilter") NO-ERROR.
            cOrderBy   = jsonObject:GetCharacter("orderBy") NO-ERROR.
            
            IF ablFilter <> "" AND ablFilter <> ? THEN
                cWhereQuery = "WHERE " + ablFilter.
    
            IF cOrderBy > "" THEN
            DO:
                cOrderBy = REPLACE(cOrderBy, ",", " by ").
                cOrderBy = "by " + cOrderBy + " ".
            END.
        END.
        ELSE 
        IF ipcFilter NE "" THEN
        DO:
            /* Use filter as WHERE clause */
            cWhereQuery = "WHERE " + ipcFilter.
        END.
        ELSE
        DO:
            ASSIGN
                iMaxRows  = 100
                iSkipRows = 0
                .                
        END.
        IF cOrderBy = ? THEN cOrderBy = "".
        
        cWhereQuery = IF cWhereQuery > "" THEN (cWhereQuery + " " + cOrderBy) ELSE (cOrderBy).
        
    END METHOD.

END CLASS.