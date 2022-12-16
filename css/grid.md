## Soru (grid-column: auto /span 2):
Gridinizin toplam column sayısı `12` ve her biri `1fr` değerinde.
Elinizde sayısını bilmediğiniz bir dizi eleman var. Herbirinin içinde katsayısı yazıyor.
Bu katsayı değerine göre genişlik vermeniz isteniyor.

```css
/* Örnek CSS Kodu */
.grid {
  display: grid;
  grid-gap: 1rem;
  grid-template-columns: repeat(12, 1fr);
}
```

```javascript
const data = [
  { id: 1, column: 12 },
  { id: 2, column: 6 },
  { id: 3, column: 6 },
  { id: 4, column: 4 },
  { id: 5, column: 4 },
  { id: 6, column: 4 },
];
```

Buradaki veriden anladığımız üzere. İlk veri tam genişlikte. 2 ve 3 id değerine sahip veriler aynı satırda toplam 2 tane olacak şekilde olmalı. Son 3 veri de son satıra sığmalıdır.

## Cevap:
React yoluyla anlatalım.

```jsx
const App = () => {
  const data = [
    { id: 1, column: 12 },
    { id: 2, column: 6 },
    { id: 3, column: 6 },
    { id: 4, column: 4 },
    { id: 5, column: 4 },
    { id: 6, column: 4 },
  ];

  return (
    <div className="grid">
      {data.map((item) => (
        <div style={{ "grid-column": `auto / span ${item.column}` }} />
      ))}
    </div>
  );
};
```
