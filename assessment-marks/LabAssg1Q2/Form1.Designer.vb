<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class Form1
    Inherits System.Windows.Forms.Form

    'Form overrides dispose to clean up the component list.
    <System.Diagnostics.DebuggerNonUserCode()> _
    Protected Overrides Sub Dispose(ByVal disposing As Boolean)
        Try
            If disposing AndAlso components IsNot Nothing Then
                components.Dispose()
            End If
        Finally
            MyBase.Dispose(disposing)
        End Try
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> _
    Private Sub InitializeComponent()
        Me.lblSdtDtl = New System.Windows.Forms.Label()
        Me.lblAssDtl = New System.Windows.Forms.Label()
        Me.lblStdNum = New System.Windows.Forms.Label()
        Me.lblStsNme = New System.Windows.Forms.Label()
        Me.lblExam = New System.Windows.Forms.Label()
        Me.lblGpProject = New System.Windows.Forms.Label()
        Me.lblTest = New System.Windows.Forms.Label()
        Me.lblResult = New System.Windows.Forms.Label()
        Me.lblTtlMark = New System.Windows.Forms.Label()
        Me.lblGrd = New System.Windows.Forms.Label()
        Me.txtStudentNumber = New System.Windows.Forms.TextBox()
        Me.txtStudentName = New System.Windows.Forms.TextBox()
        Me.lblQuiz = New System.Windows.Forms.Label()
        Me.txtExamination = New System.Windows.Forms.TextBox()
        Me.txtGroupProject = New System.Windows.Forms.TextBox()
        Me.txtTest = New System.Windows.Forms.TextBox()
        Me.txtQuiz = New System.Windows.Forms.TextBox()
        Me.lblTotalMarks = New System.Windows.Forms.Label()
        Me.lblGrade = New System.Windows.Forms.Label()
        Me.cmdCalculateMark = New System.Windows.Forms.Button()
        Me.btnClear = New System.Windows.Forms.Button()
        Me.btnExit = New System.Windows.Forms.Button()
        Me.SuspendLayout()
        '
        'lblSdtDtl
        '
        Me.lblSdtDtl.AutoSize = True
        Me.lblSdtDtl.Font = New System.Drawing.Font("Microsoft Sans Serif", 11.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblSdtDtl.Location = New System.Drawing.Point(26, 28)
        Me.lblSdtDtl.Name = "lblSdtDtl"
        Me.lblSdtDtl.Size = New System.Drawing.Size(122, 18)
        Me.lblSdtDtl.TabIndex = 0
        Me.lblSdtDtl.Text = "Student Details"
        '
        'lblAssDtl
        '
        Me.lblAssDtl.AutoSize = True
        Me.lblAssDtl.Font = New System.Drawing.Font("Microsoft Sans Serif", 11.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblAssDtl.Location = New System.Drawing.Point(280, 28)
        Me.lblAssDtl.Name = "lblAssDtl"
        Me.lblAssDtl.Size = New System.Drawing.Size(148, 18)
        Me.lblAssDtl.TabIndex = 1
        Me.lblAssDtl.Text = "Assesment Details"
        '
        'lblStdNum
        '
        Me.lblStdNum.AutoSize = True
        Me.lblStdNum.Location = New System.Drawing.Point(26, 63)
        Me.lblStdNum.Name = "lblStdNum"
        Me.lblStdNum.Size = New System.Drawing.Size(90, 13)
        Me.lblStdNum.TabIndex = 2
        Me.lblStdNum.Text = "Student Number :"
        '
        'lblStsNme
        '
        Me.lblStsNme.AutoSize = True
        Me.lblStsNme.Location = New System.Drawing.Point(26, 122)
        Me.lblStsNme.Name = "lblStsNme"
        Me.lblStsNme.Size = New System.Drawing.Size(81, 13)
        Me.lblStsNme.TabIndex = 3
        Me.lblStsNme.Text = "Student Name :"
        '
        'lblExam
        '
        Me.lblExam.AutoSize = True
        Me.lblExam.Location = New System.Drawing.Point(280, 63)
        Me.lblExam.Name = "lblExam"
        Me.lblExam.Size = New System.Drawing.Size(99, 13)
        Me.lblExam.TabIndex = 4
        Me.lblExam.Text = "Examination (50%) :"
        '
        'lblGpProject
        '
        Me.lblGpProject.AutoSize = True
        Me.lblGpProject.Location = New System.Drawing.Point(280, 97)
        Me.lblGpProject.Name = "lblGpProject"
        Me.lblGpProject.Size = New System.Drawing.Size(107, 13)
        Me.lblGpProject.TabIndex = 5
        Me.lblGpProject.Text = "Group Project (25%) :"
        '
        'lblTest
        '
        Me.lblTest.AutoSize = True
        Me.lblTest.Location = New System.Drawing.Point(280, 131)
        Me.lblTest.Name = "lblTest"
        Me.lblTest.Size = New System.Drawing.Size(63, 13)
        Me.lblTest.TabIndex = 6
        Me.lblTest.Text = "Test (15%) :"
        '
        'lblResult
        '
        Me.lblResult.AutoSize = True
        Me.lblResult.Font = New System.Drawing.Font("Microsoft Sans Serif", 12.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblResult.Location = New System.Drawing.Point(37, 202)
        Me.lblResult.Name = "lblResult"
        Me.lblResult.Size = New System.Drawing.Size(79, 20)
        Me.lblResult.TabIndex = 7
        Me.lblResult.Text = "RESULT"
        '
        'lblTtlMark
        '
        Me.lblTtlMark.AutoSize = True
        Me.lblTtlMark.Location = New System.Drawing.Point(42, 243)
        Me.lblTtlMark.Name = "lblTtlMark"
        Me.lblTtlMark.Size = New System.Drawing.Size(106, 13)
        Me.lblTtlMark.TabIndex = 8
        Me.lblTtlMark.Text = "TOTAL MARKS (%) :"
        '
        'lblGrd
        '
        Me.lblGrd.AutoSize = True
        Me.lblGrd.Location = New System.Drawing.Point(301, 243)
        Me.lblGrd.Name = "lblGrd"
        Me.lblGrd.Size = New System.Drawing.Size(54, 13)
        Me.lblGrd.TabIndex = 9
        Me.lblGrd.Text = "GRADE : "
        '
        'txtStudentNumber
        '
        Me.txtStudentNumber.Location = New System.Drawing.Point(29, 79)
        Me.txtStudentNumber.Name = "txtStudentNumber"
        Me.txtStudentNumber.Size = New System.Drawing.Size(195, 20)
        Me.txtStudentNumber.TabIndex = 10
        '
        'txtStudentName
        '
        Me.txtStudentName.Location = New System.Drawing.Point(29, 138)
        Me.txtStudentName.Name = "txtStudentName"
        Me.txtStudentName.Size = New System.Drawing.Size(195, 20)
        Me.txtStudentName.TabIndex = 11
        '
        'lblQuiz
        '
        Me.lblQuiz.AutoSize = True
        Me.lblQuiz.Location = New System.Drawing.Point(280, 162)
        Me.lblQuiz.Name = "lblQuiz"
        Me.lblQuiz.Size = New System.Drawing.Size(63, 13)
        Me.lblQuiz.TabIndex = 12
        Me.lblQuiz.Text = "Quiz (10%) :"
        '
        'txtExamination
        '
        Me.txtExamination.Location = New System.Drawing.Point(401, 60)
        Me.txtExamination.Name = "txtExamination"
        Me.txtExamination.Size = New System.Drawing.Size(69, 20)
        Me.txtExamination.TabIndex = 13
        '
        'txtGroupProject
        '
        Me.txtGroupProject.Location = New System.Drawing.Point(401, 94)
        Me.txtGroupProject.Name = "txtGroupProject"
        Me.txtGroupProject.Size = New System.Drawing.Size(69, 20)
        Me.txtGroupProject.TabIndex = 14
        '
        'txtTest
        '
        Me.txtTest.Location = New System.Drawing.Point(401, 128)
        Me.txtTest.Name = "txtTest"
        Me.txtTest.Size = New System.Drawing.Size(69, 20)
        Me.txtTest.TabIndex = 15
        '
        'txtQuiz
        '
        Me.txtQuiz.Location = New System.Drawing.Point(401, 162)
        Me.txtQuiz.Name = "txtQuiz"
        Me.txtQuiz.Size = New System.Drawing.Size(69, 20)
        Me.txtQuiz.TabIndex = 16
        '
        'lblTotalMarks
        '
        Me.lblTotalMarks.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.lblTotalMarks.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.75!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblTotalMarks.Location = New System.Drawing.Point(154, 233)
        Me.lblTotalMarks.Name = "lblTotalMarks"
        Me.lblTotalMarks.Size = New System.Drawing.Size(100, 32)
        Me.lblTotalMarks.TabIndex = 17
        Me.lblTotalMarks.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
        '
        'lblGrade
        '
        Me.lblGrade.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.lblGrade.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.75!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblGrade.Location = New System.Drawing.Point(352, 233)
        Me.lblGrade.Name = "lblGrade"
        Me.lblGrade.Size = New System.Drawing.Size(100, 32)
        Me.lblGrade.TabIndex = 18
        Me.lblGrade.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
        '
        'cmdCalculateMark
        '
        Me.cmdCalculateMark.AutoSize = True
        Me.cmdCalculateMark.Location = New System.Drawing.Point(73, 321)
        Me.cmdCalculateMark.Name = "cmdCalculateMark"
        Me.cmdCalculateMark.Size = New System.Drawing.Size(88, 23)
        Me.cmdCalculateMark.TabIndex = 19
        Me.cmdCalculateMark.Text = "Calculate Mark"
        Me.cmdCalculateMark.UseVisualStyleBackColor = True
        '
        'btnClear
        '
        Me.btnClear.Location = New System.Drawing.Point(218, 321)
        Me.btnClear.Name = "btnClear"
        Me.btnClear.Size = New System.Drawing.Size(75, 23)
        Me.btnClear.TabIndex = 20
        Me.btnClear.Text = "Clear"
        Me.btnClear.UseVisualStyleBackColor = True
        '
        'btnExit
        '
        Me.btnExit.Location = New System.Drawing.Point(352, 321)
        Me.btnExit.Name = "btnExit"
        Me.btnExit.Size = New System.Drawing.Size(75, 23)
        Me.btnExit.TabIndex = 21
        Me.btnExit.Text = "Exit"
        Me.btnExit.UseVisualStyleBackColor = True
        '
        'Form1
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(498, 370)
        Me.Controls.Add(Me.btnExit)
        Me.Controls.Add(Me.btnClear)
        Me.Controls.Add(Me.cmdCalculateMark)
        Me.Controls.Add(Me.lblGrade)
        Me.Controls.Add(Me.lblTotalMarks)
        Me.Controls.Add(Me.txtQuiz)
        Me.Controls.Add(Me.txtTest)
        Me.Controls.Add(Me.txtGroupProject)
        Me.Controls.Add(Me.txtExamination)
        Me.Controls.Add(Me.lblQuiz)
        Me.Controls.Add(Me.txtStudentName)
        Me.Controls.Add(Me.txtStudentNumber)
        Me.Controls.Add(Me.lblGrd)
        Me.Controls.Add(Me.lblTtlMark)
        Me.Controls.Add(Me.lblResult)
        Me.Controls.Add(Me.lblTest)
        Me.Controls.Add(Me.lblGpProject)
        Me.Controls.Add(Me.lblExam)
        Me.Controls.Add(Me.lblStsNme)
        Me.Controls.Add(Me.lblStdNum)
        Me.Controls.Add(Me.lblAssDtl)
        Me.Controls.Add(Me.lblSdtDtl)
        Me.Name = "Form1"
        Me.Text = "ASSESMENT MARKS"
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub

    Friend WithEvents lblSdtDtl As Label
    Friend WithEvents lblAssDtl As Label
    Friend WithEvents lblStdNum As Label
    Friend WithEvents lblStsNme As Label
    Friend WithEvents lblExam As Label
    Friend WithEvents lblGpProject As Label
    Friend WithEvents lblTest As Label
    Friend WithEvents lblResult As Label
    Friend WithEvents lblTtlMark As Label
    Friend WithEvents lblGrd As Label
    Friend WithEvents txtStudentNumber As TextBox
    Friend WithEvents txtStudentName As TextBox
    Friend WithEvents lblQuiz As Label
    Friend WithEvents txtExamination As TextBox
    Friend WithEvents txtGroupProject As TextBox
    Friend WithEvents txtTest As TextBox
    Friend WithEvents txtQuiz As TextBox
    Friend WithEvents lblTotalMarks As Label
    Friend WithEvents lblGrade As Label
    Friend WithEvents cmdCalculateMark As Button
    Friend WithEvents btnClear As Button
    Friend WithEvents btnExit As Button
End Class
