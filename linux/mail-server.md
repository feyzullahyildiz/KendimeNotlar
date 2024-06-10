
# Mail Server kuruyoruz.. (Kuramadık 🤣)
Kendi domainimize ait bir Mail Server kuracağız.

#### Ne kullanacağız.
docker-mailserver (Haraka'yı configure etmekte zorlandım tam olarak olmadı)
> Referans aldığımız [doc docker-mailserver](https://docker-mailserver.github.io/docker-mailserver/latest/usage/)


# DNS Kayıtları

| TYPE | NAME | VALUE(Content) |
|----------|----------|----------|
| A    | mail   | 11.22.33.44   |
| MX    | fey.com  | mail.fey.com   |
| PTR    | 	11.22.33.44   | mail.fey.com   |

*PTR zorunlu değil ama iyi olur*

Bu kayıtların doğru olduğunun kontrolü de
```sh
$ dig @1.1.1.1 +short MX example.com
mail.example.com
$ dig @1.1.1.1 +short A mail.example.com
11.22.33.44
$ dig @1.1.1.1 +short -x 11.22.33.44
mail.example.com
```

Şuanlık PTR kaydının testi olan dig çalışmadı. Bakalım nolcak

### compose.yml ve mailserver.env
```sh
DMS_GITHUB_URL="https://raw.githubusercontent.com/docker-mailserver/docker-mailserver/master"
wget "${DMS_GITHUB_URL}/compose.yaml"
wget "${DMS_GITHUB_URL}/mailserver.env"
# yazarak bu iki dosyayı inidiyoruz.
```


>compose.yaml dosyasındaki hostname değerini `mail.fey.com` ile değiştirin

### hostname
`hostname -f`
yazınca karşımıza çıkar. (FQDN - Fully Qualified Domain Name) 
- eposta sunucularında yapılması iyi olurmuş.
Burada gelen response `mail.fey.com` gibi olması gerekiyormuş.

bu dosyaları editlemek gerekiyor.
- /etc/hosts
- /etc/hostname (bu galiba sadece ubuntuda, belki debian based bişeydir.)

> ilginç birşey oldu. `/etc/hosts` update ettikten sonra reboot attım.
> Uptime sonrası `/etc/hosts`'a yeni bir kayıt eklendiğini gördüm
>
>`/etc/hostname`'i güncellememiştim
>
> ikisinide günceledikten sonra ve sonradan kendiliğinden oluşan satırı sildikten sonra ilgili kayıt tekrardan eklendi. Bu eklenen kayıt ilk başta olan verinin ta kendisi. Önemli olan şu galiba, `hostname -f` yazınca istediğim çıktıyı alabiliyor olmak.

#### hostname ve docker ile ilişkisi
- docker run --rm alpine hostname -f
    - her seferinde değiştiğini göreceksiniz
- docker run --rm --hostname=foobar alpine hostname -f
    - bu şekilde hostname'i set edebiliyoruz.
- Bu yaptıklarımızı kullanmamıza gerek olmayabilir galiba. İndirdiğimiz compose.yml dosyasında zaten bu container için olan hostname'i güncellemiştik.



### SSL
letsencrypt ile yaptık.
```sh
#mailserver.env
SSL_TYPE=letsencrypt
```
docker container ayağa kaldırkdık certbot için.

```sh

# Requires access to port 80 from the internet, adjust your firewall if needed.
docker run --rm -it \
  -v "${PWD}/docker-data/certbot/certs/:/etc/letsencrypt/" \
  -v "${PWD}/docker-data/certbot/logs/:/var/log/letsencrypt/" \
  -p 80:80 \
  certbot/certbot certonly --standalone -d mail.fey.com
  
```
yenilemek için farklı bir script yazdık
```sh
#!/bin/bash

# Log dosyasının adı
log_file="ssl_renew_log.txt"

# Mevcut tarih ve saat bilgisi
current_date=$(date '+%Y-%m-%d %H:%M:%S')

# Bilgi mesajı
info_message="Bu bir bilgi mesajıdır - $current_date"

# Bilgi mesajını log dosyasına ekle
echo "$info_message" >> "$log_file"

# This will need access to port 443 from the internet, adjust your firewall if needed.
docker run --rm -it \
  -v "${PWD}/docker-data/certbot/certs/:/etc/letsencrypt/" \
  -v "${PWD}/docker-data/certbot/logs/:/var/log/letsencrypt/" \
  -p 80:80 \
  -p 443:443 \
  certbot/certbot renew
```
Bunu da crontab'a ekledik.

`crontab -e` ile edit modunda açarız.


```sh
0 1 * * * /home/ubuntu/docker-mailserver/renew-ssl-with-certbot.sh
```
`crontab -l` ile kontrol ederiz.

Bu şekilde otomatik olarak SSL yenilenir.

mailserver için ise, volume vermek gerekiyor.

```yaml
# compose.yaml 
services: 
  mailserver:
    image: ghcr.io/docker-mailserver/docker-mailserver:latest
    ...
    volumes:
        ...
        - ./docker-data/certbot/certs/:/etc/letsencrypt # Bu satır eklendir.


```

Mail sunucusu da sürekli yeni certifikaya ulaşmış olur


## Advanced DNS setup
DKIM, DMARC & SPF

### DKIM
private, public key oluşturuyoruz.
```sh
docker exec -ti mailserver setup config dkim
```
Sonrasında DNS kaydında TXT oluşturup, public key'i oraya koyacağız...

Bu şekilde maili imzalıyoruz. Gönderenin asıl kişi olduğunu verify edebiliyoruz..


```
/tmp/docker-mailserver/opendkim/keys/mail.fey.com/mail.txt
```

```mail.txt

mail._domainkey IN      TXT     ( "v=DKIM1; h=sha256; k=rsa; "
          "p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAxgfS2z2Cwy4m2p8a6LpwDmC+7TQ5H0mKMSrV44SdGCaamhMZTGUSY06JtAqHb+RBppHhmd+CDtH/R+aA7nisthNo1O2iEYidcs6xVzWkAbf+D+C9X1x+bnUwap5J+Iq/IJhZohnthih7bWsPb+hL73GgXJ6r0Cnut1pkihvCwXVj7YPAef9m//DL+9NLf/iNq8JMuHn0c9P7zL"
          "EpHm9zb/0gZRtNtn8uZdw7hoePis8svEkvGPegpYEbFiUrPKLhKrg2lBf2PnP+0cqfa0PO3+xnnUFg1IE7blOynCrjrUhbQhj4C3Q95v8qjXg0WBanp2NPzKLtA407AVFAn7MzXwIDAQAB" )  ; ----- DKIM key mail for mail.fey.com


```

v=DKIM1; h=sha256; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAxgfS2z2Cwy4m2p8a6LpwDmC+7TQ5H0mKMSrV44SdGCaamhMZTGUSY06JtAqHb+RBppHhmd+CDtH/R+aA7nisthNo1O2iEYidcs6xVzWkAbf+D+C9X1x+bnUwap5J+Iq/IJhZohnthih7bWsPb+hL73GgXJ6r0Cnut1pkihvCwXVj7YPAef9m//DL+9NLf/iNq8JMuHn0c9P7zLEpHm9zb/0gZRtNtn8uZdw7hoePis8svEkvGPegpYEbFiUrPKLhKrg2lBf2PnP+0cqfa0PO3+xnnUFg1IE7blOynCrjrUhbQhj4C3Q95v8qjXg0WBanp2NPzKLtA407AVFAn7MzXwIDAQAB



# DNSSEC

Bunun ne olduğunu pek bilmiyorum. Anlamadım da.

Cloudflare üzerinden 1 tık ile açılıyor.

Bunun üzerinden kayıt oluşturdu ama DNS kayıtlarına eklemedi.

# DNS DMARC
Cloudflare üzerinde DMARC Management falan bile var

Bir kayıt ekliyor DNS Recordlarına


# SPF
mailleri gönderen sunucular için whitelist ekliyorsun..




