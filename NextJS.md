# NextJS 13 Notlarım

### page.tsx

- `/hakkimizda` route için
- `app/hakkimizda/page.tsx`
- bu path içinde `page.jsx` yada `page.tsx` olmalı. default export olmalı. Bu sayfa render edilir.

### dinamik route

- `/ali-veli`
- `app/[blog]/page.tsx`
- burada, tek slash olan tüm route'ları karşılamış oluyoruz. `/ali/veli`'ye yapılan istekler buraya **düşmez**

```tsx
export default Blog({params}) {
    return <div>{prams.blog}</div>
}
```

### Catch all routes

- `app/[...blog]/page.tsx`
- `/` dışında yapılan istekler buraya düşer.
- Aşağıdaki path'leri karşılar diyebiliriz.
  - `/*`
  - `/ali`
  - `/ali/veli`
  - `/ali/duru/veli/durmaz`

```tsx
export default function Blogs({ params }) {
  return <div>PARAMS: {params.blog.join(", ")}</div>;
}
```

### Optional Catch Routes

- Bu routeler'ı karşılamak için
  - `/docs`
  - `/docs/1`
  - `/docs/1/info`
- `app/docs/[[...posts]]/page.tsx`

Burada 2 tane köşeli parantez kullandığımız için optional oluyor. `/docs`'a atılan isteği de buraya düşünürüyor. Eğer tek braket kullansaydık `/docs`'a atılan istek 404 verirdi.

### Link

```tsx
import Link from "next/link";
export default function Blogs({ params, ...props }) {
  return (
    <>
      <Link href="/">Main</Link>
      <br />
      <Link href="/docs/1">Docs/1</Link>
      <br />
      <Link
        href={{
          pathname: "/docs",
          query: { foo: "bar", ids: ["1", "2", "3"] },
        }}
        prefetch={true}
      >
        Docs with queryparams
      </Link>
    </>
  );
}
```

v14 için; prefetch sadece production'da aktifleşiyormuş. 3 state'i var.

- `null (default)`
  - static path'ler için fetch yapılıyor. dinamik route'lar için en yakındaki loading.tsx çağırılacak diyor çok anlamadım.
- `true`
- `false`

### Loading.tsx

- default olarak Server component'i, client'ta da çalışabilir olarak yapılabilir.
- `props` tamamen boş olarak geliyor.
- Yüklenirken render ediliyor...

#### Error.tsx

- client component olmak zorunda ama server'daki hataları da burada görebiliz.
- props içinde error ve reset adında 2 property var. reset bir function. error ise bir Error

```tsx
"use client"; // Error components must be Client Components

import { useEffect } from "react";

export default function Error({
  error,
  reset,
}: {
  error: Error & { digest?: string };
  reset: () => void;
}) {
  useEffect(() => {
    // Log the error to an error reporting service
    console.error(error);
  }, [error]);

  return (
    <div>
      <h2>Something went wrong!</h2>
      <button
        onClick={
          // Attempt to recover by trying to re-render the segment
          () => reset()
        }
      >
        Try again
      </button>
    </div>
  );
}
```

### 404, not-found.tsx

- Route olarak yakalanmayan pathler için kullanlıyor.
- `app/not-found.tsx` tüm uygulamadaki pathleri karşılayacaktır.
- props'u boş geliyor.
  > v13'de bu not-found.tsx olmayabilir. pages/404 vardı (Sadece 13'ün ilk versiyonlarında da bu şekilde olabilir)

> not-found.tsx'i bir klasör altına koyunca 404 hatası verdiremedim. app/not-found.tsx çalışıyor ama app/hakkimizda/not-found.tsx hiç çalışmadı.


### head.tsx
Bulunduğu path'in en derinindeki head.tsx çalışır. Parent klasörlerdeki head.tsx çalışmaz.


# Extra Notlarım
- app/lib
  - Contains functions used in your application, such as reusable utility functions and data fetching functions.
- app/ui
  - componentler içinmiş
  - `global.css` gibi dosyaları da buraya koyuyorlar
- /scripts: Contains a seeding script that you'll use to populate your database in a later chapte