
const finnhubLiveData = (socket, symbol, onMessage) => {

    
    // Connection opened -> Subscribe
    socket.addEventListener('open', function (event) {
        socket.send(JSON.stringify({'type':'subscribe', 'symbol': symbol}))
        // socket.send(JSON.stringify({'type':'subscribe', 'symbol': 'BINANCE:BTCUSDT'}))
        // socket.send(JSON.stringify({'type':'subscribe', 'symbol': 'IC MARKETS:1'}))
    });
    
    // Listen for messages
    socket.addEventListener('message', onMessage);
    
    // Unsubscribe
    var unsubscribe = function(symbol) {
        socket.send(JSON.stringify({'type':'unsubscribe','symbol': symbol}))
    }
}

export { finnhubLiveData };