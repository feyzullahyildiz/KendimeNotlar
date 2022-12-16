# This ile alakalı

Aşağıdaki kod bloğunda neden this hatası alıyoruz. (Tekrardan bind edersek çalışıyor)

Örnek bind
```javascript
Provider._getTokenAndEmitEvent = Provider._getTokenAndEmitEvent.bind(Provider);
```
```javascript
    
const getNewToken = async () => {
    return 'TOKEN';
} 
const Provider = {
    _token: null,
    _cbs: [],
    _intervalID: null,
    _initInterval: function (cb) {
        console.log('_initInterval')
        if (this._token) {
            cb(this._token);
        }
        if (this._intervalID) {
            return;
        }
        console.log('start _initInterval', this);
        this._getTokenAndEmitEvent();
        // Bu satır nasıl oluyorsa this'i değiştiriyor
        // I DUNNO WHYYYY
        this._intervalID = setInterval(this._getTokenAndEmitEvent, 10 * 1000)
    },
    _stopInterval: function () {
        console.log('start _stopInterval')
        // Check Interval ID
        if(!this._intervalID) {
            return;
        }
        // Check CB array len
        if (this._cbs.length === 0) {
            console.log('STOPPED INTERVAL')
            clearInterval(this._intervalID);
            this._intervalID = null;
            this._token = null;
        }
    },
    subscribe: function (cb) {
        this._cbs.push(cb);
        this._initInterval(cb);
        return cb;
    },
    unsubscribe: function (cb) {
        const i = this._cbs.indexOf(cb);
        this._cbs.splice(0, i);
        this._stopInterval();
    },
    _emitEvents: function () {
        const t = this._token;
        this._cbs.forEach(cb => cb(t));
    },
    _getTokenAndEmitEvent: async function () {
        this._token = await getNewToken();
        this._emitEvents();
    },
};


const cb = Provider.subscribe((token) => {
    console.log('TOKEN', token)
});
setTimeout(() => {
    Provider.unsubscribe(cb);
}, 1000)
```

