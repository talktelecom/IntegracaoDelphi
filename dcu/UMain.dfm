object FormMain: TFormMain
  Left = 1095
  Top = 662
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
  object lblTempo: TLabel
    Left = 32
    Top = 80
    Width = 29
    Height = 13
    Caption = 'tempo'
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
end
