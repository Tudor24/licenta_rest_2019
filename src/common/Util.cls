 
 /*------------------------------------------------------------------------
    File        : Util
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Tudor
    Created     : Mon Apr 29 19:33:03 EEST 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.common.Util: 
    
    METHOD PUBLIC STATIC LOGICAL IsEmpty (INPUT ipcValue AS CHARACTER):
        RETURN ipcValue = ? OR ipcValue = '':U.
    END METHOD.
    
END CLASS.