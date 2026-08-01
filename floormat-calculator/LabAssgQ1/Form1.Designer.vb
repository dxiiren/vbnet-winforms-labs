<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class frmMatsRUs
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
        Me.lblHeader = New System.Windows.Forms.Label()
        Me.lblType = New System.Windows.Forms.Label()
        Me.radStandard = New System.Windows.Forms.RadioButton()
        Me.chkFoldable = New System.Windows.Forms.CheckBox()
        Me.radDeluxe = New System.Windows.Forms.RadioButton()
        Me.radPremium = New System.Windows.Forms.RadioButton()
        Me.radOther = New System.Windows.Forms.RadioButton()
        Me.radBlue = New System.Windows.Forms.RadioButton()
        Me.radBlack = New System.Windows.Forms.RadioButton()
        Me.lblColor = New System.Windows.Forms.Label()
        Me.lblSub = New System.Windows.Forms.Label()
        Me.lblSales = New System.Windows.Forms.Label()
        Me.lblTotal = New System.Windows.Forms.Label()
        Me.lblSalesTax = New System.Windows.Forms.Label()
        Me.lblSubTotal = New System.Windows.Forms.Label()
        Me.lblTotalDue = New System.Windows.Forms.Label()
        Me.btnCalculate = New System.Windows.Forms.Button()
        Me.btnExit = New System.Windows.Forms.Button()
        Me.Panel1 = New System.Windows.Forms.Panel()
        Me.Panel2 = New System.Windows.Forms.Panel()
        Me.Panel1.SuspendLayout()
        Me.Panel2.SuspendLayout()
        Me.SuspendLayout()
        '
        'lblHeader
        '
        Me.lblHeader.AutoSize = True
        Me.lblHeader.Font = New System.Drawing.Font("Microsoft Sans Serif", 26.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblHeader.Location = New System.Drawing.Point(76, 26)
        Me.lblHeader.Name = "lblHeader"
        Me.lblHeader.Size = New System.Drawing.Size(503, 39)
        Me.lblHeader.TabIndex = 0
        Me.lblHeader.Text = "Branded Floor Mats and Rugs"
        '
        'lblType
        '
        Me.lblType.AutoSize = True
        Me.lblType.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.75!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblType.Location = New System.Drawing.Point(18, 12)
        Me.lblType.Name = "lblType"
        Me.lblType.Size = New System.Drawing.Size(39, 16)
        Me.lblType.TabIndex = 1
        Me.lblType.Text = "Type"
        '
        'radStandard
        '
        Me.radStandard.AutoSize = True
        Me.radStandard.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.radStandard.Location = New System.Drawing.Point(26, 40)
        Me.radStandard.Name = "radStandard"
        Me.radStandard.Size = New System.Drawing.Size(107, 19)
        Me.radStandard.TabIndex = 2
        Me.radStandard.TabStop = True
        Me.radStandard.Text = "Standard ($99)"
        Me.radStandard.UseVisualStyleBackColor = True
        '
        'chkFoldable
        '
        Me.chkFoldable.AutoSize = True
        Me.chkFoldable.Location = New System.Drawing.Point(411, 93)
        Me.chkFoldable.Name = "chkFoldable"
        Me.chkFoldable.Size = New System.Drawing.Size(119, 17)
        Me.chkFoldable.TabIndex = 3
        Me.chkFoldable.Text = "Foldable ($25 extra)"
        Me.chkFoldable.UseVisualStyleBackColor = True
        '
        'radDeluxe
        '
        Me.radDeluxe.AutoSize = True
        Me.radDeluxe.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.radDeluxe.Location = New System.Drawing.Point(26, 65)
        Me.radDeluxe.Name = "radDeluxe"
        Me.radDeluxe.Size = New System.Drawing.Size(103, 19)
        Me.radDeluxe.TabIndex = 4
        Me.radDeluxe.TabStop = True
        Me.radDeluxe.Text = "Deluxe ($129)"
        Me.radDeluxe.UseVisualStyleBackColor = True
        '
        'radPremium
        '
        Me.radPremium.AutoSize = True
        Me.radPremium.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.radPremium.Location = New System.Drawing.Point(26, 90)
        Me.radPremium.Name = "radPremium"
        Me.radPremium.Size = New System.Drawing.Size(115, 19)
        Me.radPremium.TabIndex = 5
        Me.radPremium.TabStop = True
        Me.radPremium.Text = "Premium ($179)"
        Me.radPremium.UseVisualStyleBackColor = True
        '
        'radOther
        '
        Me.radOther.AutoSize = True
        Me.radOther.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.radOther.Location = New System.Drawing.Point(21, 90)
        Me.radOther.Name = "radOther"
        Me.radOther.Size = New System.Drawing.Size(149, 19)
        Me.radOther.TabIndex = 9
        Me.radOther.TabStop = True
        Me.radOther.Text = "Other Color ($10 extra)"
        Me.radOther.UseVisualStyleBackColor = True
        '
        'radBlue
        '
        Me.radBlue.AutoSize = True
        Me.radBlue.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.radBlue.Location = New System.Drawing.Point(21, 65)
        Me.radBlue.Name = "radBlue"
        Me.radBlue.Size = New System.Drawing.Size(105, 19)
        Me.radBlue.TabIndex = 8
        Me.radBlue.TabStop = True
        Me.radBlue.Text = "Blue ($5 extra)"
        Me.radBlue.UseVisualStyleBackColor = True
        '
        'radBlack
        '
        Me.radBlack.AutoSize = True
        Me.radBlack.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.radBlack.Location = New System.Drawing.Point(21, 40)
        Me.radBlack.Name = "radBlack"
        Me.radBlack.Size = New System.Drawing.Size(55, 19)
        Me.radBlack.TabIndex = 7
        Me.radBlack.TabStop = True
        Me.radBlack.Text = "Black"
        Me.radBlack.UseVisualStyleBackColor = True
        '
        'lblColor
        '
        Me.lblColor.AutoSize = True
        Me.lblColor.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.75!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblColor.Location = New System.Drawing.Point(18, 10)
        Me.lblColor.Name = "lblColor"
        Me.lblColor.Size = New System.Drawing.Size(39, 16)
        Me.lblColor.TabIndex = 6
        Me.lblColor.Text = "Color"
        '
        'lblSub
        '
        Me.lblSub.AutoSize = True
        Me.lblSub.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblSub.Location = New System.Drawing.Point(408, 140)
        Me.lblSub.Name = "lblSub"
        Me.lblSub.Size = New System.Drawing.Size(61, 15)
        Me.lblSub.TabIndex = 10
        Me.lblSub.Text = "Subtotal : "
        '
        'lblSales
        '
        Me.lblSales.AutoSize = True
        Me.lblSales.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblSales.Location = New System.Drawing.Point(408, 169)
        Me.lblSales.Name = "lblSales"
        Me.lblSales.Size = New System.Drawing.Size(67, 15)
        Me.lblSales.TabIndex = 11
        Me.lblSales.Text = "Sales Tax :"
        '
        'lblTotal
        '
        Me.lblTotal.AutoSize = True
        Me.lblTotal.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblTotal.Location = New System.Drawing.Point(408, 205)
        Me.lblTotal.Name = "lblTotal"
        Me.lblTotal.Size = New System.Drawing.Size(66, 15)
        Me.lblTotal.TabIndex = 12
        Me.lblTotal.Text = "Total Due :"
        '
        'lblSalesTax
        '
        Me.lblSalesTax.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.lblSalesTax.Location = New System.Drawing.Point(481, 170)
        Me.lblSalesTax.Name = "lblSalesTax"
        Me.lblSalesTax.Size = New System.Drawing.Size(122, 19)
        Me.lblSalesTax.TabIndex = 13
        Me.lblSalesTax.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
        '
        'lblSubTotal
        '
        Me.lblSubTotal.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.lblSubTotal.Location = New System.Drawing.Point(481, 136)
        Me.lblSubTotal.Name = "lblSubTotal"
        Me.lblSubTotal.Size = New System.Drawing.Size(122, 19)
        Me.lblSubTotal.TabIndex = 14
        Me.lblSubTotal.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
        '
        'lblTotalDue
        '
        Me.lblTotalDue.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.lblTotalDue.Location = New System.Drawing.Point(481, 205)
        Me.lblTotalDue.Name = "lblTotalDue"
        Me.lblTotalDue.Size = New System.Drawing.Size(122, 19)
        Me.lblTotalDue.TabIndex = 15
        Me.lblTotalDue.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
        '
        'btnCalculate
        '
        Me.btnCalculate.Location = New System.Drawing.Point(411, 245)
        Me.btnCalculate.Name = "btnCalculate"
        Me.btnCalculate.Size = New System.Drawing.Size(75, 23)
        Me.btnCalculate.TabIndex = 16
        Me.btnCalculate.Text = "Calculate"
        Me.btnCalculate.UseVisualStyleBackColor = True
        '
        'btnExit
        '
        Me.btnExit.Location = New System.Drawing.Point(528, 248)
        Me.btnExit.Name = "btnExit"
        Me.btnExit.Size = New System.Drawing.Size(75, 20)
        Me.btnExit.TabIndex = 17
        Me.btnExit.Text = "Exit"
        Me.btnExit.UseVisualStyleBackColor = True
        '
        'Panel1
        '
        Me.Panel1.Controls.Add(Me.lblType)
        Me.Panel1.Controls.Add(Me.radStandard)
        Me.Panel1.Controls.Add(Me.radPremium)
        Me.Panel1.Controls.Add(Me.radDeluxe)
        Me.Panel1.Location = New System.Drawing.Point(12, 84)
        Me.Panel1.Name = "Panel1"
        Me.Panel1.Size = New System.Drawing.Size(161, 120)
        Me.Panel1.TabIndex = 19
        '
        'Panel2
        '
        Me.Panel2.Controls.Add(Me.lblColor)
        Me.Panel2.Controls.Add(Me.radBlack)
        Me.Panel2.Controls.Add(Me.radBlue)
        Me.Panel2.Controls.Add(Me.radOther)
        Me.Panel2.Location = New System.Drawing.Point(194, 84)
        Me.Panel2.Name = "Panel2"
        Me.Panel2.Size = New System.Drawing.Size(173, 120)
        Me.Panel2.TabIndex = 20
        '
        'frmMatsRUs
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(628, 302)
        Me.Controls.Add(Me.Panel2)
        Me.Controls.Add(Me.Panel1)
        Me.Controls.Add(Me.btnExit)
        Me.Controls.Add(Me.btnCalculate)
        Me.Controls.Add(Me.lblTotalDue)
        Me.Controls.Add(Me.lblSubTotal)
        Me.Controls.Add(Me.lblSalesTax)
        Me.Controls.Add(Me.lblTotal)
        Me.Controls.Add(Me.lblSales)
        Me.Controls.Add(Me.lblSub)
        Me.Controls.Add(Me.chkFoldable)
        Me.Controls.Add(Me.lblHeader)
        Me.Name = "frmMatsRUs"
        Me.Text = "Mats-R-Us"
        Me.Panel1.ResumeLayout(False)
        Me.Panel1.PerformLayout()
        Me.Panel2.ResumeLayout(False)
        Me.Panel2.PerformLayout()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub

    Friend WithEvents lblHeader As Label
    Friend WithEvents lblType As Label
    Friend WithEvents radStandard As RadioButton
    Friend WithEvents chkFoldable As CheckBox
    Friend WithEvents radDeluxe As RadioButton
    Friend WithEvents radPremium As RadioButton
    Friend WithEvents radOther As RadioButton
    Friend WithEvents radBlue As RadioButton
    Friend WithEvents radBlack As RadioButton
    Friend WithEvents lblColor As Label
    Friend WithEvents lblSub As Label
    Friend WithEvents lblSales As Label
    Friend WithEvents lblTotal As Label
    Friend WithEvents lblSalesTax As Label
    Friend WithEvents lblSubTotal As Label
    Friend WithEvents lblTotalDue As Label
    Friend WithEvents btnCalculate As Button
    Friend WithEvents btnExit As Button
    Friend WithEvents Panel1 As Panel
    Friend WithEvents Panel2 As Panel
End Class
