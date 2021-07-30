unit unFrmPesquisa;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  TFrmPesquisa = class(TForm)
    pnTitulo: TPanel;
    pnBottom: TPanel;
    pnDados: TPanel;
    pnGrid: TPanel;
    dgDados: TDBGrid;
    edPesquisa: TEdit;
    btConsultar: TBitBtn;
    Label1: TLabel;
    lbTitulo: TLabel;
    Label2: TLabel;
    FDQryPesq: TFDQuery;
    dsPesq: TDataSource;
    btConfirma: TBitBtn;
    btCancelar: TBitBtn;
    procedure btConsultarClick(Sender: TObject);
    procedure btCancelarClick(Sender: TObject);
    procedure btConfirmaClick(Sender: TObject);
    procedure dgDadosDblClick(Sender: TObject);
  private
    { Private declarations }
    FTabela     :string;
    FCampos     :string;
    FFiltroField:string;
    FFiltroValue:string;

    FFieldRetorno_1:string;
    FFieldRetorno_2:string;

    FValueRetorno_1:string;
    FValueRetorno_2:string;
    procedure Consultar(pTexto:string);

    procedure GetDados;
    function GetValueRetorno_1: string;
    function GetValueRetorno_2: string;
  public
    { Public declarations }
    property Tabela:string             read FTabela           write FTabela;
    property Campos:string             read FCampos           write FCampos;
    property FiltroCampo:string        read FFiltroField      write FFiltroField;
    property FiltroValue:string        read FFiltroValue      write FFiltroValue;
    property SetFieldRetorno_1:string  read FFieldRetorno_1   write FFieldRetorno_1;
    property SetFieldRetorno_2:string  read FFieldRetorno_2   write FFieldRetorno_2;
    property GetFieldValue_1  :string  read GetValueRetorno_1 write FValueRetorno_1;
    property GetFieldValue_2  :string  read GetValueRetorno_2 write FValueRetorno_2;
  end;

var
  FrmPesquisa: TFrmPesquisa;

implementation

uses unBase;

{$R *.dfm}

procedure TFrmPesquisa.btCancelarClick(Sender: TObject);
begin
   FDQryPesq.Close;
   Close;
end;

procedure TFrmPesquisa.btConfirmaClick(Sender: TObject);
begin
   GetDados;
end;

procedure TFrmPesquisa.btConsultarClick(Sender: TObject);
begin
   Consultar(edPesquisa.Text);
end;


procedure TFrmPesquisa.GetDados();
begin
   if Trim(FFieldRetorno_1)<>'' then
      FValueRetorno_1:=FDQryPesq.FieldByName(FFieldRetorno_1).AsString;

   if Trim(FFieldRetorno_2)<>'' then
      FValueRetorno_2:=FDQryPesq.FieldByName(FFieldRetorno_2).AsString;
   Close;
end;


function TFrmPesquisa.GetValueRetorno_1: string;
begin
  Result := FValueRetorno_1;
end;


function TFrmPesquisa.GetValueRetorno_2: string;
begin
  Result := FValueRetorno_2;
end;

procedure TFrmPesquisa.Consultar(pTexto:string);
var
   cSql   :string;
   cFiltro:string;

begin
   cSql:='Select ' + FCampos + ' From ' + FTabela;
   cFiltro:='';

   if FFiltroField<>'' then
      cFiltro:=' Where ' + FFiltroField + ' = ' + FFiltroValue;

   if (Trim(pTexto)='') then
   begin
      cFiltro:='';
      cSql:='Select ' + FCampos + ' From ' + FTabela;
   end;

   if (Trim(pTexto)<>'') And (Trim(pTexto)<>'*') then
   begin
      cFiltro:='';
      cSql:='Select ' + FCampos + ' From ' + FTabela +
            ' Where ' + FFiltroField + ' Like ' + QuotedStr(pTexto+'%');
   end;

   cSql:=cSql + cFiltro;

   FDQryPesq.Close;
   FDQryPesq.Sql.Clear;
   FDQryPesq.Sql.Add(cSql);
   FDQryPesq.Open;
end;

procedure TFrmPesquisa.dgDadosDblClick(Sender: TObject);
begin
   GetDados;

end;

end.
