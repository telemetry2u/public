VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} LoadDataForm 
   Caption         =   "Load Telemetry2U Data"
   ClientHeight    =   3760
   ClientLeft      =   110
   ClientTop       =   450
   ClientWidth     =   6570
   OleObjectBlob   =   "LoadDataForm.frx":0000
   StartUpPosition =   1  'CenterOwner
End
Attribute VB_Name = "LoadDataForm"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
' Retrieve data - if new sheet load last 30 days of data
' otherwise append data received since last time

Private Sub LoadDataButton_Click()
    Dim NodeDescription As String
    Dim NodeId As String
    Dim vJSON As Variant
    Dim Sheet As Worksheet
    Dim LastDate As Date
    Dim StartDate As Date
    Dim LastRow As Integer
    
    NodeId = Telemetry2U.GetWorksheet("Nodes").Range("A" & NodeList.ListIndex + 2)
    NodeDescription = NodeList.Value
    Set Sheet = Telemetry2U.GetWorksheet(NodeDescription)
    LastDate = Application.WorksheetFunction.Max(Sheet.Range("A:A"))
    If Year(LastDate) < 2000 Then
        StartDate = Now - 30
    Else
        StartDate = LastDate + (1# / 86400#)
    End If
    vJSON = Telemetry2U.MakeApiCall("data/" & NodeId & "/" & Format(StartDate, "yyyy-mm-dd hh:mm:ss") & "/9999-01-01")
    Telemetry2U.Output Sheet, vJSON
    
    ' Remove "T" from JSON dates so Excel will parse them correctly
    LastRow = Sheet.Cells(Rows.Count, 1).End(xlUp).Row
    Sheet.Range("A2:A" & LastRow).Replace "T", " "
    Sheet.Range("A2:A" & LastRow).NumberFormat = "yyyy-mm-dd hh:mm:ss"
End Sub

' Retrieve list of nodes when form is opened

Private Sub UserForm_Initialize()
    Dim vJSON As Variant
    Dim NewSheet As Worksheet
    Dim Rng As Range
    Dim NodeCollection As New Collection
    
    vJSON = Telemetry2U.MakeApiCall("nodes")
    Set NewSheet = Telemetry2U.GetWorksheet("Nodes")
    NewSheet.Cells.Clear
    Telemetry2U.Output NewSheet, vJSON
    With NewSheet
        NodeList.List = .Range(.Range("B2"), .Cells(.Rows.Count, 2).End(xlUp)).Value
    End With
    Worksheets("Main").Activate
End Sub
