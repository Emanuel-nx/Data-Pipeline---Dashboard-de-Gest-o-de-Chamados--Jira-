import pandas as pd
from sqlalchemy import create_engine
import os
from dotenv import load_dotenv # Importa a biblioteca
import sys

# Carrega as variáveis do arquivo .env
load_dotenv()

# Puxa os dados das variáveis de ambiente
USER = os.getenv('DB_USER')
PASSWORD = os.getenv('DB_PASSWORD')
HOST = os.getenv('DB_HOST')
DATABASE = os.getenv('DB_DATABASE')

try:
    # 1. Criar a conexão (Engine)
    engine = create_engine(f"mysql+pymysql://{USER}:{PASSWORD}@{HOST}/{DATABASE}")
    
    # 2. Extração (Extract)
    # Pega o caminho de onde o script está e sobe um nível para achar a pasta 'data'
    caminho_diretorio = os.path.dirname(os.path.abspath(__file__))
    arquivo_csv = os.path.join(caminho_diretorio, '..', 'data', 'tickets_jira.csv')
    print(f"--- Lendo arquivo: {arquivo_csv} ---")
    df = pd.read_csv(arquivo_csv)

    # 3. Transformação (Transform) - O toque do Engenheiro
    print("--- Padronizando os dados ---")
    # Coloca tudo em maiúsculo e troca espaços por underline (Padrão SQL)
    df.columns = [col.upper().replace(' ', '_').strip() for col in df.columns]
    
    # Exemplo: Se tiver colunas de data como texto, podemos converter aqui
    # df['DATA_CRIACAO'] = pd.to_datetime(df['DATA_CRIACAO'])

    # 4. Carga (Load)
    print("--- Carregando dados no MySQL ---")
    # 'replace' substitui a tabela se ela já existir. 'append' apenas adiciona.
    df.to_sql('stg_tickets_jira', con=engine, if_exists='replace', index=False)

    print("\n✅ SUCESSO: Dados carregados na tabela 'stg_tickets_jira'!")

except Exception as e:
    print(f"\n❌ ERRO: Ocorreu um problema: {e}")
    sys.exit()