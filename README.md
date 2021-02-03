# Kendime Notlar
- [Docker](./docker/Docker.md)
- [DockerSwarm](./docker/DockerSwarm.md)
- [create-react-app](./create-react-app.md) ile alakalı notlarım
- [kotlin-coroutines](./kotlin-coroutines.md)
- [ssh](./ssh.md)


# Kendime Sorularım
## ssh-keygen ve git'i ssh ile kullanma
- github-gitlab gibi git serverlarından private repolardan şifresiz bir şekilde git pull, git clone yapabilmek için ssh-keygen ile private ve public key oluşturuyoruz. Public key'i github'a ekledikten sonra git pull yapabiliyoruz. Githubda bir public key'i iki farklı repoda kullanamıyoruz, github izin vermiyor. Dolayısıyla ikinci bir private-public key oluşturmamız gerekiyor. ssh-keygen ile key oluştururken dosya adı verebiliyoruz dolayısıyla rahatlıkla birden fazla key oluşturabiliyoruz.
Sorun şu, git pull yaparken nasıl olur da ikinci private-public key'i kullanabilirim. Şuanda linuxte her bir repo için linuxte yeni bir kullanıcı açıyorum.
- `Çözüm` [bu](https://ma.ttias.be/specify-a-specific-ssh-private-key-for-git-pull-git-clone/) veya [bu](https://stackoverflow.com/a/4565746/7975831)  olabilir.

## Jenkinsfile'da nasıl Environment kullanılır.
- Jenkinsfile'da credentials fonksiyonunu kullanarak kısmen environment kullanabiliyoruz ama bu değer şifrelenmiş oluyor.
