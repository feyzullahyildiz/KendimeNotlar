# Kendime Notlar
- [Docker](./docker/Docker.md)
- [DockerSwarm](./docker/DockerSwarm.md)
- [create-react-app](./create-react-app.md) ile alakalı notlarım
- [kotlin-coroutines](./kotlin-coroutines.md)
- [ssh](./ssh.md)
- [Cesium](./Cesium.md)
- [nginx](./nginx.md)
    - Nginx, React, react-router-dom konfigurasyonu


# Kendime Sorularım


## ssh-keygen ve git'i ssh ile kullanma
- github-gitlab gibi git serverlarından private repolardan şifresiz bir şekilde git pull, git clone yapabilmek için ssh-keygen ile private ve public key oluşturuyoruz. Public key'i github'a ekledikten sonra git pull yapabiliyoruz. Githubda bir public key'i iki farklı repoda kullanamıyoruz, github izin vermiyor. Dolayısıyla ikinci bir private-public key oluşturmamız gerekiyor. ssh-keygen ile key oluştururken dosya adı verebiliyoruz dolayısıyla rahatlıkla birden fazla key oluşturabiliyoruz.
Sorun şu, git pull yaparken nasıl olur da ikinci private-public key'i kullanabilirim. Şuanda linuxte her bir repo için linuxte yeni bir kullanıcı açıyorum.
- `Çözüm` [bu](https://ma.ttias.be/specify-a-specific-ssh-private-key-for-git-pull-git-clone/) veya [bu](https://stackoverflow.com/a/4565746/7975831)  olabilir.

## Jenkinsfile'da nasıl Environment kullanılır.
- Jenkinsfile'da credentials fonksiyonunu kullanarak kısmen environment kullanabiliyoruz ama bu değer şifrelenmiş oluyor.


## Ubuntu ve Docker'da Network, Sanal Network
- Ubuntuda nasıl sanal network oluşturulur.
- Docker default olarak bridge ile sanal network oluşturuyor diye biliyorum. Bridge'in cli'ı var mı.
- ifconfig nasıl okunur.
- Subnet nedir ?
- Gateway nedir ?
- Route table nedir ?
- 10.0.0.x 172.24.x.x 192.168 ile başlayan ipler için özel bir durum var mı ?
- Docker containerlarının ip değerleri neden 172.17.x.x ile ile başlıyor.
- Bir bilgisayarı iki farklı network'e bağladığımızı düşünelim.
- Senaryo 1 için: Network A ip: 192.168.1.20, Network B ip: 192.168.1.21
    - Bu ip değerlerini oluşturmak mümkün mü ?
    - Ne şartlarda 192.168.1.30'a istek yaptığımızda Network A üzerindeki makineye ulaşırım.
    - İnternete çıkarken hangi networkten internete çıkarım. Bu networkü nasıl değiştiririm.
    - Bu networkler sanal olsaydı bir fark olur muydu ? 
- Senaryo 2 için: Network A ip: 192.168.1.20, Network B ip: 192.168.2.20
    - Bu makineler kesinlikle birbirini görebilirler mi, ne şartlarda göremezler.
- Ubuntuya dns server nasıl kurulur, open source dns uygulaması var mı. dns serverlar networkün hangi katmanında çalışıyor, portu var mı ?
- ufw nasıl çalışıyor, ufw ile bir portu kapattığımız zaman o portu işletim sisteminde bir uygulama dinleyebilir mi ? dinleyebiliyor ise ufw bir proxy server mıdır ?
- NetworkA içerisinde 4 cihaz bulunmakdadır, NetworkB içerisinde bu 4 cihazla beraber 1 cihaz daha bulunmaktadır, yani 5 cihaz. Bu 4 cihazın ilkine bağlanıp ufw ile 22 portunu kapattım. NetworkB de olup NetworkA da olmayan cihaz ile bu cihaza erişemezken, NetworkA üzerindeki diğer 3 cihaz ile 22 portuna hala erişebilir durumda idim. Neden ? Nasıl ?
