Public Class frmMatsRUs

    Const dblStandard As Double = 99
    Const dblDeluxe As Double = 129
    Const dblPremium As Double = 179
    Const dblBlack As Double = 0
    Const dblBlue As Double = 5
    Const dblOther As Double = 10
    Private Sub btnExit_Click(sender As Object, e As EventArgs) Handles btnExit.Click
        Me.Close()
    End Sub

    Private Sub btnCalculate_Click(sender As Object, e As EventArgs) Handles btnCalculate.Click
        Dim dblPrice As Double
        Dim dblAddPrice As Double

        Dim dblSubTotal As Double

        Dim dblTax As Double
        Dim dblTotal As Double

        If radStandard.Checked = True Then
            dblPrice = dblStandard
        ElseIf radDeluxe.Checked = True Then
            dblPrice = dblDeluxe
        ElseIf radPremium.Checked = True Then
            dblPrice = dblPremium
        End If

        If radBlack.Checked = True Then
            dblAddPrice = dblBlack
        ElseIf radBlue.Checked = True Then
            dblAddPrice = dblBlue
        ElseIf radOther.Checked = True Then
            dblAddPrice = dblOther
        End If

        If chkFoldable.Checked = True Then
            dblAddPrice = dblAddPrice + 25
        End If

        dblSubTotal = CalculatePrice(dblPrice, dblAddPrice)
        dblTax = CalculateAdditionalPrice(dblSubTotal)
        dblTotal = dblSubTotal + dblTax

        lblSubTotal.Text = dblSubTotal.ToString("c")
        lblSalesTax.Text = dblTax.ToString("c")
        lblTotalDue.Text = dblTotal.ToString("c")
    End Sub

    Public Function CalculatePrice(ByVal dblPrice As Double, dblAddPrice As Double)
        Dim dblTotal = dblPrice + dblAddPrice
        Return dblTotal
    End Function

    Public Function CalculateAdditionalPrice(ByVal dblPrice)
        Return dblPrice * 0.06
    End Function
End Class
