# SSH

### Private Public key ile bağlanma
- İşlerin hepsi bağlanmak istediğiniz makineden yapılıyor, sadece ssh ile bağlanabildiğinizden emin olmanız gerekiyor.
- Asıl olay bağlanmak istediğiniz makinedeki `~/.ssh/authorized_keys` dosyasına bağlandığınız makinedeki public key'i eklemeniz. Bunu eliniz ile de yapabilirsiniz, yada aşağıdaki komutları inceleyin.
- ssh-keygen ile private ve public key oluşturuyorsunuz. `ssh-keygen`
- `ssh-copy-id -i ~/.ssh/id_rsa.pub root@10.0.0.2` ile yazarsınız. Bu size bağlanmak istediğiniz makinenin şifresini soracaktır. Sonrasında bağlandığınız makinedeki `~/.ssh/authorized_keys` dosyasına sizin public key'iniz eklenecektir.
- `ssh root@10.0.0.2` 
- [Detaylı Bilgi için](https://upcloud.com/community/tutorials/use-ssh-keys-authentication/?utm_term=&utm_campaign=DSA&utm_source=adwords&utm_medium=ppc&hsa_acc=9391663435&hsa_cam=7185608860&hsa_grp=81739862313&hsa_ad=391197952986&hsa_src=g&hsa_tgt=aud-312112117574:dsa-460992423274&hsa_kw=&hsa_mt=b&hsa_net=adwords&hsa_ver=3&gclid=CjwKCAiAjeSABhAPEiwAqfxURTwoxJyAuEWz5wiYJPPzBCj7gXcay1DOv1lygbNXfJJ3E1mHLvcanRoCEYsQAvD_BwE)
