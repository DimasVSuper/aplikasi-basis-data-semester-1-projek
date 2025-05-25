-- =====================
-- ACID itu singkatan dari:
-- Atomicity (Atomisitas)
-- Semua operasi dalam satu transaksi harus selesai semua (commit) atau tidak sama sekali (rollback).
-- Jadi transaksi itu seperti satu paket utuh, kalau gagal satu bagian, semua dibatalkan supaya data tetap konsisten.

-- Consistency (Konsistensi)
-- Setelah transaksi selesai, database harus tetap dalam keadaan konsisten sesuai aturan, constraint, dan integritas data yang berlaku.
-- Data tidak boleh rusak atau melanggar aturan setelah transaksi.

-- Isolation (Isolasi)
-- Transaksi yang berjalan bersamaan tidak saling mengganggu.
-- Setiap transaksi seolah-olah berjalan sendiri tanpa interferensi dari transaksi lain.

-- Durability (Ketahanan)
-- Setelah transaksi di-commit, perubahan data akan permanen tersimpan walau terjadi kegagalan sistem atau mati listrik.
-- Data tidak boleh hilang setelah transaksi berhasil.



-- ================================
-- RESET DATABASE
-- ================================
DROP DATABASE IF EXISTS bloodguard;
CREATE DATABASE bloodguard;
USE bloodguard;

-- ================================
-- SKENARIO 1: SETUP TABLES
-- ================================

DROP TABLE IF EXIST donor;
CREATE TABLE donor (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    nama VARCHAR(100) NOT NULL,
    no_hp VARCHAR(15),
    gol_darah ENUM('A','B','AB','O') NOT NULL,
    rhesus ENUM('+','-') NOT NULL,
    terakhir_donor DATE
);
desc donor;

DROP TABLE IF EXIST stok_darah;
CREATE TABLE stok_darah (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    donor_id CHAR(36),
    jenis ENUM('Whole Blood','PRC','Plasma','Trombosit') NOT NULL,
    tgl_masuk DATE NOT NULL,
    tgl_expire DATE NOT NULL,
    status ENUM('Tersedia','Terpakai','Expired') DEFAULT 'Tersedia',
    FOREIGN KEY (donor_id) REFERENCES donor(id) ON DELETE SET NULL
);
desc stok_darah;

DROP TABLE IF EXIST rumah_sakit;
CREATE TABLE rumah_sakit (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    nama VARCHAR(100) NOT NULL,
    alamat TEXT
);
desc rumah_sakit;

DROP TABLE IF EXIST transaksi;
CREATE TABLE transaksi (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    stok_id CHAR(36),
    rs_id CHAR(36),
    tgl_transaksi DATETIME DEFAULT NOW(),
    jenis ENUM('Masuk','Keluar') NOT NULL,
    FOREIGN KEY (stok_id) REFERENCES stok_darah(id) ON DELETE SET NULL,
    FOREIGN KEY (rs_id) REFERENCES rumah_sakit(id) ON DELETE SET NULL
);
desc transaksi;

-- ================================
-- SKENARIO 2: DATA DUMMY
-- ================================

INSERT INTO donor (nama, no_hp, gol_darah, rhesus, terakhir_donor) VALUES
('Sarah Putri', '081122334455', 'A', '+', '2023-11-15'),
('Rizky Maulana', '081233445566', 'B', '-', '2023-10-20'),
('Dewi Anggraeni', '081344556677', 'AB', '+', NULL),
('Fajar Setiawan', '081455667788', 'O', '-', '2023-12-05'),
('Nadia Permata', '081566778899', 'A', '-', '2023-09-30');

SELECT * FROM donor;

INSERT INTO stok_darah (donor_id, jenis, tgl_masuk, tgl_expire) VALUES
((SELECT id FROM donor WHERE nama = 'Sarah Putri'), 'Whole Blood', '2023-12-01', '2023-12-31'),
((SELECT id FROM donor WHERE nama = 'Rizky Maulana'), 'PRC', '2023-12-05', '2024-01-04'),
((SELECT id FROM donor WHERE nama = 'Dewi Anggraeni'), 'Plasma', '2023-12-10', '2024-12-09'),
((SELECT id FROM donor WHERE nama = 'Fajar Setiawan'), 'Whole Blood', '2023-12-15', '2024-01-14'),
((SELECT id FROM donor WHERE nama = 'Nadia Permata'), 'Trombosit', '2023-12-20', '2023-12-25');

SELECT * FROM stok_darah;
SELECT stok_darah.donor_id, donor.id AS kecocokan
FROM stok_darah
JOIN donor ON stok_darah.donor_id = donor.id;

INSERT INTO rumah_sakit (nama, alamat) VALUES
('RS. Sejahtera', 'Jl. Merdeka No. 123'),
('RS. Bunda Mulia', 'Jl. Kenangan No. 45'),
('RS. Permata Hati', 'Jl. Cendrawasih No. 67');

SELECT * FROM rumah_sakit;

-- ================================
-- SKENARIO 3: OPERASIONAL
-- ================================

-- 1. Pendaftar Baru
INSERT INTO donor (nama, no_hp, gol_darah, rhesus) 
VALUES ('Budi Santoso', '081677889900', 'O', '+');
SELECT * FROM donor WHERE nama = 'Budi Santoso';

-- 2. Input Stok Darah Baru
INSERT INTO stok_darah (donor_id, jenis, tgl_masuk, tgl_expire)
SELECT id, 'Whole Blood', CURDATE(), DATE_ADD(CURDATE(), INTERVAL 35 DAY)
FROM donor WHERE nama = 'Budi Santoso';
SELECT * FROM stok_darah WHERE donor_id = (SELECT id FROM donor WHERE nama = 'Budi Santoso');

-- 3. Distribusi Darah ke RS
START TRANSACTION;

SET @stok_id := (SELECT id FROM stok_darah WHERE status = 'Tersedia' AND jenis = 'Whole Blood' LIMIT 1);

INSERT INTO transaksi (stok_id, rs_id, jenis)
VALUES (@stok_id, (SELECT id FROM rumah_sakit WHERE nama = 'RS. Sejahtera'), 'Keluar');

UPDATE stok_darah SET status = 'Terpakai' WHERE id = @stok_id;
-- ROLLBACK(Gunakan bila salah satu Transaksi Error!)
COMMIT;



-- 4. Cek Stok Darah Tersedia
SELECT d.gol_darah, d.rhesus, s.jenis, COUNT(*) as jumlah
FROM stok_darah s
JOIN donor d ON s.donor_id = d.id
WHERE s.status = 'Tersedia'
GROUP BY d.gol_darah, d.rhesus, s.jenis;

-- 5. Cari Donor Golongan O-
SELECT * FROM donor WHERE gol_darah = 'O' AND rhesus = '-';

-- 6. Update Data Donor
UPDATE donor SET no_hp = '081688990011' WHERE nama = 'Nadia Permata';
SELECT * FROM donor WHERE nama = 'Nadia Permata';

-- 7. Hapus Data Donor
SELECT id FROM stok_darah WHERE donor_id = (SELECT id FROM donor WHERE nama = 'Fajar Setiawan');
DELETE FROM transaksi WHERE stok_id IN (
    SELECT id FROM stok_darah WHERE donor_id = (SELECT id FROM donor WHERE nama = 'Fajar Setiawan')
);
DELETE FROM stok_darah WHERE donor_id = (SELECT id FROM donor WHERE nama = 'Fajar Setiawan');
DELETE FROM donor WHERE nama = 'Fajar Setiawan';
-- Pengecheckan apakah Fajar Setiawan
SELECT * FROM donor WHERE nama = 'Fajar Setiawan';
SELECT * FROM stok_darah WHERE donor_id = (SELECT id FROM donor WHERE nama = 'Fajar Setiawan');
SELECT * FROM transaksi WHERE stok_id = (SELECT id FROM donor WHERE nama = 'Fajar Setiawan');
SELECT * FROM donor where nama = 'Fajar Setiawan';

-- 8. Cek Darah Expired
SELECT * FROM stok_darah WHERE tgl_expire < CURDATE() AND status = 'Tersedia';

-- 9. Update Status Expired
UPDATE stok_darah SET status = 'Expired' WHERE tgl_expire < CURDATE() AND status = 'Tersedia';
SELECT * FROM stok_darah WHERE status = 'Expired';

-- 10. Riwayat Transaksi RS
SELECT rs.nama, t.tgl_transaksi, s.jenis 
FROM transaksi t
JOIN rumah_sakit rs ON t.rs_id = rs.id
JOIN stok_darah s ON t.stok_id = s.id;

-- 11. Total Donor per Golongan Darah
SELECT gol_darah, rhesus, COUNT(*) as total_donor
FROM donor
GROUP BY gol_darah, rhesus;

-- 12. Donor Lama Tidak Donor
SELECT nama, gol_darah, rhesus, terakhir_donor
FROM donor
WHERE terakhir_donor < DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
OR terakhir_donor IS NULL;

-- 13. Input Donor + Tanggal Terakhir Donor
INSERT INTO donor (nama, no_hp, gol_darah, rhesus, terakhir_donor)
VALUES ('Citra Dewi', '081799001122', 'AB', '-', '2023-07-10');
SELECT * FROM donor WHERE nama = 'Citra Dewi';

-- 14. Cek Stok Akan Expired (3 hari lagi)
SELECT * FROM stok_darah
WHERE tgl_expire BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 3 DAY)
AND status = 'Tersedia';

-- 15. Ketersediaan Darah Spesifik
SELECT COUNT(*) as tersedia
FROM stok_darah s
JOIN donor d ON s.donor_id = d.id
WHERE d.gol_darah = 'A' AND d.rhesus = '+' 
AND s.jenis = 'Whole Blood' AND s.status = 'Tersedia';

-- 16. Update Rumah Sakit
UPDATE rumah_sakit
SET alamat = 'Jl. Bahagia No. 89'
WHERE nama = 'RS. Bunda Mulia';
SELECT * FROM rumah_sakit WHERE nama = 'RS. Bunda Mulia';

-- 17. Hapus Rumah Sakit
DELETE FROM rumah_sakit WHERE nama = 'RS. Permata Hati';
SELECT * FROM rumah_sakit WHERE nama = 'RS. Permata Hati';

-- 18. Transaksi Terakhir
SELECT * FROM transaksi ORDER BY tgl_transaksi DESC LIMIT 5;

-- 19. Laporan Bulanan
SELECT 
    MONTH(tgl_transaksi) as bulan,
    COUNT(*) as total_transaksi,
    SUM(CASE WHEN jenis = 'Masuk' THEN 1 ELSE 0 END) as masuk,
    SUM(CASE WHEN jenis = 'Keluar' THEN 1 ELSE 0 END) as keluar
FROM transaksi
WHERE YEAR(tgl_transaksi) = YEAR(CURDATE())
GROUP BY MONTH(tgl_transaksi);

-- 20. Donor dengan Jumlah Stok
SELECT d.nama, COUNT(s.id) as jumlah_stok
FROM donor d
LEFT JOIN stok_darah s ON d.id = s.donor_id
GROUP BY d.nama
ORDER BY jumlah_stok DESC;