unit Model.Cliente;

interface

uses
  GimenesD.FD.Model.Base,
  SysUtils,
  FireDAC.Comp.Client,
  Controller.Connection,
  StrUtils,
  IdHTTP,
  IdSSLOpenSSL,
  JSON,
  System.Generics.Collections;

type
  TTelefone = class(TObjetoBase)
  private
    FCodigo: Integer; 
    FDDD: String;
    FTelefone: String;
    FCodigoCliente: Integer;
  public
    property Codigo: Integer read FCodigo;
    property DDD: String read FDDD write FDDD;
    property Telefone: String read FTelefone write FTelefone;
    property CodigoCliente: Integer read FCodigoCliente write FCodigoCliente;
  end;

  TEndereco = class(TObjetoBase)
  private
    FCodigo: Integer;
    FLogradouro: String;
    FCEP: String;
    FNumero: String;
    FBairro: String;
    FCidade: String;
    FEstado: String;
    FPais: String;
    FCodigoCliente: Integer;
  public
    property Codigo: Integer read FCodigo;
    property Logradouro: String read FLogradouro write FLogradouro;
    property CEP: String read FCEP write FCEP;
    property Numero: String read FNumero write FNumero;
    property Bairro: String read FBairro write FBairro;
    property Cidade: String read FCidade write FCidade;
    property Estado: String read FEstado write FEstado;
    property Pais: String read FPais write FPais;
    property CodigoCliente: Integer read FCodigoCliente write FCodigoCliente;

    procedure PreencherEnderecoPorCEP(ACEP : String = '');
  end;

  TCliente = class(TObjetoBase)
  private
    FCodigo: Integer;
    FNome: String;
    FAtivo: Boolean;
    FTipo: String;
    FCPF_CNPJ: String;
    FRG_IE: String;
    FData_Cadastro: TDate;
    FEndereco: TEndereco;
    FTelefones: TObjectList<TTelefone>;

    procedure Inserir(); override;
    procedure Editar(); override;
    
    procedure SetCPF_CNPJ(ADocumento: String);

    procedure DeterminarNaoInserir(); override;
  public
    property Codigo: Integer read FCodigo;
    property Nome: String read FNome write FNome;
    property Ativo: Boolean read FAtivo write FAtivo;
    property Tipo: String read FTipo write FTipo;
    property CPF_CNPJ: String read FCPF_CNPJ write SetCPF_CNPJ;
    property RG_IE: String read FRG_IE write FRG_IE;
    property Data_Cadastro: TDate read FData_Cadastro write FData_Cadastro;
    property Endereco: TEndereco read FEndereco write FEndereco;
    property Telefones: TObjectList<TTelefone> read FTelefones write FTelefones;

    procedure Gravar(); override;
    procedure Excluir(); override;

    constructor Create(AConexao: TConexao; ACodigo: String = ''); override;  
    
    function ValidarCPF(ACPF: String): Boolean;
    function ValidarCNPJ(ANPJ: String): Boolean;
  end;

implementation

{ TCliente }

constructor TCliente.Create(AConexao: TConexao; ACodigo: String = '');
var
  TbDetalhes: TFDQuery;
begin
  inherited Create(AConexao, ACodigo);

  Self.FTelefones := TObjectList<TTelefone>.Create(True);      
  
  if ACodigo = '' then
  begin
    Self.FEndereco := TEndereco.Create(AConexao);
  end
  else
  begin
    TbDetalhes := AConexao.GerarQuery();

    TbDetalhes.SQL.Clear();
    TbDetalhes.SQL.Add('SELECT Codigo FROM Endereco WHERE CodigoCliente = ' + ACodigo);
    TbDetalhes.Open();

    Self.FEndereco := TEndereco.Create(AConexao, TbDetalhes.FieldByName('Codigo').AsString);

    TbDetalhes.SQL.Clear();
    TbDetalhes.SQL.Add('SELECT Codigo FROM Telefone WHERE CodigoCliente = ' + ACodigo);
    TbDetalhes.Open();

    for var I := 0 to TbDetalhes.RecordCount - 1 do
    begin
      Self.FTelefones.Add(TTelefone.Create(AConexao, TbDetalhes.FieldByName('Codigo').AsString));
      TbDetalhes.Next();
    end;
  end;
end;

procedure TCliente.DeterminarNaoInserir();
begin
  inherited;

  Self.CamposNaoInserir.Add('Endereco');
  Self.CamposNaoInserir.Add('Telefones');
end;

procedure TCliente.Excluir();
begin
  if Self.Endereco.Codigo > 0 then
  begin
    Self.Endereco.Excluir();
  end;

 for var Telefone in Self.Telefones do
 begin
   if Telefone.Codigo > 0 then
   begin
     Telefone.Excluir();
   end;
 end;

 inherited;
end;

procedure TCliente.Gravar();
begin
  if Self.CPF_CNPJ = '' then
  begin
    var Documento: String;
    Documento := IfThen(Self.Tipo = 'F', 'CPF', 'CNPJ');
    raise Exception.Create(Documento + ' não informado!');
  end;
  
  Self.Endereco.CodigoCliente := Self.Codigo;

  for var I := 0 to Self.Telefones.Count - 1 do
  begin
    Self.Telefones[I].CodigoCliente := Self.Codigo;
  end;
  
  inherited;
end;

procedure TCliente.Inserir();
var
  TbCliente: TFDQuery;
  Conexao : TConexao;
begin
  Conexao := TConexao.ObterInstancia();
  TbCliente := Conexao.GerarQuery();
  Conexao.Conectar();

  TbCliente.SQL.Clear();
  TbCliente.SQL.Add('SELECT Codigo FROM Cliente WHERE CPF_CNPJ = ' + QuotedStr(Self.CPF_CNPJ));
  TbCliente.Open();

  if (TbCliente.RecordCount > 0) then
  begin
    var Documento: String;
    Documento := IfThen(Self.Tipo = 'F', 'CPF', 'CNPJ');
    raise Exception.Create(Documento + ' já cadastrado!');
  end;

  Self.Data_Cadastro := Date();
  inherited;

  Self.Endereco.CodigoCliente := Self.Codigo;

  for var I := 0 to Self.Telefones.Count - 1 do
  begin
    Self.Telefones[I].CodigoCliente := Self.Codigo;
  end;

  if not Self.Endereco.Logradouro.IsEmpty then
  begin
    Self.Endereco.Gravar();
  end;
  
  for var I := 0 to Self.Telefones.Count - 1 do
  begin
    if not Self.Telefones[I].Telefone.IsEmpty then
    begin
      Self.Telefones[I].Gravar();
    end;
  end;
end;

procedure TCliente.Editar();
begin
  inherited;

  if not Self.Endereco.Logradouro.IsEmpty then
  begin
    Self.Endereco.Gravar();
  end
  else if Self.Endereco.Codigo > 0 then
  begin
    Self.Endereco.Excluir();
    Self.Endereco := TEndereco.Create(Self.Conexao);
  end;

  for var I := 0 to Self.Telefones.Count - 1 do
  begin
    if not Self.Telefones[I].Telefone.IsEmpty then
    begin
      Self.Telefones[I].Gravar();
    end
    else if Self.Telefones[I].Codigo > 0 then
    begin
      Self.Telefones[I].Excluir();
    end;
  end;
end;

procedure TCliente.SetCPF_CNPJ(ADocumento: String);
begin
//Removido por não fazer parte das especificações do teste
//  if Self.Tipo = 'F' then
//  begin
//    if (ADocumento <> '') and (not Self.ValidarCPF(ADocumento)) then
//    begin
//      Exit;
//    end;
//  end
//  else
//  begin
//    if (ADocumento <> '') and (not Self.ValidarCNPJ(ADocumento))  then
//    begin
//      Exit;
//    end;
//  end;

  Self.FCPF_CNPJ := ADocumento;
end;

function TCliente.ValidarCPF(ACPF: String): Boolean;
var
  Digito10, Digito11: String;
  Soma: Integer;
begin
  if ((ACPF = '00000000000') or (ACPF = '11111111111') or
      (ACPF = '22222222222') or (ACPF = '33333333333') or
      (ACPF = '44444444444') or (ACPF = '55555555555') or
      (ACPF = '66666666666') or (ACPF = '77777777777') or
      (ACPF = '88888888888') or (ACPF = '99999999999') or
      (Length(ACPF) <> 11)) then
  begin
    Result := False;
    Exit;
  end;

  try
    Soma := 0;
    for var I := 1 to 9 do
    begin
      Soma := Soma + (StrToInt(ACPF[I]) * (11-I));
    end;

    Digito10 := IntToStr(11 - (Soma mod 11));
    Digito10 := IfThen(((Digito10 = '10') or (Digito10 = '11')), '0', Digito10);

    Soma := 0;
    for var I := 1 to 10 do
    begin
      Soma := Soma + (StrToInt(ACPF[I]) * (12-I));
    end;

    Digito11 := IntToStr(11 - (Soma mod 11));
    Digito11 := IfThen(((Digito11 = '10') or (Digito11 = '11')), '0', Digito11);

    Result := ((Digito10 = ACPF[10]) and (Digito11 = ACPF[11]));
  except
    Result := False;
  end;
end;

function TCliente.ValidarCNPJ(ANPJ: String): Boolean;
begin
  Result := True;
end;

{ TEndereco }

procedure TEndereco.PreencherEnderecoPorCEP(ACEP : String = '');
var
  IdHTTP: TIdHTTP;
  IOHandler: TIdSSLIOHandlerSocketOpenSSL;
  CEPConsultar: String;
  JSON: TJSONObject;
begin
  IOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  IOHandler.SSLOptions.SSLVersions := [sslvTLSv1,sslvTLSv1_1,sslvTLSv1_2];
  IdHTTP := TIdHTTP.Create(nil);
  IdHTTP.IOHandler := IOHandler;
  IdHTTP.Request.Clear();
  IdHTTP.Request.CustomHeaders.Clear();

  if ACEP = '' then
  begin
    CEPConsultar := Self.FCEP;
  end
  else
  begin
    CEPConsultar := ACEP;
  end;

  try
    JSON := TJSONObject.ParseJSONValue(IdHTTP.Get('https://viacep.com.br/ws/' + CEPConsultar + '/json/')) as TJSONObject;
    Self.FLogradouro := JSON.GetValue('logradouro').Value;
    Self.FBairro := JSON.GetValue('bairro').Value;
    Self.FCidade := JSON.GetValue('localidade').Value;
    Self.FEstado := JSON.GetValue('uf').Value;
  except
    raise Exception.Create('Erro ao consultar CEP! Verifique se o CEP informado está correto!');
  end;

  FreeAndNil(IdHTTP);
  FreeAndNil(IOHandler);
  FreeAndNil(JSON);
end;

end.
