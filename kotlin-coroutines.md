# Kotlin Coroutines


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

