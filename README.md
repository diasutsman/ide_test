# IDE Examination

## Signature :

Signature memastikan data yang dikirimkan adalah asli dan tidak bisa disanggah. Signature dihasilkan oleh pemakai layanan dan diverifikasi oleh penerima layanan.
Signature dibentuk dari payload yang sudah ditentukan, dengan mengimplementasikan algoritma SHA256-HMAC dengan Consumer Secret sebagai kuncinya. Kemudian, akan dilakukan enkripsi dari signature ini dengan menggunakan Base64. Hasil akhirnya akan diletakkan di atribut IDE-Signature di Header.