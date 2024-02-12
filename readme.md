# Read Me

Para execução do sistema são necessárias às seguintes dlls:
- ssleay32.dll
- libeay32.dll

---

## Notas

O Banco de dados usado foi o MS SQL Server Express e a conexão com o sistema é configurada no arquivo dpr, pois não houve especificações relacionadas a isso na solicitação do teste. 

Um arquivo sql pode ser encontrado na pasta Banco, esse arquivo constrói as tabelas necessárias para o funcionamento do sistema.

Também implementei e posteriormente removi o uso de uma validação de CPF pois a mesma não foi solcitada nas especificações. Por essa mesma razão também não implementei a validação dos outros documentos.