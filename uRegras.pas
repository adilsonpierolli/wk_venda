unit uRegras;

interface

uses  System.SysUtils, System.Classes,unBase, FireDAC.Comp.Client;

type
  TProdutoRec = Record
      Codigo   :Integer;
      Descricao:string;
      Valor    :Double;
  end;

type
   TPedido =class
      numeropedido :Integer;
      dataemissao  :TDateTime;
      codigocliente:Integer;
      valortotal   :Double;
    end;


type
   TPedidoProduto =class
      numeropedido :Integer;
      codigproduto :Integer;
      quantidade   :Integer;
      vlrunitario  :Double;
      vlrtotal     :Double;
    end;

function GetProduto(pCodigo: string): TProdutoRec;
function GetCliente(pCodigo: string): string;

procedure GravarPedido(pPedido:TPedido; PedidoProdutos:TFDMemTable);
function GravarItensPedido(pNumeroPedido:string; pPedidoItens:TFDMemTable):Boolean;
function GetGenerator(pTabela: string): Integer;
function CancelarPedido(pNumPedido: string): Boolean;
function ExistePedido(pNumeroPedido:string):Boolean;

procedure CarregarPedidos(pNumeroPedido:string; oPedido:TPedido);
function CarregarPedidoProdutos(pNumeroPedido:string; FDMemItens:TFDMemTable):Boolean;

implementation


function GetCliente(pCodigo: string): string;
var
   QryAux:TFDQuery;
   cSql:string;
begin
   cSql:='Select NOME From CLIENTES Where CODIGO='+pCodigo.Trim;

   QryAux:=TFDQuery.Create(nil);
   QryAux.Connection:=dmBase.FDConexao;
   QryAux.Close;
   QryAux.SQL.Clear;
   QryAux.SQL.Add(cSql);
   QryAux.Open;

   try
      if not QryAux.IsEmpty then
         Result:=QryAux.FieldByName('NOME').AsString
      else
         Result:='-1';
   finally
      QryAux.Close;
      FreeAndNil(QryAux);
   end;

end;


function GetProduto(pCodigo: string): TProdutoRec;
var
   QryAux:TFDQuery;
   cSql:string;
begin
   cSql:='Select CODIGO,DESCRICAO,PRECOVENDA From PRODUTOS Where CODIGO='+pCodigo.Trim;

   QryAux:=TFDQuery.Create(nil);
   QryAux.Connection:=dmBase.FDConexao;
   QryAux.Close;
   QryAux.SQL.Clear;
   QryAux.SQL.Add(cSql);
   QryAux.Open;

   try
      if not QryAux.IsEmpty then
      begin
         Result.Codigo   :=QryAux.FieldByName('CODIGO').AsInteger;
         Result.Descricao:=QryAux.FieldByName('DESCRICAO').AsString;
         Result.Valor    :=QryAux.FieldByName('PRECOVENDA').AsFloat;
      end
      else
      begin
         Result.Codigo   :=-1;
         Result.Descricao:='';
         Result.Valor    :=0;
      end;
   finally
      QryAux.Close;
      FreeAndNil(QryAux);
   end;

end;


procedure GravarPedido(pPedido:TPedido; PedidoProdutos:TFDMemTable);
var
   FQryPed         :TFDQuery;
   cSql            :string;
   cNew            :string;
   cInsert         :string;
   cUpdate         :string;
   cValues         :string;
   cAux1           :string;
   cNumeroPedido   :string;
   cDataEmissao    :string;
   cCodigoCliente  :string;
   cValor          :string;
begin
   cInsert:='Insert into PEDIDOS (numpedido, dataemissao, codigocliente, valortotal)';

   cNumeroPedido :=pPedido.numeropedido.ToString;
   cDataEmissao  :=FormatDateTime('dd.mm.yyyy', pPedido.dataemissao);
   cCodigoCliente:=pPedido.codigocliente.ToString;

   cAux1 :=StringReplace(pPedido.valortotal.ToString,'.','',[rfReplaceAll]);
   cValor:=StringReplace(cAux1,',','.',[rfReplaceAll]);

   cValues := cNumeroPedido            + ',' +
              '"' + cDataEmissao + '"' + ',' +
              cCodigoCliente           + ',' +
              cValor;

   cSql:=cInsert + ' Values (' + cValues + ')';

   try
      if dmBase.FDConexao.Connected then
      begin
         FQryPed:=TFDQuery.Create(nil);
         try
            FQryPed.Connection:=dmBase.FDConexao;
            FQryPed.Close;
            FQryPed.SQL.Clear;
            FQryPed.SQL.Add(cSql);

            try
               dmBase.FDConexao.StartTransaction;
               FQryPed.ExecSQL;
               dmBase.FDConexao.CommitRetaining;
               cNumeroPedido:=pPedido.numeropedido.ToString;

                GravarItensPedido(cNumeroPedido, PedidoProdutos);
            except
               dmBase.FDConexao.RollbackRetaining;
            end;
         finally
            FreeAndNil(FQryPed);
         end;

       end;
    except
      dmBase.FDConexao.RollbackRetaining;
   end;
end;


function GravarItensPedido(pNumeroPedido:string; pPedidoItens:TFDMemTable):Boolean;
var
   FQryItens     :TFDQuery;
   cInsert       :string;
   cUpdate       :string;
   cValues       :string;
   cSql          :string;
   cNumeroPedido :string;
   cCodigoProduto:string;
   cQuantidade   :string;
   cValorUnitario:string;
   cValorTotal   :string;
   sAux          :string;
begin
   Result:=FALSE;
   cInsert:='Insert into pedidos_produtos (numeropedido, codigoproduto, quantidade, valorunitario, valortotal )';

   pPedidoItens.First;

   while not pPedidoItens.Eof  do
   begin
      cNumeroPedido :=pNumeroPedido;
      cCodigoProduto:=pPedidoItens.FieldByName('CODIGO').AsString;
      cQuantidade   :=pPedidoItens.FieldByName('QUANTIDADE').AsString;

      cValorUnitario:=pPedidoItens.FieldByName('VLR_UNITARIO').AsString;
                sAux:=StringReplace(cValorUnitario,'.','',[rfReplaceAll]);
      cValorUnitario:=StringReplace(sAux,',','.',[rfReplaceAll]);

      cValorTotal   :=pPedidoItens.FieldByName('VLR_TOTAL').AsString;
                sAux:=StringReplace(cValorTotal,'.','',[rfReplaceAll]);
      cValorTotal   :=StringReplace(sAux,',','.',[rfReplaceAll]);

      cValues:=cNumeroPedido   + ',' +
                cCodigoProduto + ',' +
                cQuantidade    + ',' +
                cValorUnitario + ',' +
                cValorTotal;

      cSql :=cInsert + ' Values (' + cValues +')';

      FQryItens:=TFDQuery.Create(nil);
      try
         FQryItens.Connection:=dmBase.FDConexao;
         FQryItens.Close;
         FQryItens.SQL.Clear;
         FQryItens.SQL.Add(cSql);

         try
            dmBase.FDConexao.StartTransaction;
            FQryItens.ExecSQL;
            dmBase.FDConexao.CommitRetaining;
            Result:=TRUE;
         except
            dmBase.FDConexao.RollbackRetaining;
            result:=FALSE;
            Break;
         end;
      finally
         FreeAndNil(FQryItens);
      end;

      pPedidoItens.Next;

   end;

end;


function GetGenerator(pTabela: string): Integer;
var
   QryAux :TFDQuery;
   cSql   :string;
   cUpdate:string;
begin
   Result:=-1;

   dmBase.FDConexao.StartTransaction;
   try
      cUpdate:='UPDATE generator_tabela set id_value = id_value + 1 Where  Tabela = '+QuotedStr(pTabela);

      dmBase.FDConexao.ExecSQL(cUpdate);

      dmBase.FDConexao.CommitRetaining;
   except
      dmBase.FDConexao.RollbackRetaining;
   end;

   QryAux:=TFDQuery.Create(nil);
   try
      cSql:='Select id_value From generator_tabela where tabela=' + QuotedStr(pTabela);
      QryAux.Connection:=dmBase.FDConexao;
      QryAux.Close;
      QryAux.SQL.Clear;
      QryAux.SQL.Add(cSql);
      QryAux.Open;
      if not QryAux.IsEmpty then
         Result:=QryAux.FieldByName('id_value').AsInteger;
   finally
      FreeAndNil(QryAux);
   end;
end;


function CancelarPedido(pNumPedido: string): Boolean;
var
   cSql   :string;
begin
   Result:=TRUE;

   dmBase.FDConexao.StartTransaction;
   try
      cSql:='Delete From pedidos_produtos where numeropedido=' + pNumPedido;
      dmBase.FDConexao.ExecSQL(cSql);
      dmBase.FDConexao.CommitRetaining;
   except
      dmBase.FDConexao.RollbackRetaining;
      Result:=FALSE;
      Exit;
   end;

   try
      cSql:='Delete From PEDIDOS where numpedido=' + pNumPedido;
      dmBase.FDConexao.ExecSQL(cSql);
      dmBase.FDConexao.CommitRetaining;
   except
      dmBase.FDConexao.RollbackRetaining;
      Result:=FALSE;
      Exit;
   end;

end;

function ExistePedido(pNumeroPedido:string):Boolean;
var
  QryPed:TFDQuery;
  cSql  :string;
begin
  Result:=FALSE;
  cSql:='Select * From PEDIDOS Where numpedido=' + pNumeroPedido;
  QryPed:=TFDQuery.Create(nil);
  try
     QryPed.Connection:=dmBase.FDConexao;
     QryPed.Close;
     QryPed.SQL.Clear;
     QryPed.SQL.Add(cSql);
     QryPed.Open(cSql);
     if not QryPed.IsEmpty then
        Result:=TRUE;
  finally
     FreeAndNil(QryPed);
  end;

end;


procedure CarregarPedidos(pNumeroPedido:string; oPedido:TPedido);
var
  QryPed:TFDQuery;
  cSql  :string;
begin
  cSql:='Select * From PEDIDOS Where numpedido=' + pNumeroPedido;
  QryPed:=TFDQuery.Create(nil);
  try
     QryPed.Connection:=dmBase.FDConexao;
     QryPed.Close;
     QryPed.SQL.Clear;
     QryPed.SQL.Add(cSql);
     QryPed.Open(cSql);
     if not QryPed.IsEmpty then
     begin
        oPedido.numeropedido :=QryPed.FieldByName('numpedido').AsInteger;
        oPedido.dataemissao  :=QryPed.FieldByName('dataemissao').AsDateTime;
        oPedido.codigocliente:=QryPed.FieldByName('codigocliente').AsInteger;
        oPedido.valortotal   :=QryPed.FieldByName('valortotal').AsFloat;
     end
     else
     begin
        oPedido.numeropedido :=-1;
        oPedido.dataemissao  :=0;
        oPedido.codigocliente:=0;
        oPedido.valortotal   :=0;
     end;
  finally
     FreeAndNil(QryPed);
  end;

end;


function CarregarPedidoProdutos(pNumeroPedido:string; FDMemItens:TFDMemTable):Boolean;
var
  QryItens:TFDQuery;
  cSql    :string;
begin
   Result:=TRUE;

   cSql:='Select P.numeropedido,   '  +
         '       P.codigoproduto,  '  +
         '       P.quantidade,     '  +
         '       P.valorunitario,  '  +
         '       P.valortotal,     '  +
         '       R.Descricao       '  +
         ' From PEDIDOS_PRODUTOS P ' +
         ' inner join PRODUTOS R on (R.codigo=P.codigoproduto) ' +
         ' Where numeropedido=' + pNumeroPedido;

   QryItens:=TFDQuery.Create(nil);
   try
      QryItens.Connection:=dmBase.FDConexao;
      QryItens.Close;
      QryItens.SQL.Clear;
      QryItens.SQL.Add(cSql);
      QryItens.Open(cSql);
      if not QryItens.IsEmpty then
      begin
         if FDMemItens.Active then
            FDMemItens.EmptyDataSet;

         QryItens.First;
         while not QryItens.EOF do
         begin
            FDMemItens.Append;
            FDMemItens.FieldByName('CODIGO').AsInteger     := QryItens.FieldByName('CODIGOPRODUTO').AsInteger;
            FDMemItens.FieldByName('DESCRICAO').AsString   := QryItens.FieldByName('DESCRICAO').AsString;
            FDMemItens.FieldByName('QUANTIDADE').AsInteger := QryItens.FieldByName('QUANTIDADE').AsInteger;
            FDMemItens.FieldByName('VLR_UNITARIO').AsFloat := QryItens.FieldByName('VALORUNITARIO').AsFloat;
            FDMemItens.FieldByName('VLR_TOTAL').AsFloat    := QryItens.FieldByName('VALORTOTAL').AsFloat;
            FDMemItens.Post;
            QryItens.Next;
         end;
      end
      else
      begin
         Result:=FALSE;
      end;
  finally
      FreeAndNil(QryItens);
  end;

end;

end.
