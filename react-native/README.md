## [<-- GERİ](../README)

# React Native
Şuanda buraya pek yazacağım birşey yok.

## TV Desteği
TV desteğinin ayrı bir şekilde yapılmasının bir sebebi var. Kumanda ile yön tuşlarına bastığımız zaman hangi tuş'un seçili olduğunu belirtmemiz gerekiyor. `react-native`'in içinde bu olay yok. Core levelda yok yani. (onFocus, onBlur functionları tetiklenmiyor) Bunu sağlayan kütüphanelerden birisi de `react-native-tvos`. Hem android hem apple tv'ye desteği var.
- react-native'in içinde tv desteğinin nasıl verildiği ile alakalı birkaç şey yazmış ama yapamadım. buraya bakabilirsiniz; https://reactnative.dev/docs/building-for-tv

Kütüphane hakkında bilgi;
- react-native'i forklamışlar ve gerekli olan iyileştirmeleri kütüphanenin içine koymuşlar. Mümkün olduğunca pek kod değişikliği yapmamışlar, README.md bile değiştirilmemiş. Bu sebepten dolayı dökümantasyonunu bulmak bile zor oluyor :D
- main reposu (forklanmış olan) https://github.com/react-native-tvos/react-native-tvos
- dökümanların olduğu bölüm https://github.com/react-native-tvos/react-native-template-typescript-tv
- npm yerine yarn kullanmak daha sağlıklı. Projeyi kurudktan sonra bir npm ile 1 tane bile kütüphane yükleyemedim, force kullansam bile çalışmadı. Saçma sapan hatalar alıyoruz.
- Wiki sayfası [react-native-tvos/react-native-tvos/wiki](https://github.com/react-native-tvos/react-native-tvos/wiki)
    - Burada ilginç bilgiler var, son 1 yıldır güncellenmemiş ama tv için farklı bir kütüphane olduğunu burada öğrendim. ReNative, ileride bu kütüphane çok iyi yerlere gelebilir. Güncellemeleri devam ediyor. 3 yıl önce 11 platforma destek veriyor. Şuanda bu sayı 15 olmuş.
        - ReNative allows you to bootstrap, develop and deploy apps for mobile, web, TVs, desktops, consoles, wearables and more via a single development environment.
        - android tv, apple tv
        - xbox, playstation
        - oculus
        - amazon alexa
        - apple windows desktop app
        - chrome, mozilla extention
        - etc.