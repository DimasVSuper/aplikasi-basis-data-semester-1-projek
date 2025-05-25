# Penjelasan Normalisasi Database BloodGuard

Normalisasi adalah proses pengelolaan struktur tabel agar data lebih efisien, bebas duplikasi, dan mudah dikelola. Berikut penjelasan normalisasi dari Unnormalized Form (UNF) sampai Third Normal Form (3NF) pada skema database BloodGuard.

---

## 1. Unnormalized Form (UNF)
Pada tahap ini, data masih berupa kumpulan informasi mentah, bisa saja satu tabel berisi data donor, stok, rumah sakit, dan transaksi sekaligus dalam satu baris.

**Contoh UNF:**
| donor_nama | donor_no_hp | stok_jenis | stok_tgl_masuk | rs_nama | transaksi_tgl | ... |
|------------|-------------|------------|----------------|---------|---------------|-----|
| Sarah      | 0811xxxxxxx | PRC        | 2023-12-01     | RS A    | 2023-12-05    | ... |

Data seperti ini rawan duplikasi dan sulit dikelola.

---

## 2. First Normal Form (1NF)
Setiap kolom hanya boleh berisi satu nilai (atomic), tidak ada data yang berupa list/array di satu sel.

**Penerapan di BloodGuard:**  
Setiap tabel sudah memiliki kolom yang atomic, misal: `donor.nama`, `stok_darah.jenis`, dst.

---

## 3. Second Normal Form (2NF)
Sudah memenuhi 1NF, dan setiap atribut non-primer sepenuhnya bergantung pada primary key.

**Penerapan di BloodGuard:**  
Di tabel `stok_darah`, semua kolom (jenis, tgl_masuk, status, dst) bergantung pada `id` stok_darah.  
Tidak ada kolom yang hanya bergantung pada sebagian primary key (karena semua tabel pakai single primary key).

---

## 4. Third Normal Form (3NF)
Sudah memenuhi 2NF, dan tidak ada atribut non-primer yang bergantung pada atribut non-primer lainnya (tidak ada transitive dependency).

**Penerapan di BloodGuard:**  
Di tabel `transaksi`, kolom `rs_id` dan `stok_id` hanya menyimpan id, detail rumah sakit dan stok darah diakses lewat relasi (foreign key).  
Tidak ada kolom seperti "rs_nama" di tabel transaksi, sehingga tidak ada duplikasi data rumah sakit.

---

## **Kesimpulan**
Struktur tabel `donor`, `stok_darah`, `rumah_sakit`, dan `transaksi` pada BloodGuard sudah memenuhi 3NF.  
Setiap entitas utama dipisahkan ke tabel sendiri, relasi antar entitas menggunakan foreign key, dan tidak ada duplikasi data.  
Hasilnya: data lebih konsisten, efisien, dan mudah dikembangkan.