# Kotlin Coroutines


### `runBlocking`
- `runBlocking` herhangi bir fonksiyonda çağrılabilir.
- başlatıldığı scope farklı thread'de olabilir.
- alttaki kod örneğinde main thread blocklanmamış oluyor. 

```kotlin
import kotlinx.coroutines.*

fun log(str: String) {
    println("(Thread: ${Thread.currentThread().name}) $str")
}

fun main() {
    log("main start")
    val value = runBlocking(Dispatchers.IO) {
        for (i in 0..3) {
            Thread.sleep(300)
            log("sleeping $i")
        }
        return@runBlocking 10
    }
    log("main end $value")
}

/*OUTPUT*/
(Thread: main) main start
(Thread: DefaultDispatcher-worker-1) sleeping 0
(Thread: DefaultDispatcher-worker-1) sleeping 1
(Thread: DefaultDispatcher-worker-1) sleeping 2
(Thread: DefaultDispatcher-worker-1) sleeping 3
(Thread: main) main end 10

Process finished with exit code 0
```

## Suspend function
- `suspend` function'ın içerisinde başka bir `suspend` function çağırabilirsiniz.
- `suspend` fun içerisinde bir `suspend` fun çağırılıyor ise önce onun bitmesini bekliyor.
- `suspend` olmayan function içersinde `suspend` function çağırma işlemi için funtion'ı birkaç özellik katmanız gerekiyor. (galiba)
- Bunlardan birisi `runBlocking` ve içerisinde delay koyabilirsiniz.

```kotlin
import kotlinx.coroutines.*

fun log(str: String) {
    println("(Thread: ${Thread.currentThread().name}) $str")
}
fun main () {
    log("main start")
    second()
    log("main end")
}
fun second() = runBlocking {
    log("second start")
    delay(1000)
    doHello()
    delay(1000)
    log("second end")
}

suspend fun doWorld() {
    delay(100L)
    log("World!")
}
suspend fun doHello() {
    delay(100L)
    log("Hello!")
    doWorld()
}

/*OUTPUT*/
(Thread: main) main start
(Thread: main) second start
(Thread: main) Hello!
(Thread: main) World!
(Thread: main) second end
(Thread: main) main end

Process finished with exit code 0
```


## Launch Örneği

`launch` örneği, alttaki koddan çıkardığımız yorum şudur. `launch` kendi scope'unda bağımsız çalışır ve kendinden sonraki kodları bekletmez. Outputta göründüğü gibi `main end` logu en son geldiği için tüm işlemler bittikten sonra `main` fonksiyonuna düşüyor. Kendi scope'unda bağımsız çalışır ama çağırıldığı fonksiyona düşerken `launch` bittikten sonra düşer.


```kotlin
fun log(str: String) {
    println("(Thread: ${Thread.currentThread().name}) $str")
}

fun main() {
    log("main start")
    second()
    log("main end")
}

fun second() = runBlocking {
    log("second start")
    launch(Dispatchers.IO) {
        log("IO launch start")
        delay(3000)
        log("IO launch end")
    }
    launch {
        log("Default launch start")
        delay(3000)
        log("Default launch end")
    }
    delay(2000)
    log("second end")
}

/*OUTPUT*/
(Thread: main) main start
(Thread: main) second start
(Thread: DefaultDispatcher-worker-1) IO launch start
(Thread: main) Default launch start
(Thread: main) second end
(Thread: DefaultDispatcher-worker-1) IO launch end
(Thread: main) Default launch end
(Thread: main) main end

```
### `launch` için Notlar
- `suspend` function'ın içerisine de normal functiona da direk eklenemez. Ya `runBlocking` ya `coroutineScope` yada türevi (belki yoktur) birşeyi koymanız gerekiyor.
- `suspend` function'a `launch` koyarken `runBlocking` koyarsanız intellij warning veriyor, `coroutineScope` koyunca warning gidiyor. 
- launch çalıştığı scopedan bağımsız(paralel) çalışıyor. Ama aynı threadde yaptığımız için sequential olarak çalışıyor bu da istediğimiz bir şey.


###  Paralel işleri single threadde başlatabilmek
- SQLite gibi databasedeki tüm işlemleri tek threadde yapmak gerekir.
- Bunun için örnek bir kod yazdım, launch paralel
```kotlin

fun log(str: String) {
    val prefix = "(Thread: ${Thread.currentThread().name})".padEnd(24, ' ')
    println("$prefix $str")
}

@ObsoleteCoroutinesApi
fun main() = runBlocking {
    log("main start")
    val res = launch {
        val total = executeQueryOnDb("fake_query_1") +
                executeQueryOnDb("fake_query_2")
        log("launch total: $total")
    }
    executeQueryOnDb("the last one")
    res.join()
    log("main end")
}

@ObsoleteCoroutinesApi
suspend fun executeQueryOnDb(query: String): Int {
    return withContext(newSingleThreadContext("DB_THREAD")) {
        log("$query START")
        Thread.sleep(2000)
        log("$query END")
        return@withContext 100
    }
}

/*OUTPUT*/
(Thread: main)           main start
(Thread: DB_THREAD)      fake_query_1 START
(Thread: DB_THREAD)      the last one START
(Thread: DB_THREAD)      fake_query_1 END
(Thread: DB_THREAD)      the last one END
(Thread: DB_THREAD)      fake_query_2 START
(Thread: DB_THREAD)      fake_query_2 END
(Thread: main)           launch total: 200
(Thread: main)           main end

Process finished with exit code 0
```
### Thread Pool tanımlama
`newSingleThreadContext` deperate olacak [bakınız](https://github.com/Kotlin/kotlinx.coroutines/issues/261). Tavsiye edilen kullanım için `newSingleThreadContext` yerine `newFixedThreadPoolContext` kullanmalıyız.
```kotlin
val DB = newFixedThreadPoolContext(10, "DB")
withContext(DB) {
    ...
}
```

