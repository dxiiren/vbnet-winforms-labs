Public Class Form1
    Private Sub btnExit_Click(sender As Object, e As EventArgs) Handles btnExit.Click
        Me.Close()
    End Sub

    Private Sub btnClear_Click(sender As Object, e As EventArgs) Handles btnClear.Click
        txtStudentNumber.Text = ""
        txtStudentName.Text = ""
        txtExamination.Text = ""
        txtGroupProject.Text = ""
        txtTest.Text = ""
        txtQuiz.Text = ""
        lblGrade.Text = ""
        lblTotalMarks.Text = ""

    End Sub

    Private Sub cmdCalculateMark_Click(sender As Object, e As EventArgs) Handles cmdCalculateMark.Click

        Dim dblTotalMark As Double
        Dim chrGrade As Char
        Dim dblExam As Double
        Dim dblGp As Double
        Dim dblTest As Double
        Dim dblQuiz As Double
        Dim intStudent As Integer

        Dim blnStudent As Boolean = Integer.TryParse(txtStudentNumber.Text, intStudent)
        Dim blnExam As Boolean = Double.TryParse(txtExamination.Text, dblExam)
        Dim blnGp As Boolean = Double.TryParse(txtGroupProject.Text, dblGp)
        Dim blnTest As Boolean = Double.TryParse(txtTest.Text, dblTest)
        Dim blnQuiz As Boolean = Double.TryParse(txtQuiz.Text, dblQuiz)

        If blnStudent And blnExam And blnGp And blnTest And blnQuiz Then
            ' Each component mark is out of its weight (see the form labels):
            ' Examination 50%, Group Project 25%, Test 15%, Quiz 10%.
            Dim strRangeError As String = ""
            If dblExam < 0 Or dblExam > 50 Then
                strRangeError = "Examination must be between 0 and 50."
            ElseIf dblGp < 0 Or dblGp > 25 Then
                strRangeError = "Group Project must be between 0 and 25."
            ElseIf dblTest < 0 Or dblTest > 15 Then
                strRangeError = "Test must be between 0 and 15."
            ElseIf dblQuiz < 0 Or dblQuiz > 10 Then
                strRangeError = "Quiz must be between 0 and 10."
            End If

            If strRangeError <> "" Then
                MsgBox(strRangeError, vbExclamation, "Mark Out Of Range")
                Return
            End If

            dblTotalMark = dblExam + dblGp + dblTest + dblQuiz

            Select Case dblTotalMark
                Case >= 85
                    chrGrade = "A"
                Case >= 75
                    chrGrade = "B"
                Case >= 65
                    chrGrade = "C"
                Case >= 55
                    chrGrade = "D"
                Case Else
                    chrGrade = "E"
            End Select

            lblTotalMarks.Text = CStr(dblTotalMark)
            lblGrade.Text = CStr(chrGrade)

            MsgBox("Student No: " & txtStudentNumber.Text & Environment.NewLine &
                       "Student Name: " & txtStudentName.Text & Environment.NewLine &
                       "Grade: " & CStr(chrGrade), vbOKOnly, "Student's Grade")
        Else
            MsgBox("Please input data correctly", vbExclamation, "Wrong Input")

        End If

    End Sub
End Class
