unit UntWsLoterias;

interface

uses
  System.Classes, System.SysUtils, UntTipo;

type
  TWebLoterias = Class(TObject)
  private
    FLoteria  : TLoterias;
    FConcurso : Integer;
  public
    function Resultado: String; overload;
    function Resultado(PConcurso: Integer): String; overload;
    constructor Create(PLoteria: TLoterias); reintroduce; overload;
    constructor Create(PLoteria: TLoterias; PConcurso: Integer); reintroduce; overload;
  end;

implementation

{ TWebLoterias }

uses
  UntConstante, UntUtil, UntDialogMessage;

constructor TWebLoterias.Create(PLoteria: TLoterias);
begin
  Create(PLoteria, 1);
end;

constructor TWebLoterias.Create(PLoteria: TLoterias; PConcurso: Integer);
begin
  inherited Create;
  FLoteria  := PLoteria;
  FConcurso := PConcurso;
end;

function TWebLoterias.Resultado: String;
begin
  Result := Resultado(FConcurso);
end;

function TWebLoterias.Resultado(PConcurso: Integer): String;
var
  sURL : String;
begin
  Result := EmptyStr;
  try
    sURL := LoteriasHTTP[FLoteria] + iif(PConcurso > 0, PConcurso.ToString, EmptyStr);
    try
      Result := GetUrlContent(sURL);
    except
      on E: Exception do
        ShowErrorMessage( E.Message + #13 + sURL );
    end;
  finally
    FConcurso := 0;
  end;
end;

end.
