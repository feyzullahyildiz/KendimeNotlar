# Java öğrenmeye başladık (IDE bağımlılığı olmadan)
- gradle ve maven'ı belirli seviyelerde öğrenmem lazım.
- sdkman diye birşey var. JDK versiyonları arasında geçiş yapabiliyoruz. Native windows support'u yok. WSL ile kullanabiliriz.
- Javanın native kütüphanelerini kullanmayı öğrenmem lazım.
- String'in implicit tip olduğunu hatırlıyorum. Eskiden kıyaslarken String.equals(string str) gibi bir method kullanlıyordu, hala böyle mi. Bi yerde 2 eşit kullanabiliyor gibi görmüştüm. Bu olay JDK veriyonları arasında breaking changes olarak mı geçti acaba ??
- JDK, SDK nedir, farkları nelerdir

## SDKMAN kurulumu, kullanımı
- https://sdkman.io/install
- yüklerken patladık, wsl'de unzip ve zip yokmuş :D
    - sudo apt-get install unzip
    - sudo apt-get install zip
- `source "$HOME/.sdkman/bin/sdkman-init.sh"` 
    - bu `~/.bashrc` dosyasına bu path'i ekliyor
- `sdk version`
- `sdk help`
- `sdk list java`
- Amazonun kendi JDK'sını kuruyoruz galiba
- `sdk install java 21-amzn`
- `sdk use java 21-amzn`
- Bundan sonra teminali kapatmak gerekiyor galiba, en azından WSL'de böyle oldu. Altaki kodu hemen görmemişti.
- `java -version`
    - ```
        openjdk version "21.0.1" 2023-10-17 LTS
        OpenJDK Runtime Environment Corretto-21.0.1.12.1 (build 21.0.1+12-LTS)
        OpenJDK 64-Bit Server VM Corretto-21.0.1.12.1 (build 21.0.1+12-LTS, mixed mode, sharing)
        ```
- `javac -version`
    - ```
        javac 21.0.1
        ```
- Başka versiyon kuralım
- `sdk install java 21-open`
### Gradle gibi toolları da buradan kurabiliyormuşuz..
- `sdk install gradle`
- `gradle --help`

## Gradle'la da bakalım birazcık
- `gradle init` (bunu başka projede deniyorum)