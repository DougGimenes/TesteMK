unit Controller.Connection;

interface

uses
  FireDAC.Comp.Client,
  FireDAC.Stan.Def,
  FireDAC.DApt,
  SysUtils,
  Math,
  FireDAC.Phys.MSSQLDef,
  FireDAC.Phys,
  FireDAC.Phys.MSSQL,
  FireDAC.UI.Intf,
  FireDAC.VCLUI.Wait,
  FireDAC.Comp.UI,
  FireDAC.Stan.Async;

type
  TConexao = class(TFDConnection)
  private
    class var Conexao : TConexao;
    class function NewInstance(): TObject; override;
  public
    class function ObterInstancia(): TConexao;
    function Conectar(AStringDeConexao: String = ''): Boolean;
    function Desconectar(): Boolean;
    class function GerarConexao(AServidor, ABanco, ALogin, ASenha: String; APath: String = ''): String;
    function GerarQuery(): TFDQuery;
  end;

implementation

{ TConexao }

function TConexao.Conectar(AStringDeConexao: String = ''): Boolean;
begin
  if not (AStringDeConexao = '') then
  begin
    Conexao.ConnectionString := AStringDeConexao;
  end;

  Conexao.LoginPrompt := False;

  try
    try
      if not Conexao.Connected then
      begin
        Conexao.Connected := True;
      end;
    except

    end;
  finally
    Result := Conexao.Connected;
  end;
end;

function TConexao.Desconectar: Boolean;
begin
  try
    Conexao.Connected := False;
  finally
    Result := not Conexao.Connected;
  end;
end;

function TConexao.GerarQuery(): TFDQuery;
begin
  Result := TFDQuery.Create(nil);
  //Result.Params.Add('MetaCaseInsCat', 'True');
  Result.Connection := Conexao;
  Result.Transaction := TFDTransaction.Create(nil);
  Result.Transaction.Options.AutoCommit := False;
  Result.Transaction.Connection := Conexao;
  Result.Transaction.StartTransaction();
end;

class function TConexao.GerarConexao(AServidor, ABanco, ALogin, ASenha, APath: String): String;
var
  ArqConexao: TextFile;
  StringConexao: String;
begin
  StringConexao := 'Server=' + AServidor + ';Login=' + ALogin + ';Password' + ASenha + ';Database=' + ABanco + ';DriverID=MSSQL';

  if APath <> '' then
  begin
    AssignFile(ArqConexao, APath);
    ReWrite(ArqConexao);

    for var I := 0 to Floor(StringConexao.Length / 128) do
    begin
      Append(ArqConexao);
      Write(ArqConexao, StringConexao.Substring(I * 128, (I+1) * 128 ));
      CloseFile(ArqConexao);
    end;
  end;

  Conexao.ConnectionString := StringConexao;
  Result := StringConexao;
end;

class function TConexao.NewInstance(): TObject;
begin
  if not Assigned(Conexao) then
  begin
    Conexao := TConexao(inherited NewInstance);
  end;

  Result := Conexao;
end;

class function TConexao.ObterInstancia: TConexao;
begin
  if not Assigned(Conexao) then
  begin
    Conexao := TConexao.Create(nil);
  end;

  Result := Conexao;
end;

end.

