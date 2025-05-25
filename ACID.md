# Penjelasan Konsep ACID pada Database

**ACID** merupakan akronim dari **Atomicity, Consistency, Isolation,** dan **Durability**. Keempat prinsip ini adalah standar utama yang memastikan setiap transaksi pada sistem basis data berjalan dengan benar, aman, dan dapat diandalkan.

---

## 1. Atomicity (Atomisitas)
Atomicity menjamin bahwa setiap transaksi dalam database diproses secara utuh. Artinya, seluruh operasi di dalam satu transaksi harus berhasil seluruhnya atau tidak dijalankan sama sekali. Jika terjadi kegagalan pada salah satu bagian transaksi, maka seluruh perubahan yang telah dilakukan akan dibatalkan (rollback), sehingga database tetap berada pada kondisi semula.

---

## 2. Consistency (Konsistensi)
Consistency memastikan bahwa setiap transaksi membawa database dari satu keadaan valid ke keadaan valid lainnya, sesuai dengan aturan, constraint, dan integritas data yang telah ditetapkan. Jika suatu transaksi melanggar aturan atau constraint, maka transaksi tersebut akan dibatalkan dan database tetap konsisten.

---

## 3. Isolation (Isolasi)
Isolation menjamin bahwa transaksi yang berjalan secara bersamaan tidak akan saling memengaruhi satu sama lain. Setiap transaksi akan dieksekusi seolah-olah dijalankan sendiri tanpa adanya transaksi lain yang berjalan secara paralel. Hal ini mencegah terjadinya konflik data akibat interaksi antar transaksi.

---

## 4. Durability (Daya Tahan)
Durability memastikan bahwa setelah transaksi dinyatakan berhasil (commit), seluruh perubahan data yang terjadi akan tersimpan secara permanen di dalam database, bahkan jika terjadi kegagalan sistem atau gangguan lainnya. Data yang telah di-commit tidak akan hilang.

---

## Kesimpulan
Penerapan prinsip ACID sangat penting untuk menjaga keandalan, integritas, dan keamanan data pada sistem basis data, terutama dalam lingkungan yang membutuhkan transaksi data secara konsisten dan aman.
