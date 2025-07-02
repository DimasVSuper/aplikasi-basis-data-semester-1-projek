# 🩸 Penjelasan Normalisasi Database BloodGuard

Normalisasi adalah proses sistematis untuk mengorganisir struktur tabel agar data lebih efisien, bebas duplikasi, dan mudah dikelola. Berikut penjelasan tahapan normalisasi dari **Unnormalized Form (UNF)** hingga **Third Normal Form (3NF)** pada skema database BloodGuard.

---

## 📋 1. Unnormalized Form (UNF)

Pada tahap ini, semua data masih bercampur dalam satu struktur tanpa pemisahan yang jelas. Data donor, stok darah, rumah sakit, dan transaksi bisa saja berada dalam satu tabel yang sama.

### 🔍 Contoh UNF:
| donor_nama | donor_no_hp | stok_jenis | stok_tgl_masuk | rs_nama | transaksi_tgl |
|------------|-------------|------------|----------------|---------|---------------|
| Sarah Putri | 0811223344 | PRC | 2023-12-01 | RS Harapan | 2023-12-05 |
| Sarah Putri | 0811223344 | Plasma | 2023-12-10 | RS Husada | 2023-12-15 |

**⚠️ Masalah:** Data berulang, sulit maintenance, dan boros storage.

---

## ⚛️ 2. First Normal Form (1NF)

Setiap kolom hanya berisi **satu nilai atomik** (tidak dapat dipecah lagi). Tidak ada data berupa list atau array dalam satu sel.

### ✅ **Penerapan di BloodGuard:**
- `donor.nama` → "Sarah Putri" ✓
- `donor.gol_darah` → "A" ✓  
- `stok_darah.jenis` → "PRC" ✓

**Hasil:** Setiap field berisi data tunggal yang tidak dapat dipecah lagi.

---

## 🔗 3. Second Normal Form (2NF)

Sudah memenuhi **1NF** + setiap atribut non-primer **sepenuhnya bergantung** pada primary key (tidak ada partial dependency).

### ✅ **Penerapan di BloodGuard:**
```sql
-- Tabel stok_darah
CREATE TABLE stok_darah (
    id CHAR(36) PRIMARY KEY,     -- Primary Key
    donor_id CHAR(36),           -- Fully dependent on 'id'
    jenis ENUM(...),             -- Fully dependent on 'id'
    tgl_masuk DATE,              -- Fully dependent on 'id'
    status ENUM(...)             -- Fully dependent on 'id'
);
```

**Hasil:** Semua kolom bergantung penuh pada primary key, bukan sebagian.

---

## 🎯 4. Third Normal Form (3NF)

Sudah memenuhi **2NF** + tidak ada **transitive dependency** (atribut non-primer tidak bergantung pada atribut non-primer lainnya).

### ✅ **Penerapan di BloodGuard:**
```sql
-- ❌ SALAH: Menyimpan nama RS di tabel transaksi
CREATE TABLE transaksi_buruk (
    id CHAR(36) PRIMARY KEY,
    rs_id CHAR(36),
    rs_nama VARCHAR(100),  -- Transitive dependency!
    rs_alamat TEXT         -- Transitive dependency!
);

-- ✅ BENAR: Relasi dengan foreign key
CREATE TABLE transaksi (
    id CHAR(36) PRIMARY KEY,
    rs_id CHAR(36),        -- Hanya ID, detail di tabel rumah_sakit
    FOREIGN KEY (rs_id) REFERENCES rumah_sakit(id)
);
```

**Hasil:** Data rumah sakit hanya ada di tabel `rumah_sakit`, tidak duplikasi.

---

## 🏆 **Kesimpulan**

### ✨ **Status Normalisasi BloodGuard:**
| Tabel | 1NF | 2NF | 3NF | Status |
|-------|-----|-----|-----|--------|
| `donor` | ✅ | ✅ | ✅ | **3NF** |
| `stok_darah` | ✅ | ✅ | ✅ | **3NF** |
| `rumah_sakit` | ✅ | ✅ | ✅ | **3NF** |
| `transaksi` | ✅ | ✅ | ✅ | **3NF** |

### 🎯 **Keuntungan Normalisasi 3NF:**
- 🚫 **Tanpa duplikasi data**
- 🔧 **Mudah maintenance**
- 📊 **Data konsisten**
- 🚀 **Performa optimal**
- 🔗 **Relasi terstruktur dengan foreign key**

---

*Database BloodGuard telah menerapkan standar normalisasi 3NF untuk memastikan integritas dan efisiensi data yang optimal.*