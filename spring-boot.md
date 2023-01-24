# SpringBoot
Local development için notlar:
- Oraclejdk kuruyoruz, şuanda en son 19 var.
- Çoğu zaman locale maven kurmaya gerek kalmıyor.
- Bir proje oluşturmak için https://start.spring.io/ sitesini kullanabiliriz. Yada SDKMAN diye birşey var. Localde app create edebiliyorsun. Windowsa kurmak için tricky birşeyler yapmak gerekiyor galiba denemedim. 

## Maven ile akalı
- Projelerin içinde maven için bir jar dosyası geliyor (bazılarında).
- `spring-boot-app\.mvn\wrapper\maven-wrapper.jar`.
- Dolayısıyla maven'ı kurmaya gerek kalmadan sadece java ile bunu run edebiliyorsun.


```BASH
# bağımlılıkları siliyor
./mvnw clean
# bağımlılıkları yüklüyor ve build ediyor
./mvnw package
# projeyi build edip run ediyor
./mvnw spring-boot:run

```
Oluşan .jar dosyası `target/*.jar` olarak oluşuyor.

Not:
- Oracle JDK paralı olacaktı ama hala beleş galiba.
- ChatGPT jdk17 için support olmadığını, docker ile uyumsuz gibi birşeyler dedi.