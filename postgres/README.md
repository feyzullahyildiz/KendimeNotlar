# Postgres

## FullTextSearch ve Locale (dil ayarı)
Youtube'da bir videoya denk geldim. [Yazılım Geliştiriciler için PostgreSQL (Atıf Ceylan)](https://youtu.be/E-RH_xjCBPI?t=2072) Bu videoyu aylar öncesinde izlemiştim. İddiaya göre Full Text Search işini bu extention ile sağlayabiliyoruz. Önce videoyu izleyin aşağıdaki bilgiler patates oldu.

Postgresql'in içinde gelen bir extention var. Bu extention `pg_trgm`.

Bu extention size 2 tane ana fonksiyon veriyor.
- word_similarity
- similarity


Aşağıdaki Örnekte bunuları kullanalım.
```sql

-- Bu isimde bir tablo oluşturuyoruz.
CREATE TABLE "public"."cities" (
  "id" serial PRIMARY KEY,
  "name" varchar(100)
);

-- Yukarıdaki insert script'i ile veri ekliyoruz.
INSERT INTO "public"."cities" ("name")
VALUES  ('İstanbul'),
    ('istanbul'),
    ('Istanbul'),
    ('ıstanbul');

-- Extension'ı oluşturalım.
CREATE EXTENSION pg_trgm;


SELECT *, word_similarity("name", 'Is') FROM "cities";

```

| id | name | word_similarity |
| :---- | :----: | ----: |
|1 | İstanbul | 0.222222|
|2 | istanbul | 0.222222|
|3 | Istanbul | 0.222222|
|4 | ıstanbul | 0|

Çıkan sonuca baktığımız zaman burada türkçe kelimeler için iyi sonuç vermiyor. `Is` diye aradığımızda 4. deki `ıstanbul` yazısına da bir miktar puan vermesini beklerdik.
Bunun için verilerin türkçe formatta olduğunu bir şekilde söylememiz gerekiyor.

```sql
-- Database dilini kontrol etmek için bunu kullanabilirsiniz.
 SHOW lc_collate;
```
|lc_collate|
|--|
|en_US.utf8|


Bu sorunu yaşarken [ahmetimamoglu postgresql-turkce-karakter-hatasinin-cozumleri](https://ahmetimamoglu.com.tr/postgresql-turkce-karakter-hatasinin-cozumleri) yazısı ile karşılaştım. 

Bizden aşağıdaki kodları çalıştırmamızı istiyor. Benim Postgresql'im dockerda (postgresql-alpine) kurulu. 
```BASH
# Mevcut paketleri listeliyoruz.
locale -a

# Yukarıdaki listede tr_TR veya tr_TR.UTF-8 yoksa ekliyoruz.
sudo locale-gen tr_TR
sudo locale-gen tr_TR.UTF-8

# Son olarak güncelleme yapıyoruz.
sudo update-locale 
```
Container'ın içinde bu kodları çalıştıramadım. `locale` alpine'ın içinde gelmiyor. Postgres'in docker official reposunda bunun ile alakalı çözüm yolu göstermiş. Image'ınızı güncellemeniz gerekebilir. Ve ben aşağıdaki gibi yaptım.

```Dockerfile
FROM postgres:14.1
RUN localedef -i tr_TR -c -f UTF-8 -A /usr/share/locale/locale.alias tr_TR.UTF-8
ENV LANG tr_TR.utf8


```
as
```BASH
# build image
docker build . -t tr-postgres
#container oluştur
docker run --name postgre-textsearch-test -p 5500:5432 -d -e POSTGRES_HOST_AUTH_METHOD=trust tr-postgres

```
Yeni database'imde ile  `SHOW lc_collate;` çalıştırarak database dilini kontrol ediyorum.

|lc_collate|
|--|
|tr_TR.UTF-8|

Ardından, yukarıda oluşturduğum tablonun aynısını ve verileri burada da oluşturuyorum.
```SQL
 SELECT *, word_similarity("name", 'ıs') FROM cities
```

| id | name | word_similarity |
| :---- | :----: | ----: |
| 1 | İstanbul | 0 |
| 2 | istanbul | 0 |
| 3 | Istanbul | 0.22222222 |
| 4 | ıstanbul | 0.22222222 |

Aslında istediğim şeye ulaşamadım ama burada `I` (Büyük I) `i` (küçük i) ile eşleşmemiş, yani harfler kendi içindeki harfler ile match olmuş oluyor.

Bundan sonrası ile alakalı pek bir malumatım yok :(
İşler karıştı.