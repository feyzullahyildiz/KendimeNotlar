
## Mongo DB Chart Authentiation Setup Notes

There are couple authention method is provided by mongodb atlas. We are going to use Custom JWT method. There are 2 Algorithm is supported by Mongodb Atlas.

- **HS256** (secret key only)
- **RS256** (private and public key, we are going to use this one)

Our backend will create a token with Private key. We will send the token from client to Mongodb atlas. Mongodb Atlas will try to verify that token with its public key.

> **_NOTE:_** You need to install openssl. For windows you can use with [winget](https://winget.run/pkg/ShiningLight/OpenSSL) or with [chocolatey](https://community.chocolatey.org/packages/openssl)

**To create private and public key**

```BASH
# This will create private key
openssl genrsa -out private_key.pem 1024
# this will create public key
openssl rsa -in private_key.pem -pubout -out public_key.pem
```

In MongoDB Atlas

- Go `Charts -> Development-Embedding -> Authentication Settings`
- Click `Add` button
- Give a name to the `Provider`
- Select Custom JSON Web Token as `Provider`
- Select Algorithm as `RS256`
- Select Signin-Key as `PEM public File`
- Enter the public key value to the textarea.
- Save it

In Backend

```typescript
import jwt from "jsonwebtoken";
import fs from "fs-extra";

// this function returns Buffer.
// I recommend you to use with Buffer not with string or not with encoding
const privateKey = fs.readFileSync("private_key.pem");

const token = jwt.sign({}, privateKey, { algorithm: "RS256", expiresIn: "1h" });

// You can use aud value here if you used aud value in mongodb atlas chart
// const token = jwt.sign({aud: "chart-only"}, privateKey, { algorithm: 'RS256', expiresIn: '1h' })
```

In Frontend

```typescript
import React, {
  SyntheticEvent,
  useEffect,
  useLayoutEffect,
  useRef,
  useState,
} from "react";
import ChartsEmbedSDK from "@mongodb-js/charts-embed-dom";

function App() {
  const divRef = useRef(document.createElement('div'));

  useLayoutEffect(() => {
    const sdk = new ChartsEmbedSDK({
      baseUrl: "https://charts.mongodb.com/charts-getir-todo-ktjra",
    });
    const chart = sdk.createChart({
      chartId: "637cc4ba-09cb-413e-8226-9e329ff05343",
      theme: "light",
      getUserToken: () => {
        return window.prompt("Type your token") || "";
      },
    });
    chart.render(divRef.current).catch((e) => {
      console.log("chart render ERROR", e);
      try {
        setState(JSON.parse(e.message).verbose);
      } catch (error) {
        setState(`ERROR`);
      }
    });
  }, []);

  return <div className="chart" ref={divRef}></div>;
}
```

Notes:

- The token should have a expire time and It should be 1 hour at most. Otherwise MongodbAtlas does not verify the token. [docs](https://www.mongodb.com/docs/charts/configure-auth-providers/#std-label-configure-auth-providers)
