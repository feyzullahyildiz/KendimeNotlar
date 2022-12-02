Field'ın oluduğu verileri getirme.

```javascript
db.collection.aggregate([{ $match: { $ne: null } }]);
```

Epoch to Date.

```javascript
db.collection.aggregate([
  {
    $project: {
      date: {
        $toDate: { $multiply: ["$creation_date", 1000] },
      },
    },
  },
]);
```

Epoch to Date.

```javascript
db.collection.aggregate([
  {
    $project: {
      date: {
        $dateToString: { format: "%Y-%m-%d", date: "$day" },
      },
    },
  },
]);
```

Created Date from _id
```javascript
db.collection.aggregate([
  {
    $addFields: {
      Date: { $toDate: "$_id" },
      Month: { $month: "$_id" },
      Year: { $year: "$_id" },
    },
  },
  {
    $addFields:  {
      year_month: {
        $dateToString: {
          format: "%Y-%m",
          date: "$Date",
        },
      }
    }
  }
]);
```

