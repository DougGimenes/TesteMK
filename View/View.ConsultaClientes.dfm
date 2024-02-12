inherited FrmConsultaCliente: TFrmConsultaCliente
  Caption = 'Consulta de Clientes'
  TextHeight = 18
  inherited PnlMain: TPanel
    inherited DbgConsulta: TDBGrid
      Top = 72
      Height = 261
      Columns = <
        item
          Expanded = False
          FieldName = 'Nome'
          Width = 430
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'CPF_CNPJ'
          Width = 150
          Visible = True
        end>
    end
    object CkbAtivos: TCheckBox
      Left = 10
      Top = 49
      Width = 159
      Height = 17
      Caption = 'Somente Ativos'
      Checked = True
      State = cbChecked
      TabOrder = 2
    end
  end
  inherited DsConsulta: TDataSource
    DataSet = QryConsulta
  end
  inherited QryConsulta: TFDQuery
    SQL.Strings = (
      'SELECT * FROM CLIENTE')
    object QryConsultaCodigo: TIntegerField
      FieldName = 'Codigo'
    end
    object QryConsultaNome: TStringField
      FieldName = 'Nome'
      Size = 100
    end
    object QryConsultaCPF_CNPJ: TStringField
      DisplayLabel = 'CPF/CNPJ'
      FieldName = 'CPF_CNPJ'
      Size = 14
    end
  end
end
