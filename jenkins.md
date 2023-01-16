# Jenkins Installation on Ubuntu

```bash
sudo apt-get install default-jre

wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -

sudo sh -c 'echo deb https://pkg.jenkins.io/debian binary/ > /etc/apt/sources.list.d/jenkins.list

sudo apt-get update && sudo apt-get install jenkins

sudo systemctl start jenkins

# http://sistem-ip-adresi:8080 
```

# install docker
docker yükle. snap kullanma. Snap sadece belirli klasörlerde çalışmaya izin veriyor. Farklı pathlerden dosya okumaya izin vermiyor. Docker build yaparkan sıkıntı çıkıyor.
> SNAP ile docker yükleme, garip hatalara sebep olabiliyor. [link](https://stackoverflow.com/a/67310327/7975831)

### Add jenkins user to docker group

```bash
sudo usermod -aG docker jenkins
```