# Sistema de Despacho de Ambulâncias

Resumo rápido com instruções para replicar o projeto localmente.

Repositório/arquivos principais:
- [app.py](app.py)
- [persistence.py](persistence.py) — contém a função de conexão e operações CRUD (`persistence.connect_bd`, `persistence.select_all_df`, `persistence.create`, `persistence.update`, `persistence.delete`)
- [sql/bombeiro.sql](sql/bombeiro.sql) — DDL + dados de exemplo (gerado no MySQL Workbench 8.0)
- [requirements.txt](requirements.txt)

Pré-requisitos
- Python 3.10+ instalado
- MySQL Server (ex.: MySQL 8.0) instalado
- MySQL Workbench 8.0 (opcional, usado para gerar/importar o arquivo SQL)

1) Criar e ativar um ambiente virtual Python
- Windows (cmd):
  - python -m venv .venv
  - .venv\Scripts\activate
- macOS / Linux:
  - python3 -m venv .venv
  - source .venv/bin/activate
- Atualizar pip:
  - python -m pip install --upgrade pip

2) Instalar dependências
- Com o ambiente virtual ativado:
  - pip install -r requirements.txt

3) Criar o banco de dados e carregar dados
- O arquivo [sql/bombeiro.sql](sql/bombeiro.sql) contém a criação do schema, tabelas, triggers, procedure e dados de exemplo.
- Observação: o arquivo foi gerado com MySQL Workbench 8.0 — recomenda-se abrir/importar e executar o script no Workbench ou rodar pelo cliente mysql:
  - No Workbench: abra o arquivo e execute (Run SQL Script).
  - Pelo terminal mysql:
    - mysql -u root -p < sql/bombeiro.sql
- Atenção ao nome do banco: o script cria o banco `GestaoAmbulancias`. A função de conexão em [`persistence.connect_bd`](persistence.py) usa por padrão `gestaoambulancias` (lowercase). Ajuste um dos dois para garantir correspondência:
  - alterar o parâmetro `database` em `persistence.connect_bd(...)` para `GestaoAmbulancias`, ou
  - editar o script SQL para usar `gestaoambulancias`.

4) Configurar credenciais de conexão
- Por padrão `persistence.connect_bd()` usa user='root', password='', host='127.0.0.1', port=3306.
- Altere chamadas ou modifique o arquivo [`persistence.py`](persistence.py) para fornecer usuário/senha corretos.

5) Executar a aplicação Streamlit
- Com o ambiente virtual ativado e banco pronto:
  - streamlit run app.py
- A interface web permite visualizar tabelas e executar operações CRUD usando as funções em [`persistence.py`](persistence.py), por exemplo [`persistence.select_all_df`](persistence.py), [`persistence.create`](persistence.py), [`persistence.update`](persistence.py), [`persistence.delete`](persistence.py).

Notas rápidas
- Se ocorrerem erros de permissões/usuário, verifique as mensagens retornadas pela função `persistence.connect_bd`.
- Em ambiente Windows o MySQL geralmente trata nomes de banco case-insensitivamente, mas em Linux há diferenças — por segurança, mantenha nomes consistentes.

Fim.