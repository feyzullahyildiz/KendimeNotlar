# SSH

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

