### Tugas 7

1. Widget tree adalah susunan hierarkis widget yang mendeskripsikan antarmuka. Widget induk membungkus atau mengatur widget anak melalui properti seperti `child`, `children`, `home`, dan `body`. Contohnya, `MyApp` membangun `MaterialApp`, yang menampilkan `MyHomePage` sebagai `home`. Halaman tersebut membangun `Scaffold` dengan `AppBar` dan isi halaman. `Column` menyusun beberapa anak secara vertikal, sedangkan `Padding` memberikan ruang di sekitar satu anak. Dalam layout, batas ukuran mengalir dari induk ke anak, anak menentukan ukurannya dalam batas itu, lalu induk menentukan posisi anak. Perubahan konfigurasi dapat memicu pembangunan ulang bagian tree yang terkait.
2. Berikut semua jenis widget yang ditulis langsung dalam implementasi aplikasi:
`MyApp` | Widget kustom akar yang membangun konfigurasi aplikasi. 
`MaterialApp` | Menyediakan konteks aplikasi Material, tema, dan halaman awal. 
`MyHomePage` | Widget kustom halaman profil dan menu utama. 
`Scaffold` | Kerangka halaman untuk app bar, body, dan penyajian SnackBar. 
`AppBar` | Bilah judul MyPortfolio. 
`Text` | Menampilkan judul, identitas, label menu, dan pesan. 
`SafeArea` | Menghindarkan konten dari area sistem seperti notch. 
`SingleChildScrollView` | Membuat isi halaman bisa digulir ketika melebihi tinggi layar.
`LayoutBuilder` | Membaca batas lebar dari induk untuk menentukan susunan kartu. 
`Column` | Menata anak secara vertikal. 
`Wrap` | Menata kartu dan memindahkan kartu ke baris selanjutnya jika ruang tidak cukup. 
`SizedBox` | Mengatur lebar kartu dan memberi jarak antarbagian. 
`InfoCard` | Widget kustom untuk pasangan label dan nilai identitas. 
`Card` | Permukaan kartu informasi dengan elevasi. 
`Padding` | Memberi ruang di sekeliling isi kartu. 
`ItemCard` | Widget kustom untuk satu tombol aksi portofolio. 
`Material` | Memberi warna latar serta permukaan tempat efek tinta tombol digambar. 
`InkWell` | Menangani ketukan dan memberikan umpan balik visual. 
`Icon` | Menampilkan simbol folder, tambah, atau logout.  
`SnackBar` | Menampilkan pesan sementara setelah tombol ditekan. 

Semua widget kustom tersebut mewarisi `StatelessWidget`. `Theme` dan `ScaffoldMessenger` diakses melalui `.of(context)`; keduanya tersedia dari struktur aplikasi, bukan dibuat langsung dalam metode `build` proyek ini. `ItemHomepage` merupakan model data, sedangkan `Color`, `TextStyle`, `EdgeInsets`, dan `ThemeData` merupakan objek konfigurasi, bukan widget.
3. `MaterialApp` mempersiapkan aplikasi dengan konvensi Material Design, termasuk tema, navigasi, lokalisasi, dan dukungan komponen Material. Pada proyek ini, `title` menentukan nama aplikasi, `theme` mengatur skema warna dan Material 3, serta `home` memilih `MyHomePage` sebagai halaman awal. Widget ini lazim diletakkan dekat akar agar konfigurasi dan layanan tersebut tersedia bagi halaman-halaman di bawahnya. Akar yang diberikan ke `runApp` di proyek ini adalah `MyApp`, lalu `MyApp` membangun `MaterialApp`. MaterialApp tidak wajib untuk semua aplikasi Flutter, tetapi sesuai untuk aplikasi yang memakai komponen Material seperti proyek ini.
4. `StatelessWidget` tidak memiliki objek state internal yang bisa diubah untuk memperbarui UI. Tampilannya ditentukan oleh konfigurasi dan konteks saat `build` dipanggil. Stateless bukan berarti hanya dibangun sekali: perubahan dari induk atau dependensi seperti tema tetap dapat menyebabkan rebuild. Pilih ini untuk tampilan yang tidak perlu mengelola state lokal, misalnya kartu identitas dan menu utama saat ini.
`StatefulWidget` memiliki objek `State` terpisah yang bertahan selama identitas widget dipertahankan dalam tree. Ketika data lokal berubah, `setState` memberi tahu framework untuk menjadwalkan rebuild. Gunakan ini untuk counter, pilihan filter, atau form dengan state lokal yang berubah. Konfigurasi StatefulWidget sendiri tetap immutable; data yang berubah disimpan di State. Menu tugas ini tetap StatelessWidget karena ketukan hanya meminta ScaffoldMessenger menampilkan SnackBar, bukan mengubah data halaman.
5. `BuildContext` adalah pegangan ke lokasi widget di tree. Lokasi ini penting saat mencari layanan atau konfigurasi dari ancestor. Parameter `context` pada `build(BuildContext context)` memungkinkan `Theme.of(context)` mengambil tema terdekat; callback tombol menggunakan `ScaffoldMessenger.of(context)` untuk menampilkan SnackBar melalui messenger yang menaungi halaman. Context harus berada di bawah ancestor yang dibutuhkan. Context milik widget pembangun tidak otomatis menjadi context anak yang baru dikembalikan oleh build; bila memerlukan lokasi di bawah widget baru, dapat memakai `Builder` atau widget anak tersendiri. Setelah operasi asynchronous, periksa `context.mounted` sebelum menggunakannya kembali. Rujukan: [BuildContext API](https://api.flutter.dev/flutter/widgets/BuildContext-class.html).

6. **Hot reload, hot restart, dan full restart**

   Hot reload menerapkan perubahan kode Dart dan membangun ulang UI sambil mempertahankan state aplikasi. Ini cocok untuk mengubah teks, warna kartu, atau susunan widget saat debugging. Hot reload tidak menjalankan ulang `main()` atau `initState()`, sehingga perubahan inisialisasi mungkin belum terlihat.

   Hot restart memulai ulang aplikasi Dart dan menghapus state yang sedang berjalan. Gunakan ketika perlu menjalankan kembali main/initState atau ketika perubahan struktur tipe tertentu tidak didukung hot reload. Full restart menghentikan lalu menjalankan aplikasi kembali, termasuk kompilasi ulang bagian platform yang diperlukan. Perubahan kode native Kotlin, Java, Swift, atau Objective-C memerlukan full restart; penambahan plugin dengan komponen native juga perlu rebuild platform. Rujukan: [Flutter hot reload](https://docs.flutter.dev/tools/hot-reload).

## Penggunaan AI
Ringkasan log bantuan AI:
Menyusun tes identitas, warna tombol, pesan SnackBar, dan interaksi pada layar kecil
