unit unConexao;

interface

uses Data.DB,
     FireDAC.Comp.Client,
     FireDAC.Phys.MySQL,
     FireDAC.Phys.MySQLDef,
     FireDAC.Comp.UI, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
     FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
     FireDAC.Stan.Async,
     FireDAC.Phys,
     FireDAC.VCLUI.Wait;


type
  iModelConexao = interface
    ['{23B13564-CFE2-4B96-9265-AA370634418D}']
    function Connection : TObject;
end;

type
    TModelConexaoFiredac = class (TInterfacedObject, iModelConexao)
    private
        FConexao : TFDConnection;
    public
       constructor Create;
       destructor Destroy; override;
       class function New : iModelConexao;
       function Connection : TObject;
    end;

implementation

{ TModelConexaoFiredac }

function TModelConexaoFiredac.Connection: TObject;
begin
    Result := FConexao;
end;

constructor TModelConexaoFiredac.Create;
begin
    FConexao := TFDConnection.Create(nil);
    FConexao.Params.DriverID := 'MySQL';
    FConexao.Params.Database := 'wkbase';
    FConexao.Params.Add('port=3306');
    FConexao.Params.UserName:='root';
    FConexao.Params.Password:='';
    FConexao.Connected := True;
end;

destructor TModelConexaoFiredac.Destroy;
begin
    FConexao.DisposeOf;
    //FreeAndNil(FConexao);
    inherited;
end;

class function TModelConexaoFiredac.New: iModelConexao;
begin
    Result := Self.Create
end;

end.
