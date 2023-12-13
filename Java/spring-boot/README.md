
# Spring Boot
- Genelde WEB dependency'si ile kullanıldığı için böyle örnekler var.

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