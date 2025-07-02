# 🛡️ Penjelasan Konsep ACID pada Database

**ACID** merupakan akronim dari **Atomicity, Consistency, Isolation,** dan **Durability**. Keempat prinsip ini adalah standar utama yang memastikan setiap transaksi pada sistem basis data berjalan dengan benar, aman, dan dapat diandalkan.

> 💡 **Fun Fact:** ACID adalah fondasi yang membuat database modern dapat diandalkan untuk aplikasi kritis seperti perbankan, e-commerce, dan sistem medis!

---

## ⚛️ 1. Atomicity (Atomisitas)

Atomicity menjamin bahwa setiap transaksi dalam database diproses secara utuh. Artinya, seluruh operasi di dalam satu transaksi harus berhasil seluruhnya atau tidak dijalankan sama sekali.

### 🔄 **Konsep "All or Nothing":**
```sql
-- Contoh Transfer Uang (BloodGuard: Transfer Stok Darah)
BEGIN TRANSACTION;
  UPDATE stok_darah SET status = 'Terpakai' WHERE id = 'stok-001';
  INSERT INTO transaksi (stok_id, rs_id, jenis) VALUES ('stok-001', 'rs-001', 'Keluar');
COMMIT; -- Kedua operasi berhasil

-- Jika ada error, otomatis ROLLBACK - tidak ada perubahan yang tersimpan
```

**⚠️ Tanpa Atomicity:** Stok darah bisa berubah status tanpa tercatat di transaksi = DATA CHAOS!asan Konsep ACID pada Database

**ACID** merupakan akronim dari **Atomicity, Consistency, Isolation,** dan **Durability**. Keempat prinsip ini adalah standar utama yang memastikan setiap transaksi pada sistem basis data berjalan dengan benar, aman, dan dapat diandalkan.

---

## 1. Atomicity (Atomisitas)
Atomicity menjamin bahwa setiap transaksi dalam database diproses secara utuh. Artinya, seluruh operasi di dalam satu transaksi harus berhasil seluruhnya atau tidak dijalankan sama sekali. Jika terjadi kegagalan pada salah satu bagian transaksi, maka seluruh perubahan yang telah dilakukan akan dibatalkan (rollback), sehingga database tetap berada pada kondisi semula.

---

## 🔒 2. Consistency (Konsistensi)

Consistency memastikan bahwa setiap transaksi membawa database dari satu keadaan valid ke keadaan valid lainnya, sesuai dengan aturan, constraint, dan integritas data yang telah ditetapkan.

### 📋 **Aturan Database:**
- **Constraint:** NOT NULL, UNIQUE, CHECK, FOREIGN KEY
- **Business Rules:** Saldo tidak boleh minus, stok darah tidak boleh negatif
- **Data Types:** ENUM('A','B','AB','O') untuk golongan darah

```sql
-- Contoh Constraint di BloodGuard
ALTER TABLE donor ADD CONSTRAINT chk_goldarah 
CHECK (gol_darah IN ('A','B','AB','O'));

-- Jika ada transaksi yang melanggar constraint, otomatis ROLLBACK
```

**✅ Dengan Consistency:** Database selalu dalam keadaan "waras" dan mengikuti aturan!

---

## 🔐 3. Isolation (Isolasi)

Isolation menjamin bahwa transaksi yang berjalan secara bersamaan tidak akan saling memengaruhi satu sama lain. Setiap transaksi akan dieksekusi seolah-olah dijalankan sendiri tanpa adanya transaksi lain yang berjalan secara paralel.

### 🚦 **Isolation Levels:**
| Level | Dirty Read | Non-repeatable Read | Phantom Read |
|-------|------------|-------------------|--------------|
| READ UNCOMMITTED | ✅ | ✅ | ✅ |
| READ COMMITTED | ❌ | ✅ | ✅ |
| REPEATABLE READ | ❌ | ❌ | ✅ |
| SERIALIZABLE | ❌ | ❌ | ❌ |

```sql
-- Contoh Isolation di BloodGuard
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
BEGIN TRANSACTION;
  SELECT * FROM stok_darah WHERE status = 'Tersedia';
  -- Transaksi lain tidak bisa mengubah data yang sedang dibaca
COMMIT;
```

**🛡️ Tanpa Isolation:** Transaksi bisa "ngintip" data kotor dari transaksi lain!

---

## 💾 4. Durability (Daya Tahan)

Durability memastikan bahwa setelah transaksi dinyatakan berhasil (commit), seluruh perubahan data yang terjadi akan tersimpan secara permanen di dalam database, bahkan jika terjadi kegagalan sistem atau gangguan lainnya.

### 🔒 **Mekanisme Durability:**
- **Write-Ahead Logging (WAL):** Log transaksi ditulis sebelum data
- **Checkpoint:** Periodic flush dari memory ke disk
- **Backup & Recovery:** Sistem pemulihan data

```sql
-- Contoh Durability di BloodGuard
BEGIN TRANSACTION;
  INSERT INTO donor (nama, gol_darah) VALUES ('John Doe', 'O');
COMMIT; -- Data sudah PERMANEN tersimpan

-- Walau server restart, data John Doe tetap ada!
```

**🚨 Tanpa Durability:** Data bisa hilang saat listrik padam atau system crash!

---

## 🏆 **Kesimpulan ACID**

### 📊 **Ringkasan Prinsip:**
| Prinsip | Fungsi | Analogi |
|---------|--------|---------|
| **Atomicity** | All or Nothing | ⚛️ Misi Rahasia |
| **Consistency** | Aturan Database | 📋 SOP Ketat |
| **Isolation** | Transaksi Terpisah | 🔐 Ruang Private |
| **Durability** | Data Permanen | 💾 Backup Otomatis |

### 🎯 **Mengapa ACID Penting?**
- ✅ **Keamanan Data:** Tidak ada data yang hilang atau rusak
- ✅ **Integritas:** Data selalu konsisten dan valid
- ✅ **Keandalan:** Database dapat dipercaya untuk aplikasi kritis
- ✅ **Skalabilitas:** Mendukung banyak user secara bersamaan

---

*Penerapan prinsip ACID sangat penting untuk menjaga keandalan, integritas, dan keamanan data pada sistem basis data, terutama dalam lingkungan yang membutuhkan transaksi data secara konsisten dan aman.*
