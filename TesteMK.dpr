program TesteMK;

uses
  Vcl.Forms,
  Main in 'Main.pas' {FrmCadastroCliente},
  Controller.Connection in 'Connection\Controller.Connection.pas',
  GimenesD.FD.Model.Base in 'Connection\GimenesD.FD.Model.Base.pas',
  Model.Cliente in 'Model\Model.Cliente.pas',
  GimenesD.FD.View.ConsultaGenerica in 'View\GimenesD.FD.View.ConsultaGenerica.pas' {FrmConsultaBase},
  View.ConsultaClientes in 'View\View.ConsultaClientes.pas' {FrmConsultaCliente};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmCadastroCliente, FrmCadastroCliente);
  Application.Run;
end.
