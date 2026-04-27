# 📊 Data Pipeline & Dashboard de Gestão de Chamados (Jira)

## 📝 Sobre o Projeto
Este projeto automatiza a extração, transformação e visualização de dados de suporte N2 da **RankMyAPP**. O objetivo é transformar dados brutos de tickets do Jira em insights estratégicos para a liderança, utilizando um pipeline de dados robusto e métricas avançadas de BI.

## 🏗️ Arquitetura do Pipeline
1. **Extração:** Dados brutos exportados do Jira em formato CSV.
2. **ETL (Python):** Script automatizado que limpa, padroniza e carrega os dados no banco de dados.
3. **Data Warehouse (MySQL):** Armazenamento estruturado e criação de Views otimizadas para análise.
4. **BI (Power BI):** Dashboard interativo com modelagem Star Schema e inteligência de tempo.

## 🛠️ Tecnologias Utilizadas
* **Linguagem:** Python 3.x (Pandas, SQLAlchemy)
* **Banco de Dados:** MySQL
* **Visualização:** Power BI (DAX Avançado)
* **Metodologia:** Modelagem Dimensional (Star Schema)

## 📈 Insights Gerados
* **Análise de Pareto (80/20):** Identificação das categorias que geram a maior carga de trabalho, permitindo foco em automações prioritárias.
* **Métrica WoW (Week over Week):** Monitoramento da variação de demanda semanal para ajuste de escala do time.
* **Tooltips Dinâmicos:** Detalhamento por aplicação (App) sem poluir o visual principal.

## 🗄️ Modelagem de Dados
O modelo segue o padrão **Estrela (Star Schema)**:
- **Fato:** `v_tickets_limpos` (Histórico de tickets).
- **Dimensão:** `Calendario` (Inteligência de tempo).

## 🚀 Como Executar
1. Instale as dependências: `pip install -r requirements.txt`
2. Configure as credenciais no script `scripts/carga_jira.py`.
3. Execute o script de carga.
4. Abra o arquivo `.pbix` e atualize os dados.

---
**Desenvolvido por:** Emanuel Nogueira
*Suporte N2 | Aspirante a Engenheiro de Dados*
