# SSH

### Private Public key ile bağlanma
- İşlerin hepsi bağlanmak istediğiniz makineden yapılıyor, sadece ssh ile bağlanabildiğinizden emin olmanız gerekiyor.
- Asıl olay bağlanmak istediğiniz makinedeki `~/.ssh/authorized_keys` dosyasına bağlandığınız makinedeki public key'i eklemeniz. Bunu eliniz ile de yapabilirsiniz, yada aşağıdaki komutları inceleyin.
- ssh-keygen ile private ve public key oluşturuyorsunuz. `ssh-keygen`
- `ssh-copy-id -i ~/.ssh/id_rsa.pub root@10.0.0.2` ile yazarsınız. Bu size bağlanmak istediğiniz makinenin şifresini soracaktır. Sonrasında bağlandığınız makinedeki `~/.ssh/authorized_keys` dosyasına sizin public key'iniz eklenecektir.
- `ssh root@10.0.0.2` 