unit UntExcecao;

interface

uses
  Forms, SysUtils, UntCustomExcecao;

type
  TExcecao = Class(TCustomExcecao)
  public
    procedure AfterConstruction; override;
  published
    property Mensagem;
    property UsuarioWin;
    property ArquivoLog;
    property Diretorio;
    property AppNome;
    property DataHora;
    property AppTitulo;
    property AppUsuario;
    property ClasseName;
    property Componente;
    property Formulario;
    property TipoObjeto;
    property TipoExcecao;
    property ErroMessage;
    property ClasseExcecao;
    property ErroConexao;
    property Finalizar;
    property LimiteErro;
    property AtivarLog;
    property AtivarEmail;
    property AtivarExcecao;
    property AtivarMensagem;
    property ExceptionEvent;
  end;

var
  EExcecao: TExcecao;

implementation

{ TExcecao }

procedure TExcecao.AfterConstruction;
begin
  inherited;
  Application.OnException := Excecao;
end;

initialization
  EExcecao := TExcecao.Create(Nil);
  EExcecao.AtivarExcecao := True;
  EExcecao.AtivarMensagem := True;

finalization
  FreeAndNil(EExcecao);

end.
