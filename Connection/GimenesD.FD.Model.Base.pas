unit GimenesD.FD.Model.Base;

interface

uses
  FireDAC.Comp.Client,
  SysUtils,
  FireDAC.Phys.MySQLDef,
  FireDAC.Phys,
  FireDAC.Phys.MySQL,
  FireDAC.UI.Intf,
  FireDAC.VCLUI.Wait,
  FireDAC.Comp.UI,
  StrUtils,
  FireDAC.Stan.Async,
  Math,
  RTTI,
  Classes,
  Controller.Connection,
  Variants;

type
  TObjetoBase = class(TObject)
  private
    function FormarFiltro(ACodigo: String = ''): String;
    function SelecionarValorPorTipo(AClassName: String; AValor: TValue): String;
  protected
    Conexao: TConexao;

    CampoCodigo: String;
    CamposNaoInserir: TStringList;

    procedure Editar(); virtual;
    procedure Inserir(); virtual;

    function RetornarCodigo(): TValue; virtual;
    procedure DeterminarCodigo(AValue: TValue); virtual;
    procedure DeterminarCampoCodigo(); virtual;
    procedure DeterminarNaoInserir(); virtual;
  public
    procedure Gravar(); virtual;
    procedure Excluir(); virtual;

    constructor Create(AConexao: TConexao; ACodigo: String = ''); overload; virtual;
  end;

implementation

{ TObjetoBase }

constructor TObjetoBase.Create(AConexao: TConexao; ACodigo: String);
var
  QrySelecionar: TFDQuery;
  Contexto:      TRttiContext;
  Tipo:          TRttiType;
  Propriedade:   TRttiProperty;
begin
  inherited Create();
  Self.DeterminarCampoCodigo();
  Self.DeterminarNaoInserir();

  Self.Conexao := AConexao;

  if ACodigo <> '' then
  begin
    Tipo := Contexto.GetType(Self.ClassType.ClassInfo);
    QrySelecionar := Self.Conexao.GerarQuery();
    QrySelecionar.SQL.Clear();
    QrySelecionar.SQL.Add('SELECT * FROM ' + (Self.ClassType.ClassName).Substring(1));
    QrySelecionar.SQL.Add('WHERE ' + Self.FormarFiltro(ACodigo));
    QrySelecionar.Open();
    Self.DeterminarCodigo(StrToInt(ACodigo));

    if QrySelecionar.RecordCount > 0 then
    begin
      for Propriedade in Tipo.GetProperties do
      begin
        if Propriedade.IsWritable and (not Propriedade.PropertyType.IsInstance) then
        begin
          Propriedade.SetValue(Self, TValue.FromVariant(QrySelecionar.FieldByName(Propriedade.Name).Value));
        end;
      end;
    end;
  end;
end;

procedure TObjetoBase.Editar;
var
  QryObjeto:   TFDQuery;
  Contexto:    TRttiContext;
  Tipo:        TRttiType;
  Propriedade: TRttiProperty;
  Cont:        Integer;
  Valor:       String;
begin
  Tipo := Contexto.GetType(Self.ClassType.ClassInfo);

  QryObjeto := Self.Conexao.GerarQuery();
  try
    QryObjeto.SQL.Clear();
    QryObjeto.SQL.Add('UPDATE ' + (Self.ClassType.ClassName).Substring(1));
    QryObjeto.SQL.Add('SET ');

    Cont := 0;
    for Propriedade in Tipo.GetProperties() do
    begin
      if (Propriedade.Name = Self.CampoCodigo) or ((Self.CamposNaoInserir.IndexOf(Propriedade.Name) <> -1) or (not Propriedade.IsWritable)) then
      begin
        Continue;
      end;

      Valor := Self.SelecionarValorPorTipo(Propriedade.PropertyType.ToString, Propriedade.GetValue(Self));
      QryObjeto.SQL.Add(IfThen(Cont > 0, ',' + Propriedade.Name + ' = ' + Valor, Propriedade.Name + ' = ' + Valor));
      Inc(Cont)
    end;
    QryObjeto.SQL.Add('WHERE ' + Self.FormarFiltro());


    QryObjeto.ExecSQL();
    QryObjeto.Transaction.Commit();
  except
    QryObjeto.Transaction.Rollback();
  end;
end;

procedure TObjetoBase.Excluir;
var
  QryObjeto: TFDQuery;
begin
  QryObjeto := Self.Conexao.GerarQuery();
  try
    QryObjeto.SQL.Clear();
    QryObjeto.SQL.Add('DELETE FROM ' + (Self.ClassType.ClassName).Substring(1));
    QryObjeto.SQL.Add('WHERE ' + Self.FormarFiltro());
    QryObjeto.ExecSQL();
    QryObjeto.Transaction.Commit();
  except
    QryObjeto.Transaction.Rollback();
  end;
end;

function TObjetoBase.FormarFiltro(ACodigo: String): String;
var
  Contexto:    TRttiContext;
  Tipo:        TRttiType;
  Propriedade: TRttiProperty;
  Valor:       String;
begin
  Tipo := Contexto.GetType(Self.ClassType.ClassInfo);
  if ACodigo = '' then
  begin
    for Propriedade in Tipo.GetProperties() do
    begin
      if Propriedade.Name = Self.CampoCodigo then
      begin
        Valor := Self.SelecionarValorPorTipo(Propriedade.PropertyType.ToString, Propriedade.GetValue(Self));
      end;
    end;

    Result := Self.CampoCodigo + ' = ' + Valor;
  end
  else
  begin
    Result := Self.CampoCodigo + ' = ' + ACodigo;
  end;
end;

procedure TObjetoBase.Gravar;
begin
  if Self.RetornarCodigo().AsInteger <> 0 then
  begin
    Self.Editar();
  end
  else
  begin
    Self.Inserir();
  end;
end;

procedure TObjetoBase.Inserir;
var
  QryObjeto:   TFDQuery;
  Contexto:    TRttiContext;
  Tipo:        TRttiType;
  Propriedade: TRttiProperty;
  Cont:        Integer;
  Valor:       String;
begin
  Tipo := Contexto.GetType(Self.ClassType.ClassInfo);

  QryObjeto := Self.Conexao.GerarQuery();
  try
    QryObjeto.SQL.Clear();
    QryObjeto.SQL.Add('INSERT INTO ' + (Self.ClassType.ClassName).Substring(1));
    QryObjeto.SQL.Add('(');

    Cont := 0;
    for Propriedade in Tipo.GetProperties() do
    begin
      if (Propriedade.IsWritable) and (Self.CamposNaoInserir.IndexOf(Propriedade.Name) = -1) then
      begin
        QryObjeto.SQL.Add(IfThen(Cont > 0, ',' + Propriedade.Name, Propriedade.Name));
        Inc(Cont);
      end;
    end;
    QryObjeto.SQL.Add(')');

    QryObjeto.SQL.Add('VALUES (');
    Cont := 0;
    for Propriedade in Tipo.GetProperties() do
    begin
      if (Propriedade.IsWritable) and (Self.CamposNaoInserir.IndexOf(Propriedade.Name) = -1) then
      begin
        Valor := Self.SelecionarValorPorTipo(Propriedade.PropertyType.ToString, Propriedade.GetValue(Self));
        QryObjeto.SQL.Add(IfThen(Cont > 0, ',' + Valor, Valor));
        Inc(Cont);
      end;
    end;
    QryObjeto.SQL.Add('); SELECT SCOPE_IDENTITY()');

    QryObjeto.Open();
    QryObjeto.Transaction.Commit();

    Self.DeterminarCodigo(QryObjeto.Fields[0].AsInteger);
  except
    QryObjeto.Transaction.Rollback();
  end;
end;

function TObjetoBase.RetornarCodigo: TValue;
var
  Contexto:    TRttiContext;
  Tipo:        TRttiType;
  Propriedade: TRttiProperty;
begin
  Tipo := Contexto.GetType(Self.ClassType.ClassInfo);
  for Propriedade in Tipo.GetProperties() do
  begin
    if Propriedade.Name = Self.CampoCodigo then
    begin
      Result := Propriedade.GetValue(Self);
      Exit;
    end;
  end;
end;

procedure TObjetoBase.DeterminarCodigo(AValue: TValue);
var
  Contexto: TRttiContext;
  Tipo:     TRttiType;
  Campo:    TRttiField;
begin
  Tipo := Contexto.GetType(Self.ClassType.ClassInfo);
  for Campo in Tipo.GetFields() do
  begin
    if Campo.Name = ('F' + Self.CampoCodigo) then
    begin
      Campo.SetValue(Self, AValue);
      Exit;
    end;
  end;
end;

function TObjetoBase.SelecionarValorPorTipo(AClassName: String; AValor: TValue): String;
begin
  if UpperCase(AClassName) = 'STRING' then
  begin
    Result := QuotedStr(AValor.AsString());
  end
  else if UpperCase(AClassName) = 'BOOLEAN' then
  begin
    Result := IntToStr(Ord(AValor.AsBoolean));
  end
  else
  begin
    Result := QuotedStr(AValor.ToString());
  end;
end;

procedure TObjetoBase.DeterminarCampoCodigo();
begin
  Self.CampoCodigo := 'Codigo';
end;

procedure TObjetoBase.DeterminarNaoInserir();
begin
  Self.CamposNaoInserir := TStringList.Create();
  Self.CamposNaoInserir.AddStrings([Self.CampoCodigo, 'CampoCodigo']);
end;

end.
