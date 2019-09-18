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
    Top = 139
    Width = 44
    Height = 13
    Caption = 'Intervalo:'
  end
  object lblChamada: TLabel
    Left = 48
    Top = 176
    Width = 48
    Height = 13
    Caption = 'Chamada:'
  end
  object lblAtendido: TLabel
    Left = 0
    Top = 176
    Width = 45
    Height = 13
    Caption = 'Atendido:'
  end
  object lblNumero: TLabel
    Left = 16
    Top = 116
    Width = 43
    Height = 13
    Caption = 'Numero :'
  end
  object Label1: TLabel
    Left = 16
    Top = 12
    Width = 36
    Height = 13
    Caption = 'Ramal :'
  end
  object Label2: TLabel
    Left = 17
    Top = 36
    Width = 37
    Height = 13
    Caption = 'Senha :'
  end
  object btnLogar: TButton
    Left = 219
    Top = 25
    Width = 75
    Height = 25
    Caption = 'Logar'
    TabOrder = 0
    OnClick = btnLogarClick
  end
  object txtInter: TEdit
    Left = 0
    Top = 200
    Width = 497
    Height = 21
    TabOrder = 1
  end
  object cboIntervalo: TComboBox
    Left = 64
    Top = 139
    Width = 313
    Height = 21
    ItemHeight = 13
    TabOrder = 2
  end
  object btnIntervalo: TButton
    Left = 399
    Top = 139
    Width = 75
    Height = 25
    Caption = 'Intervalo'
    TabOrder = 3
    OnClick = btnIntervaloClick
  end
  object txtNumero: TEdit
    Left = 64
    Top = 107
    Width = 313
    Height = 21
    TabOrder = 4
  end
  object btnDiscar: TButton
    Left = 399
    Top = 102
    Width = 75
    Height = 25
    Caption = 'Discar'
    TabOrder = 5
    OnClick = btnDiscarClick
  end
  object txtRamal: TEdit
    Left = 64
    Top = 8
    Width = 145
    Height = 21
    TabOrder = 6
    Text = '2004'
    OnKeyPress = txtRamalKeyPress
  end
  object txtSenha: TEdit
    Left = 64
    Top = 32
    Width = 145
    Height = 21
    TabOrder = 7
    Text = 'TalkTelecom$@2017'
  end
end
