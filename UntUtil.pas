unit UntUtil;

interface

uses
  SysUtils, untTipo, FireDAC.Comp.Client, DB, System.Classes,
  Vcl.ExtCtrls, Vcl.Graphics;

  /// <summary> Função para retornar valor verdadeiro ou falso de acordo com a condição </summary>
  function  iif(Condicao: Boolean; Verdadeiro, Falso: Variant): Variant;
  /// <summary> Função para retornar apenas número de um texto </summary>
  function  TextoParaNumero(Valor: String): Extended;
  /// <summary> Função para criptografar string </summary>
  function  Crypt(Valor: String): String;
  /// <summary> Função para descriptografar string </summary>
  function  DeCrypt(Valor: String): String;
  /// <summary> Função para retornar a primeira letra maiscula e as demais minuscula </summary>
  function  PrimeiraLetraMaiuscula(Valor: String): String;
  /// <summary> Função para criar ou editar arquivo de Log </summary>
  function  GravarArquivoLog(PObject: TObject; PLog: String): Boolean;
  /// <summary> Função para substituir letra com acento para sem acento </summary>
  function TirarAcento( const PChar : AnsiChar ) : AnsiChar ;
  /// <summary> Função para substituir texto com acento para sem acento </summary>
  function TiraAcentos( const PValor : String ) : String;
  /// <summary> Função para retornar Sigla para TEstadosBR </summary>
  function SiglaParaUF(const PValor : String ) : TEstadosBR;
  /// <summary> Função para retornar Estado para TEstadosBR </summary>
  function EstadoParaUF(const PValor : String ) : TEstadosBR;
  /// <summary> Função para retornar Apenas números de uma String </summary>
  function SoNumeros(const PValor : String ) : String;
  /// <summary> Função para retornar Apenas números e letras de uma String </summary>
  function SoNumerosLetras(const PValor : String ) : String;
  /// <summary> Função para retornar Data e Hora padrão </summary>
  function DataHora: TDateTime; overload;
  /// <summary> Função para retornar Data e Hora Web </summary>
  function DataHora(PServidorDateTime: TServidorDateTime): TDateTime; overload;
  /// <summary> Função para retornar versão da aplicação </summary>
  function VersaoArquivo: String; overload;
  /// <summary> Função para retornar versão de um arquivo </summary>
  function VersaoArquivo(PArquivo: String): String; overload;
  /// <summary> Função para executar comando via linha de comando </summary>
  function CreateProcessSimple(PComando: String): Boolean;
  /// <summary> Função para ordenar vetor em ordem crescente </summary>
  procedure OrdenarArray( var Vetor : Array of Integer );
  /// <summary> Função para validar CPF </summary>
  function ValidarCPF(Valor: String): Boolean;
  /// <summary> Função para validar CNPJ </summary>
  function ValidarCNPJ(Valor: String): Boolean;
  /// <summary> Função para gravar arquivo </summary>
  function GravarArquivo(PArquivo: String; PTexto: String): Boolean;
  /// <summary> Função para gerar e gravar arquivo CSV </summary>
  function GravarCSV(PArquivo: String; PDataSet: TDataSet): Boolean;
  /// <summary> Função para MemoryStream para String </summary>
  function MemoryStreamToString(PMemoryStream: TMemoryStream): String;
  /// <summary> Função para abrir arquivo </summary>
  function AbrirArquivo(PArquivo: String; var PTexto: String): Boolean;
  /// <summary> Função para forçar atualização </summary>
  procedure ForceRepaint(Panel: TPanel);
  /// <summary> Função para retorno de servidor http </summary>
  function GetUrlContent(PURL: String): String;

implementation

uses
  untConstante, untExcecao, UntHttpRequest, UntDialogMessage,
  IdSNTP, Vcl.Forms, Winapi.Windows;

function iif(Condicao: Boolean; Verdadeiro, Falso: Variant): Variant;
begin
  if Condicao then
    Result := Verdadeiro
  else
    Result := Falso;
end;

function TextoParaNumero(Valor: String): Extended;
var
  sAux : String;
  nIndex : Integer;
  bNegativo : Boolean;
begin
  sAux := '0';
  for nIndex := 1 to Length(Valor) do
    if CharInSet(Valor[nIndex], ['0'..'9', FormatSettings.DecimalSeparator, #8, #9, #13]) then
      sAux := sAux + Valor[nIndex];
  bNegativo := False;
  if (Pos('-', Valor) > 0) or ((Pos('(', Valor) > 0) or (Pos(')', Valor) > 0)) then
    bNegativo := True;
  Result := StrToFloat(sAux);
  if bNegativo then
    Result := Result * -1;
end;

function Crypt(Valor: String): String;
var
  sCripto : String;
  nStrPos,
  nStrAsc,
  nPosicao,
  nTamanho,
  nChaveTamanho,
  nChavePosicao : Integer;
begin
  if (Valor = EmptyStr) Then
    sCripto := EmptyStr
  else
  begin
    sCripto := EmptyStr;
    nChaveTamanho := Length(Chave);
    nChavePosicao := 0;
    nTamanho := 256;
    Randomize;
    nPosicao := Random(nTamanho);
    sCripto := Format('%1.2x',[nPosicao]);
    nStrPos := 0;
    repeat
      Inc(nStrPos);
      nStrAsc := (Ord(Valor[nStrPos]) + nPosicao) Mod 255;
      if nChavePosicao < nChaveTamanho then
        nChavePosicao := nChavePosicao + 1
      else
        nChavePosicao := 1;
      nStrAsc := nStrAsc Xor Ord(Chave[nChavePosicao]);
      sCripto := sCripto + Format('%1.2x',[nStrAsc]);
      nPosicao := nStrAsc;
    until nStrPos >= Length(Valor);
  end;
  Result := sCripto;
end;

function DeCrypt(Valor: String): String;
var
  sDecript : String;
  nOffSet,
  nStrPos,
  nStrAsc,
  nTmpStrAsc,
  nChaveTamanho,
  nChavePosicao : Integer;
begin
  if Valor = EmptyStr then
    sDecript := EmptyStr
  else
  begin
    nOffSet       := StrToInt('$'+ Copy(Valor,1,2));
    nStrPos       := 3;
    nChavePosicao := 0;
    nChaveTamanho := Length(Chave);
    repeat
      nStrAsc := StrToInt('$'+ Copy(Valor, nStrPos, 2));
      if (nChavePosicao < nChaveTamanho) Then
        nChavePosicao := nChavePosicao + 1
      else
        nChavePosicao := 1;
      nTmpStrAsc := nStrAsc Xor Ord(Chave[nChavePosicao]);
      if nTmpStrAsc <= nOffSet then
        nTmpStrAsc := 255 + nTmpStrAsc - nOffSet
      else
        nTmpStrAsc := nTmpStrAsc - nOffSet;
      sDecript := sDecript + Chr(nTmpStrAsc);
      nOffSet := nStrAsc;
      nStrPos := nStrPos + 2;
    until (nStrPos >= Length(Valor));
  end;
  Result:= sDecript;
end;

function PrimeiraLetraMaiuscula(Valor: String): String;
var
  nPos : Integer;
  sAux : String;
begin
  Result := EmptyStr;
  if Trim(Valor) <> EmptyStr then
  begin
    nPos := 0;
    sAux := AnsiLowerCase(Trim(Valor));
    repeat
      sAux   := Copy(sAux, nPos + 1, Length(sAux));
      nPos   := Pos(' ', sAux);
      Result := Result +
                AnsiUpperCase(sAux[1]) +
                Copy(sAux, 2, Integer(iif(nPos = 0, Length(sAux), (nPos - 1))));
    until nPos = 0;
  end;
end;

function GravarArquivoLog(PObject: TObject; PLog: String): Boolean;
begin
  Result := True;
end;

function TirarAcento( const PChar : AnsiChar ) : AnsiChar ;
begin
  case Byte(PChar) of
    192..198 : Result := 'A' ;
    199      : Result := 'C' ;
    200..203 : Result := 'E' ;
    204..207 : Result := 'I' ;
    208      : Result := 'D' ;
    209      : Result := 'N' ;
    210..214 : Result := 'O' ;
    215      : Result := 'x' ;
    216,248  : Result := '0' ;
    217..220 : Result := 'U' ;
    221      : Result := 'Y' ;
    222,254  : Result := 'b' ;
    223      : Result := 'B' ;
    224..230 : Result := 'a' ;
    231      : Result := 'c' ;
    232..235 : Result := 'e' ;
    236..239 : Result := 'i' ;
    240,
    242..246 : Result := 'o' ;
    247      : Result := '/';
    241      : Result := 'n' ;
    249..252 : Result := 'u' ;
    253, 255 : Result := 'y' ;
  else
    Result := PChar ;
  end;
end ;

function TiraAcentos( const PValor : String ) : String;
var
  nIndex : Integer ;
  sLetra : AnsiChar ;
  sResultado : AnsiString ;
begin
  Result  := EmptyStr;
  sResultado := EmptyStr;
  For nIndex := 1 to Length( PValor ) do
  begin
     sLetra := TirarAcento( AnsiString(PValor)[nIndex] ) ;
     if not (Byte(sLetra) in [32..126, 8, 9, 10, 13]) then
        sLetra := ' ' ;
     sResultado := sResultado + sLetra ;
  end ;
  Result := String(sResultado);
end ;

function SiglaParaUF(const PValor : String ) : TEstadosBR;
var
  nIndex : Byte;
begin
  Result := esSelecione;
  for nIndex := 0 to Length(EstadosBRSigla) - 1 do
    if EstadosBRSigla[TEstadosBR(nIndex)] = PValor then
      Result := TEstadosBR(nIndex);
end;

function EstadoParaUF(const PValor : String ) : TEstadosBR;
var
  nIndex : Byte;
begin
  Result := esSelecione;
  for nIndex := 0 to Length(EstadosBR) - 1 do
    if EstadosBR[TEstadosBR(nIndex)] = PValor then
      Result := TEstadosBR(nIndex);
end;

function SoNumeros(const PValor : String ) : String;
var
  nIndex : Byte;
begin
  Result := EmptyStr;
  for nIndex := 1 to Length(PValor) do
    if CharInSet(PValor[nIndex], ['0'..'9']) then
      Result := Result + PValor[nIndex];
end;

function SoNumerosLetras(const PValor : String ) : String;
var
  nIndex : Byte;
begin
  Result := EmptyStr;
  for nIndex := 1 to Length(PValor) do
    if CharInSet(PValor[nIndex], ['0'..'9', 'a'..'z', 'A'..'Z']) then
      Result := Result + PValor[nIndex];
end;

function DataHora: TDateTime;
begin
  Result := DataHora(stWindows);
end;

function DataHora(PServidorDateTime: TServidorDateTime): TDateTime;
Var
  SNTP: TIdSNTP;
begin
  try
    SNTP := TIdSNTP.Create(Nil);
    try
      SNTP.Host   := ServidorDateTime[PServidorDateTime];
      SNTP.Active := True;
      Result      := SNTP.DateTime;
    except
      Result := Now;
    end;
  finally
    SNTP.Disconnect;
    FreeAndNil(SNTP);
  end;
end;

function VersaoArquivo: String;
begin
  Result := VersaoArquivo(Application.ExeName);
end;

function VersaoArquivo(PArquivo: String): String;
type
  pFFI = ^VS_FIXEDFILEINFO;
var
  oFFI    : pFFI;
  dwHandle: Cardinal;
  dwLen   : Cardinal;
  szInfo  : Cardinal;
  pchData : PWideChar;
  pchFile : PWideChar;
  ptrBuff : Pointer;
  strFile : string;
begin
  strFile := PArquivo;
  pchFile := StrAlloc(Length(strFile) + 1);
  StrPcopy(pchFile, strFile);
  szInfo := GetFileVersionInfoSize(pchFile, dwHandle);
  Result := EmptyStr;
  if szInfo > 0 then
  begin
    pchData := StrAlloc(szInfo + 1);
    if GetFileVersionInfo(pchFile, dwHandle, szInfo, pchData) then
    begin
      VerQueryValue(pchData, '\', ptrBuff, dwLen);
      oFFI := pFFI(ptrBuff);
      Result := Format('v%d.%d.%d (%.3d) %s', [
          HiWord(oFFI^.dwFileVersionMs),
          LoWord(oFFI^.dwFileVersionMs),
          HiWord(oFFI^.dwFileVersionLs),
          LoWord(oFFI^.dwFileVersionLs),
          {$IFDEF DEBUG} 'Debug'{$ELSE} EmptyStr {$ENDIF}]).Trim;
    end;
    StrDispose(pchData);
  end;
  StrDispose(pchFile);
end;

function CreateProcessSimple(PComando: String): Boolean;
var
  SUInfo: TStartupInfo;
  ProcInfo: TProcessInformation;
begin
  FillChar(SUInfo, SizeOf(SUInfo), #0);
  SUInfo.cb      := SizeOf(SUInfo);
  SUInfo.dwFlags := STARTF_USESHOWWINDOW;
  SUInfo.wShowWindow := SW_HIDE;
  Result := CreateProcess(nil, PChar(PComando), nil, nil, false, CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS, nil, nil, SUInfo, ProcInfo);
  if Result then
  begin
    WaitForSingleObject(ProcInfo.hProcess, INFINITE);
    CloseHandle(ProcInfo.hProcess);
    CloseHandle(ProcInfo.hThread);
  end;
end;

procedure OrdenarArray( var Vetor : Array of Integer );
  procedure OrdenarArray( var Vetor : Array of Integer; PInicio, PTamanho:Integer );
  var nInicio, nTamanho, nMedia, nNumero:Integer;
  begin
    nInicio  :=  PInicio;
    nTamanho :=  PTamanho;
    nMedia   :=  Vetor[(nInicio + nTamanho) div 2];
    repeat
      while ( Vetor[nInicio] < nMedia )  do
        Inc( nInicio );
      while ( Vetor[nTamanho] > nMedia )  do
        Dec( nTamanho );
      if ( nInicio <= nTamanho ) then
      begin
        nNumero := Vetor[nInicio];
        Vetor[nInicio]  :=  Vetor[nTamanho];
        Vetor[nTamanho] :=  nNumero;
        Inc(nInicio);
        Dec(nTamanho);
      end;
    until ( nInicio > nTamanho );
    if ( nTamanho > PInicio ) then
      OrdenarArray( Vetor, PInicio, nTamanho );
    if ( nInicio < PTamanho ) then
      OrdenarArray( Vetor, nInicio, PTamanho );
  end;
begin
  OrdenarArray( Vetor, Low(Vetor), High(Vetor) );
end;

function ValidarCNPJ(Valor: String): Boolean;
var
  D01,D02 : SmallInt;
  sDigitado,
  sCalculado : String;
  N01, N02, N03, N04,
  N05, N06, N07, N08,
  N09, N10, N11, N12: Byte;
begin
  Valor := AnsiUpperCase(Valor);
  if (Length(Valor) < 14) and (Length(SoNumeros(Valor)) = 14) then
    Valor := StringOfChar('0', 14 - Length(Valor));
  if Length(Valor) < 14 then
    raise Exception.Create('CNPJ "' + Valor + '" inválido!');
  if StringOfChar('0', 14) = Valor then
    raise Exception.Create('CNPJ "' + Valor + '" inválido!');
  N01 := Ord(Valor[01]) - 48;
  N02 := Ord(Valor[02]) - 48;
  N03 := Ord(Valor[03]) - 48;
  N04 := Ord(Valor[04]) - 48;
  N05 := Ord(Valor[05]) - 48;
  N06 := Ord(Valor[06]) - 48;
  N07 := Ord(Valor[07]) - 48;
  N08 := Ord(Valor[08]) - 48;
  N09 := Ord(Valor[09]) - 48;
  N10 := Ord(Valor[10]) - 48;
  N11 := Ord(Valor[11]) - 48;
  N12 := Ord(Valor[12]) - 48;
  D01 := N12*2 + N11*3 + N10*4 + N09*5 +
         N08*6 + N07*7 + N06*8 + N05*9 +
         N04*2 + N03*3 + N02*4 + N01*5;
  D01 := 11 - (D01 mod 11);
  if D01 >= 10 then
    D01:=0;
  D02 := D01*2 + N12*3 + N11*4 + N10*5 +
         N09*6 + N08*7 + N07*8 + N06*9 +
         N05*2 + N04*3 + N03*4 + N02*5 + N01*6;
  D02 := 11 - (D02 mod 11);
  if D02 >= 10 then
    D02:=0;
  sCalculado := IntToStr(D01) + IntToStr(D02);
  sDigitado  := Valor[13] + Valor[14];
  Result := (sCalculado = sDigitado);
end;

function ValidarCPF(Valor: String): Boolean;
var
  D01, D02: SmallInt;
  sDigitado,
  sCalculado: String;
  nIndex,
  N01, N02, N03,
  N04, N05, N06,
  N07, N08, N09: Byte;
begin
  if (Length(Valor) < 11) then
    Valor := StringOfChar('0', 11 - Length(Valor));
  if Length(Valor) < 11 then
    raise Exception.Create('CPF "' + Valor + '" inválido!');
  for nIndex := 0 to 9 do
    if StringOfChar(IntToStr(nIndex)[1], 14) = Valor then
      raise Exception.Create('CPF "' + Valor + '" inválido!');
  N01 := StrToInt(Valor[1]);
  N02 := StrToInt(Valor[2]);
  N03 := StrToInt(Valor[3]);
  N04 := StrToInt(Valor[4]);
  N05 := StrToInt(Valor[5]);
  N06 := StrToInt(Valor[6]);
  N07 := StrToInt(Valor[7]);
  N08 := StrToInt(Valor[8]);
  N09 := StrToInt(Valor[9]);
  D01 := N09*2 + N08*3 + N07*4 +
         N06*5 + N05*6 + N04*7 +
         N03*8 + N02*9 + N01*10;
  D01 := 11 - (D01 mod 11);
  if D01 >= 10 then
    D01:=0;
  D02 := D01*2 + N09*3 + N08*4 +
         N07*5 + N06*6 + N05*7 +
         N04*8 + N03*9 + N02*10 +
         N01*11;
  D02 := 11 - (D02 mod 11);
  if D02 >= 10 then
    D02:=0;
  sCalculado := IntToStr(D01) + IntToStr(D02);
  sDigitado  := Valor[10]+Valor[11];
  Result := (sCalculado = sDigitado);
end;

function GravarArquivo(PArquivo: String; PTexto: String): Boolean;
var
  oStream: TStringStream;
begin
  Result := True;
  try
    try
      if not DirectoryExists(ExtractFileDir(PArquivo)) then
        ForceDirectories(ExtractFileDir(PArquivo));
      oStream := TStringStream.Create(PTexto);
      oStream.SaveToFile(PArquivo);
    except
      on E: Exception do
      begin
        Result := False;
        EExcecao.Excecao(Application, E);
      end;
    end;
  finally
    FreeAndNil(oStream)
  end;
end;

function GravarCSV(PArquivo: String; PDataSet: TDataSet): Boolean;
var
  nCount,
  nIndex : Integer;
  sTexto : String;
begin
  Result := True;
  try
    sTexto := EmptyStr;
    PDataSet.First;
    for nCount := 0 to PDataSet.RecordCount - 1 do
    begin
      if nCount = 0 then
      begin
        for nIndex := 0 to PDataSet.Fields.Count - 1 do
        begin
          if nIndex > 0 then
            sTexto := sTexto + ';';
          sTexto := sTexto + PDataSet.Fields[nIndex].DisplayLabel;
        end;
      end;
      sTexto := sTexto + #13;
      for nIndex := 0 to PDataSet.Fields.Count - 1 do
      begin
        if nIndex > 0 then
          sTexto := sTexto + ';';
        sTexto := sTexto + PDataSet.Fields[nIndex].AsString;
      end;
      PDataSet.Next;
    end;
    GravarArquivo(PArquivo, sTexto);
  except
    on E: Exception do
    begin
      Result := False;
      EExcecao.Excecao(Application, E);
    end;
  end;
end;

function MemoryStreamToString(PMemoryStream: TMemoryStream): String;
begin
  SetString(Result, PAnsiChar(PMemoryStream.Memory), PMemoryStream.Size);
end;

function AbrirArquivo(PArquivo: String; var PTexto: String): Boolean;
var
  sTexto : String;
  oMemoryStream: TMemoryStream;
begin
  Result := True;
  try
    try
      oMemoryStream := TMemoryStream.Create;
      if FileExists(PArquivo) then
      begin
        oMemoryStream.LoadFromFile(PArquivo);
        sTexto := MemoryStreamToString(oMemoryStream);
        PTexto := sTexto;
      end;
    except
      on E: Exception do
      begin
        Result := False;
        EExcecao.Excecao(Application, E);
      end;
    end;
  finally
    FreeAndNil(oMemoryStream);
  end;
end;

procedure ForceRepaint(Panel: TPanel);
var
  DC: HDC;
  Cache: Vcl.Graphics.TBitmap;
begin
  Cache := Vcl.Graphics.TBitmap.Create;
  Cache.SetSize(Panel.Width, Panel.Height);
  Cache.Canvas.Lock;
  DC := GetDC(Panel.Handle);
  try
    Panel.PaintTo(Cache.Canvas.Handle, 0, 0);
    BitBlt(DC, 0, 0, Panel.Width, Panel.Height, Cache.Canvas.Handle, 0, 0, SRCCOPY);
  finally
    ReleaseDC(Panel.Handle, DC);
    Cache.Canvas.Unlock;
    Cache.Free;
  end;
end;

function GetUrlContent(PURL: String): String;
var
  HttpRequest : THttpRequest;
begin
  try
    HttpRequest := THttpRequest.Create(PURL, hmGet, ctApplication_json, True);
    try
      Result := HttpRequest.Response.ResponseText;
    except
      on E: Exception do
        ShowErrorMessage('Erro ao realizar a requisição: ' + #13 + E.Message);
    end;
  finally
    FreeAndNil(HttpRequest);
  end;
end;

end.
