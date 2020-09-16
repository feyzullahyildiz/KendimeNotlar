## Kotlin Coroutines
- supend fun içerisinde bir supend fun çağırılıyor ise önce onun bitmesini bekliyor.
- suspend olmayan function içersinde supend function çağırma işlemi için funtion'ı birkaç özellik katmanız gerekiyor. (galiba)
    - bunlardan birisi runBlocking
    -
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
    // runBlocking is needed
    fun second() = runBlocking { 
        log("second start")
        doHello()
        log("second end")
    }

    suspend fun doWorld() {
        delay(1000L)
        log("World!")
    }
    suspend fun doHello() {
        delay(1000L)
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