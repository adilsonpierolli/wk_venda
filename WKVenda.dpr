program WKVenda;

uses
  Vcl.Forms,
  unPedidoVenda in 'unPedidoVenda.pas' {FrmPedidoVenda},
  unConexao in 'unConexao.pas',
  unBase in 'unBase.pas' {dmBase: TDataModule},
  uRegras in 'uRegras.pas',
  unListaPedidoProdutos in 'unListaPedidoProdutos.pas',
  unFrmPesquisa in 'unFrmPesquisa.pas' {FrmPesquisa};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TdmBase, dmBase);
  Application.CreateForm(TFrmPedidoVenda, FrmPedidoVenda);
  Application.Run;
end.
