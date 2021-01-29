library(openxlsx)
library(bpa)

#Membaca dataset pelanggan
data.pelanggan <- read.xlsx("C:\\Users\\GANESHA\\Desktop\\Aulia\\dqlab_messy_data_pelanggan.xlsx",
                            sheet="Pelanggan")
summary(data.pelanggan)

#Menggunakan function summary
summary(data.pelanggan)


## Wrangling kolom kode.pelanggan

#Menggunakan function basic_pattern_analysis pada kolom Kode.Pelanggan
basic_pattern_analysis(data.pelanggan$Kode.Pelanggan, unique_only = TRUE)

#Mengambil dataset yang memiliki pola teks "AA-9999" di kolom Kode.Pelanggan
data.pelanggan$Kode.Pelanggan[ data.pelanggan$Kode.Pelanggan=="KD-0047"] <- "KD-00047"

#Melihat kembali pola apakah sudah sama semua atau tidak
basic_pattern_analysis(data.pelanggan$Kode.Pelanggan, unique_only = TRUE)


## Wrangling Kolom Nama

#Menggunakan function basic_pattern_analysis pada kolom Nama
basic_pattern_analysis(data.pelanggan$Nama, unique_only = TRUE)

#Menghilangkan angka dan simbol
data.pelanggan$Nama.Lengkap <- gsub("[^A-Za-z .,]", "", data.pelanggan$Nama.Lengkap)

#Menghilangkan kata panggilan dan perbaikan penulisan gelar
data.pelanggan$Nama.Lengkap <- gsub("\\bbapak\\b", "",data.pelanggan$Nama.Lengkap, ignore.case = TRUE)
data.pelanggan$Nama.Lengkap <- gsub("\\bibu\\b", "",data.pelanggan$Nama.Lengkap, ignore.case = TRUE)
data.pelanggan$Nama.Lengkap <- gsub("\\bir\\b", "Ir",data.pelanggan$Nama.Lengkap, ignore.case = TRUE)

#Mengubah 2 spasi menjadi 1 spasi
data.pelanggan$Nama.Lengkap <- gsub("[ ]{2,}", " ", data.pelanggan$Nama.Lengkap)

#Menghilangkan spasi pada awal dan akhir dari kolom Nama.Pengguna
data.pelanggan$Nama.Lengkap <- trimws(data.pelanggan$Nama.Lengkap, which="both")



##Wrangling untuk kolom No.Telepon

#Mencari tau pola yang berbeda menggunakan bpa
basic_pattern_analysis(data.pelanggan$No.Telepon, unique_only = TRUE)

#Melihat pola yang paling banyak
data.pelanggan$No.Telepon[data.pelanggan$Pola.No.Telepon=="9999999999999999"]

#Mengganti pola menjadi pola dari yang paling banyak
data.pelanggan$No.Telepon <- gsub("^0", "+62", data.pelanggan$No.Telepon)
data.pelanggan[basic_pattern_analysis(data.pelanggan$No.Telepon)=="9999999999999999",]$No.Telepon <- 
      paste("+", data.pelanggan[basic_pattern_analysis(data.pelanggan$No.Telepon)=="9999999999999999",]$No.Telepon, sep="")



##Wrangling pada kolom kode pos

#Mencari tau apakah ada pola yang berbeda
basic_pattern_analysis(data.pelanggan$Kode.Pos, unique_only = TRUE)

#Melihat pola yang paling banyak
data.pelanggan$Kode.Pos[data.pelanggan$Pola.Kode.Pos=="999999"]

#Mengganti pola menjadi pola dari yang paling banyak
data.pelanggan$Kode.Pos[grepl(pattern = "[A]", x = data.pelanggan$Pola.Kode.Pos, ignore.case = TRUE)]
data.pelanggan$Kode.Pos <- gsub("O", "0", data.pelanggan$Kode.Pos)
data.pelanggan$Kode.Pos <- gsub("I", "1", data.pelanggan$Kode.Pos)



##Wrangling kolom alamat

#Merubah singkatan jl, jln, jl. dan jln. menjadi Jalan
data.pelanggan$Alamat <- gsub("jln[ ]*\\.","Jalan",  data.pelanggan$Alamat, ignore.case = TRUE)
data.pelanggan$Alamat <- gsub("\\bjln\\b","Jalan",  data.pelanggan$Alamat, ignore.case = TRUE)
data.pelanggan$Alamat <- gsub("jl[ ]*\\.","Jalan",  data.pelanggan$Alamat, ignore.case = TRUE)
data.pelanggan$Alamat <- gsub("\\bjl\\b","Jalan",  data.pelanggan$Alamat, ignore.case = TRUE)
data.pelanggan$Alamat <- gsub("jalan\\.","Jalan",  data.pelanggan$Alamat, ignore.case = TRUE)



##Wrangling Kolom Aktif

#Mencari tau apakah ada pola yang berbeda
basic_pattern_analysis(data.pelanggan$Aktif, unique_only = TRUE)

#Melihat pola yang paling banyak
data.pelanggan$Aktif[data.pelanggan$Pola.Aktif=="9"]

#Mengganti pola menjadi pola dari yang paling banyak
data.pelanggan$Aktif[basic_pattern_analysis(data.pelanggan$Aktif)=="AAAAA"] <- "0"
data.pelanggan$Aktif[basic_pattern_analysis(data.pelanggan$Aktif)=="AAAA"] <- "1"
data.pelanggan$Aktif <- gsub("O", "0", data.pelanggan$Aktif)
data.pelanggan$Aktif <- gsub("I", "1", data.pelanggan$Aktif)



##Wrangling kolom tanggal lahir

#Mencari tau apakah ada pola yang berbeda
basic_pattern_analysis(data.pelanggan$Tanggal.Lahir, unique_only = TRUE)

#Melihat pola yang paling banyak
data.pelanggan$Tanggal.Lahir[basic_pattern_analysis(data.pelanggan$Tanggal.Lahir)=="99-99-9999"]

#Mengubah pola untuk tanggal lahir yang mengandung huruf
data.pelanggan$Tanggal.Lahir[grepl(pattern = "[a]", x = basic_pattern_analysis(data.pelanggan$Tanggal.Lahir), ignore.case = TRUE)]

#Mencari tau nama nama bulan
bulan <- data.pelanggan$Tanggal.Lahir[grepl(pattern = "[a]", x = basic_pattern_analysis(data.pelanggan$Tanggal.Lahir), ignore.case = TRUE)]
bulan <- gsub("[0-9 ]", "", bulan)
unique(bulan)

#Mengganti nama bulan menjadi menggunakan angka
data.pelanggan$Tanggal.Lahir <- gsub(" Januari ", "-01-", data.pelanggan$Tanggal.Lahir)
data.pelanggan$Tanggal.Lahir <- gsub(" Februari ", "-02-", data.pelanggan$Tanggal.Lahir)
data.pelanggan$Tanggal.Lahir <- gsub(" Maret ", "-03-", data.pelanggan$Tanggal.Lahir)
data.pelanggan$Tanggal.Lahir <- gsub(" April ", "-04-", data.pelanggan$Tanggal.Lahir)
data.pelanggan$Tanggal.Lahir <- gsub(" Mei ", "-05-", data.pelanggan$Tanggal.Lahir)
data.pelanggan$Tanggal.Lahir <- gsub(" Juni ", "-06-", data.pelanggan$Tanggal.Lahir)
data.pelanggan$Tanggal.Lahir <- gsub(" Juli ", "-07-", data.pelanggan$Tanggal.Lahir)
data.pelanggan$Tanggal.Lahir <- gsub(" Agustus ", "-08-", data.pelanggan$Tanggal.Lahir)
data.pelanggan$Tanggal.Lahir <- gsub(" September ", "-09-", data.pelanggan$Tanggal.Lahir)
data.pelanggan$Tanggal.Lahir <- gsub(" Oktober ", "-10-", data.pelanggan$Tanggal.Lahir)
data.pelanggan$Tanggal.Lahir <- gsub(" November ", "-11-", data.pelanggan$Tanggal.Lahir)
data.pelanggan$Tanggal.Lahir <- gsub(" Desember ", "-12-", data.pelanggan$Tanggal.Lahir)



##Wrangling kolom tanggal lahir

#Menyamakan pola tanggal lahir
data.pelanggan[basic_pattern_analysis(data.pelanggan$Tanggal.Lahir)=="99/99/99",]$Tanggal.Lahir <- 
      format(as.Date(data.pelanggan[basic_pattern_analysis(data.pelanggan$Tanggal.Lahir)=="99/99/99",]$Tanggal.Lahir, format = "%m/%d/%y"), "%d-%m-%Y")

data.pelanggan[basic_pattern_analysis(data.pelanggan$Tanggal.Lahir)=="99/99/9999",]$Tanggal.Lahir <- 
      format(as.Date(data.pelanggan[basic_pattern_analysis(data.pelanggan$Tanggal.Lahir)=="99/99/9999",]$Tanggal.Lahir, format = "%m/%d/%Y"), "%d-%m-%Y")



##Wrangling kolom nilai belanja setahun

#Melihat missing value
summary(data.pelanggan$Nilai.Belanja.Setahun)

#Mengganti missing value dengan mean
nilai_rata_rata <- mean(data.pelanggan$Nilai.Belanja.Setahun, na.rm=TRUE)
data.pelanggan$Nilai.Belanja.Setahun[is.na(data.pelanggan$Nilai.Belanja.Setahun)] <- nilai_rata_rata

#Melihat kembali apakah masih ada missing value
summary(data.pelanggan$Nilai.Belanja.Setahun)