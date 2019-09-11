object FormMain: TFormMain
  Left = 1264
  Top = 527
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
    Left = 32
    Top = 72
    Width = 44
    Height = 13
    Caption = 'Intervalo:'
  end
  object lblChamada: TLabel
    Left = 32
    Top = 96
    Width = 48
    Height = 13
    Caption = 'Chamada:'
  end
  object lblAtendido: TLabel
    Left = 32
    Top = 120
    Width = 45
    Height = 13
    Caption = 'Atendido:'
  end
  object btnLogar: TButton
    Left = 32
    Top = 24
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
    Height = 25
    TabOrder = 1
  end
end
