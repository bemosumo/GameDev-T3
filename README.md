# Tutorial Game Development (Tutorial 3 & 5)

**Nama:** Muhammad Fawwaz Edsa Fatin S  
**NPM:** 2306275582  

---

<details>
<summary><h2>Tutorial 3 - Introduction to Game Programming</h2></summary>

Pada tutorial ini, saya telah mengimplementasikan mekanika pergerakan dasar 2D platformer (kiri, kanan, gravitasi, dan lompat), serta mengeksplorasi beberapa mekanika lanjutan untuk memenuhi kriteria Latihan Mandiri.

Berikut adalah fitur lanjutan yang telah saya kembangkan beserta penjelasan implementasinya:

### 1. Double Jump
Karakter dapat melompat maksimal dua kali sebelum menyentuh tanah.
* **Proses Pengerjaan:** Saya menambahkan variabel `max_jumps = 2` dan `jump_count = 0`. Setiap kali karakter berada di lantai (`is_on_floor()`), `jump_count` di-reset menjadi 0. Ketika tombol lompat ditekan (`ui_up`), sistem akan mengecek apakah `jump_count < max_jumps`. Jika iya, karakter akan melompat dan `jump_count` bertambah 1.

### 2. Crouch
Karakter dapat berjongkok ketika berada di tanah, yang akan memperlambat kecepatan berjalannya dan mengubah pose karakternya.
* **Proses Pengerjaan:** Jika karakter berada di lantai dan tombol bawah ditekan (`ui_down`), variabel `is_crouching` menjadi `true`. Kecepatan berjalan karakter diubah menggunakan nilai `crouch_speed` (lebih lambat dari `walk_speed`). Animasi karakter juga diubah menjadi pose jongkok (`duck`).

### 3. Dash
Karakter dapat bergerak lebih cepat menggunakan tombol konfirmasi (seperti *Enter/Space*), disertai dengan efek visual *skidding*.
* **Proses Pengerjaan:** Menggunakan deteksi input `ui_accept`. Ketika ditahan, kecepatan horizontal dikalikan dengan `dash_multiplier`. Animasi diubah menjadi pose *dash/skid*. 
* **Polishing Khusus:** Saya menambahkan logika pembalikan arah (mirroring) khusus saat mode *dash*. Jika karakter meluncur ke kiri, gambar sprite menghadap ke kanan (`flip_h = false`), begitu juga sebaliknya agar arah meluncur karakter membelakangi gaya geseknya.

### 4. Polishing
Saya membuat sistem penggantian gambar karakter berdasarkan *state* karakter saat ini.
* **Proses Pengerjaan:** Saya membuat beberapa variabel `@export` bertipe `Texture2D` di `Player.gd` (`tex_stand`, `tex_jump`, `tex_fall`, `tex_duck`, `tex_dash`) sehingga aset gambar dapat dimasukkan melalui panel *Inspector*. Pada akhir fungsi `_physics_process`, sistem mengevaluasi *state* (sedang melompat, jatuh, jongkok, dash, atau diam/jalan) dan menukar `sprite.texture` sesuai dengan kondisi yang relevan.

</details>

<br>

<details>
<summary><h2>Tutorial 5 - Assets Creation & Integration</h2></summary>

Pada tutorial ini, saya mempelajari cara mengintegrasikan aset visual (spritesheet) dan audio ke dalam Godot, mengimplementasikan fitur Latihan Mandiri, serta melakukan penyesuaian (*refactoring*) pada kode dari Tutorial 3.

Berikut adalah fitur dan perubahan yang telah saya kembangkan beserta penjelasan implementasinya:

### 1. Refactoring Kode & Animasi Player (Update dari Tutorial 3)
Melakukan penyesuaian struktur kode pada `Player.gd` agar memenuhi standar *linter* (`gdlint`) dan *formatter* (`gdformat`), serta merombak sistem animasi manual dari Tutorial 3 menjadi sistem yang lebih dinamis.
* **Proses Pengerjaan:** * **Perubahan Sistem Animasi:** Karena pada tutorial ini digunakan sistem animasi bawaan Godot, kode penggantian tekstur manual (`sprite.texture`) dari Tutorial 3 dihapus sepenuhnya. Sistem diganti menggunakan node `AnimatedSprite2D` dengan memanggil metode `animplayer.play(animation)` sesuai dengan *state* karakter. Pengecekan keamanan (`has_animation`) juga ditambahkan untuk mencegah *error spam* apabila terdapat animasi yang belum didaftarkan di Godot.
  * **Penyesuaian Standar Kode:** Mengubah penamaan variabel konstan menjadi huruf kecil (contoh: `SPEED` menjadi `speed`) sesuai dengan standar *class-variable-name*. Saya juga mengelompokkan seluruh deklarasi variabel `@export` di bagian teratas *script* (*class-definitions-order*).

### 2. Objek Beranimasi (Koin)
Saya membuat objek *collectible* berupa koin yang berputar menggunakan *spritesheet* kustom.
* **Proses Pengerjaan:** Objek dibuat dalam *scene* terpisah menggunakan *root node* `Area2D`. Animasi diatur menggunakan node `AnimatedSprite2D` dengan membagi *spritesheet* koin menjadi beberapa *frame* secara horizontal, yang kemudian diputar secara berulang menggunakan fitur *Autoplay*.

### 3. Efek Suara (SFX) & Interaksi Koin
Menambahkan efek suara saat karakter pemain menyentuh atau mengambil koin.
* **Proses Pengerjaan:** Node `AudioStreamPlayer` dipasangkan pada *scene* koin dan dihubungkan dengan sinyal `body_entered`. Saat pemain berbenturan dengan koin, *sprite* disembunyikan (`visible = false`) dan deteksi *collision* dimatikan (`set_deferred("monitoring", false)`) sementara SFX diputar. Koin dihapus dari memori menggunakan `queue_free()` setelah audio selesai diputar menggunakan metode `await sfx.finished` untuk mencegah audio terpotong.

### 4. Background Music (BGM) Positional
Menambahkan musik latar dengan volume yang menyesuaikan jarak pemain dari sumber suara.
* **Proses Pengerjaan:** Menggunakan node `AudioStreamPlayer2D` pada *scene* utama. Properti `Max Distance` dikonfigurasi sedemikian rupa sehingga volume BGM akan terdengar semakin samar secara dinamis ketika karakter pemain bergerak menjauh dari pusat level permainan.

### 5. Polishing (Player Audio Feedback)
Menambahkan SFX khusus pada mekanika pergerakan karakter menggunakan node `AudioStreamPlayer` di dalam *scene* karakter untuk meningkatkan umpan balik permainan.
* **Proses Pengerjaan:**
  * **Lompat & Mendarat:** SFX lompatan dipicu saat input *ui_up* ditekan. Saat input dilepas, sistem memicu SFX mendarat. Terdapat variabel status tambahan untuk menghentikan pemutaran audio secara paksa saat karakter melakukan *double jump* agar suara tidak bertumpuk.
  * **Menabrak Tembok:** Benturan tembok dideteksi menggunakan kondisi `is_on_wall()`. Untuk mencegah pemutaran suara yang berulang kali (*spam*) saat karakter ditahan ke arah tembok, variabel `was_on_wall` digunakan untuk memastikan SFX hanya berbunyi pada *frame* pertama saat benturan terjadi.

</details>

---

## Referensi
* [Godot Engine Documentation: CharacterBody2D](https://docs.godotengine.org/en/stable/classes/class_characterbody2d.html)
* [Godot Engine Documentation: 2D Movement Overview](https://docs.godotengine.org/en/stable/tutorials/physics/2d_movement.html)
* [Godot Engine Documentation: AudioStreamPlayer2D](https://docs.godotengine.org/en/stable/classes/class_audiostreamplayer2d.html)
* **Pixabay** - Digunakan sebagai sumber aset efek suara (SFX) dan Background Music (BGM). URL: [pixabay.com](https://pixabay.com/)
* **CraftPix** - Digunakan sebagai sumber aset *spritesheet* visual koin. URL: [craftpix.net](https://craftpix.net/)
