# BloodGuard - Sistem Manajemen Bank Darah - Dimas Bayu Nugroho
[![GitHub Repo](https://img.shields.io/badge/GitHub-Repository-blue?logo=github)](https://github.com/DimasVSuper/aplikasi-basis-data-semester-1-projek) [![MySQL](https://img.shields.io/badge/MySQL-Database-orange?logo=mysql)](https://www.mysql.com/) [![XAMPP](https://img.shields.io/badge/XAMPP-Server-orange?logo=apache)](https://www.apachefriends.org/)

## Deskripsi
BloodGuard adalah aplikasi basis data untuk manajemen stok darah, donor, dan distribusi darah ke rumah sakit. Sistem ini dirancang untuk memudahkan pengelolaan data donor, stok darah, transaksi distribusi, serta pelaporan pada bank darah. Aplikasi ini menggunakan MySQL sebagai database dan XAMPP sebagai server lokal.

## Fitur Utama
- Manajemen data donor dan stok darah.
- Distribusi darah ke rumah sakit.
- Pelaporan stok, transaksi, dan donor.
- Update status darah (tersedia, terpakai, expired).
- Query analisis dan laporan bulanan.


## Anggota Kelompok
- Dimas Bayu Nugroho(Database Administrator/Researcher)
- Nama 2 (NIM)
- Nama 3 (NIM)
- Nama 4 (NIM)
- Nama 5 (NIM)


## Tech Stack
- **Database:** MySQL (via XAMPP)
- **Server:** XAMPP (Apache, MySQL)
- **Bahasa SQL:** MySQL Syntax

## Cara Penggunaan
1. **Install XAMPP** di komputer Anda.
2. **Jalankan Apache dan MySQL** melalui XAMPP Control Panel.
3. **Import file `bloodguard.sql`** ke database MySQL menggunakan phpMyAdmin atau command line:
   - Buka phpMyAdmin, buat database baru bernama `bloodguard`.
   - Import file `bloodguard.sql`.
4. **Database siap digunakan** untuk pengembangan aplikasi atau query operasional.

## Struktur Database
- **donor:** Data pendonor darah.
- **stok_darah:** Stok darah yang tersedia dan riwayatnya.
- **rumah_sakit:** Data rumah sakit penerima darah.
- **transaksi:** Catatan distribusi darah ke rumah sakit.



## 📚 Daftar Pustaka

### 📘 [WHO: Blood Donor Selection – Guidelines on Assessing Donor Suitability for Blood Donation (2012)](https://apps.who.int/iris/bitstream/handle/10665/76724/9789241548519_eng.pdf)
Panduan resmi dari World Health Organization (WHO) mengenai kriteria dan prosedur penilaian kelayakan donor darah. Membahas penilaian risiko infeksi, riwayat medis donor, serta kebijakan nasional terkait donor darah.

- [Unduh PDF Resmi WHO](https://apps.who.int/iris/bitstream/handle/10665/76724/9789241548519_eng.pdf)

---

### 📕 [AABB: Standards for Blood Banks and Transfusion Services, 32nd Edition (2020)](https://www.aabb.org/aabb-store/product/bundle-standards-for-blood-banks-and-transfusion-services-32nd-edition-print-and-standards-for-blood-banks-and-transfusion-services-32nd-edition-portal-14628378)
Standar praktik terkini dari American Association of Blood Banks (AABB) untuk bank darah dan layanan transfusi. Edisi ke-32 ini mencakup sistem mutu, persyaratan teknis, serta kalibrasi dan pemeliharaan peralatan penting.

- [Sampel PDF (Pratinjau)](https://marketplace.aabb.org/PRODUCTFILES/14626539/203120_sam.pdf)
- [Halaman Produk Resmi AABB](https://www.aabb.org/aabb-store/product/bundle-standards-for-blood-banks-and-transfusion-services-32nd-edition-print-and-standards-for-blood-banks-and-transfusion-services-32nd-edition-portal-14628378)

---



> Untuk detail query dan skenario penggunaan, lihat file [bloodguard.sql](./bloodguard.sql).