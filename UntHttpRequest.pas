unit UntHttpRequest;

interface

uses
  System.SysUtils, System.Classes, Winapi.ActiveX, Winapi.WinInet, System.Variants,
  System.Win.ComObj, System.Generics.Collections, UntTipo, UntConstante;

type
  TResponse = class
  private
    FResponseCode: Integer;
    FResponseText: String;
    FHeaders: TDictionary<String, String>;
  public
    destructor  Destroy; override;
    constructor Create;
  published
    property ResponseCode: Integer read FResponseCode write FResponseCode;
    property ResponseText: String read FResponseText write FResponseText;
    property Headers: TDictionary<String, String> read FHeaders write FHeaders;
  end;

type
  THeaders = class
  private
    FHeaders: TDictionary<String, String>;
  public
    function    Add(const Name, Value: String): THeaders;
    function    Remove(const Name: String): THeaders;
    function    Get(const Name: String): String;
    function    Count: Integer;
    function    GetHeaderNames: TArray<String>;
    destructor  Destroy; override;
    constructor Create;
  end;

  THttpRequest = class
  private
    FUrl: String;
    FBody: String;
    FMethod: THttpMethod;
    FHeaders: THeaders;
    FResponse: TResponse;
    FWaitReturn: Boolean;
    FContentType: TContentType;
    function GetResponse: TResponse;
  public
    function    Execute: TResponse;
    destructor  Destroy; override;
    constructor Create; reintroduce; overload;
    constructor Create(PURL : String; PMethod: THttpMethod;
                       PContentType: TContentType; PWaitReturn: Boolean); reintroduce; overload;
  published
    property Headers     : THeaders     read FHeaders;
    property Response    : TResponse    read GetResponse;
    property Url         : String       read FUrl         write FUrl;
    property Body        : String       read FBody        write FBody;
    property Method      : THttpMethod  read FMethod      write FMethod;
    property WaitReturn  : Boolean      read FWaitReturn  write FWaitReturn;
    property ContentType : TContentType read FContentType write FContentType;
  end;

implementation

{ TResponse }

uses
  UntExcecao;

constructor TResponse.Create;
begin
  FHeaders := TDictionary<String, String>.Create;
end;

destructor TResponse.Destroy;
begin
  FHeaders.Free;
  inherited;
end;


{ THeaders }

constructor THeaders.Create;
begin
  FHeaders := TDictionary<String, String>.Create;
end;

destructor THeaders.Destroy;
begin
  FHeaders.Free;
  inherited;
end;

function THeaders.Add(const Name, Value: String): THeaders;
begin
  FHeaders.AddOrSetValue(Name, Value);
  Result  := Self;
end;

function THeaders.Remove(const Name: String): THeaders;
begin
  FHeaders.Remove(Name);
  Result  := Self;
end;

function THeaders.Get(const Name: String): String;
begin
  if FHeaders.ContainsKey(Name) then
    Result  := FHeaders[Name]
  else
    Result  := EmptyStr;
end;

function THeaders.Count: Integer;
begin
  Result := FHeaders.Count;
end;

function THeaders.GetHeaderNames: TArray<String>;
begin
  Result := FHeaders.Keys.ToArray;
end;


{ THttpRequest }

constructor THttpRequest.Create;
begin
  Create(EmptyStr, hmGet, ctNenhum, False);
end;

constructor THttpRequest.Create(PURL : String; PMethod: THttpMethod;
  PContentType: TContentType; PWaitReturn: Boolean);
begin
  inherited Create;
  FHeaders     := THeaders.Create;
  FUrl         := PURL;
  FMethod      := PMethod;
  FBody        := EmptyStr;
  FContentType := PContentType;
  FWaitReturn  := PWaitReturn;
end;

destructor THttpRequest.Destroy;
begin
  if Assigned(FHeaders) then
    FreeAndNil(FHeaders);
  if Assigned(FResponse) then
    FreeAndNil(FResponse);
  inherited;
end;

function THttpRequest.GetResponse: TResponse;
begin
  if Assigned(FResponse) then
    FreeAndNil(FResponse);
  Result := Execute;
end;

function THttpRequest.Execute: TResponse;
var
  nIndex      : Integer;
  Request     : OleVariant;
  Response    : TResponse;
  HeaderLines : TStringList;
  HeaderName,
  HeaderValue : String;
begin
  try
    CoInitialize(Nil);
    if FUrl = EmptyStr then
      Raise Exception.Create('URL não pode ser vazia.');
    Request := CreateOleObject('WinHttp.WinHttpRequest.5.1');
    Request.Open(HttpMethod[FMethod], FUrl, (not FWaitReturn));
    Request.SetRequestHeader('Content-Type', ContentTypeDesc[FContentType]);
    for HeaderName in FHeaders.GetHeaderNames do
      Request.SetRequestHeader(HeaderName, FHeaders.Get(HeaderName));
    Request.Send(FBody);
    if not FWaitReturn then
      Exit;
    Response    := TResponse.Create;
    HeaderLines := TStringList.Create;
    try
      Response.ResponseCode := Request.Status;
      Response.ResponseText := Request.ResponseText;
      try
        HeaderLines.Text := StringReplace(Request.GetAllResponseHeaders, #13#10, #10, [rfReplaceAll]);
        for nIndex := 0 to HeaderLines.Count - 1 do
        begin
          if Pos(': ', HeaderLines[nIndex]) > 0 then
          begin
            HeaderName := Trim(Copy(HeaderLines[nIndex], 1, Pos(':', HeaderLines[nIndex]) - 1));
            HeaderValue := Trim(Copy(HeaderLines[nIndex], Pos(':', HeaderLines[nIndex]) + 2, Length(HeaderLines[nIndex])));
            if Response.Headers.ContainsKey(HeaderName) then
              Response.Headers[HeaderName] := Response.Headers[HeaderName] + ', ' + HeaderValue
            else
              Response.Headers.Add(HeaderName, HeaderValue);
          end;
        end;
      finally
        FreeAndNil(HeaderLines);
      end;
      Result := Response;
    except
      on E : Exception do
      begin
        if Assigned(Response) then
          FreeAndNil(Response);
        EExcecao.Excecao(Self, E);
      end;
    end;
  finally
    Request := Unassigned;
    CoUninitialize;
  end;
end;

end.
