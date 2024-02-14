' File: FileProductVer.vbs
Set FSO=CreateObject("Scripting.FileSystemObject")
If Wscript.Arguments.Count > 0 then
   sFullFileName = Wscript.Arguments(0)
   If FSO.FileExists(sFullFileName) Then
      Set objFolder = CreateObject("Shell.Application").Namespace(FSO.GetParentFolderName(sFullFileName))
      Set objFolderItem = objFolder.ParseName(FSO.GetFileName(sFullFileName))
      WScript.Echo "FileVersion   : " & objFolderItem.ExtendedProperty("Fileversion")
      WScript.Echo "ProductVersion: " & objFolderItem.ExtendedProperty("productversion")
   Else
      WScript.Echo "Error: missing file"
   End If
Else
   WScript.Echo "Error: missing input"
End If