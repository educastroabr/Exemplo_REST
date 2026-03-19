program ExemploRest;

uses
  Vcl.Forms,
  UntFrmPrincipal in 'UntFrmPrincipal.pas' {FrmPrincipal},
  UntHttpRequest in 'UntHttpRequest.pas',
  UntTipo in 'UntTipo.pas',
  UntConstante in 'UntConstante.pas',
  UntCustomExcecao in 'UntCustomExcecao.pas',
  UntExcecao in 'UntExcecao.pas',
  UntUtil in 'UntUtil.pas',
  UntEMail in 'UntEMail.pas',
  UntDialogMessage in 'UntDialogMessage.pas',
  UntWsLoterias in 'UntWsLoterias.pas',
  UntWsCaixaLoteria in 'UntWsCaixaLoteria.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Sistema Exemplo REST';
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.Run;
end.
