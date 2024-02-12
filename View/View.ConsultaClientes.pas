unit View.ConsultaClientes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, GimenesD.FD.View.ConsultaGenerica,
  Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids;

type
  TFrmConsultaCliente = class(TFrmConsultaBase)
    QryConsultaCodigo: TIntegerField;
    QryConsultaNome: TStringField;
    QryConsultaCPF_CNPJ: TStringField;
    CkbAtivos: TCheckBox;
  private
    { Private declarations }
    procedure FinalizarConsulta(); override;
    function  FormarFiltro() : String; override;
    function  FormarSQLAutoComplete() : String; override;
  public
    { Public declarations }
  end;

var
  FrmConsultaCliente: TFrmConsultaCliente;

implementation

{$R *.dfm}

procedure TFrmConsultaCliente.FinalizarConsulta();
begin
  Self.FConsultou := True;
  Self.FCodigoConsultado := Self.QryConsulta.FieldByName('Codigo').AsInteger;
end;

function  TFrmConsultaCliente.FormarFiltro() : String;
begin
  Result := '';
  if Self.EdtConsulta.Text <> '' then
  begin
    Result := '(NOME LIKE ' + QuotedStr('%' + Self.EdtConsulta.Text + '%') +')';
  end;

  if Self.CkbAtivos.Checked then
  begin
    if Self.EdtConsulta.Text <> '' then
    begin
      Result := Result + ' AND (ATIVO = 1)';
    end
    else
    begin
      Result := '(ATIVO = 1)';
    end;
  end;

end;

function  TFrmConsultaCliente.FormarSQLAutoComplete() : String;
begin
  Result := 'SELECT TOP 1 NOME FROM Cliente' + #13 +
            'WHERE (NOME LIKE ' + QuotedStr(Self.EdtConsulta.Text + '%') + ')';
end;

end.
