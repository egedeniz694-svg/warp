import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:wireguard_flutter/wireguard_flutter.dart';

void main() => runApp(WarpApp());

class WarpApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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

  // Buraya VDS'inden aldığın config bilgilerini gireceğiz
  final String config = """
[Interface]
PrivateKey = SENIN_PRIVATE_KEY
Address = 10.0.0.2/32
DNS = 1.1.1.1

[Peer]
PublicKey = VDS_PUBLIC_KEY
Endpoint = VDS_IP_ADRESIN:51820
AllowedIPs = 0.0.0.0/0
""";

  void toggleVpn() async {
    try {
      if (isConnected) {
        await wireguard.stop();
      } else {
        await wireguard.start(
          bundleId: "com.example.warp_vpn", // iOS için kritik
          config: config,
          name: "WarpVPN",
        );
      }
      setState(() => isConnected = !isConnected);
    } catch (e) {
      print("Bağlantı hatası: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg.jpg"), // Arka plana havalı bir görsel koy
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: GlassmorphicContainer(
            width: 350,
            height: 500,
            borderRadius: 30,
            blur: 20,
            alignment: Alignment.bottomCenter,
            border: 2,
            linearGradient: LinearGradient(
              colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)],
            ),
            borderGradient: LinearGradient(
              colors: [Colors.blue.withOpacity(0.5), Colors.purple.withOpacity(0.5)],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("WARP", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, letterSpacing: 5)),
                SizedBox(height: 50),
                GestureDetector(
                  onTap: toggleVpn,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: isConnected ? [BoxShadow(color: Colors.blue.withAlpha(150), blurRadius: 30, spreadRadius: 10)] : [],
                      gradient: RadialGradient(colors: isConnected ? [Colors.blue, Colors.blueAccent] : [Colors.grey, Colors.black]),
                    ),
                    child: Icon(Icons.power_settings_new, size: 80, color: Colors.white),
                  ),
                ),
                SizedBox(height: 30),
                Text(isConnected ? "BAĞLANDI" : "BAĞLANTI YOK", style: TextStyle(fontSize: 18, color: isConnected ? Colors.blue : Colors.grey)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
