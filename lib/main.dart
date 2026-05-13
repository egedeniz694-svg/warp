import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:wireguard_flutter/wireguard_flutter.dart';

void main() => runApp(WarpApp());

class WarpApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: WarpHome(),
    );
  }
}

class WarpHome extends StatefulWidget {
  @override
  _WarpHomeState createState() => _WarpHomeState();
}

class _WarpHomeState extends State<WarpHome> {
  final wireguard = WireGuardFlutter.instance;
  bool isConnected = false;

  final String config = """
[Interface]
PrivateKey = YPilfrHHIeb6F2Y53SUb+jqZ0btEJqW4LmB7rX5QD3k=
Address = 10.7.0.2/24
DNS = 172.31.0.2

[Peer]
PublicKey = t15hg8eyo/bWMljjavqNuO5r4w6g5kNM+fBgRPMa8EQ=
PresharedKey = i7iMQiTrXij2u8VkpnNeoDhY4OZDKYYXu1FNS3nNXkM=
AllowedIPs = 0.0.0.0/0, ::/0
Endpoint = 100.27.231.149:51820
PersistentKeepalive = 25
""";

  void toggleVpn() async {
    try {
      if (isConnected) {
        await wireguard.stop(); 
      } else {
        await wireguard.start(
          bundleId: "com.egedeniz.warp", 
          config: config,
          name: "WarpVPN",
        );
      }
      setState(() => isConnected = !isConnected);
    } catch (e) {
      print("Hata: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: GlassmorphicContainer(
          width: 320,
          height: 550,
          borderRadius: 30,
          blur: 25,
          alignment: Alignment.center,
          border: 2,
          linearGradient: LinearGradient(colors: [Colors.white10, Colors.white.withOpacity(0.05)]),
          borderGradient: LinearGradient(colors: [Colors.blueAccent, Colors.purpleAccent]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("WARP", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 8)),
              SizedBox(height: 100),
              GestureDetector(
                onTap: toggleVpn,
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: isConnected ? Colors.blueAccent.withOpacity(0.5) : Colors.transparent,
                        blurRadius: 40,
                        spreadRadius: 5,
                      )
                    ],
                    gradient: RadialGradient(
                      colors: isConnected ? [Colors.blueAccent, Colors.blue.shade900] : [Colors.grey.shade800, Colors.black],
                    ),
                  ),
                  child: Icon(Icons.power_settings_new, size: 80, color: Colors.white),
                ),
              ),
              SizedBox(height: 50),
              Text(isConnected ? "CONNECTED" : "DISCONNECTED", style: TextStyle(color: isConnected ? Colors.blueAccent : Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}
