unit UntFrmPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons,
  System.ImageList, Vcl.ImgList, System.Actions, Vcl.ActnList, Vcl.ComCtrls, JvExStdCtrls, JvRichEdit;

type
  TFrmPrincipal = class(TForm)
    Panel1: TPanel;
    cbbLoteria: TComboBox;
    Label10: TLabel;
    Label8: TLabel;
    edtSorteio: TEdit;
    aclLista: TActionList;
    imlImegns: TImageList;
    actPesquisar: TAction;
    btnPesquisar: TSpeedButton;
    actFechar: TAction;
    btnFechar: TSpeedButton;
    mmoResultado: TJvRichEdit;
    procedure actFecharExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure edtSorteioKeyPress(Sender: TObject; var Key: Char);
    procedure actPesquisarExecute(Sender: TObject);
  private
  public
    procedure AfterConstruction; override;
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.dfm}

uses
  UntExcecao, UntDialogMessage, UntUtil, UntTipo, UntConstante, UntWsCaixaLoteria;

procedure TFrmPrincipal.actFecharExecute(Sender: TObject);
begin
  Close;
end;

procedure TFrmPrincipal.actPesquisarExecute(Sender: TObject);
var
  sAux: String;
  nIndex: Integer;
  WsLoteria: TWsCaixaLoteria;
begin
  try
    mmoResultado.Lines.Clear;
    try
      WsLoteria := TWsCaixaLoteria.FromJsonString(TLoterias(cbbLoteria.ItemIndex), StrToInt(edtSorteio.Text));
      if WsLoteria.Numero > 0 then
      begin
        mmoResultado.Lines.Add('Loteria: ' + LoteriasDesc[TLoterias(cbbLoteria.ItemIndex)]);
        mmoResultado.Lines.Add('Número Concurso Anterior: ' + FormatFloat(',0', WsLoteria.NumeroConcursoAnterior));
        mmoResultado.Lines.Add('Número Concurso Apurado: ' + FormatFloat(',0', WsLoteria.Numero));
        mmoResultado.Lines.Add('Número Próximo Concurso: ' + FormatFloat(',0', WsLoteria.NumeroConcursoProximo));
        mmoResultado.Lines.Add('Acumulado: ' + iif(WsLoteria.Acumulado, 'Sim', 'Não'));
        mmoResultado.Lines.Add('Data Apuração: ' + WsLoteria.DataApuracao);
        mmoResultado.Lines.Add('Data Próximo Concurso: ' + WsLoteria.DataProximoConcurso);
        sAux := EmptyStr;
        for nIndex := 0 to Length(WsLoteria.listaDezenas) - 1 do
          sAux := sAux + iif(nIndex = 0, EmptyStr, ', ') + WsLoteria.listaDezenas[nIndex];
        mmoResultado.Lines.Add('Números sorteados: ' + sAux);
        if Length(WsLoteria.ListaDezenasSegundoSorteio) > 0 then
        begin
          sAux := EmptyStr;
          for nIndex := 0 to Length(WsLoteria.ListaDezenasSegundoSorteio) - 1 do
            sAux := sAux + iif(nIndex = 0, EmptyStr, ', ') + WsLoteria.ListaDezenasSegundoSorteio[nIndex];
          mmoResultado.Lines.Add('Números sorteados segundo sorteio: ' + sAux);
        end;
        sAux := EmptyStr;
        for nIndex := 0 to Length(WsLoteria.dezenasSorteadasOrdemSorteio) - 1 do
          sAux := sAux + iif(nIndex = 0, EmptyStr, ', ') + WsLoteria.dezenasSorteadasOrdemSorteio[nIndex];
        mmoResultado.Lines.Add('Números sorteados em ordem de sorteio: ' + sAux);
        mmoResultado.Lines.Add('Valor Arrecado: ' + FormatFloat('R$ ,0.00', WsLoteria.ValorArrecadado));
        mmoResultado.Lines.Add('Valor Acumulado Concurso Especial: ' + FormatFloat('R$ ,0.00', WsLoteria.ValorAcumuladoConcursoEspecial));
        mmoResultado.Lines.Add('Valor Acumulado Próximo Concurso: ' + FormatFloat('R$ ,0.00', WsLoteria.ValorAcumuladoProximoConcurso));
        mmoResultado.Lines.Add('Valor Estimado Próximo Concurso: ' + FormatFloat('R$ ,0.00', WsLoteria.ValorEstimadoProximoConcurso));
        mmoResultado.Lines.Add('');
        mmoResultado.Lines.Add('Faixas de Premiações');
        for nIndex := 0 to Length(WsLoteria.listaRateioPremio) - 1 do
        begin
          mmoResultado.Lines.Add('Descrição da Faixa: ' + WsLoteria.listaRateioPremio[nIndex].DescricaoFaixa);
          mmoResultado.Lines.Add('Faixa: ' + FormatFloat(',0', WsLoteria.listaRateioPremio[nIndex].Faixa));
          mmoResultado.Lines.Add('Número de Ganhadores: ' + FormatFloat(',0', WsLoteria.listaRateioPremio[nIndex].NumeroDeGanhadores));
          mmoResultado.Lines.Add('Valor do Prêmio: ' + FormatFloat('R$ ,0.00', WsLoteria.listaRateioPremio[nIndex].ValorPremio));
          mmoResultado.Lines.Add('Valor Total Pago: ' + FormatFloat('R$ ,0.00',
                                                     WsLoteria.listaRateioPremio[nIndex].ValorPremio * WsLoteria.listaRateioPremio[nIndex].NumeroDeGanhadores));
          mmoResultado.Lines.Add('');
        end;
      end
      else
        mmoResultado.Lines.Add('Sorteio não localizado!');
    except
      on E : Exception do
        EExcecao.Excecao(Self, E);
    end;
  finally
    FreeAndNil(WsLoteria);
  end;
end;

procedure TFrmPrincipal.AfterConstruction;
var
  sAux: String;
begin
  inherited;
  try
    Caption := Application.Title;
    cbbLoteria.Items.Clear;
    for sAux in LoteriasDesc do
      cbbLoteria.Items.Add(sAux);
    cbbLoteria.ItemIndex := 0;
    mmoResultado.Lines.Clear;
  except
    on E : Exception do
      EExcecao.Excecao(Self, E);
  end;
end;

procedure TFrmPrincipal.edtSorteioKeyPress(Sender: TObject; var Key: Char);
begin
  if not CharInSet(Key, ['0' .. '9', #8, #9, #13]) then
    Key := #0;
end;

procedure TFrmPrincipal.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := ConfirmMessage('Fechar ' + Application.Title + '?');
end;

end.
