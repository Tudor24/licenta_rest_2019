
/*------------------------------------------------------------------------
    File        : testParty.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : Tudor
    Created     : Mon Apr 29 19:11:00 EEST 2019
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

BLOCK-LEVEL ON ERROR UNDO, THROW.

/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
DEFINE VARIABLE daParty                   AS party.da.DAParty NO-UNDO.
DEFINE VARIABLE daParty2                   AS party.da.DAParty NO-UNDO.

daParty = party.da.DAParty:GetInstance().
daParty2 = party.da.DAParty:GetInstance().

delete object daparty no-error.

daParty = party.da.DAParty:GetInstance().

delete object daparty no-error.

/*daparty = new party.da.daparty().*/

message 'a'
view-as alert-box.

delete object daparty no-error.