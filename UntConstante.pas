unit UntConstante;

interface

uses
  untTipo, Vcl.Graphics;

const
  Chave = 'Definir Chave';
  EmptyDate = 0;
  IgnoreTag = 999;
  EmptyNumber = -1;
  AndOrDesc : Array [TAndOr] of String = (' And ', ' Or ');
  LicencaDesc : Array [TLicenca] of String = ('Básico', 'Intermediário', 'Avançado');
  OperacaoDesc : Array [TOperacao] of String = (' = ', ' > ', ' < ', ' >= ', ' <= ', ' Between ', ' LIKE ');
  OperadorDesc : Array [TOperador] of String = ('Normal', 'Inserir', 'Alterar', 'Excluir');
  ForcaSenhaDesc : Array [TForcaSenha] of String = ('Nenhuma', 'Baixa', 'Fraca', 'Média', 'Alta', 'Excelente');
  ForcaSenhaTeclas : Array [TForcaSenha] of String = ('Nenhuma',
                           'Letra minúscula (abc...)', 'Letra maiúscula (ABC...)',
                           'Número (123...)', '8 caracteres', 'Caráter especial (@#$...)');
  ForcaSenhaColor : Array [TForcaSenha] of TColor = (clNone, clMaroon, clRed, clAqua, clBlue, clNavy);
  BancoDadosDesc : Array [TBancoDados] of String = ('<(selecione)>',
                    'MySql', 'SQLite', 'Oracle', 'MSSql', 'FireBird', 'InterBase', 'Postgre SQL',
                    'DB2', 'ASA', 'ADS', 'Nexus', 'DS', 'Informix', 'MS Access', 'Outro');
  BancoDadosDriverID : Array [TBancoDados] of String = ('<(selecione)>',
                          'MySql', 'SQLite', 'Ora', 'MSSql', 'FB', 'IB', 'PG',
                          'DB2', 'ASA', 'ADS', 'Nexus', 'DS', 'Infx', 'MSAcc', 'ODBC');
  EstadosBR : Array [TEstadosBR] of String = (
                    'Selecione', 'Acre', 'Alagoas', 'Amapá', 'Amazonas', 'Bahia',
                    'Ceará', 'Espírito Santo', 'Goiás', 'Maranhão', 'Mato Grosso',
                    'Mato Grosso do Sul', 'Minas Gerais', 'Pará', 'Paraíba', 'Paraná',
                    'Pernambuco', 'Piauí', 'Rio de Janeiro', 'Rio Grande do Norte',
                    'Rio Grande do Sul', 'Rondônia', 'Roraima', 'Santa Catarina',
                    'São Paulo', 'Sergipe', 'Tocantins', 'Distrito Federal');
  EstadosBRCapitais : Array [TEstadosBR] of String = (
                    'Selecione', 'Rio Branco', 'Maceió', 'Macapá', 'Manaus', 'Salvador',
                    'Fortaleza', 'Vitória', 'Goiânia', 'São Luís', 'Cuiabá', 'Campo Grande',
                    'Belo Horizonte', 'Belém', 'João Pessoa', 'Curitiba', 'Recife',
                    'Teresina', 'Rio de Janeiro', 'Natal', 'Porto Alegre', 'Porto Velho',
                    'Boa Vista', 'Florianópolis', 'São Paulo', 'Aracaju', 'Palmas', 'Brasília' );
  EstadosBRSigla : Array [TEstadosBR] of String = (
                           'Selecione', 'AC', 'AL', 'AP', 'AM', 'BA', 'CE', 'ES', 'GO',
                           'MA', 'MT', 'MS', 'MG', 'PA', 'PB', 'PR', 'PE', 'PI', 'RJ',
                           'RN', 'RS', 'RO', 'RR', 'SC', 'SP', 'SE', 'TO', 'DF');
  ServidorDateTime : Array [TServidorDateTime] of String = ('time.windows.com', 'pool.ntp.br',
                                            'time.cloudflare.com', 'gps.jd.ntp.br',
                                            'a.st1.ntp.br', 'c.st1.ntp.br',
                                            'd.st1.ntp.br', 'a.ntp.br', 'b.ntp.br', 'c.ntp.br',
                                            'gps.ntp.br');
  LoteriasHTTP : Array [TLoterias] of String = (
    'https://servicebus2.caixa.gov.br/portaldeloterias/api/quina/',
    'https://servicebus2.caixa.gov.br/portaldeloterias/api/loteca/',
    'https://servicebus2.caixa.gov.br/portaldeloterias/api/federal/',
    'https://servicebus2.caixa.gov.br/portaldeloterias/api/megasena/',
    'https://servicebus2.caixa.gov.br/portaldeloterias/api/supersete/',
    'https://servicebus2.caixa.gov.br/portaldeloterias/api/duplasena/',
    'https://servicebus2.caixa.gov.br/portaldeloterias/api/lotofacil/',
    'https://servicebus2.caixa.gov.br/portaldeloterias/api/lotomania/',
    'https://servicebus2.caixa.gov.br/portaldeloterias/api/timemania/',
    'https://servicebus2.caixa.gov.br/portaldeloterias/api/diadesorte/'
  );
  LoteriasDesc : Array [TLoterias] of String = (
                  'Quina', 'Loteca', 'Federal', 'Mega Sena', 'Super Sete',
                  'Dupla Sena', 'Loto Fácil', 'Lotomania', 'Time Mania', 'Dia de Sorte');
  ContentTypeDesc : Array [TContentType] of String = ( '',
                //Application
                'application/java-archive', 'application/EDI-X12', 'application/EDIFACT',
                'application/javascript', 'application/octet-stream', 'application/ogg',
                'application/pdf', 'application/xhtml+xml', 'application/x-shockwave-flash',
                'application/json', 'application/ld+json', 'application/xml',
                'application/zip', 'application/x-www-form-urlencoded',
                //Audio
                'audio/mpeg', 'audio/x-ms-wma', 'audio/vnd.rn-realaudio', 'audio/x-wav',
                //Imagem
                'image/gif', 'image/jpeg', 'image/png', 'image/tiff',
                'image/vnd.microsoft.icon', 'image/x-icon', 'image/vnd.djvu', 'image/svg+xml',
                // Texto
                'text/css', 'text/csv', 'text/html', 'text/javascript', 'text/plain', 'text/xml',
                //Vídeo
                'video/mpeg', 'video/mp4', 'video/quicktime', 'video/x-ms-wmv',
                'video/x-msvideo', 'video/x-flv', 'video/webm' );
  HttpMethod : Array [THttpMethod] of String = ('GET', 'POST', 'PUT', 'DELETE');

implementation

end.
