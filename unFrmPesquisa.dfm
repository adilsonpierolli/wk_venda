object FrmPesquisa: TFrmPesquisa
  Left = 0
  Top = 0
  Caption = 'FrmPesquisa'
  ClientHeight = 433
  ClientWidth = 667
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object pnTitulo: TPanel
    Left = 0
    Top = 0
    Width = 667
    Height = 41
    Align = alTop
    Color = clSkyBlue
    ParentBackground = False
    TabOrder = 0
    ExplicitLeft = 272
    ExplicitTop = 32
    ExplicitWidth = 185
    object lbTitulo: TLabel
      Left = 100
      Top = 8
      Width = 105
      Height = 23
      Caption = 'CLIENTES'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlue
      Font.Height = -19
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 8
      Top = 9
      Width = 85
      Height = 19
      Caption = 'Pesquisar:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object pnBottom: TPanel
    Left = 0
    Top = 404
    Width = 667
    Height = 29
    Align = alBottom
    Color = clSkyBlue
    ParentBackground = False
    TabOrder = 1
    ExplicitTop = 403
    object btConfirma: TBitBtn
      Left = 587
      Top = 0
      Width = 75
      Height = 31
      Caption = 'Confirma'
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 0
      OnClick = btConfirmaClick
    end
    object btCancelar: TBitBtn
      Left = 509
      Top = 0
      Width = 75
      Height = 30
      Caption = 'Cancelar'
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
      OnClick = btCancelarClick
    end
  end
  object pnDados: TPanel
    Left = 0
    Top = 41
    Width = 667
    Height = 52
    Align = alTop
    Color = 16707288
    ParentBackground = False
    TabOrder = 2
    ExplicitWidth = 778
    object Label1: TLabel
      Left = 8
      Top = 6
      Width = 175
      Height = 13
      Caption = 'Informe Express'#227'o a Pesquisar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object edPesquisa: TEdit
      Left = 8
      Top = 22
      Width = 568
      Height = 21
      TabOrder = 0
    end
    object btConsultar: TBitBtn
      Left = 582
      Top = 16
      Width = 75
      Height = 25
      Caption = 'Consultar'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = btConsultarClick
    end
  end
  object pnGrid: TPanel
    Left = 0
    Top = 93
    Width = 667
    Height = 311
    Align = alClient
    TabOrder = 3
    ExplicitLeft = 8
    ExplicitTop = 88
    ExplicitWidth = 770
    ExplicitHeight = 298
    object dgDados: TDBGrid
      Left = 1
      Top = 1
      Width = 665
      Height = 309
      Align = alClient
      DataSource = dsPesq
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      OnDblClick = dgDadosDblClick
    end
  end
  object FDQryPesq: TFDQuery
    Connection = dmBase.FDConexao
    Left = 272
    Top = 176
  end
  object dsPesq: TDataSource
    DataSet = FDQryPesq
    Left = 264
    Top = 240
  end
end
