# SSH
### VPS içinde ssh portunu değiştirmek

```sh

#!/bin/bash

set -e

NEW_SSH_PORT=2222  # Yeni SSH portunu burada değiştir
README_FILE="README.txt"

echo "[1/5] SSH portunu $NEW_SSH_PORT olarak ayarlıyoruz..."

# SSH yapılandırmasını yedekle
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

# Port numarasını değiştir
sed -i "s/^#Port .*/Port $NEW_SSH_PORT/" /etc/ssh/sshd_config
sed -i "s/^Port .*/Port $NEW_SSH_PORT/" /etc/ssh/sshd_config

echo "[2/5] UFW ile güvenlik duvarı yapılandırılıyor..."

# UFW aktif değilse etkinleştir
ufw allow "$NEW_SSH_PORT"/tcp
ufw delete allow 22/tcp || true
ufw enable

echo "[3/5] fail2ban kuruluyor ve başlatılıyor..."

apt update
apt install -y fail2ban

systemctl enable fail2ban
systemctl start fail2ban

echo "[4/5] SSH servisi yeniden başlatılıyor..."

systemctl restart sshd

echo "[5/5] Bilgilendirici README.txt dosyası oluşturuluyor..."

cat > "$README_FILE" <<EOF
Server Güvenlik Yapılandırması
==============================

SSH Portu:
----------
SSH artık $NEW_SSH_PORT portu üzerinden çalışmaktadır.
Bağlanmak için:
  ssh -p $NEW_SSH_PORT kullanıcı_adı@sunucu_ip

Fail2Ban:
---------
Kaba kuvvet saldırılarına karşı koruma etkin.
Loglar:
  sudo fail2ban-client status
  sudo fail2ban-client status sshd

SSH Giriş Denemeleri:
---------------------
Son denemeleri görmek için:
  sudo journalctl -u ssh -n 50
  sudo lastb
  sudo grep "Failed password" /var/log/auth.log

Firewall (UFW):
---------------
Açık portları görmek için:
  sudo ufw status numbered

Yedek Dosya:
------------
SSH ayarlarının yedeği: /etc/ssh/sshd_config.bak

EOF

echo "Kurulum tamamlandı. Detaylar '$README_FILE' dosyasında."


```

### Private Public key ile bağlanma
- İşlerin hepsi bağlanmak istediğiniz makineden yapılıyor, sadece ssh ile bağlanabildiğinizden emin olmanız gerekiyor.
- Asıl olay bağlanmak istediğiniz makinedeki `~/.ssh/authorized_keys` dosyasına bağlandığınız makinedeki public key'i eklemeniz. Bunu eliniz ile de yapabilirsiniz, yada aşağıdaki komutları inceleyin.
- ssh-keygen ile private ve public key oluşturuyorsunuz. `ssh-keygen`
- `ssh-copy-id -i ~/.ssh/id_rsa.pub root@10.0.0.2` ile yazarsınız. Bu size bağlanmak istediğiniz makinenin şifresini soracaktır. Sonrasında bağlandığınız makinedeki `~/.ssh/authorized_keys` dosyasına sizin public key'iniz eklenecektir.
- `ssh root@10.0.0.2` 
- [Detaylı Bilgi için](https://upcloud.com/community/tutorials/use-ssh-keys-authentication/?utm_term=&utm_campaign=DSA&utm_source=adwords&utm_medium=ppc&hsa_acc=9391663435&hsa_cam=7185608860&hsa_grp=81739862313&hsa_ad=391197952986&hsa_src=g&hsa_tgt=aud-312112117574:dsa-460992423274&hsa_kw=&hsa_mt=b&hsa_net=adwords&hsa_ver=3&gclid=CjwKCAiAjeSABhAPEiwAqfxURTwoxJyAuEWz5wiYJPPzBCj7gXcay1DOv1lygbNXfJJ3E1mHLvcanRoCEYsQAvD_BwE)


### JWT de RSA kullanmak ve SSH key üretmek
- normal şartlada üretilen public key formatı defaultta pem olmuyor.
- En azından npm/jsonwebtoken kütüphanesi public key'i pem istiyor.
- Bu örneği ssh-keygen üzerinden değilde openssl üzerinden göstereceğim. openssl'i kurmanız gerekir. [Burada çalıştı, bakınız](https://community.chocolatey.org/packages/openssl)
- Aşağıdaki kodları yazarak oluşturabilirsiniz.
```BASH

# Bu private key oluşturur, (private key'i ssh-keygen den oluştursanız da çalışıyor)
openssl genrsa -out private_key.pem 1024

# private key'e bakarak public key'i oluşturur.
openssl rsa -in private_key.pem -pubout -out public_key.pem

# Not: public key private key'e bağlı, aynı private key'in sadece 1 tane public key'i olabiliyormuş. Bilmiyordum.

```
JWT
```ts

import jwt from 'jsonwebtoken';
import fs from 'fs-extra';
import path from 'path';

const privateKey = fs.readFileSync(path.join(__dirname, 'keys3', 'private_key.pem'))
const publicKey = fs.readFileSync(path.join(__dirname, 'keys3', 'public_key.pem'))


const token = jwt.sign({ foo: 'bar' }, privateKey, { algorithm: 'RS256' })

console.log('TOKEN', token);

try {
    const payload = jwt.verify(token, publicKey, { algorithms: ['RS256'],  })
    console.log('PAYLOAD', payload);
} catch (error) {
    console.log('FAILED', error);
}


```

