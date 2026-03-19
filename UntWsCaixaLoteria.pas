unit UntWsCaixaLoteria;

interface

uses
  System.SysUtils, Generics.Collections, Rest.Json, UntWsLoterias, UntTipo;

type

  TListaRateioPremioClass = Class
  private
    FDescricaoFaixa: String;
    FFaixa: Extended;
    FNumeroDeGanhadores: Extended;
    FValorPremio: Extended;
  public
    property DescricaoFaixa: String read FDescricaoFaixa write FDescricaoFaixa;
    property Faixa: Extended read FFaixa write FFaixa;
    property NumeroDeGanhadores: Extended read FNumeroDeGanhadores write FNumeroDeGanhadores;
    property ValorPremio: Extended read FValorPremio write FValorPremio;
    function ToJsonString: string;
    Class function FromJsonString(AJsonString: string): TListaRateioPremioClass;
  end;

  TListaMunicipioUFGanhadoresClass = Class
  private
    FGanhadores: Extended;
    FMunicipio: String;
    FNomeFatansiaUL: String;
    FPosicao: Extended;
    FSerie: String;
    FUf: String;
  public
    property ganhadores: Extended read FGanhadores write FGanhadores;
    property municipio: String read FMunicipio write FMunicipio;
    property nomeFatansiaUL: String read FNomeFatansiaUL write FNomeFatansiaUL;
    property posicao: Extended read FPosicao write FPosicao;
    property serie: String read FSerie write FSerie;
    property uf: String read FUf write FUf;
    function ToJsonString: string;
    Class function FromJsonString(AJsonString: string): TListaMunicipioUFGanhadoresClass;
  end;

  TWsCaixaLoteria = Class
  private
    FAcumulado: Boolean;
    FDataApuracao: String;
    FDataProximoConcurso: String;
    FDezenasSorteadasOrdemSorteio: TArray<String>;
    FExibirDetalhamentoPorCidade: Boolean;
    FIndicadorConcursoEspecial: Extended;
    FListaDezenas: TArray<String>;
    FListaMunicipioUFGanhadores: TArray<TListaMunicipioUFGanhadoresClass>;
    FListaRateioPremio: TArray<TListaRateioPremioClass>;
    FLocalSorteio: String;
    FNomeMunicipioUFSorteio: String;
    FNomeTimeCoracaoMesSorte: String;
    FNumero: Extended;
    FNumeroConcursoAnterior: Extended;
    FNumeroConcursoFinal_0_5: Extended;
    FNumeroConcursoProximo: Extended;
    FNumeroJogo: Extended;
    FObservacao: String;
    FTipoJogo: String;
    FTipoPublicacao: Extended;
    FUltimoConcurso: Boolean;
    FValorAcumuladoConcursoEspecial: Extended;
    FValorAcumuladoConcurso_0_5: Extended;
    FValorAcumuladoProximoConcurso: Extended;
    FValorArrecadado: Extended;
    FValorEstimadoProximoConcurso: Extended;
    FValorSaldoReservaGarantidora: Extended;
    FValorTotalPremioFaixaUm: Extended;
    FListaDezenasSegundoSorteio: TArray<String>;
  public
    property Acumulado: Boolean read FAcumulado write FAcumulado;
    property DataApuracao: String read FDataApuracao write FDataApuracao;
    property DataProximoConcurso: String read FDataProximoConcurso write FDataProximoConcurso;
    property DezenasSorteadasOrdemSorteio: TArray<String> read FDezenasSorteadasOrdemSorteio write FDezenasSorteadasOrdemSorteio;
    property ListaDezenasSegundoSorteio: TArray<String> read FListaDezenasSegundoSorteio write FListaDezenasSegundoSorteio;
    property ExibirDetalhamentoPorCidade: Boolean read FExibirDetalhamentoPorCidade write FExibirDetalhamentoPorCidade;
    property IndicadorConcursoEspecial: Extended read FIndicadorConcursoEspecial write FIndicadorConcursoEspecial;
    property ListaDezenas: TArray<String> read FListaDezenas write FListaDezenas;
    property ListaMunicipioUFGanhadores: TArray<TListaMunicipioUFGanhadoresClass> read FListaMunicipioUFGanhadores write FListaMunicipioUFGanhadores;
    property ListaRateioPremio: TArray<TListaRateioPremioClass> read FListaRateioPremio write FListaRateioPremio;
    property LocalSorteio: String read FLocalSorteio write FLocalSorteio;
    property NomeMunicipioUFSorteio: String read FNomeMunicipioUFSorteio write FNomeMunicipioUFSorteio;
    property NomeTimeCoracaoMesSorte: String read FNomeTimeCoracaoMesSorte write FNomeTimeCoracaoMesSorte;
    property Numero: Extended read FNumero write FNumero;
    property NumeroConcursoAnterior: Extended read FNumeroConcursoAnterior write FNumeroConcursoAnterior;
    property NumeroConcursoFinal_0_5: Extended read FNumeroConcursoFinal_0_5 write FNumeroConcursoFinal_0_5;
    property NumeroConcursoProximo: Extended read FNumeroConcursoProximo write FNumeroConcursoProximo;
    property NumeroJogo: Extended read FNumeroJogo write FNumeroJogo;
    property Observacao: String read FObservacao write FObservacao;
    property TipoJogo: String read FTipoJogo write FTipoJogo;
    property TipoPublicacao: Extended read FTipoPublicacao write FTipoPublicacao;
    property UltimoConcurso: Boolean read FUltimoConcurso write FUltimoConcurso;
    property ValorAcumuladoConcursoEspecial: Extended read FValorAcumuladoConcursoEspecial write FValorAcumuladoConcursoEspecial;
    property ValorAcumuladoConcurso_0_5: Extended read FValorAcumuladoConcurso_0_5 write FValorAcumuladoConcurso_0_5;
    property ValorAcumuladoProximoConcurso: Extended read FValorAcumuladoProximoConcurso write FValorAcumuladoProximoConcurso;
    property ValorArrecadado: Extended read FValorArrecadado write FValorArrecadado;
    property ValorEstimadoProximoConcurso: Extended read FValorEstimadoProximoConcurso write FValorEstimadoProximoConcurso;
    property ValorSaldoReservaGarantidora: Extended read FValorSaldoReservaGarantidora write FValorSaldoReservaGarantidora;
    property ValorTotalPremioFaixaUm: Extended read FValorTotalPremioFaixaUm write FValorTotalPremioFaixaUm;
    function ToJsonString: string;
    destructor Destroy; override;
    class function FromJsonString(PLoteria: TLoterias): TWsCaixaLoteria; overload;
    class function FromJsonString(PLoteria: TLoterias; PConcurso: Integer): TWsCaixaLoteria; overload;
  end;

implementation

{TListaRateioPremioClass}

uses
  UntDialogMessage;

function TListaRateioPremioClass.ToJsonString: string;
begin
  Result := TJson.ObjectToJsonString(Self);
end;

Class function TListaRateioPremioClass.FromJsonString(AJsonString: string): TListaRateioPremioClass;
begin
  Result := TJson.JsonToObject<TListaRateioPremioClass>(AJsonString)
end;

{TListaMunicipioUFGanhadoresClass}

function TListaMunicipioUFGanhadoresClass.ToJsonString: string;
begin
  Result := TJson.ObjectToJsonString(Self);
end;

Class function TListaMunicipioUFGanhadoresClass.FromJsonString(AJsonString: string): TListaMunicipioUFGanhadoresClass;
begin
  Result := TJson.JsonToObject<TListaMunicipioUFGanhadoresClass>(AJsonString)
end;

{TWsCaixaLoteria}

destructor TWsCaixaLoteria.Destroy;
var
  LlistaMunicipioUFGanhadoresItem: TListaMunicipioUFGanhadoresClass;
  LlistaRateioPremioItem: TListaRateioPremioClass;
begin
 for LlistaMunicipioUFGanhadoresItem in FListaMunicipioUFGanhadores do
   LlistaMunicipioUFGanhadoresItem.Free;
 for LlistaRateioPremioItem in FListaRateioPremio do
   LlistaRateioPremioItem.Free;
  inherited;
end;

function TWsCaixaLoteria.ToJsonString: string;
begin
  Result := TJson.ObjectToJsonString(Self);
end;

class function TWsCaixaLoteria.FromJsonString(PLoteria: TLoterias): TWsCaixaLoteria;
begin
  Result := FromJsonString(PLoteria, 0);
end;

class function TWsCaixaLoteria.FromJsonString(PLoteria: TLoterias; PConcurso: Integer): TWsCaixaLoteria;
var
  sAux : String;
  oLot : TWebLoterias;
begin
  try
    oLot := TWebLoterias.Create(PLoteria);
    sAux := oLot.Resultado(PConcurso);
    try
      Result := TJson.JsonToObject<TWsCaixaLoteria>(sAux);
    except
      Result := TWsCaixaLoteria.Create;
      //on E : Exception do
        //ShowErrorMessage(E.Message);
    end;
  finally
    FreeAndNil(oLot);
  end;
end;

end.
