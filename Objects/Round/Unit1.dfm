object Form1: TForm1
  Left = 370
  Top = 173
  Width = 349
  Height = 192
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 8
    Top = 68
    Width = 57
    Height = 13
    Caption = #1602#1610#1605#1577' '#1575#1604#1578#1585#1580#1610#1581
  end
  object Label4: TLabel
    Left = 7
    Top = 20
    Width = 54
    Height = 13
    Caption = #1587#1593#1585' '#1575#1604#1587#1575#1593#1577
  end
  object Label5: TLabel
    Left = 152
    Top = 24
    Width = 109
    Height = 13
    Caption = #1587#1593#1585' '#1575#1604#1587#1575#1593#1577' '#1576#1593#1583' '#1575#1604#1578#1585#1580#1610#1581
  end
  object Edit_Value: TEdit
    Left = 64
    Top = 16
    Width = 73
    Height = 21
    TabOrder = 0
    Text = '12'
    OnChange = Edit_ValueChange
  end
  object Edit_ValueRound: TEdit
    Left = 272
    Top = 16
    Width = 57
    Height = 21
    TabOrder = 1
  end
  object Edit_UnitRound: TEdit
    Left = 72
    Top = 64
    Width = 49
    Height = 21
    TabOrder = 2
    Text = '5'
    OnChange = Edit_UnitRoundChange
  end
  object GroupBox1: TGroupBox
    Left = 136
    Top = 56
    Width = 201
    Height = 89
    Caption = #1605#1587#1578#1608#1609' '#1575#1604#1578#1585#1580#1610#1581
    TabOrder = 3
    object Label1: TLabel
      Left = 27
      Top = 20
      Width = 98
      Height = 13
      Caption = #1571#1583#1582#1604' '#1605#1587#1578#1608#1609' '#1575#1604#1578#1585#1580#1610#1581
    end
    object Label_PercentageMinDisadvantage: TLabel
      Left = 33
      Top = 64
      Width = 96
      Height = 13
      Caption = #1606#1587#1576#1577' '#1605#1587#1578#1608#1609' '#1575#1604#1578#1585#1580#1610#1581
    end
    object Label3: TLabel
      Left = 77
      Top = 44
      Width = 11
      Height = 13
      Caption = #1571#1608
    end
    object Edit_ValueNiveauRound: TEdit
      Left = 145
      Top = 16
      Width = 40
      Height = 21
      TabOrder = 0
      Text = '2.5'
      OnEnter = Edit_ValueNiveauRoundEnter
      OnExit = Edit_ValueNiveauRoundExit
    end
    object Edit_PercentageNiveauRound: TEdit
      Left = 145
      Top = 60
      Width = 27
      Height = 21
      TabOrder = 1
      Text = '50'
      OnEnter = Edit_PercentageNiveauRoundEnter
      OnExit = Edit_PercentageNiveauRoundExit
    end
    object UpDown1: TUpDown
      Left = 172
      Top = 60
      Width = 16
      Height = 21
      Associate = Edit_PercentageNiveauRound
      Position = 50
      TabOrder = 2
    end
  end
end
