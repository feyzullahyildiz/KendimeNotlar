
# Aynı windows hesabında çoklu git-github hesabı kullanımı
**Not: Çok daha farklı yöntemleri olabilir, ben bunu buldum**

- `~/.gitconfig` adında bir dosya var. Buraya değişkenler atıyoruz diyebiliriz.
    - Anladığım kadarı ile burası zorunlu değil, ama commit history'sinde diğer mail adresini görebilirsiniz.
### .gitconfig dosyası
- `git config --global user.name "A. Feyzullah YILDIZ"`
- `git config --global user.email "feyzullah.yildiz@orioninc.com"`
```
# .gitconfig
[user]
    name = A. Feyzullah YILDIZ
    email = feyzullah.yildiz@orioninc.com
```
- Eski hali bu şekilde idi. Bu PC'de kişisel github hesabımı da kullanmak istiyorum.
- .gitconfig dosyası içindeki user ile alakalı herşeyi buradan alıcaz
```
# .gitconfig yeni hali
[includeIf "gitdir:~/Desktop/feyz_projects/"]
path = ~/.gitconfig.home
[includeIf "gitdir:~/Desktop/projects/"]
path = ~/.gitconfig.work
```
- 2 dosya oluşturuyoruz.
    - .gitconfig.work
    - .gitconfig.home
```
# .gitconfig.work
[user]
	name = A. Feyzullah YILDIZ
	email = feyzullah.yildiz@orioninc.com
```
```
# .gitconfig.home
[user]
	name = A. Feyzullah YILDIZ
	email = ahmet.feyzullah.yildiz@gmail.com
```
Test Etmek için
- `cd ~/Desktop/feyz_projects/`
- `git config --get user.email`
- OUTPUT: ahmet.feyzullah.yildiz@gmail.com
- `cd ~/Desktop/projects/`
- `git config --get user.email`
- OUTPUT: feyzullah.yildiz@orioninc.com

### SSH bölümümüz
- ssh-keygen ile key üretiyoruz.
- `ssh-keygen -t rsa -b 4096 -C "ahmet.feyzullah.yildiz@gmail.com"`
    - denemedim ama muhtemelen sadece argument vermeden de çalışır diye düşünüyorum.
- dosya adını `github_feyzullahyildiz` verin.
- Oluşan dosyanın `~/.ssh/github_feyzullahyildiz` olduğuna emin olun
- github.com bu ssh public key'ini ekleyin https://github.com/settings/keys
- yoksa eğer `~/.ssh/config` adında bir dosya oluşturuyoruz
```
# ~/.ssh/config
Host github.com-feyzullahyildiz
	HostName github.com
	User git
	IdentityFile ~/.ssh/github_feyzullahyildiz
```
- Burada ilginç birşey yapıyoruz :D
- Host olarak verdiğimiz değer `github.com-feyzullahyildiz` bu şekilde
- Kişisel hesaplarımı artık ssh ile kullanacağız. Ve URL'lerini değiştireceğiz :)
- `git@github.com:feyzullahyildiz/KendimeNotlar.git`
- yerine aşağıdaki gibi yapacağız
- `git@github.com-feyzullahyildiz:feyzullahyildiz/KendimeNotlar.git`