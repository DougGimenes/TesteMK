unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,Controller.Connection, Model.Cliente,
  Vcl.Mask, Vcl.ExtCtrls, StrUtils, Data.DB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.Grids, Vcl.DBGrids,
  View.ConsultaClientes;

type
  TFrmCadastroCliente = class(TForm)
    EdtNome: TLabeledEdit;
    EdtCPF_CNPJ: TLabeledEdit;
    RgpTipo: TRadioGroup;
    EdtRG_IE: TLabeledEdit;
    BtnConsultar: TButton;
    BtnEditar: TButton;
    BtnNovo: TButton;
    BtnAtivar: TButton;
    BtnCancelar: TButton;
    BtnGravar: TButton;
    DbgTelefones: TDBGrid;
    LblTelefones: TLabel;
    MtbTelefones: TFDMemTable;
    MtbTelefonesCodigo: TIntegerField;
    MtbTelefonesDDD: TStringField;
    MtbTelefonesTelefone: TStringField;
    DsTelefones: TDataSource;
    EdtDDD: TLabeledEdit;
    EdtTelefone: TLabeledEdit;
    BtnGravarTelefone: TButton;
    BtnCancelarTelefone: TButton;
    BtnNovoTelefone: TButton;
    BtnEditarTelefone: TButton;
    EdtCEP: TLabeledEdit;
    EdtLogradouro: TLabeledEdit;
    EdtBairro: TLabeledEdit;
    EdtCidade: TLabeledEdit;
    EdtEstado: TLabeledEdit;
    EdtPais: TLabeledEdit;
    EdtNumero: TLabeledEdit;
    BtnConsultaCEP: TButton;
    BtnExcluir: TButton;
    LblDataCadastro: TLabel;
    procedure RgpTipoClick(Sender: TObject);
    procedure EdtCPF_CNPJExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BtnNovoClick(Sender: TObject);
    procedure BtnGravarClick(Sender: TObject);
    procedure BtnCancelarClick(Sender: TObject);
    procedure BtnEditarClick(Sender: TObject);
    procedure BtnGravarTelefoneClick(Sender: TObject);
    procedure BtnCancelarTelefoneClick(Sender: TObject);
    procedure BtnNovoTelefoneClick(Sender: TObject);
    procedure BtnEditarTelefoneClick(Sender: TObject);
    procedure BtnAtivarClick(Sender: TObject);
    procedure BtnConsultarClick(Sender: TObject);
    procedure BtnConsultaCEPClick(Sender: TObject);
    procedure BtnExcluirClick(Sender: TObject);
  private
    { Private declarations }
    Conexao: TConexao;
    Cliente: TCliente;

    procedure TratarTela(AEditando: Boolean = False);
    procedure TratarTelefone(AEditando: Boolean = False);
    procedure TratarEndereco();
    procedure TratarObjeto();
  public
    { Public declarations }
  end;

var
  FrmCadastroCliente: TFrmCadastroCliente;

implementation

{$R *.dfm}

procedure TFrmCadastroCliente.BtnAtivarClick(Sender: TObject);
begin
  Self.Cliente.Ativo := not Self.Cliente.Ativo;
  Self.Cliente.Gravar();
  Self.TratarTela()
end;

procedure TFrmCadastroCliente.BtnCancelarClick(Sender: TObject);
begin
  Self.TratarTela();
end;

procedure TFrmCadastroCliente.BtnCancelarTelefoneClick(Sender: TObject);
begin
  Self.MtbTelefones.Cancel();
  Self.EdtDDD.Text := '';
  Self.EdtTelefone.Text := '';

  Self.TratarTelefone();
end;

procedure TFrmCadastroCliente.BtnConsultaCEPClick(Sender: TObject);
begin
  Self.Cliente.Endereco.CEP := Self.EdtCEP.Text;
  Self.Cliente.Endereco.PreencherEnderecoPorCEP();
  Self.TratarEndereco();
end;

procedure TFrmCadastroCliente.BtnConsultarClick(Sender: TObject);
var
  Consulta: TFrmConsultaCliente;
begin
  Consulta := TFrmConsultaCliente.Create(Self, Conexao);
  try
    Consulta.ShowModal();
    if Consulta.Consultou then
    begin
      Self.Cliente := TCliente.Create(Conexao, IntToStr(Consulta.CodigoConsultado));
    end;
  finally
    FreeAndNil(Consulta);
  end;

  Self.TratarTela();
end;

procedure TFrmCadastroCliente.BtnEditarClick(Sender: TObject);
begin
  Self.TratarTela(True);
end;

procedure TFrmCadastroCliente.BtnEditarTelefoneClick(Sender: TObject);
begin
  Self.MtbTelefones.Edit();
  Self.EdtDDD.Text := Self.MtbTelefones.FieldByName('DDD').AsString;
  Self.EdtTelefone.Text := Self.MtbTelefones.FieldByName('Telefone').AsString;

  Self.TratarTelefone(True);
end;

procedure TFrmCadastroCliente.BtnExcluirClick(Sender: TObject);
begin
  Self.Cliente.Excluir();
  Self.Cliente := TCliente.Create(Conexao);
  Self.TratarTela();
end;

procedure TFrmCadastroCliente.BtnGravarClick(Sender: TObject);
begin
  Self.TratarObjeto();
  Self.Cliente.Gravar();
  Self.TratarTela();
end;

procedure TFrmCadastroCliente.BtnGravarTelefoneClick(Sender: TObject);
begin
  Self.MtbTelefones.FieldByName('DDD').AsString := Self.EdtDDD.Text;
  Self.MtbTelefones.FieldByName('Telefone').AsString := Self.EdtTelefone.Text;
  Self.MtbTelefones.Post();
  Self.EdtDDD.Text := '';
  Self.EdtTelefone.Text := '';

  Self.TratarTelefone();
end;

procedure TFrmCadastroCliente.BtnNovoClick(Sender: TObject);
begin
  if Self.Cliente.Codigo > 0 then
  begin
    Self.Cliente := TCliente.Create(Conexao);
  end;

  Self.TratarTela(True);
end;

procedure TFrmCadastroCliente.BtnNovoTelefoneClick(Sender: TObject);
begin
  Self.MtbTelefones.Append();
  Self.EdtDDD.Text := '';
  Self.EdtTelefone.Text := '';

  Self.TratarTelefone(True);
end;

procedure TFrmCadastroCliente.EdtCPF_CNPJExit(Sender: TObject);
begin
//Removido por não fazer parte das especificações do teste
//  if Self.RgpTipo.ItemIndex = 0 then
//  begin
//    if not Self.Cliente.ValidarCPF(Self.EdtCPF_CNPJ.Text) then
//    begin
//      Self.EdtCPF_CNPJ.Text := '';
//      MessageDlg('CPF inválido!', mtWarning, [mbOK], 0)
//    end;
//  end
//  else
//  begin
//    if not Self.Cliente.ValidarCNPJ(Self.EdtCPF_CNPJ.Text) then
//    begin
//      Self.EdtCPF_CNPJ.Text := '';
//      MessageDlg('CNPJ inválido!', mtWarning, [mbOK], 0)
//    end;
//  end;
end;

procedure TFrmCadastroCliente.FormShow(Sender: TObject);
begin
  Conexao := TConexao.ObterInstancia();
  Conexao.Conectar('Server=DOUGLAS-PC;OSAuthent=Yes;Database=TesteMK;DriverID=MSSQL;');
  Self.Cliente := TCliente.Create(Conexao);
  Self.MtbTelefones.Open();
  Self.TratarTela();
end;

procedure TFrmCadastroCliente.RgpTipoClick(Sender: TObject);
begin
  Self.EdtCPF_CNPJ.EditLabel.Caption := IfThen(Self.RgpTipo.ItemIndex = 0, 'CPF', 'CNPJ');
  Self.EdtRG_IE.EditLabel.Caption := IfThen(Self.RgpTipo.ItemIndex = 0, 'RG', 'Inscrição Estadual');
end;

procedure TFrmCadastroCliente.TratarTela(AEditando: Boolean = False);
begin
  if not (Self.Cliente.Codigo > 0) then
  begin
    Self.Cliente := TCliente.Create(Conexao);
  end;

  //Preenchendo
  Self.EdtNome.Text := Self.Cliente.Nome;
  Self.RgpTipo.ItemIndex := (1 * Ord(Self.Cliente.Tipo = 'J'));
  Self.EdtCPF_CNPJ.Text := Self.Cliente.CPF_CNPJ;
  Self.EdtRG_IE.Text := Self.Cliente.RG_IE;
  Self.LblDataCadastro.Caption := 'Cadastrado em: ' + FormatDateTime('dd/mm/yyyy', Self.Cliente.Data_Cadastro);
  Self.LblDataCadastro.Visible := (Self.Cliente.Codigo > 0);

  Self.BtnAtivar.Caption := IfThen(Self.Cliente.Ativo, 'Desativar', 'Ativar');

  Self.MtbTelefones.EmptyDataSet();
  for var I := 0 to Self.Cliente.Telefones.Count - 1 do
  begin
    Self.MtbTelefones.Append();
    Self.MtbTelefones.FieldByName('Codigo').AsInteger := Self.Cliente.Telefones[I].Codigo;
    Self.MtbTelefones.FieldByName('DDD').AsString := Self.Cliente.Telefones[I].DDD;
    Self.MtbTelefones.FieldByName('Telefone').AsString := Self.Cliente.Telefones[I].Telefone;
    Self.MtbTelefones.Post();
  end;

  Self.TratarEndereco();

  //Permitindo edição
  Self.EdtNome.ReadOnly := not AEditando;
  Self.RgpTipo.Enabled := AEditando;
  Self.EdtCPF_CNPJ.ReadOnly := not AEditando;
  Self.EdtRG_IE.ReadOnly := not AEditando;

  Self.BtnConsultar.Visible := not AEditando;
  Self.BtnNovo.Visible := not AEditando;
  Self.BtnEditar.Visible := (Self.Cliente.Codigo > 0) and (not AEditando);
  Self.BtnAtivar.Visible := (Self.Cliente.Codigo > 0) and (not AEditando);
  Self.BtnGravar.Visible := AEditando;
  Self.BtnCancelar.Visible := AEditando;
  Self.BtnExcluir.Visible := (not AEditando) and (Self.Cliente.Codigo > 0);

  Self.BtnNovoTelefone.Enabled := AEditando;
  Self.BtnEditarTelefone.Enabled := AEditando;

  Self.EdtCEP.ReadOnly := not AEditando;
  Self.EdtLogradouro.ReadOnly := not AEditando;
  Self.EdtBairro.ReadOnly := not AEditando;
  Self.EdtPais.ReadOnly := not AEditando;
  Self.EdtNumero.ReadOnly := not AEditando;
  Self.EdtEstado.ReadOnly := not AEditando;
  Self.EdtCidade.ReadOnly := not AEditando;
  Self.BtnConsultaCEP.Enabled := AEditando;
end;

procedure TFrmCadastroCliente.TratarTelefone(AEditando: Boolean = False);
begin
  Self.EdtDDD.ReadOnly := not AEditando;
  Self.EdtTelefone.ReadOnly := not AEditando;
  Self.BtnGravarTelefone.Visible := AEditando;
  Self.BtnCancelarTelefone.Visible := AEditando;
end;

procedure TFrmCadastroCliente.TratarEndereco();
begin
  Self.EdtCEP.Text        := Self.Cliente.Endereco.CEP;
  Self.EdtLogradouro.Text := Self.Cliente.Endereco.Logradouro;
  Self.EdtBairro.Text     := Self.Cliente.Endereco.Bairro;
  Self.EdtPais.Text       := Self.Cliente.Endereco.Pais;
  Self.EdtNumero.Text     := Self.Cliente.Endereco.Numero;
  Self.EdtEstado.Text     := Self.Cliente.Endereco.Estado;
  Self.EdtCidade.Text     := Self.Cliente.Endereco.Cidade;
end;

procedure TFrmCadastroCliente.TratarObjeto();
begin
  Self.Cliente.Nome := Self.EdtNome.Text;
  Self.Cliente.Tipo := IfThen(Self.RgpTipo.ItemIndex = 0, 'F', 'J');
  Self.Cliente.CPF_CNPJ := Self.EdtCPF_CNPJ.Text;
  Self.Cliente.RG_IE := Self.EdtRG_IE.Text;
  Self.Cliente.Ativo := True;

  Self.Cliente.Telefones.Clear();
  Self.MtbTelefones.First();
  for var I := 0 to Self.MtbTelefones.RecordCount - 1 do
  begin
    var Telefone: TTelefone;
    if Self.MtbTelefones.FieldByName('Codigo').AsInteger > 0 then
    begin
      Telefone := TTelefone.Create(Conexao, Self.MtbTelefones.FieldByName('Codigo').AsString);
    end
    else
    begin
      Telefone := TTelefone.Create(Conexao);
    end;

    Telefone.DDD := Self.MtbTelefones.FieldByName('DDD').AsString;
    Telefone.Telefone := Self.MtbTelefones.FieldByName('Telefone').AsString;

    Self.Cliente.Telefones.Add(Telefone);

    Self.MtbTelefones.Next();
  end;

  Self.Cliente.Endereco.CEP := Self.EdtCEP.Text;
  Self.Cliente.Endereco.Logradouro := Self.EdtLogradouro.Text;
  Self.Cliente.Endereco.Bairro := Self.EdtBairro.Text;
  Self.Cliente.Endereco.Pais := Self.EdtPais.Text;
  Self.Cliente.Endereco.Numero := Self.EdtNumero.Text;
  Self.Cliente.Endereco.Estado := Self.EdtEstado.Text;
  Self.Cliente.Endereco.Cidade := Self.EdtCidade.Text;
end;

end.
