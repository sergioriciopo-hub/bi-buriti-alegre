import pandas as pd

lei = pd.read_parquet(r'C:\BI_BuritiAlegre\data\leituras.parquet')
lei['dt_ref'] = pd.to_datetime(lei['dt_ref'])

abr = lei[lei['dt_ref'].dt.to_period('M') == '2026-04'].copy()

# Detalhes do outlier
print("=== REGISTRO OUTLIER (99998 m3) ===")
outlier = abr[abr['qt_volume_lido'] >= 90000]
print(outlier.to_string())
print()

# fl_erro_leitura - distribuicao geral
print("=== fl_erro_leitura - distribuicao geral ===")
print(lei['fl_erro_leitura'].value_counts())
print()

# fl_erro_leitura em abril
print("=== fl_erro_leitura em Abril/2026 ===")
print(abr['fl_erro_leitura'].value_counts())
print()

# Se filtrar fl_erro_leitura, qual impacto em abril?
abr_limpo = abr[abr['fl_erro_leitura'] != True]
print(f"Abril SEM erros: {len(abr_limpo)} registros | Lido={abr_limpo['qt_volume_lido'].sum():,.0f} | Fat={abr_limpo['qt_volume_faturado'].sum():,.0f}")
print(f"Abril COM erros: {len(abr)} registros      | Lido={abr['qt_volume_lido'].sum():,.0f} | Fat={abr['qt_volume_faturado'].sum():,.0f}")
print()

# Verificar se ha leitura corrigida para o mesmo cliente em mes seguinte
print("=== Resumo mensal SEM fl_erro_leitura ===")
lei_ok = lei[lei['fl_erro_leitura'] != True]
mensal_ok = lei_ok.groupby(lei_ok['dt_ref'].dt.to_period('M'))[['qt_volume_lido','qt_volume_faturado']].sum()
print(mensal_ok.tail(12).to_string())
