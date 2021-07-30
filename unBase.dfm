object dmBase: TdmBase
  OldCreateOrder = False
  Height = 344
  Width = 631
  object FDConexao: TFDConnection
    Params.Strings = (
      'Database=wkbase'
      'User_Name=root'
      'DriverID=MySQL')
    LoginPrompt = False
    Left = 64
    Top = 32
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 192
    Top = 32
  end
  object FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink
    VendorLib = 'F:\wamp\bin\mysql\mysql5.7.11\lib\libmysql.dll'
    Left = 328
    Top = 32
  end
  object FDQuery1: TFDQuery
    Connection = FDConexao
    SQL.Strings = (
      'Select  * From CLIENTES')
    Left = 64
    Top = 112
  end
end
