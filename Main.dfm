object FrmCadastroCliente: TFrmCadastroCliente
  Left = 0
  Top = 0
  Caption = 'Cadastro de Clientes'
  ClientHeight = 430
  ClientWidth = 509
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnShow = FormShow
  TextHeight = 15
  object LblTelefones: TLabel
    Left = 232
    Top = 43
    Width = 84
    Height = 23
    Caption = 'Telefones'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object LblDataCadastro: TLabel
    Left = 286
    Top = 393
    Width = 144
    Height = 15
    Caption = 'Cadastrado em: 11/02/2022'
    Visible = False
  end
  object EdtNome: TLabeledEdit
    Left = 8
    Top = 64
    Width = 121
    Height = 23
    EditLabel.Width = 33
    EditLabel.Height = 15
    EditLabel.Caption = 'Nome'
    TabOrder = 0
    Text = ''
  end
  object EdtCPF_CNPJ: TLabeledEdit
    Left = 8
    Top = 168
    Width = 121
    Height = 23
    EditLabel.Width = 21
    EditLabel.Height = 15
    EditLabel.Caption = 'CPF'
    NumbersOnly = True
    TabOrder = 1
    Text = ''
    OnExit = EdtCPF_CNPJExit
  end
  object RgpTipo: TRadioGroup
    Left = 8
    Top = 93
    Width = 185
    Height = 57
    Caption = 'Tipo'
    Items.Strings = (
      'Pessoa Fisica'
      'Pessoa Juridica')
    TabOrder = 2
    StyleElements = []
    OnClick = RgpTipoClick
  end
  object EdtRG_IE: TLabeledEdit
    Left = 8
    Top = 208
    Width = 121
    Height = 23
    EditLabel.Width = 15
    EditLabel.Height = 15
    EditLabel.BiDiMode = bdLeftToRight
    EditLabel.Caption = 'RG'
    EditLabel.ParentBiDiMode = False
    NumbersOnly = True
    TabOrder = 3
    Text = ''
    OnExit = EdtCPF_CNPJExit
  end
  object BtnConsultar: TButton
    Left = 170
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Consultar'
    TabOrder = 4
    OnClick = BtnConsultarClick
  end
  object BtnEditar: TButton
    Left = 89
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Editar'
    TabOrder = 5
    OnClick = BtnEditarClick
  end
  object BtnNovo: TButton
    Left = 8
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Novo'
    TabOrder = 6
    OnClick = BtnNovoClick
  end
  object BtnAtivar: TButton
    Left = 251
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Ativar'
    TabOrder = 7
    OnClick = BtnAtivarClick
  end
  object BtnCancelar: TButton
    Left = 413
    Top = 8
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancelar'
    TabOrder = 8
    OnClick = BtnCancelarClick
  end
  object BtnGravar: TButton
    Left = 332
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Gravar'
    TabOrder = 9
    OnClick = BtnGravarClick
  end
  object DbgTelefones: TDBGrid
    Left = 232
    Top = 72
    Width = 137
    Height = 98
    DataSource = DsTelefones
    Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 10
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'DDD'
        Width = 30
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Telefone'
        Width = 70
        Visible = True
      end>
  end
  object EdtDDD: TLabeledEdit
    Left = 232
    Top = 224
    Width = 41
    Height = 23
    EditLabel.Width = 24
    EditLabel.Height = 15
    EditLabel.BiDiMode = bdLeftToRight
    EditLabel.Caption = 'DDD'
    EditLabel.ParentBiDiMode = False
    NumbersOnly = True
    ReadOnly = True
    TabOrder = 11
    Text = ''
  end
  object EdtTelefone: TLabeledEdit
    Left = 279
    Top = 224
    Width = 74
    Height = 23
    EditLabel.Width = 44
    EditLabel.Height = 15
    EditLabel.BiDiMode = bdLeftToRight
    EditLabel.Caption = 'Telefone'
    EditLabel.ParentBiDiMode = False
    NumbersOnly = True
    ReadOnly = True
    TabOrder = 12
    Text = ''
  end
  object BtnGravarTelefone: TButton
    Left = 232
    Top = 253
    Width = 56
    Height = 25
    Cancel = True
    Caption = 'Gravar'
    TabOrder = 13
    Visible = False
    OnClick = BtnGravarTelefoneClick
  end
  object BtnCancelarTelefone: TButton
    Left = 294
    Top = 253
    Width = 56
    Height = 25
    Cancel = True
    Caption = 'Cancelar'
    TabOrder = 14
    Visible = False
    OnClick = BtnCancelarTelefoneClick
  end
  object BtnNovoTelefone: TButton
    Left = 232
    Top = 176
    Width = 56
    Height = 25
    Cancel = True
    Caption = 'Novo'
    TabOrder = 15
    OnClick = BtnNovoTelefoneClick
  end
  object BtnEditarTelefone: TButton
    Left = 294
    Top = 176
    Width = 56
    Height = 25
    Cancel = True
    Caption = 'Editar'
    TabOrder = 16
    OnClick = BtnEditarTelefoneClick
  end
  object EdtCEP: TLabeledEdit
    Left = 8
    Top = 254
    Width = 121
    Height = 23
    CharCase = ecUpperCase
    EditLabel.Width = 21
    EditLabel.Height = 15
    EditLabel.Caption = 'CEP'
    NumbersOnly = True
    TabOrder = 17
    Text = ''
  end
  object EdtLogradouro: TLabeledEdit
    Left = 8
    Top = 299
    Width = 361
    Height = 23
    EditLabel.Width = 62
    EditLabel.Height = 15
    EditLabel.Caption = 'Logradouro'
    TabOrder = 18
    Text = ''
  end
  object EdtBairro: TLabeledEdit
    Left = 8
    Top = 344
    Width = 273
    Height = 23
    EditLabel.Width = 48
    EditLabel.Height = 15
    EditLabel.Caption = 'EdtBairro'
    TabOrder = 19
    Text = ''
  end
  object EdtCidade: TLabeledEdit
    Left = 287
    Top = 344
    Width = 201
    Height = 23
    EditLabel.Width = 37
    EditLabel.Height = 15
    EditLabel.Caption = 'Cidade'
    TabOrder = 20
    Text = ''
  end
  object EdtEstado: TLabeledEdit
    Left = 8
    Top = 390
    Width = 41
    Height = 23
    EditLabel.Width = 14
    EditLabel.Height = 15
    EditLabel.Caption = 'UF'
    TabOrder = 21
    Text = ''
  end
  object EdtPais: TLabeledEdit
    Left = 55
    Top = 390
    Width = 226
    Height = 23
    EditLabel.Width = 21
    EditLabel.Height = 15
    EditLabel.Caption = 'Pa'#237's'
    TabOrder = 22
    Text = ''
  end
  object EdtNumero: TLabeledEdit
    Left = 375
    Top = 299
    Width = 113
    Height = 23
    EditLabel.Width = 44
    EditLabel.Height = 15
    EditLabel.Caption = 'N'#250'mero'
    TabOrder = 23
    Text = ''
  end
  object BtnConsultaCEP: TButton
    Left = 135
    Top = 253
    Width = 75
    Height = 25
    Caption = 'Buscar'
    TabOrder = 24
    OnClick = BtnConsultaCEPClick
  end
  object BtnExcluir: TButton
    Left = 440
    Top = 389
    Width = 48
    Height = 25
    Caption = 'Excluir'
    TabOrder = 25
    OnClick = BtnExcluirClick
  end
  object MtbTelefones: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 384
    Top = 88
    object MtbTelefonesCodigo: TIntegerField
      FieldName = 'Codigo'
    end
    object MtbTelefonesDDD: TStringField
      FieldName = 'DDD'
      Size = 2
    end
    object MtbTelefonesTelefone: TStringField
      FieldName = 'Telefone'
      Size = 9
    end
  end
  object DsTelefones: TDataSource
    DataSet = MtbTelefones
    Left = 384
    Top = 136
  end
end
