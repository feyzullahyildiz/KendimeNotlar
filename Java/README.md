### [<- GERİ](../README.md)
# Alt Başlıklar
- [Spring Boot, IoC, Shell etc.](./spring-boot/README.md)
## Java öğrenmeye başladık (IDE bağımlılığı olmadan)

- gradle ve maven'ı belirli seviyelerde öğrenmem lazım.
- sdkman diye birşey var. JDK versiyonları arasında geçiş yapabiliyoruz. Native windows support'u yok. WSL ile kullanabiliriz.
- Javanın native kütüphanelerini kullanmayı öğrenmem lazım.
- String'in implicit tip olduğunu hatırlıyorum. Eskiden kıyaslarken String.equals(string str) gibi bir method kullanlıyordu, hala böyle mi. Bi yerde 2 eşit kullanabiliyor gibi görmüştüm. Bu olay JDK veriyonları arasında breaking changes olarak mı geçti acaba ??
  - O kadar java yazmıştım, şunu bilmiyormuşum :D https://stackoverflow.com/a/513839/7975831
- JDK, SDK nedir, farkları nelerdir
- DSL diye bir syntax gibi bişey var. `build.gradle`, `setings.gradle` dosyaları için DSL diyebiliriz ve populer olanı Groovy

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

```
Select type of project to generate:
  1: basic
  2: application
  3: library
  4: Gradle plugin
Enter selection (default: basic) [1..4] 1

Select build script DSL:
  1: Kotlin
  2: Groovy
Enter selection (default: Kotlin) [1..2] 2

Project name (default: learning-java):
Generate build using new APIs and behavior (some features may change in the next minor release)? (default: no) [yes, no] no

> Task :init
To learn more about Gradle by exploring our Samples at https://docs.gradle.org/8.5/samples

BUILD SUCCESSFUL in 9s
2 actionable tasks: 2 executed
```

- Mümkün olduğunca en basic halini seçtim ve beklediğimden daha fazla dosya oluşmuş oldu.
- Dosyalar şöyle
- `gradlew` ve `gradlew.bat`
  - `gradlew` bir bash script. `gradlew.bat` ise aynısının windows friendly hali
- `settings.gradle` ve `build.gradle` DSL script ile hazırlanmış. Ne için kullanılıyor tam olarak hakim değilim.
- `gradle/wrapper/gradle-wrapper.jar` yaklaşık 43KB olan bir dosyamız. Defualt olarak `.gitignore`'a eklenmemiş.

### Gradle ile basic console app deneyelim.

- `gradle init`

```
Select type of project to generate:
  1: basic
  2: application
  3: library
  4: Gradle plugin
Enter selection (default: basic) [1..4] 2

Select implementation language:
  1: C++
  2: Groovy
  3: Java
  4: Kotlin
  5: Scala
  6: Swift
Enter selection (default: Java) [1..6] 3

Generate multiple subprojects for application? (default: no) [yes, no] no
Select build script DSL:
  1: Kotlin
  2: Groovy
Enter selection (default: Kotlin) [1..2] 2

Select test framework:
  1: JUnit 4
  2: TestNG
  3: Spock
  4: JUnit Jupiter
Enter selection (default: JUnit Jupiter) [1..4] 1

Project name (default: learning-java):
Source package (default: learning.java):
Enter target version of Java (min. 7) (default: 21):
Generate build using new APIs and behavior (some features may change in the next minor release)? (default: no) [yes, no] no

> Task :init
To learn more about Gradle by exploring our Samples at https://docs.gradle.org/8.5/samples/sample_building_java_applications.html

BUILD SUCCESSFUL in 1m 19s
2 actionable tasks: 2 executed

```

- Bu şekilde run edebileceğimiz komutlar var.
- run etmek için
  - `./gradlew run`
- tasklar var örnek kodlarımız
  - `./gradlew tasks`
  - `./gradlew tasks --all`
- test build
  - `./gradlew build`
  - `./gradlew jar`
  - `./gradlew help --task build`
- test için
  - `./gradlew test`
  - `./gradlew help --task test`

### Ufak derin bilgilerden

- `CWD` ve `./gradlew run` ilişkisi
  - file formatlarıyla falan çalışmamız gerektiği durumlarda CWD kullanmamız gerekir. Java en nihayetinde compile oluyor ve single file'a dönüyor. nodejs'de `__dirname` ve `__filename` gibi değişkenleri kullanabiliyorduk ama burada pek mantıklı değil gibi duruyor.
  - CWD için JAVA'da kullanılan kod şöyle
    - `String cwd = System.getProperty("user.dir");`
  - gradle ile run ettiğimizde CWD değeri farklı geliyor. Çünkü gradle, projeyi build ettikten sonra `app` dizine gidiyor ve projeyi orada run ediyor.
  - nasıl test ederiz peki
  - `./gradlew build` yada `./gradlew jar`
  - `java -jar ./app/build/libs/app.jar`
    - muhtemelen şu şekilde hata alacağız.
    - `no main manifest attribute, in ./app/build/libs/app.jar`
  - Bunun çözümü için, `build.gradle`'a jar için `Main-Class` propertisini girmek gerekiyor.
  ```groovy
  jar {
      manifest {
          attributes(
              'Main-Class': 'learning.java.App'
          )
      }
  }
  // ....
  // YADA application scope'undan okuyabiliriz.
  // ....
  application {
    mainClass = 'learning.java.App'
  }
  jar {
      manifest {
          attributes(
              'Main-Class': application.mainClass
          )
      }
  }
  ```
  - Sonrasında aşağıdaki kod çalışmalı ve CWD değerini düzgün bir şekilde alabilmeliyiz...
  - `java -jar ./app/build/libs/app.jar`
  - Eğer ki gradle'da bunun düzgün bir çözümü yok ise ve Maven bunu düzgün bir şekilde hallediyorsa. Gradle NET ÇÖPTÜR diyebiliriz :D

## File Okuma ve Yazma

```java
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.Path;
public class App {

    public void readFile() {
        String cwd = System.getProperty("user.dir");
        String fileName = "input.txt";
        Path filePath = Paths.get(cwd, fileName);
        System.out.println("File Path: " + filePath.toString());
        try {
            String fileContent = Files.readString(filePath);
            System.out.println("FileContent: " + fileContent);
            // Create file if not exists
            Path outputFilePath = Paths.get(cwd, "output.txt");
            if (!Files.exists(outputFilePath)) {
                Files.createFile(outputFilePath);
            }
            // Set text of file like this...
            Files.writeString(outputFilePath, "output file content 1");

        } catch (IOException e) {
            e.printStackTrace();
        }

    }

    public static void main(String[] args) {
        new App().readFile();
    }
}
// KODU şu şekilde çalıştırabilirsiniz. Bulunduğunuz path'e input.txt dosyası ekleyiniz
// ./gradlew build && java -jar ./app/build/libs/app.jar
```

## Library ekleme ve Build işlemi

- **BURADA HENÜZ ÇÖZEMEDİĞİMİZ BİR HATA VAR**
- Build ettiğinde kütüphaneleri bulamıyor, hata alıyoruz. Developmentta çalışıyor. Bunun sebebini öğrenmemiz lazım. `Öğrenemedik`.
- build.gradle'ımız şu şekilde.

```groovy
dependencies {
    // https://mvnrepository.com/artifact/com.google.code.gson/gson
    implementation group: 'com.google.code.gson', name: 'gson', version: '2.10.1'
}
```

- JSON file okuyup Gson ile parse edit console'a basmak istiyoruz.

```java
package learning.java;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.Path;
import com.google.gson.Gson;

public class App {
    public static class User {
        public int id;
        public String name;
        public String surname;
    }
    public void readFromJson() {
        String cwd = System.getProperty("user.dir");
        var jsonFilePath = Paths.get(cwd, "example.json");
        try {
            var jsonContent = Files.readString(jsonFilePath);
            System.out.println(String.format("jsonContent: %s", jsonContent));
            var gson = new Gson();
            var user = gson.fromJson(jsonContent, User.class);
            System.out.println(String.format("USER ID: %d", user.id));
            System.out.println(String.format("USER NAME: %s", user.name));
            System.out.println(String.format("USER SURNAME: %s", user.surname));

        } catch (IOException e) {
            e.printStackTrace();
        }

    }
    public static void main(String... argv) {
        new App().readFromJson();
    }
}
```

- CWD ile alakalı sorun yaşıyorduk ve hala yaşıyoruz.
- Örnekteki koda göre projenin ana dizini için bu path'i varsayalım --> `~`

```json
// ~/app/example.json       // ./gradlew CWD olarak hep app'in içinde.
// ~/example.json           // build edildikten sonra .jar file CWD'yi düzgün gördüğü için bunu kullanıyor
{
  "id": 151,
  "name": "ALİ",
  "surname": "Duru"
}
```

- `./gradlew run`'ı çalıştırıyorum ve kod çalışıyor.

```
USER ID: 151
USER NAME: ALİ
USER SURNAME: Duru
```

- Ama bu çalışmıyor.
- `./gradlew build && java -jar ./app/build/libs/app.jar`

```

BUILD SUCCESSFUL in 1s
7 actionable tasks: 6 executed, 1 up-to-date
jsonContent: {
  "id": 151,
  "name": "ALİ",
  "surname": "Duru"
}

Exception in thread "main" java.lang.NoClassDefFoundError: com/google/gson/Gson
        at learning.java.App.readFromJson(App.java:71)
        at learning.java.App.main(App.java:88)
Caused by: java.lang.ClassNotFoundException: com.google.gson.Gson
        at java.base/jdk.internal.loader.BuiltinClassLoader.loadClass(BuiltinClassLoader.java:641)
        at java.base/jdk.internal.loader.ClassLoaders$AppClassLoader.loadClass(ClassLoaders.java:188)
        at java.base/java.lang.ClassLoader.loadClass(ClassLoader.java:526)
        ... 2 more
```

# MAVEN

- gradle'a ara verdik, bi de maven ile denemeler yapalım...

## FAT JAR kavramı ve .jar dosyasını execute işlemi

- Dependency'leri de içeriyorsa buna `FAT JAR` diyorlar.
- Bu konu ciddi bir konu. Dependency kullandığımızda build ettiğimiz app'i run ettiğimizde patlıyoruz. Development'ta çalışmasına rağmen build (.jar dosyası) dependency'ileri bulamıyor.
- Benim anladığım, dependency'i import etmek için 2 yöntem var. Birisini `maven` developmentta iken kendisi handle ediyor ve `~/.m2` folderından import ediyor. Compile ederken `javac`'ı dependenciler için kullanmıyor olabilir, sadece yazdığımız kod için kullanıyordur muhtemelen. Ama compile edilmiş kod'u run ederken birden fazla .jar dosyası verebiliyor (Böyle çok kod gördüm Örnek: `java -cp lib\*.jar;. myproject.MainClass`). Bu yönteme fat jar Demiyoruz. Çünkü hepsi ayrı ayrı jar dosyaları. Ve henüz bunun nasıl yapıldığını bilmiyorum. Bir şekilde depend olan kütüphanenin jar dosyalarını target'ın içine kopyalayabilirsem olurdu ama henüz öğrenemedim :)
- Peki `FAT JAR` nasıl yapılıyor. Bu zıkkım için de plugin işine girmemiz gerekiyor. Pluginimizin adı; `maven-assembly-plugin`
- ```xml
    <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-assembly-plugin</artifactId>
        <version>3.3.0</version>
        <configuration>
        <archive>
            <manifest>
            <mainClass>com.mycompany.app.App</mainClass>
            </manifest>
        </archive>
        <descriptorRefs>
            <descriptorRef>jar-with-dependencies</descriptorRef>
        </descriptorRefs>
        </configuration>
    </plugin>
  ```
- `mvn clean compile assembly:single` yazıyoruz. İsmi, `mvn package`'ı run ettiğimizden daha farklı bir .jar dosyası çıkartıyor. Kıysalamak için `mvn clean package assemly:single`'ı run edebilirsiniz.
- `my-app-1.0-SNAPSHOT.jar` (5KB)
- `my-app-1.0-SNAPSHOT-jar-with-dependencies.jar` (278KB)
- İşin güzel tarafından biri de, bu jar dosyasının mainClass'ı tanımlamış oluyor. Direk şu şekilde çalıştırabiliyoruz. mainClass değeri default olarak verilmiş oluyor, yani run ederken -cp ile 2. parametrede verebiliyoruz.
- `java -jar my-app-1.0-SNAPSHOT-jar-with-dependencies.jar`
- [maven-01/pom.xml için buraya tıklayınız](./proje/maven-01/pom.xml)
- [maven-01/Dockerfile için buraya tıklayınız](./proje/maven-01/Dockerfile)

---

### Genel start ve compiler versiyon sorun çözümü

- sdk install maven
- mvn --version
- mvn archetype:generate -DgroupId=com.mycompany.app -DartifactId=my-app -DarchetypeArtifactId=maven-archetype-quickstart -DarchetypeVersion=1.4 -DinteractiveMode=false
- YADA mvn archetype:generate yazıyoruz. Runtime'da soruyor...
- cd my-app
- mvn package
  - Burada hata veriyor.
  - [ERROR] Source option 7 is no longer supported. Use 8 or later.
  - pom.xml içindeki şu değerleri 1.8 yapmak gerekiyormuş galiba, sonrasında çalıştı. Eski değeri 1.7 idi.
  - ```xml
      <maven.compiler.source>1.8</maven.compiler.source>
      <maven.compiler.target>1.8</maven.compiler.target>
    ```
- sonrasında `target/my-app-1.0-SNAPSHOT.jar` dosya çıkıyor.
- Bu isim pom.xml'de var. version ve artifactId'ye bakıyor
- `java -cp target/my-app-1.0-SNAPSHOT.jar com.mycompany.app.App`

### maven genel kodlar

- `mvn install`
- `mvn clean install`
- `mvn package`
- `mvn exec:java -Dexec.mainClass="com.mycompany.app.App"`
  - mainClass için aşağıda plugin kurduk, default değeri set edebiliyoruz.
- Build sonrası execute
- `java -cp target/my-app-1.0-SNAPSHOT.jar com.mycompany.app.App`

### Default mainClass'ı pom.xml'de tanımlamak

- Bu satırı ekliyoruz. Bu sayede default mainClass'ı belirlemiş oluyoruz. Bu string değeri jar dosyasının içine yazılmıyor diye anlıyorum. build edilmiş jar dosyasını run ederken gene de bu veriyi vermemiz gerekiyor

```xml
<!-- https://stackoverflow.com/a/2472767/7975831 -->
<plugin>
    <groupId>org.codehaus.mojo</groupId>
    <artifactId>exec-maven-plugin</artifactId>
    <version>1.4.0</version>
    <configuration>
    <mainClass>com.mycompany.app.App</mainClass>
    </configuration>
</plugin>
```

- `mvn exec:java` artık çalışır hale gelmiş oldu.

### Maven ile Kütüphane ekleme

- Hala build alından dosyadan kütüphane'ye erişemiyorduk. FAT JAR hazırlamayı öğrendik, yukarıyı oku.
- Gradle'da oluğu gibi

### Fat olmayan JAR file run ederken potansiyel hata

- Not, henüz bunu hazırlamayı bilmiyorum.

```sh
# Execute jar file with multiple classpath libraries from command prompt
# https://stackoverflow.com/a/25156085/7975831
# Using java 1.7, on UNIX -
# on UNIX
java -cp myjar.jar:lib/*:. mypackage.MyClass
# On Windows you need to use ';' instead of ':' -
java -cp myjar.jar;lib/*;. mypackage.MyClass
```

## ENV okuma

- Basit gözüküyor.

```java
String user = System.getenv("USER");            // Nullable
String javaHome = System.getenv("JAVA_HOME");   // Nullable
```

- Dotenv dosyaları için kütüphane gerekiyor gibi gözüküyor.
- dotenv-java
- dotenv-kotlin

## ARGS Okuma

- `mvn exec:java -Dexec.args="--foo bar"`
- YADA
- `java -cp ./target/my-app-1.0-SNAPSHOT-jar-with-dependencies.jar com.mycompany.app.App --foo bar`
- YADA
- `java -jar ./target/my-app-1.0-SNAPSHOT-jar-with-dependencies.jar --foo bar`

```java
public void logArgs(String[] args) {
    System.out.println("ARGS");
    String argsInString = String.join(", ", args);
    System.out.println(String.format("Args %s", argsInString));
}
```

- Sonuç 3 yöntem için de aynı

```txt
ARGS
Args --foo, bar
```
### Kütüphane ile deneyelim
- JCommander
```java

import com.beust.jcommander.Parameter;
public class MyArgs {
    @Parameter(names = { "-d", "--debug", "-debug" }, description = "Debug mode")
    private boolean debug = false;
    public void run() {
        System.out.println(String.format("Debug Mode %s", debug));
    }
}
----
import com.beust.jcommander.JCommander;
----
public static void main(String[] args) {
    MyArgs main = new MyArgs();
    JCommander.newBuilder()
            .addObject(main)
            .build()
            .parse(args);
    main.run();
}
```