unit UntCustomExcecao;

interface

uses
  Classes, Dialogs, SysUtils, DateUtils, Forms, Windows, idSNTP,
  UntDialogMessage, UntEMail;

type
  TCustomExcecao = Class(TComponent)
  private
    FDiretorio: String;
    FClasseExcecao: String;
    FDataHora: TDateTime;
    FTipoExcecao: String;
    FErroMessage: String;
    FComponente: String;
    FTipoObjeto: String;
    FFormulario: String;
    FClasseName: String;
    FAppUsuario: String;
    FAppNome: String;
    FErroConexao: Boolean;
    FAppTitulo: String;
    FAtivarEmail: Boolean;
    FAtivarExcecao: Boolean;
    FFinalizar: Boolean;
    FAtivarLog: Boolean;
    FLimiteErro: Integer;
    FAtivarMensagem: Boolean;
    FListaErro: Array of TDateTime;
    FExceptionEvent: TExceptionEvent;
    function GetDiretorio: String;
    function GetUsuarioWin: String;
    function GetArquivoLog: String;
    function GetMensagem: String;
  public
    function  EMail: Boolean; virtual;
    function  GravarLog: Boolean; virtual;
    procedure Excecao(Sender: TObject; E: Exception); overload; virtual;
    procedure Excecao(Sender: TObject; E: Exception; PConsultaSQL: String); overload; virtual;
  published
    property Mensagem       : String          read GetMensagem;
    property UsuarioWin     : String          read GetUsuarioWin;
    property ArquivoLog     : String          read GetArquivoLog;
    property Diretorio      : String          read GetDiretorio      write FDiretorio;
    property AppNome        : String          read FAppNome          write FAppNome;
    property DataHora       : TDateTime       read FDataHora         write FDataHora;
    property AppTitulo      : String          read FAppTitulo        write FAppTitulo;
    property AppUsuario     : String          read FAppUsuario       write FAppUsuario;
    property ClasseName     : String          read FClasseName       write FClasseName;
    property Componente     : String          read FComponente       write FComponente;
    property Formulario     : String          read FFormulario       write FFormulario;
    property TipoObjeto     : String          read FTipoObjeto       write FTipoObjeto;
    property TipoExcecao    : String          read FTipoExcecao      write FTipoExcecao;
    property ErroMessage    : String          read FErroMessage      write FErroMessage;
    property ClasseExcecao  : String          read FClasseExcecao    write FClasseExcecao;
    property ErroConexao    : Boolean         read FErroConexao      write FErroConexao;
    property Finalizar      : Boolean         read FFinalizar        write FFinalizar;
    property LimiteErro     : Integer         read FLimiteErro       write FLimiteErro;
    property AtivarLog      : Boolean         read FAtivarLog        write FAtivarLog;
    property AtivarEmail    : Boolean         read FAtivarEmail      write FAtivarEmail;
    property AtivarExcecao  : Boolean         read FAtivarExcecao    write FAtivarExcecao;
    property AtivarMensagem : Boolean         read FAtivarMensagem   write FAtivarMensagem;
    property ExceptionEvent : TExceptionEvent read FExceptionEvent   write FExceptionEvent;
  end;

implementation

uses
  untUtil, untTipo;

{ TCustomExcecao }

function TCustomExcecao.GravarLog: Boolean;
var
  oArquivoLog : TextFile;
begin
  try
    AssignFile(oArquivoLog, ArquivoLog);
    if FileExists(ArquivoLog) then
      Append(oArquivoLog)
    else
      Rewrite(oArquivoLog);
    Writeln(oArquivoLog, Mensagem);
  finally
    CloseFile(oArquivoLog);
  end;
end;

function TCustomExcecao.EMail: Boolean;
begin
  Result := EnviarEmail(pvGmail, 'usuario', 'Senha', 'Remetente Nome',
                        'Remetente Email', ['Destino1@provedor.com'], 'Assunto',
                        'Corpo Email', ['PAnexo1.doc']);
end;

procedure TCustomExcecao.Excecao(Sender: TObject; E: Exception; PConsultaSQL: String);
var
  dAno, dMes,
  dDia, dHora,
  dMin, dSeg,
  dMSeg  : Word;
  nTempo : Integer;
begin
  try
    FAppNome        := EmptyStr;
    FDataHora       := 0;
    FAppTitulo      := EmptyStr;
    FAppUsuario     := EmptyStr;
    FClasseName     := EmptyStr;
    FComponente     := EmptyStr;
    FFormulario     := EmptyStr;
    FTipoObjeto     := EmptyStr;
    FTipoExcecao    := EmptyStr;
    FErroMessage    := EmptyStr;
    FClasseExcecao  := EmptyStr;
    FErroConexao    := False;
    if FAtivarExcecao then
    begin
      FAppNome        := Application.Name;
      FDataHora       := untUtil.DataHora(stWindows);
      FAppTitulo      := Application.Title;
      FAppUsuario     := EmptyStr;
      if Assigned(Sender) then
      begin
        FClasseName := Sender.ClassName;
        FTipoObjeto := Sender.ClassType.ClassName;
        FFormulario := iif(Sender is TForm, TForm(Sender).Name, EmptyStr);
      end
      else
      begin
        FFormulario := EmptyStr;
        FClasseName := Application.ClassName;
        FTipoObjeto := Application.ClassType.ClassName;
      end;
      if Assigned(Screen.ActiveControl) then
        FComponente := Screen.ActiveControl.Name
      else
        FComponente := EmptyStr;
      FTipoExcecao    := E.ClassType.ClassName;
      if Trim(PConsultaSQL) = EmptyStr then
        FErroMessage    := E.Message
      else
        FErroMessage    := E.Message + #13 + 'Consulta SQL: ' + #13 + PConsultaSQL;
      FClasseExcecao  := E.ClassName;
      if not FErroConexao then
        FErroConexao := (Pos('not connected', AnsiLowerCase(Mensagem)) > 0) or
                        (Pos('connection lost contact', AnsiLowerCase(Mensagem)) > 0);
      if FAtivarLog then
        GravarLog;
      if FAtivarEmail then
        EMail;
      if FAtivarMensagem then
        ShowErrorMessage(Mensagem);
    end;
  finally
    if (LimiteErro >= 0) or (Finalizar) or (FErroConexao) then
    begin
      if FErroConexao then
      begin
        ShowErrorMessage('Não conectado ao banco de dados.' + #13 + 'Aplicação será finalizada!');
        Application.Terminate;
      end
      else if ((Length(FListaErro) > LimiteErro) and (Finalizar)) then
      begin
        ShowErrorMessage('Excedeu o limite de erro, informe ao suporte técnico!');
        Application.Terminate;
      end
      else
      begin
        if Length(FListaErro) > 0 then
        begin
          DecodeDateTime(DataHora - FListaErro[Length(FListaErro) - 1], dAno, dMes, dDia, dHora, dMin, dSeg, dMSeg);
          nTempo := dSeg + (dMin * 60) + (dHora * 60 * 24);
          if nTempo > 2 then
            SetLength(FListaErro, 0)
          else
          begin
            SetLength(FListaErro, Length(FListaErro) + 1);
            FListaErro[Length(FListaErro) - 1] := DataHora;
          end;
        end
        else
        begin
          SetLength(FListaErro, Length(FListaErro) + 1);
          FListaErro[Length(FListaErro) - 1] := DataHora;
        end;
      end;
    end;
  end;
end;

procedure TCustomExcecao.Excecao(Sender: TObject; E: Exception);
begin
  Excecao(Sender, E, EmptyStr);
end;

function TCustomExcecao.GetArquivoLog: String;
begin
  Result := Diretorio + ChangeFileExt(ExtractFileName(ParamStr(0)), '') + '_' +
            FormatDateTime('YYYY_MM_DD', untUtil.DataHora(stWindows)) + '_ERRO.log';
end;

function TCustomExcecao.GetDiretorio: String;
begin
  if (Trim(FDiretorio) <> EmptyStr) and (DirectoryExists(FDiretorio)) then
    Result := FDiretorio
  else if DirectoryExists(GetEnvironmentVariable('tmp')) = True then
    Result := GetEnvironmentVariable('TMP') + '\'
  else if DirectoryExists(GetEnvironmentVariable('temp')) = True then
    Result := GetEnvironmentVariable('TEMP') + '\'
  else
    Result := GetEnvironmentVariable('USERPROFILE') + '\';
  Result := Result + iif(Copy(Result, 1, Length(Result)) = '\', EmptyStr, '\') + Application.Name + ' Log\';
  if not DirectoryExists(Result) then
    ForceDirectories(Result);
end;

function TCustomExcecao.GetMensagem: String;
begin
  Result := EmptyStr;
  if Trim(FAppNome) <> EmptyStr then
    Result := iif(Trim(Result) = EmptyStr, Result, Result + #13) + 'Aplicação: ' + FAppNome;
  if FDataHora > 0 then
    Result := iif(Trim(Result) = EmptyStr, Result, Result + #13) + 'Data e Hora: ' +
              FormatDateTime(FormatSettings.ShortDateFormat + ' ' + FormatSettings.ShortTimeFormat, FDataHora);
  if Trim(FAppTitulo) <> EmptyStr then
    Result := iif(Trim(Result) = EmptyStr, Result, Result + #13) + 'Título: ' + FAppTitulo;
  if Trim(UsuarioWin) <> EmptyStr then
    Result := iif(Trim(Result) = EmptyStr, Result, Result + #13) + 'Usuário Windows: ' + UsuarioWin;
  if Trim(FAppUsuario) <> EmptyStr then
    Result := iif(Trim(Result) = EmptyStr, Result, Result + #13) + 'Usuário Sistema: ' + FAppUsuario;
  if Trim(FClasseName) <> EmptyStr then
    Result := iif(Trim(Result) = EmptyStr, Result, Result + #13) + 'Classe Nome: ' + FClasseName;
  if Trim(FComponente) <> EmptyStr then
    Result := iif(Trim(Result) = EmptyStr, Result, Result + #13) + 'Componente: ' + FComponente;
  if Trim(FFormulario) <> EmptyStr then
    Result := iif(Trim(Result) = EmptyStr, Result, Result + #13) + 'Formulário: ' + FFormulario;
  if Trim(FTipoObjeto) <> EmptyStr then
    Result := iif(Trim(Result) = EmptyStr, Result, Result + #13) + 'Tipo Objeto: ' + FTipoObjeto;
  if Trim(FTipoExcecao) <> EmptyStr then
    Result := iif(Trim(Result) = EmptyStr, Result, Result + #13) + 'Tipo Exceção: ' + FTipoExcecao;
  if Trim(FClasseExcecao) <> EmptyStr then
    Result := iif(Trim(Result) = EmptyStr, Result, Result + #13) + 'Classe Exceção: ' + FClasseExcecao;
  if Trim(FErroMessage) <> EmptyStr then
    Result := iif(Trim(Result) = EmptyStr, Result, Result + #13) + 'Erro: ' + FErroMessage;
  if Trim(Result) <> EmptyStr then
    Result := StringOfChar('*', 80) + #13 + Result + #13 + StringOfChar('*', 80);
end;

function TCustomExcecao.GetUsuarioWin: String;
var
  nIndex: DWord;
  sAuxiliar: String;
begin
  nIndex := 255;
  SetLength(sAuxiliar, nIndex);
  Windows.GetUserName(PChar(sAuxiliar), nIndex);
  sAuxiliar := String(PChar(sAuxiliar));
  Result := Result + sAuxiliar;
end;

end.
