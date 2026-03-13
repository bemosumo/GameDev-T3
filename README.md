# Tutorial 3 Game Development

**Nama:** Muhammad Fawwaz Edsa Fatin S  
**NPM:** 2306275582

---

## Latihan Mandiri

Pada tutorial ini, saya telah mengimplementasikan mekanika pergerakan dasar 2D platformer (kiri, kanan, gravitasi, dan lompat), serta mengeksplorasi beberapa mekanika lanjutan untuk memenuhi kriteria Latihan Mandiri.

Berikut adalah fitur lanjutan yang telah saya kembangkan beserta penjelasan implementasinya:

### 1. Double Jump
Karakter dapat melompat maksimal dua kali sebelum menyentuh tanah.
* **Proses Pengerjaan:** Saya menambahkan variabel `max_jumps = 2` dan `jump_count = 0`. Setiap kali karakter berada di lantai (`is_on_floor()`), `jump_count` di-reset menjadi 0. Ketika tombol lompat ditekan (`ui_up`), sistem akan mengecek apakah `jump_count < max_jumps`. Jika iya, karakter akan melompat dan `jump_count` bertambah 1.

### 2. Crouch
Karakter dapat berjongkok ketika berada di tanah, yang akan memperlambat kecepatan berjalannya dan mengubah pose karakternya.
* **Proses Pengerjaan:** Jika karakter berada di lantai dan tombol bawah ditekan (`ui_down`), variabel `is_crouching` menjadi `true`. Kecepatan berjalan karakter diubah menggunakan nilai `crouch_speed` (lebih lambat dari `walk_speed`). Sprite karakter juga diubah menjadi pose jongkok (`zombie_duck`).

### 3. Dash
Karakter dapat bergerak lebih cepat menggunakan 'enter+kanan/kiri', disertai dengan efek visual *skidding*.
* **Proses Pengerjaan:** Menggunakan deteksi input `ui_accept` (Space/Enter). Ketika ditahan, kecepatan horizontal dikalikan dengan `dash_multiplier`. Sprite diubah menjadi pose `zombie_skid`. 
* **Polishing Khusus:** Saya menambahkan logika pembalikan arah (mirroring) khusus saat mode *dash*. Jika karakter meluncur ke kiri, gambar sprite menghadap ke kanan (`flip_h = false`), begitu juga sebaliknya agar arah meluncur karakter searah dengan gambarnya.

### 4. Polishing
Saya membuat sistem penggantian gambar karakter berdasarkan *state* karakter saat ini.
* **Proses Pengerjaan:** Saya membuat beberapa variabel `@export` bertipe `Texture2D` di `Player.gd` (`tex_stand`, `tex_jump`, `tex_fall`, `tex_duck`, `tex_dash`) sehingga aset gambar dapat dimasukkan melalui panel *Inspector*. Pada akhir fungsi `_physics_process`, sistem mengevaluasi *state* (sedang melompat, jatuh, jongkok, dash, atau diam/jalan) dan menukar `sprite.texture` sesuai dengan kondisi yang relevan.

---

## Referensi
* [Godot Engine Documentation: CharacterBody2D](https://docs.godotengine.org/en/stable/classes/class_characterbody2d.html)
