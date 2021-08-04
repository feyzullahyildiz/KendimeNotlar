# Nginx

## Frontend ve Nginx Build İşlemleri
### React Router basename ile nginx configurasyonu nasıl yapılmalı
- create-react-app kullanıyoruz, server side rendering kullanmıyoruz. 
- react-router-dom kullanıyoruz. projenin `/panel` şeklinde çalışmasını istiyoruz.
- react-router kendi içinde nested routerı var ve bu durumlarda da sayfa yenilemelerinde çalışmaya devam etmesini, 404 hatasını almamak istiyoruz.
### Çözüm 
- [Buradaki](https://create-react-app.dev/docs/deployment) dökümanı okumanız iyi olacaktır.
- 404 hatası için nginx configurasyonu ile alakalı bilgi [burada](https://www.learninjava.com/react-router-apache-nginx-tomcat/)
- `package.json` dosyasına `homepage` adına bir key eklemeli ve değerini `/panel` yapmalıyız.
- `react-router-dom` için configurasyon aşağıdaki gibi olmalı.
    - ```tsx
        <BrowserRouter basename="/panel">
            <Link to="/today"/> // renders <a href="/panel/today">
            <Link to="/tomorrow"/> // renders <a href="/panel/tomorrow">
            ...
        </BrowserRouter>
    ```
- Projeyi build etmeliyiz. `yarn build` veya `npm run build` yazarak.
- build için `panel` adında bir klasör oluşturmalıyız. `build` klasörünü (index.html'in bulunduğu klasörü) `panel` klasörüne atmalıyız. 
- path olarak bu şekilde olmalı `/var/www/html/panel/index.html` ve `/var/www/html/` path'i serve edilmeli. 
    - ```
        server {
            ...
            location /panel {
                root /var/www/html/;
                index  index.html index.htm;
                try_files $uri $uri/ /panel/index.html;
            }
        }

    ```


## Sorularım
### Soru 1
- multipart data upload ediyorum. nginx upload bitmeden yönlendirmesi gereken yere göndermiyor. Nginxte bunu nasıl değiştirebilirim. Sürekli bir veri akışı nasıl yapılır.
### Çözüm
- proxy_request_buffering değeri default olarak on; Bunu kapattığımız zaman. İstediğimizi elde etmiş oluyoruz. [stackoverflowda bir soru](https://stackoverflow.com/questions/12282342/nginx-files-upload-streaming-with-proxy-pass) [nginx dökümantasyonu](http://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_request_buffering)

- `proxy_request_buffering off;` 

### Soru 2
- nginx'e multipart veri upload ederken temp olarak bir path vermek istiyoruz, mesela farklı bir disk. bunu sağlayan ayar için [client_body_temp_path](http://nginx.org/en/docs/http/ngx_http_core_module.html) kullanılıyor. Bunu ayarladığımız zaman error.log file'ına sürekli permission denied hatası düşüyor.
    - ```conf
        server {
               location /api {
                   client_body_temp_path /media/cesium/nginx_tmp 1 2;
                    ...
               } 
        }
        ```
    - aldığımız hata ise aşağıdaki gibidir
    - ```txt
            2021/07/07 16:11:51 [crit] 15994#15994: *6443 open() "/media/cesium/nginx_tmp/8/30/0000000308" failed (13: Permission denied), client: 192.168.20.180, server: _, request: "POST /api/v1/terrain/5/uploadfile HTTP/1.0"
        ```
### Soru 2 Çözüm Denemesi 1 (Başarısız)
- [https://stackoverflow.com/q/28273035/7975831](https://stackoverflow.com/q/28273035/7975831)
- Burada selinux ile bişeyler yapmamız gerektiği yazıyor.
- Ubuntuya selinux eklemek için bu aşamaları uyguladık. [https://linuxconfig.org/how-to-disable-enable-selinux-on-ubuntu-20-04-focal-fossa-linux](https://linuxconfig.org/how-to-disable-enable-selinux-on-ubuntu-20-04-focal-fossa-linux)
```bash
sudo apt install policycoreutils selinux-utils selinux-basics
sudo selinux-activate
reboot
# Burada ne var ne yok patladık. Ubuntuya bunu yüklemek sıkıntılı bir durum galiba. System boot olmadı. Gerçi baya bir uyarı vermiş. AppArmor'u kapattığınızdan emin olun falan filan diye. Ama yöntemi sevmedim.

```
### Soru 2 Çözüm Denemesi 2 (Başarısız)
- selinux yerine default AppArmor diye birşey varmış.
- Hali hazırda ubuntu bunun ile beraber geliyormuş.
- AppArmor üzerinde bişeyler deneyeceğiz.
- [https://www.digitalocean.com/community/tutorials/how-to-create-an-apparmor-profile-for-nginx-on-ubuntu-14-04](https://www.digitalocean.com/community/tutorials/how-to-create-an-apparmor-profile-for-nginx-on-ubuntu-14-04)
- `sudo aa-autodep nginx` yazarak nginx için bir rule gibi birşey oluşturduk.
- Sonrası patladı
- 

### Soru 2 Çözüm Denemesi 3 (Başarısız)
- stackoverflow üzerine soru açtım. [https://stackoverflow.com/questions/68300720/linux-ubuntu-and-nginx-permissions-on-another-disk-when-i-use-client-body-temp](https://stackoverflow.com/questions/68300720/linux-ubuntu-and-nginx-permissions-on-another-disk-when-i-use-client-body-temp)

### Soru 2 Çözümü (Başarılı)
- disk'i tekrardan mount etmek gerekiyor.
- `sudo mount -o remount,rw  /dev/sdb1 /media/cesium`


### Soru 3