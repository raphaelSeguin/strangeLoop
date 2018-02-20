const express = require('express');
const socket = require('socket.io');
const osc = require('osc');
//const router = express.Router();

const getIPAddresses = function () {
    var os = require("os"),
        interfaces = os.networkInterfaces(),
        ipAddresses = [];

    for (var deviceName in interfaces) {
        var addresses = interfaces[deviceName];
        for (var i = 0; i < addresses.length; i++) {
            var addressInfo = addresses[i];
            if (addressInfo.family === "IPv4" && !addressInfo.internal) {
                ipAddresses.push(addressInfo.address);
            }
        }
    }

    return ipAddresses;
};
const ipAdress = getIPAddresses()[0];
const app = express();
const welcome = (req, res) => {
  res.sendFile(__dirname + '/index.html');
}
const server = app.listen(8000, ipAdress, () => {
  console.log('allo, oui j\'écoute : ' + ipAdress + ":8000");
});

const io = socket(server);
app.use(express.static('public'));
app.get('/', welcome);

io.on('connection', (socketEvent) => {
  console.log('socket!!!');
  socketEvent.on('color', (data) => {
    console.log(data);
    udpPort.send({
        address: "/color",
        args: [data.r, data.g, data.b]
    }, "127.0.0.1", 57110);
  });
  socketEvent.on ('disconnect', () => {
    console.log("disconnection");
  });

});

// mettre p5 et.js et socket.io dans le dossier public
var udpPort = new osc.UDPPort({
    localAddress: "0.0.0.0",
    localPort: 57121
});

udpPort.open();

udpPort.on("ready", function () {
    udpPort.send({
        address: "/s_new",
        args: ["default", 100]
    }, "127.0.0.1", 57110);
});




// get route pour client
// message socket entrant (bang couleur)
// renvoyer OSC vers processing
