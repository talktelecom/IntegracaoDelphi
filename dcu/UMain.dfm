object FormMain: TFormMain
  Left = 913
  Top = 865
  Width = 476
  Height = 300
  Caption = 'Atendimento'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lblIntervalo: TLabel
    Left = 17
    Top = 67
    Width = 44
    Height = 13
    Caption = 'Intervalo:'
  end
  object lblChamada: TLabel
    Left = 8
    Top = 214
    Width = 48
    Height = 13
    Caption = 'Chamada:'
  end
  object lblAtendido: TLabel
    Left = 8
    Top = 195
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
  object lblRamal: TLabel
    Left = 16
    Top = 12
    Width = 36
    Height = 13
    Caption = 'Ramal :'
  end
  object lblSenha: TLabel
    Left = 17
    Top = 36
    Width = 37
    Height = 13
    Caption = 'Senha :'
  end
  object lblErro: TLabel
    Left = 8
    Top = 233
    Width = 22
    Height = 13
    Caption = 'Erro:'
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
  object cboIntervalo: TComboBox
    Left = 67
    Top = 64
    Width = 313
    Height = 21
    ItemHeight = 13
    TabOrder = 1
    OnChange = cboIntervaloChange
  end
  object txtNumero: TEdit
    Left = 64
    Top = 107
    Width = 313
    Height = 21
    TabOrder = 2
    OnChange = txtNumeroChange
  end
  object btnDiscar: TButton
    Left = 86
    Top = 134
    Width = 75
    Height = 25
    Caption = 'Discar'
    TabOrder = 3
    OnClick = btnDiscarClick
  end
  object txtRamal: TEdit
    Left = 68
    Top = 8
    Width = 145
    Height = 21
    TabOrder = 4
    Text = '2004'
    OnKeyPress = txtRamalKeyPress
  end
  object txtSenha: TEdit
    Left = 64
    Top = 32
    Width = 145
    Height = 21
    PasswordChar = '*'
    TabOrder = 5
    Text = 'TalkTelecom$@2017'
  end
  object chkInterna: TCheckBox
    Left = 17
    Top = 142
    Width = 59
    Height = 17
    Caption = 'Interna'
    TabOrder = 6
  end
  object btnConsulta: TButton
    Left = 166
    Top = 134
    Width = 75
    Height = 25
    Caption = 'Consultar'
    Enabled = False
    TabOrder = 7
    OnClick = btnConsultaClick
  end
  object btnTransfere: TButton
    Left = 246
    Top = 134
    Width = 75
    Height = 25
    Caption = 'Transfere'
    Enabled = False
    TabOrder = 8
    OnClick = btnTransfereClick
  end
  object btnEspera: TButton
    Left = 326
    Top = 134
    Width = 75
    Height = 25
    Caption = 'Espera'
    Enabled = False
    TabOrder = 9
    OnClick = btnEsperaClick
  end
end
