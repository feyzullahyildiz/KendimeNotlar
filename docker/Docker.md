# Docker

```sh
# docker-compose yerine docker compose kullanabiliyoruz bu şekilde.
# loadingler falan daha güzel gözüküyor

sudo apt-get update
sudo apt-get install docker-compose-plugin

# Bana ilginç geldi ama emin değilim. compose.yaml dosyasına direk bakıyor. docker-compose.yaml olmasına gerek yok galiba. Belki bu durum sadece bu plugine özeldir.

```

## Image build ve volume oluşturma
- Dockerfile içinde oluşturduğun Volume pathleri için image'a localindeki volume dosyalarının gitmesini istemiyorsan volume'e koydunğun dosyaların pathleri .dockerignore dosyasında da da olması gerekiyor.

## Docker bilmiyorsun haberin olsun
### Binded volume ve Permission durumları ile alakalı bilgi
- Linuxte `whoami` komutu aktif kullanıcının kim olduğunu verir. `id -u` adında bir komut var. Bu komut aktif kullanıcının `id` değerini veriyor.
- Her container aktif bir kullanıcı-id ile çalışır. Dolayısıyla containerdaki işlemler bu kullanıcının yetkisi kadardır.
- Linuxdeki yetki mekanizması kullanıcı adı değil kullanıcıların id değerlerine göre çalışır. 
- Ubuntuda `useradd` komutu ile oluşturduğunuz ilk kullanıcının `id` değeri genelde `1000` olur ve bir sonraki ise `1001` olur.
- Bir nodejs containerı varsayılan olarak `node` adında bir kullanıcı ile çalışır. Ve bu kullanıcının `id` değeri `1000` dir.
- Bir nodejs containerı ile host arasında bir binded volume oluşturalım.
    - `docker run -v /home/feyzullah/outer_dir:/home/node/inner_dir node`
    - Burada `feyzullah` kullanıcısının id değeri `1000` 
    - Hosttaki `feyzullah` kullanıcısı ve containerdaki `node` bu folderda tam yetkiye sahiptir. Çünkü bunlar mantıken aynı kullanıcıdır. 
    - 
