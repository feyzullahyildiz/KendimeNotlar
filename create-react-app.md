### Eski projemi nasıl create-react-app'e geçirdim. (eject etmeden)
- npx create-react-app frontend --typescript ile projemi kurdum.
- .env dosyası oluşturdum `EXTEND_ESLINT=true` ekledim
- eski projemin kodlarını kopyaladım
- Umd modül kullanıyorduk windowda bulunan değişkenler hata veriyordu.
- eslint ile oynamak gerekiyordu
- https://create-react-app.dev/docs/setting-up-your-editor/#experimental-extending-the-eslint-config gerekli bilgiler verilmiş olmasına rağmen düzgün çalışmıyor
- .eslintrc.js .eslintrc.json dosyalarına bakıp projeyi kaldırması gerekiyor ama `react-scripts`'in webpack.config.js dosyasında cache tutuyor ve bu durum config dosyanızı çalıştırmıyor. [Detay için](https://github.com/facebook/create-react-app/issues/9175#issuecomment-692519550)
- `node_modules/react-scripts/config/webpack.config.js` cache propertisini false yapmanız gerekiyor.
