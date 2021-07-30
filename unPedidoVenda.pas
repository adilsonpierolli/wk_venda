unit unPedidoVenda;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons,
  Data.DB, Vcl.Grids, Vcl.DBGrids,
  unConexao, FireDAC.Phys.MySQLDef, FireDAC.Stan.Intf, FireDAC.Phys,
  FireDAC.Phys.MySQL, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.Stan.StorageBin,
  Vcl.ComCtrls, uRegras;

type
  TFrmPedidoVenda = class(TForm)
    pnTop: TPanel;
    pnBottom: TPanel;
    pnCentro: TPanel;
    Label1: TLabel;
    pnDadosPed: TPanel;
    lbVenda: TLabel;
    edVenda: TEdit;
    lbCodCliente: TLabel;
    edCodCliente: TEdit;
    edNome: TEdit;
    sbPesquisaCliente: TSpeedButton;
    pnItens: TPanel;
    lbCodProd: TLabel;
    edCodProduto: TEdit;
    sbPesquisaProduto: TSpeedButton;
    edDescricao: TEdit;
    Label2: TLabel;
    edQuantidade: TEdit;
    Label3: TLabel;
    Label5: TLabel;
    edVlrUnitario: TEdit;
    Label6: TLabel;
    Label4: TLabel;
    edVlrTotal: TEdit;
    Label7: TLabel;
    edTotalPed: TEdit;
    DataSource1: TDataSource;
    FDMemPedido: TFDMemTable;
    dgDados: TDBGrid;
    FDMemPedidoCODIGO: TIntegerField;
    FDMemPedidoDESCRICAO: TStringField;
    FDMemPedidoQUANTIDADE: TIntegerField;
    FDMemPedidoVLR_UNITARIO: TFloatField;
    FDMemPedidoVLR_TOTAL: TFloatField;
    FDMemPedidoTOTALPED: TAggregateField;
    FDMemPedidoTotalInterno: TFloatField;
    Label8: TLabel;
    edDataEmissao: TDateTimePicker;
    pnMenu: TPanel;
    sbNovo: TSpeedButton;
    sbGravarPedido: TSpeedButton;
    lbData: TLabel;
    pnConsulta: TPanel;
    sbCarregaPedido: TSpeedButton;
    sbCancelarPedido: TSpeedButton;
    btAdicionar: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure sbNovoClick(Sender: TObject);
    procedure edCodClienteExit(Sender: TObject);
    procedure edCodProdutoExit(Sender: TObject);
    procedure edQuantidadeChange(Sender: TObject);
    procedure edVlrUnitarioChange(Sender: TObject);
    procedure dgDadosKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FDMemPedidoCalcFields(DataSet: TDataSet);
    procedure sbGravarPedidoClick(Sender: TObject);
    procedure sbCarregaPedidoClick(Sender: TObject);
    procedure edCodClienteChange(Sender: TObject);
    procedure edVlrTotalEnter(Sender: TObject);
    procedure sbPesquisaClienteClick(Sender: TObject);
    procedure btAdicionarClick(Sender: TObject);
    procedure sbPesquisaProdutoClick(Sender: TObject);
    procedure sbCancelarPedidoClick(Sender: TObject);
    procedure edCodClienteKeyPress(Sender: TObject; var Key: Char);
    procedure edCodProdutoKeyPress(Sender: TObject; var Key: Char);
    procedure edQuantidadeKeyPress(Sender: TObject; var Key: Char);
    procedure edVlrUnitarioKeyPress(Sender: TObject; var Key: Char);
    procedure edNomeEnter(Sender: TObject);
  private
    procedure CalcularValor;
    procedure GetTotalPedido;
    function ValidarDadosItens: Boolean;
    function ValidarDadosPedido: Boolean;
    procedure ConsultaCliente;
    procedure AdicionarProduto;
    procedure LimparDadosGerais;
    procedure LimparCampos;
    procedure EnterTabkey(Sender: TObject; var Key: Char);

    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPedidoVenda: TFrmPedidoVenda;

implementation

uses unBase, unFrmPesquisa;

{$R *.dfm}

procedure TFrmPedidoVenda.btAdicionarClick(Sender: TObject);
begin
   if FDMemPedido.State in [dsEdit] then
   begin
      With FDMemPedido do
      begin
         FieldByName('VLR_TOTAL').AsFloat :=FieldByName('QUANTIDADE').AsInteger * FieldByName('VLR_UNITARIO').AsFloat;
      end;

         FDMemPedido.Post;
         dgDados.ReadOnly:=TRUE;
         Exit;
   end;

   if ValidarDadosItens then
   begin
      begin
         AdicionarProduto();
         LimparCampos();
         edCodProduto.SetFocus;
      end;
   end;

end;

procedure TFrmPedidoVenda.AdicionarProduto();
begin
   FDMemPedido.Append;
   FDMemPedido.FieldByName('CODIGO').AsInteger      :=StrToInt(edCodProduto.Text);
   FDMemPedido.FieldByName('DESCRICAO').AsString    :=edDescricao.Text;
   FDMemPedido.FieldByName('QUANTIDADE').AsInteger  :=StrToInt(edQuantidade.Text);
   FDMemPedido.FieldByName('VLR_UNITARIO').AsFloat  :=StrToFloat(edVlrUnitario.Text);
   FDMemPedido.FieldByName('VLR_TOTAL').AsFloat     :=StrToFloat(edVlrTotal.Text);
   FDMemPedido.Post;
end;


function TFrmPedidoVenda.ValidarDadosPedido():Boolean;
begin
   Result:=TRUE;

   if Trim(edCodCliente.Text) = '' then
   begin
      Application.MessageBox('Código Cliente está vazio, Verifique','AVISO',48);
      Result:=FALSE;
      Exit;
   end;

   if FDMemPedido.RecordCount=0 then
   begin
      Application.MessageBox('Produtos do Pedido está vazio, Verifique','AVISO',48);
      Result:=FALSE;
      Exit;
   end;
end;


function TFrmPedidoVenda.ValidarDadosItens():Boolean;
begin
   Result:=TRUE;

   if Trim(edCodProduto.Text) = '' then
   begin
      Application.MessageBox('Código do Produto está vazio, Verifique','AVISO',48);
      Result:=FALSE;
   end;

   if Trim(edQuantidade.Text) = '' then
   begin
      Application.MessageBox('Quantidade  do Produto está vazia, Verifique','AVISO',48);
      Result:=FALSE;
   end;

   if Trim(edVlrUnitario.Text) = '' then
   begin
      Application.MessageBox('Valor Unitário do Produto está vazio, Verifique','AVISO',48);
      Result:=FALSE;
   end;
end;


procedure TFrmPedidoVenda.LimparCampos();
begin
   edCodProduto.Clear;
   edDescricao.Clear;
   edQuantidade.Text :='1';
   edVlrUnitario.Text:='0';
   edVlrTotal.Text   :='0';
end;


procedure TFrmPedidoVenda.LimparDadosGerais();
begin
   edCodCliente.Clear;
   edNome.Clear;
   edVenda.Text      :='0000';
   edDataEmissao.Date:=Now();
   edTotalPed.Text   :='0,00';
   if FDMemPedido.Active then
      FDMemPedido.EmptyDataSet;

end;

procedure TFrmPedidoVenda.edCodClienteChange(Sender: TObject);
begin
   pnConsulta.Visible:= StrToIntDef(edCodCliente.Text, 0) = 0;
   if Trim(edCodCliente.Text)='' then edNome.Clear;

end;


procedure TFrmPedidoVenda.edCodClienteExit(Sender: TObject);
begin
   ConsultaCliente();
end;

procedure TFrmPedidoVenda.edCodClienteKeyPress(Sender: TObject; var Key: Char);
begin
   EnterTabkey(Sender, key);
end;


procedure TFrmPedidoVenda.EnterTabkey(Sender: TObject; var Key: Char);
begin
 If key = #13 then
   Begin
      Key:= #0;
      Perform(Wm_NextDlgCtl,0,0);
   end;
end;


procedure TFrmPedidoVenda.ConsultaCliente();
var
   sRetorno:string;
begin
   If Trim(edCodCliente.Text)<>'' then
   begin
      sRetorno:=GetCliente(edCodCliente.Text);
      edNome.Clear;

      if sRetorno <> '-1' then
         edNome.Text:= sRetorno
      else
         Application.MessageBox('Cliente não Encontrado ou Não existe, Verifique...','AVISO');
   End;
end;


procedure TFrmPedidoVenda.edCodProdutoExit(Sender: TObject);
var
   sRetorno:TProdutoRec;
begin
   If StrToIntDef(edCodProduto.Text,0) > 0 then
   Begin
      sRetorno:=GetProduto(edCodProduto.Text);
      edDescricao.Clear;

      if sRetorno.Codigo <> -1 then
      begin
         edDescricao.Text   := sRetorno.Descricao;
         edVlrUnitario.Text:= sRetorno.Valor.ToString;
         CalcularValor();
         edQuantidade.SetFocus;
      end
      else
         Application.MessageBox('Produto não Encontrado ou Não existe, Verifique...','AVISO',48);
   End;

end;


procedure TFrmPedidoVenda.edCodProdutoKeyPress(Sender: TObject; var Key: Char);
begin
   EnterTabkey(Sender, key);

end;

procedure TFrmPedidoVenda.edNomeEnter(Sender: TObject);
begin
   Perform(Wm_NextDlgCtl,0,0);
end;

procedure TFrmPedidoVenda.edQuantidadeChange(Sender: TObject);
begin
  if edQuantidade.Text<>'' then
     CalcularValor();
end;

procedure TFrmPedidoVenda.edQuantidadeKeyPress(Sender: TObject; var Key: Char);
begin
   EnterTabkey(Sender, key);

end;

procedure TFrmPedidoVenda.edVlrTotalEnter(Sender: TObject);
begin
   btAdicionar.SetFocus;
end;

procedure TFrmPedidoVenda.edVlrUnitarioChange(Sender: TObject);
begin
  if edVlrUnitario.Text<>'' then
     CalcularValor();

end;

procedure TFrmPedidoVenda.edVlrUnitarioKeyPress(Sender: TObject; var Key: Char);
begin
   EnterTabkey(Sender, key);

end;

procedure TFrmPedidoVenda.CalcularValor();
var
   FQuant:Integer;
   FPreco:Double;
   FTotal:Double;
begin
   FQuant:=1;
   FPreco:=0;
   FTotal:=0;

  if edQuantidade.Text<>'' then
     FQuant:=StrToInt(edQuantidade.Text);

  if edVlrUnitario.Text<>'' then
     FPreco:=StrToFloat(edVlrUnitario.Text);

   FTotal:=FQuant * FPreco;

   edVlrTotal.Text:=ftOTAL.ToString;



end;



procedure TFrmPedidoVenda.dgDadosKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
   vRet  :Integer;
   vIndex:integer;
begin
  if (Chr(Key) = #13) then
  begin
     vIndex:= dgDados.SelectedIndex;

     if (vIndex=2) OR (vIndex=3) then
     begin
        dgDados.ReadOnly:=False;
        FDMemPedido.Edit;
     end;
  end;

  if (Chr(Key) = #110) OR (Key=VK_DELETE) then  // Botoes DELETE ou DEL
  begin
     Key:=0;
     vRet:= Application.MessageBox('Deseja Apagar o Registro','AVISO',MB_ICONHAND + MB_YESNO + MB_ICONEXCLAMATION);

     if vRet=6 then
        FDMemPedido.Delete;

  end;

end;

procedure TFrmPedidoVenda.GetTotalPedido();
begin
   edTotalPed.Text:=FDMemPedido.FieldByName('TOTALPED').AsString;
end;

procedure TFrmPedidoVenda.FDMemPedidoCalcFields(DataSet: TDataSet);
begin

   With DataSet do
   begin
      FieldByName('TotalInterno').AsFloat :=FieldByName('QUANTIDADE').AsInteger * FieldByName('VLR_UNITARIO').AsFloat;
   end;

   edTotalPed.Text:=FDMemPedido.FieldByName('TOTALPED').AsString;

end;

procedure TFrmPedidoVenda.FormShow(Sender: TObject);
begin
  lbData.Caption:=FormatDateTime('dd/mm/yyyy',Now());
  FDMemPedido.CreateDataSet;
  pnCentro.Enabled:=FALSE;
end;


procedure TFrmPedidoVenda.sbCancelarPedidoClick(Sender: TObject);
var
   sNumeroPedido:string;
   iNumero      :Integer;
begin
   sNumeroPedido:='';
   sbCarregaPedido.Enabled:=FALSE;

   iNumero:=0;
   InputQuery('Informe Número Pedido para Cancelar','Informe Número Pedido', sNumeroPedido);
   if sNumeroPedido<>'' then
   begin
      if TryStrToInt(sNumeroPedido,iNumero) then
      begin
         if ExistePedido(sNumeroPedido) then
         begin
            if CancelarPedido(sNumeroPedido) then
               Application.MessageBox('Pedido foi Cancelado','AVISO',48)
            else
               Application.MessageBox('Atenção Erro ao Cancelar o Pedido','AVISO',48)
         end
         else
               Application.MessageBox('Atenção Pedido Não Existe, Verifique !','AVISO',48)
      end
      else
         Application.MessageBox('Informe Somente Números','AVISO',48);
   end;
end;


procedure TFrmPedidoVenda.sbCarregaPedidoClick(Sender: TObject);
var
   sNumeroPedido:string;
   iNumero      :Integer;
   FPedido      :TPedido;
begin
   sNumeroPedido:='';
   sbGravarPedido.Enabled:=FALSE;
   InputQuery('Consultar Pedido','Informe Número Pedido', sNumeroPedido);
   if sNumeroPedido<>'' then
   begin
      if TryStrToInt(sNumeroPedido,iNumero) then
      begin
         pnCentro.Enabled:=TRUE;
         FPedido:=TPedido.Create;
         try
            CarregarPedidos(sNumeroPedido, FPedido );
            if FPedido.numeropedido <>-1 then
            begin
               edCodCliente.Text     :=FPedido.codigocliente.ToString;
               edDataEmissao.DateTime:=FPedido.dataemissao;
               edTotalPed.Text       :=FPedido.valortotal.ToString;
               edVenda.Text          :=sNumeroPedido;
               ConsultaCliente();
               CarregarPedidoProdutos(sNumeroPedido, FDMemPedido);
            end
            else
               Application.MessageBox('Pedido não Encontrado, Verifique','AVISO',48);
         finally
            FreeAndNil(FPedido);
         end;
      end
      else
         Application.MessageBox('Informe Somente Números','AVISO',48);
   end;
end;


procedure TFrmPedidoVenda.sbNovoClick(Sender: TObject);
var
   iNumeroPedido:Integer;
begin

   pnCentro.Enabled:=TRUE;
   LimparDadosGerais();
   LimparCampos();

   if FDMemPedido.Active then
      FDMemPedido.EmptyDataSet;

   sbGravarPedido.Enabled:=TRUE;

   iNumeroPedido:=GetGenerator('PEDIDO');
   edVenda.Text:=Format('%4.4d',[iNumeroPedido]);
   edCodCliente.SetFocus;

end;

procedure TFrmPedidoVenda.sbPesquisaClienteClick(Sender: TObject);
begin
   if FrmPesquisa=nil then
      FrmPesquisa:=TFrmPesquisa.Create(Self);

   FrmPesquisa.Tabela           :='CLIENTES';
   FrmPesquisa.Campos           :='CODIGO,NOME';
   FrmPesquisa.FiltroCampo      :='NOME';
   FrmPesquisa.SetFieldRetorno_1:='CODIGO';
   FrmPesquisa.SetFieldRetorno_2:='NOME';
   FrmPesquisa.ShowModal;
   edCodCliente.Text:=FrmPesquisa.GetFieldValue_1;
   edNome.Text      :=FrmPesquisa.GetFieldValue_2;
   FreeAndNil(FrmPesquisa);
end;

procedure TFrmPedidoVenda.sbPesquisaProdutoClick(Sender: TObject);
begin
   if FrmPesquisa=nil then
      FrmPesquisa:=TFrmPesquisa.Create(Self);

   FrmPesquisa.Tabela           :='PRODUTOS';
   FrmPesquisa.Campos           :='CODIGO,DESCRICAO';
   FrmPesquisa.FiltroCampo      :='DESCRICAO';
   FrmPesquisa.SetFieldRetorno_1:='CODIGO';
   FrmPesquisa.SetFieldRetorno_2:='DESCRICAO';
   FrmPesquisa.ShowModal;
   edCodProduto.Text:=FrmPesquisa.GetFieldValue_1;
   edDescricao.Text :=FrmPesquisa.GetFieldValue_2;
   FreeAndNil(FrmPesquisa);

end;

procedure TFrmPedidoVenda.sbGravarPedidoClick(Sender: TObject);
var
   cSql   :string;
   cInsert:string;
   cValues:string;
   oPedido:TPedido;
begin
   if ValidarDadosPedido then
   begin
      oPedido:=TPedido.Create;
      try
         oPedido.numeropedido :=StrToInt(edVenda.Text);
         oPedido.dataemissao  :=edDataEmissao.Date;
         oPedido.codigocliente:=StrToInt(Trim(edCodCliente.Text));
         oPedido.valortotal   :=StrToFloat(edTotalPed.Text);
         try
            GravarPedido(oPedido, FDMemPedido);
            LimparDadosGerais();
            sbGravarPedido.Enabled:=FALSE;
            pnCentro.Enabled:=FALSE;
            Application.MessageBox('Pedido Gravado com Sucesso','AVISO',48);
         except
            Application.MessageBox('Atenção ERRO ao Gravar o Pedido !','AVISO',48);
         end;
      finally
         FreeAndNil(oPedido);
      end;
   end;
end;

end.
