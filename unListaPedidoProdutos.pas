unit unListaPedidoProdutos;

interface

uses Classes, uRegras, Dialogs;

Type
  TListaPedidoProdutos = class
  private
    { private declarations }
    FListaPedidoProduto: TList;
  protected
    { protected declarations }
  public
    { public declarations }
    constructor Create;
    procedure Adicionar(pPedidoProduto: TPedidoProduto);
    procedure Remover(Index: Integer);
    function Count: Integer;
  published
    { published declarations }
  end;

implementation

{ TListaPedidoProdutos }

procedure TListaPedidoProdutos.Adicionar(pPedidoProduto: TPedidoProduto);
begin
   FListaPedidoProduto.Add(pPedidoProduto);
end;

function TListaPedidoProdutos.Count: Integer;
begin
   Result := FListaPedidoProduto.Count;
end;

constructor TListaPedidoProdutos.Create;
begin
   FListaPedidoProduto := TList.Create;
end;

procedure TListaPedidoProdutos.Remover(Index: Integer);
begin
   if Index < Count then
      FListaPedidoProduto.Delete(Index)
   else
       ShowMessage('Item não encontrado!');
end;

end.

