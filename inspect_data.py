import pandas as pd
import pickle
import numpy as np

# Load data
print("--- MEMBEDAH FILE step_4_start.pkl ---")
with open('step_4_start.pkl', 'rb') as file:
    MIMICtable = pickle.load(file)

# Bersihkan nama kolom (seperti perbaikan kita sebelumnya)
MIMICtable.columns = MIMICtable.columns.str.replace("'", "")
actual_columns = MIMICtable.columns.tolist()

print(f"Total Kolom di Data: {len(actual_columns)}")
print(f"Daftar Kolom: {actual_columns}")
print("-" * 30)

# Daftar Kolom yang WAJIB ADA (Sesuai Core.ipynb)
# Ini adalah standar AI Clinician
required_colbin = ['gender','mechvent','max_dose_vaso','re_admission'] 
required_colnorm= ['age','Weight_kg','GCS','HR','SysBP','MeanBP','DiaBP','RR','Temp_C','FiO2_1',
          'Potassium','Sodium','Chloride','Glucose','Magnesium','Calcium',
          'Hb','WBC_count','Platelets_count','PTT','PT','Arterial_pH','paO2','paCO2',
          'Arterial_BE','HCO3','Arterial_lactate','SOFA','SIRS','Shock_Index','PaO2_FiO2','cumulated_balance'] 
required_collog=['SpO2','BUN','Creatinine','SGOT','SGPT','Total_bili','INR','input_total','input_4hourly','output_total','output_4hourly']

all_required = required_colbin + required_colnorm + required_collog

# Cek mana yang hilang
missing_columns = []
for col in all_required:
    if col not in actual_columns:
        missing_columns.append(col)

print(f"JUMLAH KOLOM HILANG: {len(missing_columns)}")
if len(missing_columns) > 0:
    print("Kolom yang tidak ada di file:")
    for i, col in enumerate(missing_columns, 1):
        print(f"{i}. {col}")
else:
    print("Aneh, semua kolom ada kok!")

print("-" * 30)
print("Analisis Selesai.")