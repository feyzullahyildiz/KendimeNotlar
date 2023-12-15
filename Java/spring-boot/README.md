
# Spring Boot
- Genelde WEB dependency'si ile kullanıldığı için böyle örnekler var.

## Genel komutlar
- `mvn spring-boot:run`
- `mvn spring-boot:run -Dspring-boot.run.arguments="--person.name=TestFOOBAR"` 
- `mvn spring-boot:run -Dspring-boot.run.arguments="start --input foobar.txt --output output.txt"`
## Annotationlar
- `@SpringBootApplication`
    - Ana Java class'ının başına veriliyor
- `@RestController`
    - Herhangi bir Class'a verilebilir. Controller olduğuna işaret
- `@RequestMapping("/api")`
    - Genelde `@RestController` ile beraber kullanılır.
- `@GetMapping("user/{id}")`
- `@PostMapping("user")`
- `@Autowired`
    - `IoC`'deki ilgili instance'ı almak için kullanılır. Genelde Interface'leri veririz.
    - ```java
        public class UserController {
            // 3 tane injection tipimiz var.
            // Field injection, pek tavsiye edilmiyor. Test yazarken extra iş yükü
            // çıkartıyor
            // Setter injection
            // Constructor injection, (TAVSIYE OLAN BUDUR)

            // Field injection
            @Autowired
            FirstClass firstClass;

            // Setter injection
            SecondClass secondClass;
            @Autowired
            public void setSecondClass(SecondClass sc) {
                this.secondClass = sc;
            }

            // Constructor injection
            ThirdClass thirdClass;
            public UserController(ThirdClass tc) {
                this.thirdClass = tc;
            }

            @GetMapping("/names")
            public String getNames() {
                return String.join(",",
                        this.firstClass.getName(),
                        this.secondClass.getName(),
                        this.thirdClass.getName());
            }
        }
    ```
- `@Qualifier(String str)`
    - Autowired ile beraber kullanılır
    - 1den fazla `IoC`'de instance var ise, hangisinin instance'ını istiyorsak. İlgili classın adını camelCase'e çevirerek veririz. Kendimiz özel bir isim vermek istersek. Instance'ı istenen class için anotasyonu şu şekilde yapabiliriz `@Component(String str)`. Bean için ise, `function ismi` yada `@Bean(String str)`
- `@Primary`
    - `@Qualifier` kullanmak istemiyorsak ve default instance istiyorsak, istediğimiz `@Compontent`'in Class'ına yada `@Bean`'in function'ına bu anotasyonu ekliyoruz ve o default olarak geliyor. Aynı anda 1 interface için 2 tane Primary veremiyoruz, App crash oluyor.
- `@Component`
    - Bunun instance'ını Spring kendisi yapıyor.
- `@Bean`
    - Bu bir function ve Spring bunu run edip, return ettiği değeri tutuyor.
    - Örnek; DB bağlantılarını bu fonksiyon içinde okuyup, instance return edebiliriz
    - Ana java class'ına böyle bir fonksiyon/method yazabiliriz. Yazıldığı class içinde SpringBoot'a ait en az bir anotasyon olmalı.



## Spring Shell
Command Line Application için kullanlıyor ve Çoğu özellik beraberinde geliyor.

Bana göre çok saçma birşey yaşadım.
- `spring initializr` ile bir proje oluşturdum ve dependency olarak `Spring Shell` ekledim.
- `mvn clean package` ve ne beklersiniz. (Ben target içinde jar dosyası oluşturmasını bekledim) Ama process bir türlü bitmedi.
- `package` goal'ünü çalıştırınca default olarak `test` yaptığı için burada kilitlendi diye düşündüm. Çünkü app ayağa kaldınca ölümüne `standart input` üzerinden veri bekliyor. Proje ile gelen test'leri commentledim ve package çalıştı.
### Spring Shell İçin genel komutlar
- ARGS göndermek için
    - `mvn spring-boot:run -Dspring-boot.run.arguments="start --input foobar.txt --output output.txt"`
- Build sonrası jar'a göndermek için
    - `mnv clean package`
    - `java -jar ./target/demo-0.0.1-SNAPSHOT.jar start --input my-input.file.txt --output my-outputfilepath.json.txt`
### Default Logları kapatmak için
`src/main/resources/application.properties`
```txt
logging.level.root=OFF
spring.main.banner-mode=off

```

### Binary executable yapmak. `ÇALIŞMADI`
- `mvn -Pnative native:compile -DskipTests=true`
Bir hata aldım.
```
Failed to execute goal org.graalvm.buildtools:native-maven-plugin:0.9.28:compile (default-cli) on project demo: 'gu' tool was not found in your JAVA_HOME.This probably means that the JDK at '/home/feyz/.sdkman/candidates/java/current' is not a GraalVM distribution
```
sdkman ile Graal Cloud Native kurup tekrar deniyor olacağım.
`sdk install gcn`
- Olmadı.
- Ayrı bir JDK varmış `sdk install java 21.0.1-graalce`
- Olmadı, bu da başka bir hata verdi. İkisini beraber ve ayrı denedim, olmadı.
- Spring Initializr'da bir dependency var. Onuda kısmen denedim ama olmadı gibi. (GraalVM Native Support)

