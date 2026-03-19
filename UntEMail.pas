unit UntEMail;

interface

uses
  Classes, UntDialogMessage, SysUtils, IdSMTP, IdSSLOpenSSL, IdMessage, IdText,
  IdAttachmentFile, IdExplicitTLSClientServerBase;

type
  TProvedor = (pvGmail, pvTerra, pvOffice365);

  TGrupoEmail = (geSuporte, geDesenvolvimento);

  TEmail = class(TComponent)

  private
    function EnviarEmail( PProvedor: TProvedor; PSenha: String; PUsuario: String;
                          PRemetenteNome: String; PRemetenteEmail: String;
                          PDestino: Array of String; PAssunto: String;
                          PCorpoEmail: String; PAnexo: Array of String): Boolean;
  end;

function EnviarEmail( PProvedor: TProvedor; PUsuario: String; PSenha: String;
                      PRemetenteNome: String; PRemetenteEmail: String;
                      PDestino: Array of String; PAssunto: String;
                      PCorpoEmail: String; PAnexo: Array of String): Boolean;

implementation

var
  ProvedorHTTP : Array [TProvedor] of String =
                   ('smtp.gmail.com',
                    'smtp.sao.terra.com.br',
                    'smtp.office365.com');

  ProvedorPorta : Array [TProvedor] of Integer =
                   (465, 587, 587);

function EnviarEmail( PProvedor: TProvedor; PUsuario: String; PSenha: String;
                      PRemetenteNome: String; PRemetenteEmail: String;
                      PDestino: Array of String; PAssunto: String;
                      PCorpoEmail: String; PAnexo: Array of String): Boolean;
var
  oEmail: TEmail;
begin
  Result := False;
  try
    oEmail := TEmail.Create(Nil);
    Result := oEmail.EnviarEmail(PProvedor, PSenha, PUsuario, PRemetenteNome,
                                 PRemetenteEmail, PDestino, PAssunto, PCorpoEmail,
                                 PAnexo);
  finally
    FreeAndNil(oEmail);
  end;
end;

function TEmail.EnviarEmail( PProvedor: TProvedor; PSenha: String; PUsuario: String;
                          PRemetenteNome: String; PRemetenteEmail: String;
                          PDestino: Array of String; PAssunto: String;
                          PCorpoEmail: String; PAnexo: Array of String): Boolean;
var
  IdSMTP: TIdSMTP;
  IdText: TIdText;
  sAnexo: String;
  nIndex: Integer;
  IdMessage: TIdMessage;
  IdSSLIO: TIdSSLIOHandlerSocketOpenSSL;
begin
  Result := True;
  IdSSLIO := TIdSSLIOHandlerSocketOpenSSL.Create(Self);
  IdSMTP := TIdSMTP.Create(Self);
  IdMessage := TIdMessage.Create(Self);
  try
    IdSSLIO.SSLOptions.Method := sslvSSLv23;
    IdSSLIO.PassThrough       := False;
    IdSSLIO.SSLOptions.Mode   := sslmClient;
    case PProvedor of
      pvTerra: {IdSMTP.AuthenticationType := atLogin};
      pvGmail:
        begin
          IdSMTP.IOHandler := IdSSLIO;
          IdSMTP.UseTLS    := utUseImplicitTLS;
          IdSMTP.AuthType  := satDefault;
        end;
      pvOffice365:
        begin
          IdSSLIO.SSLOptions.Method := sslvTLSv1;
          IdSSLIO.PassThrough       := True;
          IdSSLIO.SSLOptions.Mode   := sslmServer;
          IdSMTP.IOHandler          := IdSSLIO;
        end;
    end;
    IdSMTP.Port := ProvedorPorta[PProvedor];
    IdSMTP.Host := ProvedorHTTP[PProvedor];
    IdSMTP.Username := PUsuario;
    IdSMTP.Password := PSenha;
    IdMessage.From.Address := PRemetenteEmail;
    IdMessage.From.Name := PRemetenteNome;
    IdMessage.ReplyTo.EMailAddresses := IdMessage.From.Address;
    for nIndex := 0 to Length(PDestino) - 1 do
      if Trim(PDestino[nIndex]) <> EmptyStr then
        IdMessage.Recipients.Add.Text := PDestino[nIndex];
    IdMessage.Subject := PAssunto;
    IdMessage.Encoding := meMIME;
    IdText := TIdText.Create(IdMessage.MessageParts);
    IdText.Body.Add(PCorpoEmail);
    IdText.ContentType := 'text/plain; charset=iso-8859-1';
    for nIndex := 0 to Length(PAnexo) - 1 do
      if (Trim(PAnexo[nIndex]) <> EmptyStr) and (FileExists(PAnexo[nIndex])) then
        TIdAttachmentFile.Create(IdMessage.MessageParts, PAnexo[nIndex]);
    try
      IdSMTP.Connect;
      IdSMTP.Authenticate;
    except
      on E:Exception do
      begin
        Result := False;
        ShowErrorMessage('Erro na conexo ou autenticao: ' + E.Message);
        Exit;
      end;
    end;
    try
      IdSMTP.Send(IdMessage);
      ShowMessageDialog('Mensagem enviada com sucesso!');
    except
      on E:Exception do
      begin
        Result := False;
        ShowErrorMessage('Erro ao enviar a mensagem: ' + E.Message);
      end;
    end;
  finally
    IdSMTP.Disconnect;
    UnLoadOpenSSLLibrary;
    FreeAndNil(IdMessage);
    FreeAndNil(IdSSLIO);
    FreeAndNil(IdSMTP);
  end;
end;

end.
