unit UntTipo;

interface

type
  TAndOr = (taAnd, taOr);
  TLicenca = (lcBasico, lcIntermediario, lcAvancado);
  TOperador = (enNormal, enInserir, enAlterar, enExcluir);
  TOperacao = (toIgual, toMaior, toMenor, toMaiorIgual, toMenorIgual, toBetween, toContenha);
  TDiretorio = (drPadrao, drTemporario, drExcetavel);
  TEstadosBR = (esSelecione, esAcre, esAlagoas, esAmapá, esAmazonas, esBahia, esCeará,
                esEspíritoSanto, esGoiás, esMaranhão, esMatoGrosso, esMatoGrossoDoSul,
                esMinasGerais, esPará, esParaíba, esParaná, esPernambuco, esPiauí,
                esRioDeJaneiro, esRioGrandeDoNorte, esRioGrandeDoSul, esRondônia,
                esRoraima, esSantaCatarina, esSaoPaulo, esSergipe, esTocantins,
                esDistritoFederal);
  TBancoDados = (bdNenhum, bdMySql, bdSQLite, bdOracle, bdSqlServer, bdFireBird,
                 bdInterbase, bdPostgreSQL, bdDB2, bdASA, bdADS, bdNexus, bdDS,
                 bdInformix, bdMSAccess, bdOutro);
  TForcaSenha = (fsNenhuma, fsBaixa, fsFraca, fsMedia, fsAlta, fsExcelente);
  TTipoExportar = (teNenhum, teExcel, teWord, teHTML, teCSV);
  TServidorDateTime = (stWindows, stPool, stCloudFlare, stJdNtp,
              stAST1, stCST1, stDST1, stANTP, stBNTP, stCNTP, stGPSNTP);
  TLoterias = ( ltQuina, ltLoteca, ltFederal, ltMegaSena, ltSuperSete, ltDuplaSena,
               ltLotoFacil, ltLotoMania, ltTimeMania, ltDiaDeSorte );
  TValidador = record
    Total   : SmallInt;
    Ordem   : Integer;
    Minimo  : SmallInt;
    Maximo  : SmallInt;
    Loteria : TLoterias;
  end;
  TContentType = ( ctNenhum, ctApplication_java_archive, ctApplication_EDI_X12, ctApplication_EDIFACT, ctApplication_javascript,
                ctApplication_octet_stream, ctApplication_ogg, ctApplication_pdf, ctApplication_xhtml_xml,
                ctApplication_x_shockwave_flash, ctApplication_json, ctApplication_ld_json, ctApplication_xml,
                ctApplication_zip, ctApplication_x_www_form_urlencoded,
                ctAudio_mpeg, ctAudio_x_ms_wma, ctAudio_vnd_rn_realaudio, ctAudio_x_wav,
                ctImg_gif, ctImg_jpeg, ctImg_png, ctImg_tiff, ctImg_vnd_microsoft_icon,
                ctImg_x_icon, ctImg_vnd_djvu, ctImg_svg_xml,
                ctText_css, ctText_csv, ctText_html, ctText_javascript, ctText_plain, ctText_xml,
                ctVideo_mpeg, ctVideo_mp4, ctVideo_quicktime, ctVideo_x_ms_wmv, ctVideo_x_msvideo,
                ctVideo_x_flv, ctVideo_webm );

  TPesquisa = packed record
    AndOr : TAndOr;
    Campo : String;
    ValorIni : Variant;
    ValorFim : Variant;
    Operacao : TOperacao;
  end;
  PPesquisa = ^TPesquisa;
  THttpMethod = (hmGet, hmPost, hmPut, hmDelete);

implementation

end.
