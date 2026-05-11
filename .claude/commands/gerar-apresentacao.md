# Gerar Apresentação Executiva — Águas de Ipameri

Gera ou melhora a apresentação PowerPoint executiva do BI Ipameri.

## Como usar

```
/gerar-apresentacao [opções]
```

**Exemplos:**
- `/gerar-apresentacao` — gera com os dados mais recentes
- `/gerar-apresentacao mes=2026-03` — gera para um mês específico
- `/gerar-apresentacao melhorar="slide 5: adicionar grafico de pizza"` — melhora um slide específico
- `/gerar-apresentacao slides="capa,faturamento,inadimplencia"` — gera apenas slides selecionados
- `/gerar-apresentacao abrir=true` — gera e abre o arquivo ao final

---

## Instruções para o agente

Você é responsável por gerar ou melhorar a apresentação executiva PowerPoint do BI Águas de Ipameri.

### Contexto do projeto

- **Script principal:** `scripts/gerar_apresentacao.py`
- **Dados:** pasta `data/` (parquets do BigQuery)
- **Saída:** pasta `Apresentacoes/` (arquivo `.pptx`)
- **Template de referência visual:** `PW Comercial_03.2026.pptx` (pasta Apresentação Indicadores)
- **Diretório raiz:** `C:\BI_Ipameri`

### Regras de design (baseadas no template PW Comercial)

| Elemento | Especificação |
|----------|--------------|
| Tamanho do slide | 20" × 11.25" |
| Cor principal | `#1A6FAD` (azul Águas de Ipameri) |
| Título | 36pt, bold, azul, canto superior esquerdo |
| Caixa de dados | Fundo azul escuro `#0D3B5E`, texto branco/azul claro, canto inferior esquerdo |
| Caixa de insight | Retângulo colorido na base do slide, texto branco, largura parcial à direita |
| Linha decorativa | 4px azul abaixo do título |
| Fundo dos slides | `#F4F6F8` (cinza muito claro) |
| Gráficos | Matplotlib, fundo `#F4F6F8`, sem bordas top/right |

### Slides disponíveis (13 no total)

1. **Capa** — identidade visual institucional
2. **Ligações e Economias** — `nr_economia_agua`, `nr_lig_agua` por mês
3. **Volume Faturado** — `qt_volume_faturado` m³ por mês
4. **Leituras** — `fl_critica`, `fl_erro_leitura`, distribuição
5. **Ticket Médio** — `vl_total_faturado / nr_economia_agua`
6. **Tarifa Média** — `vl_agua / qt_volume_faturado` R$/m³
7. **Faturamento por Componente** — `vl_agua`, `vl_servico_basico_agua`, `vl_servico`, `vl_lixo`
8. **Faturamento Mensal** — evolução 12 meses
9. **Arrecadação e Eficiência** — faturado vs arrecadado + % eficiência
10. **Inadimplência** — `vl_divida` por faixa de atraso
11. **Cortes e Religações** — `dt_fim_execucao`, `dt_reliagacao`
12. **Frota e Combustível** — `Quantidade`, `Valor_Total`, `Km_Rodados`, `Km_Por_Litro`
13. **Encerramento** — resumo de KPIs

### Parquets disponíveis

```
faturamento.parquet         → dt_ref, vl_total_faturado, nr_economia_agua, nr_lig_agua,
                              vl_agua, vl_servico, vl_servico_basico_agua, vl_lixo,
                              qt_volume_faturado, qt_volume_lido
arrecadacao.parquet         → dt_ref, vl_total_arrecadado, vl_agua
pendencia_atual.parquet     → dt_ref_documento, dt_vencimento, vl_divida
cortes.parquet              → dt_fim_execucao
religacoes.parquet          → dt_reliagacao
leituras.parquet            → dt_ref, fl_critica, fl_erro_leitura, id_tipo_leitura,
                              qt_volume_lido, qt_volume_faturado
frota_combustivel.parquet   → Data, Motorista, Veiculo, Modelo, Quantidade,
                              Valor_Total, Km_Rodados, Km_Por_Litro, Custo_Por_Km
```

### Funções auxiliares já implementadas

```python
new_slide(prs)              → slide em branco com fundo #F4F6F8
titulo_slide(sl, titulo, subtitulo)  → título 36pt + linha decorativa + logo
caixa_dados(sl, mes_ref, linhas)     → box azul escuro inf-esq com KPIs
caixa_insight(sl, texto, cor_bg)     → retângulo de insight na base
chart_area()                → (x, y, w, h) para área principal do gráfico
setup_ax(ax)                → estilo padrão matplotlib
fig_to_buf(fig)             → BytesIO da figura para inserir no slide
fmt_R(v)                    → formata reais: "R$ 1,08 Mi"
fmt_n(v)                    → formata número: "11,3K"
```

---

## Passos a executar

### Passo 1 — Entender o pedido

Analise os argumentos passados pelo usuário:

- **Sem argumentos** → executar `python scripts/gerar_apresentacao.py` e reportar resultado
- **`melhorar="..."`** → ler o script atual, aplicar a melhoria descrita, salvar e executar
- **`mes=YYYY-MM`** → ajustar o filtro de período no script e executar
- **`slides="..."`** → verificar se o slide pedido existe; se não, criar no script
- **`abrir=true`** → após gerar, abrir o arquivo com `Start-Process`

### Passo 2 — Para melhorias: ler o script atual

```
Read: scripts/gerar_apresentacao.py
```

Identifique o trecho exato a modificar. Use `Edit` (nunca `Write` completo) para alterações pontuais.

### Passo 3 — Executar

```
cd <diretório raiz>
python scripts/gerar_apresentacao.py
```

Capture a saída. Se houver erro, diagnostique e corrija antes de reportar ao usuário.

### Passo 4 — Reportar

Informe:
- Nome do arquivo gerado
- Tamanho em KB
- Slides incluídos
- Qualquer melhoria aplicada
- Caminho completo para o usuário abrir

---

## Melhorias sugeridas (backlog)

Quando o usuário não especificar o que melhorar, sugira itens deste backlog:

| # | Melhoria | Complexidade |
|---|----------|-------------|
| 1 | Adicionar slide de **Energia Elétrica** (consumo kWh + custo por UC) | Média |
| 2 | Slide de **Serviços Executados** (backlog por tipo/equipe) | Média |
| 3 | **Capa dinâmica** com logo da empresa em imagem real (PNG) | Baixa |
| 4 | **Comparativo anual** (mês atual vs mesmo mês ano anterior) | Alta |
| 5 | Slide de **Mapa de Calor** por bairro (inadimplência/volume) | Alta |
| 6 | **Índice de perdas** (volume lido - volume faturado) | Baixa |
| 7 | Slide de **Meta vs Realizado** (faturamento + arrecadação) | Média |
| 8 | **Tabela de ranking** de motoristas por km/L (frota) | Baixa |
| 9 | **Linha do tempo** de reajustes tarifários | Média |
| 10 | Exportar em **PDF** além de PPTX | Baixa |

---

## Exemplos de pedidos de melhoria

```
/gerar-apresentacao melhorar="adicionar slide de energia eletrica apos o slide 12"
/gerar-apresentacao melhorar="no slide de inadimplencia, adicionar KPI de ticket medio dos inadimplentes"
/gerar-apresentacao melhorar="mudar a cor do insight do slide de eficiencia para verde quando >= 95%"
/gerar-apresentacao melhorar="adicionar logo PNG no canto superior esquerdo da capa"
/gerar-apresentacao melhorar="slide 3: adicionar linha de tendencia no grafico de volume"
```

$ARGUMENTS
