Attribute VB_Name = "Telemetry2U"
' Microsoft Excel Helper function to retrieve data from Telemetry2U REST API

' MIT License
' Copyright (c) 2022 Telemetry2U Pty Lrd
' Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
' The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
' THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Option Explicit

' Construct authorization string
' Email / API key comes from sheet Account Details cells B1 & B2

Function GetAuthorization() As String
    Dim email As String
    Dim apiKey As String
    Dim authorization As String

    email = Worksheets("Account Details").Range("B1")
    apiKey = Worksheets("Account Details").Range("B2")
    authorization = EncodeBase64(email & ":" & apiKey)
    GetAuthorization = "Bearer " & authorization
End Function

' Encode string to Base64

Function EncodeBase64(data As String) As String
    Dim Result As String
    Dim RawData() As Byte
    RawData = StrConv(data, vbFromUnicode)

    Dim XmlDoc As Object
    Dim Base64Node As Object
    Set XmlDoc = CreateObject("MSXML2.DOMDocument")
    Set Base64Node = XmlDoc.createElement("b64")

    Base64Node.DataType = "bin.base64"
    Base64Node.nodeTypedValue = RawData
    Result = Replace(Base64Node.text, vbLf, "")
    Set Base64Node = Nothing
    Set XmlDoc = Nothing
    EncodeBase64 = Result
End Function

' Make API call to endpoint and return JSON object

Function MakeApiCall(endpoint As String) As Variant
    Dim url As String
    Dim request As Object
    Dim vJSON As Variant
    Dim state As String

    url = "https://telemetry2u.com/api/" & endpoint
    Set request = CreateObject("MSXML2.ServerXMLHTTP")
    With request
        .Open "GET", url, True
        .setRequestHeader "Authorization", GetAuthorization()
        .setRequestHeader "Accept", "application/json"
        .setRequestHeader "Content-Type", "application/json"
        .Send
        While request.readyState <> 4
            DoEvents
        Wend
'        Debug.Print .ResponseText
        If Left(.ResponseText, 1) <> "[" Then
            MsgBox .ResponseText
        Else
            JSON.Parse .ResponseText, vJSON, state
        End If
    End With
    MakeApiCall = vJSON
End Function

' Worksheet name must contains maximum of 31 characters
' and not include characters: ":", "\", "/", "?", "*", "[", "]"

Function SafeSheetName(name As String) As String
    Dim Result As String
    Result = name
    Dim ProblemChars
    ProblemChars = [{":", "\", "/", "?", "*", "[", "]"}]
    Dim i As Integer
    For i = LBound(ProblemChars) To UBound(ProblemChars)
        Result = Replace(Result, ProblemChars(i), "_")
    Next
    SafeSheetName = Left(Result, 31)
End Function

' Get reference to worksheet or create new one if it doesn't exist

Function GetWorksheet(name As String) As Worksheet
    Dim SafeName As String
    SafeName = SafeSheetName(name)
    Dim SheetIndex As Integer
    On Error Resume Next
    SheetIndex = ActiveWorkbook.Sheets(SafeName).Index
    On Error GoTo 0
    If SheetIndex > 0 Then
        Set GetWorksheet = ActiveWorkbook.Sheets(SheetIndex)
    Else
        Dim NewWorksheet As Worksheet
        Dim LastWorksheet As Worksheet
        Set LastWorksheet = ActiveWorkbook.Worksheets(ActiveWorkbook.Worksheets.Count)
        Set NewWorksheet = ActiveWorkbook.Sheets.Add(After:=LastWorksheet)
        NewWorksheet.name = SafeName
        Set GetWorksheet = NewWorksheet
    End If
End Function

' Copy JSON data to worksheet

Sub OutputOld(oTarget As Worksheet, vJSON)
    Dim aData()
    Dim aHeader()
    
    JSON.ToArray vJSON, aData, aHeader
    If UBound(aData) > 0 Then
        With oTarget
            .Activate
            .Cells.Delete
            With .Cells(1, 1)
                .Resize(1, UBound(aHeader) - LBound(aHeader) + 1).Value = aHeader
                .Offset(1, 0).Resize( _
                        UBound(aData, 1) - LBound(aData, 1) + 1, _
                        UBound(aData, 2) - LBound(aData, 2) + 1 _
                    ).Value = aData
            End With
            .Columns.AutoFit
        End With
    Else
        MsgBox "No data was retrieved"
    End If
End Sub

Sub Output(Sheet As Worksheet, vJSON)
    Dim LastRow As Integer
    Dim aData()
    Dim aHeader()
    
    LastRow = Sheet.Cells(Rows.Count, 1).End(xlUp).Row
    JSON.ToArray vJSON, aData, aHeader
    If aData(0, 0) <> Empty Then
        With Sheet
            .Activate
            With .Cells(LastRow, 1)
                If LastRow <= 1 Then
                    .Resize(1, UBound(aHeader) - LBound(aHeader) + 1).Value = aHeader
                End If
                .Offset(1, 0).Resize( _
                        UBound(aData, 1) - LBound(aData, 1) + 1, _
                        UBound(aData, 2) - LBound(aData, 2) + 1 _
                    ).Value = aData
            End With
            .Columns.AutoFit
        End With
    Else
        MsgBox "No data was retrieved"
    End If
End Sub



