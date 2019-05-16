
/*------------------------------------------------------------------------
    File        : testFacility.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : Tudor
    Created     : Tue May 14 20:04:01 EEST 2019
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

BLOCK-LEVEL ON ERROR UNDO, THROW.

USING facility.bl.BEFacility FROM PROPATH.
USING facility.si.SIFacility FROM PROPATH.

/* ********************  Preprocessor Definitions  ******************** */

{facility/include/dsFacility.i}
/* ***************************  Main Block  *************************** */

DEF VAR beFac AS BEFacility NO-UNDO.

beFac = BEFacility:GetInstance().
beFac:ReadFacility("", OUTPUT DATASET dsFacility BY-REFERENCE).
MESSAGE 'A'
VIEW-AS ALERT-BOX.
for first ttFacility:
MESSAGE ttFacility.DESCRIPTION
VIEW-AS ALERT-BOX.
end.
DELETE OBJECT beFac NO-ERROR.

DEF VAR SIF AS SIFacility NO-UNDO.

SIF = NEW SIFacility().

FINALLY:
    DELETE OBJECT SIF.
END.