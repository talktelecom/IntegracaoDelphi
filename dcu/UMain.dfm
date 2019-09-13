object FormMain: TFormMain
  Left = 736
  Top = 299
  Width = 517
  Height = 265
  Caption = 'Atendimento'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object lblIntervalo: TLabel
    Left = 16
    Top = 128
    Width = 44
    Height = 13
    Caption = 'Intervalo:'
  end
  object lblChamada: TLabel
    Left = 16
    Top = 104
    Width = 48
    Height = 13
    Caption = 'Chamada:'
  end
  object lblAtendido: TLabel
    Left = 16
    Top = 72
    Width = 45
    Height = 13
    Caption = 'Atendido:'
  end
  object lblNumero: TLabel
    Left = 16
    Top = 49
    Width = 43
    Height = 13
    Caption = 'Numero :'
  end
  object btnLogar: TButton
    Left = 16
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Logar'
    TabOrder = 0
    OnClick = btnLogarClick
  end
  object txtInter: TEdit
    Left = 16
    Top = 152
    Width = 457
    Height = 21
    TabOrder = 1
  end
  object cboIntervalo: TComboBox
    Left = 64
    Top = 120
    Width = 313
    Height = 21
    ItemHeight = 13
    TabOrder = 2
  end
  object btnIntervalo: TButton
    Left = 399
    Top = 120
    Width = 75
    Height = 25
    Caption = 'Intervalo'
    TabOrder = 3
  end
  object Edit1: TEdit
    Left = 64
    Top = 40
    Width = 313
    Height = 21
    TabOrder = 4
  end
  object btnDiscar: TButton
    Left = 399
    Top = 35
    Width = 75
    Height = 25
    Caption = 'Discar'
    TabOrder = 5
    OnClick = btnDiscarClick
  end
end
