library(openxlsx)
library(bpa)

#Read Data
data.pelanggan <- read.xlsx("C:\\Users\\GANESHA\\Desktop\\Aulia\\dqlab_messy_data_pelanggan.xlsx",
                            sheet="Pelanggan")
summary(data.pelanggan)

#Use function summary
summary(data.pelanggan)


## Wrangling kode.pelanggan column

#Use function basic_pattern_analysis for Kode.Pelanggan column
basic_pattern_analysis(data.pelanggan$Kode.Pelanggan, unique_only = TRUE)

#Take the data that has pattern "AA-9999"
data.pelanggan$Kode.Pelanggan[ data.pelanggan$Kode.Pelanggan=="KD-0047"] <- "KD-00047"

#Make sure all the pattern is correct
basic_pattern_analysis(data.pelanggan$Kode.Pelanggan, unique_only = TRUE)


## Wrangling Nama Column

#Use function basic_pattern_analysis for Nama Column
basic_pattern_analysis(data.pelanggan$Nama, unique_only = TRUE)

#Remove numbers and symbols
data.pelanggan$Nama.Lengkap <- gsub("[^A-Za-z .,]", "", data.pelanggan$Nama.Lengkap)

#Remove nick name (Ibu Bapak) and fix the degree
data.pelanggan$Nama.Lengkap <- gsub("\\bbapak\\b", "",data.pelanggan$Nama.Lengkap, ignore.case = TRUE)
data.pelanggan$Nama.Lengkap <- gsub("\\bibu\\b", "",data.pelanggan$Nama.Lengkap, ignore.case = TRUE)
data.pelanggan$Nama.Lengkap <- gsub("\\bir\\b", "Ir",data.pelanggan$Nama.Lengkap, ignore.case = TRUE)

#Change 2 spaces to be 1 space
data.pelanggan$Nama.Lengkap <- gsub("[ ]{2,}", " ", data.pelanggan$Nama.Lengkap)

#Remove spaces at the beginning and end of Nama.Pengguna column
data.pelanggan$Nama.Lengkap <- trimws(data.pelanggan$Nama.Lengkap, which="both")


##Wrangling alamat column

#Change the abbreviation of jl, jln, jl. and jln. to be Jalan
data.pelanggan$Alamat <- gsub("jln[ ]*\\.","Jalan",  data.pelanggan$Alamat, ignore.case = TRUE)
data.pelanggan$Alamat <- gsub("\\bjln\\b","Jalan",  data.pelanggan$Alamat, ignore.case = TRUE)
data.pelanggan$Alamat <- gsub("jl[ ]*\\.","Jalan",  data.pelanggan$Alamat, ignore.case = TRUE)
data.pelanggan$Alamat <- gsub("\\bjl\\b","Jalan",  data.pelanggan$Alamat, ignore.case = TRUE)
data.pelanggan$Alamat <- gsub("jalan\\.","Jalan",  data.pelanggan$Alamat, ignore.case = TRUE)


##Wrangling tanggal lahir column

#Find out is there any different pattern
basic_pattern_analysis(data.pelanggan$Tanggal.Lahir, unique_only = TRUE)

#Check out the data of the most pattern
data.pelanggan$Tanggal.Lahir[basic_pattern_analysis(data.pelanggan$Tanggal.Lahir)=="99-99-9999"]

#Change the pattern for tanggal lahir that contain letters
data.pelanggan$Tanggal.Lahir[grepl(pattern = "[a]", x = basic_pattern_analysis(data.pelanggan$Tanggal.Lahir), ignore.case = TRUE)]

#Find out the name of month
bulan <- data.pelanggan$Tanggal.Lahir[grepl(pattern = "[a]", x = basic_pattern_analysis(data.pelanggan$Tanggal.Lahir), ignore.case = TRUE)]
bulan <- gsub("[0-9 ]", "", bulan)
unique(bulan)

#Change the name of month to be the number of month
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

#Check the pattern
basic_pattern_analysis(data.pelanggan$Tanggal.Lahir, unique_only = TRUE)

#Equalize the pattern for tanggal lahir
data.pelanggan[basic_pattern_analysis(data.pelanggan$Tanggal.Lahir)=="99/99/99",]$Tanggal.Lahir <- 
  format(as.Date(data.pelanggan[basic_pattern_analysis(data.pelanggan$Tanggal.Lahir)=="99/99/99",]$Tanggal.Lahir, format = "%m/%d/%y"), "%d-%m-%Y")

data.pelanggan[basic_pattern_analysis(data.pelanggan$Tanggal.Lahir)=="99/99/9999",]$Tanggal.Lahir <- 
  format(as.Date(data.pelanggan[basic_pattern_analysis(data.pelanggan$Tanggal.Lahir)=="99/99/9999",]$Tanggal.Lahir, format = "%m/%d/%Y"), "%d-%m-%Y")


##Wrangling Aktif column

#Find out is there any different pattern
basic_pattern_analysis(data.pelanggan$Aktif, unique_only = TRUE)

#Check out the data of the most pattern
data.pelanggan$Aktif[data.pelanggan$Pola.Aktif=="9"]

#Change the other pattern to be "9"
data.pelanggan$Aktif[basic_pattern_analysis(data.pelanggan$Aktif)=="AAAAA"] <- "0"
data.pelanggan$Aktif[basic_pattern_analysis(data.pelanggan$Aktif)=="AAAA"] <- "1"
data.pelanggan$Aktif <- gsub("O", "0", data.pelanggan$Aktif)
data.pelanggan$Aktif <- gsub("I", "1", data.pelanggan$Aktif)


##Wrangling for kode pos column

#Find out is there any different pattern
basic_pattern_analysis(data.pelanggan$Kode.Pos, unique_only = TRUE)

#Check out the data of the most pattern
data.pelanggan$Kode.Pos[data.pelanggan$Pola.Kode.Pos=="999999"]

#Change the other pattern to be "999999"
data.pelanggan$Kode.Pos[grepl(pattern = "[A]", x = data.pelanggan$Pola.Kode.Pos, ignore.case = TRUE)]
data.pelanggan$Kode.Pos <- gsub("O", "0", data.pelanggan$Kode.Pos)
data.pelanggan$Kode.Pos <- gsub("I", "1", data.pelanggan$Kode.Pos)


##Wrangling for No.Telepon column

#Find out the different pattern using bpa
basic_pattern_analysis(data.pelanggan$No.Telepon, unique_only = TRUE)

#Check out the data from the most pattern
data.pelanggan$No.Telepon[data.pelanggan$Pola.No.Telepon=="9999999999999999"]

#Change the other pattern to be "9999999999999999"
data.pelanggan$No.Telepon <- gsub("^0", "+62", data.pelanggan$No.Telepon)
data.pelanggan[basic_pattern_analysis(data.pelanggan$No.Telepon)=="9999999999999999",]$No.Telepon <- 
  paste("+", data.pelanggan[basic_pattern_analysis(data.pelanggan$No.Telepon)=="9999999999999999",]$No.Telepon, sep="")


##Wrangling nilai belanja setahun column

#Find out the missing value
summary(data.pelanggan$Nilai.Belanja.Setahun)

#Fill the missing value with mean
nilai_rata_rata <- mean(data.pelanggan$Nilai.Belanja.Setahun, na.rm=TRUE)
data.pelanggan$Nilai.Belanja.Setahun[is.na(data.pelanggan$Nilai.Belanja.Setahun)] <- nilai_rata_rata

#Check out is there any missing value left
summary(data.pelanggan$Nilai.Belanja.Setahun)