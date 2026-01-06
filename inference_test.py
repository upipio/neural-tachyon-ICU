import numpy as np
import pickle
import warnings

# Matikan warning scikit-learn version mismatch (biasanya muncul beda versi)
warnings.filterwarnings("ignore")

def load_model():
    print("Sedang memuat otak AI (bestpol.pkl)...")
    try:
        # Load file hasil training
        with open('bestpol.pkl', 'rb') as file:
            modl = pickle.load(file)
            Qon = pickle.load(file)          # Q-Value Matrix (Kecerdasan)
            physpol = pickle.load(file)
            transitionr = pickle.load(file)
            transitionr2 = pickle.load(file)
            R = pickle.load(file)
            C = pickle.load(file)            # Model Clustering (K-Means)
            # Sisanya kita skip karena tidak dipakai untuk inference
            
        print("Model berhasil dimuat!")
        return C, Qon
    except FileNotFoundError:
        print("ERROR: File 'bestpol.pkl' tidak ditemukan. Training dulu!")
        return None, None

def get_action_recommendation(kmeans_model, q_matrix, patient_data):
    # 1. Tentukan Cluster/State pasien ini (Mirip kondisi nomor berapa?)
    # Input harus array 2D, makanya di-reshape
    state_id = kmeans_model.predict(patient_data.reshape(1, -1))[0]
    
    # 2. Cari Aksi Terbaik untuk State tersebut dari Q-Matrix
    # Qon bentuknya (States, Actions). Kita cari nilai tertinggi di baris state_id
    best_action_id = np.argmax(q_matrix[state_id, :])
    
    return state_id, best_action_id

if __name__ == "__main__":
    # 1. Load Model
    kmeans, q_values = load_model()
    
    if kmeans is not None:
        # 2. Buat Data Pasien "Pura-pura" (Dummy)
        # Ingat, input harus 47 fitur yang SUDAH dinormalisasi (Z-Score)
        # Disini kita pakai data random dulu cuma buat tes jalan/enggak
        print("\n--- Simulasi Pasien Masuk ---")
        dummy_patient = np.random.rand(47) 
        
        # 3. Minta Rekomendasi AI
        state, action = get_action_recommendation(kmeans, q_values, dummy_patient)
        
        # 4. Tampilkan Hasil
        print(f"Kondisi Pasien masuk ke Cluster ID : {state}")
        print(f"Rekomendasi Aksi dari AI (0-24)    : {action}")
        
        print("\n--- Penjelasan untuk Teman ---")
        print("Output 'Rekomendasi Aksi' adalah angka 0-24.")
        print("Nanti angka ini harus dipetakan balik ke dosis obat.")
        print("Contoh kasar: 0=Dosis Rendah, 24=Dosis Tinggi (Perlu mapping table).")