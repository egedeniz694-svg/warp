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

  // Senin VDS Bilgilerin Buraya Gömüldü
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
          bundleId: "com.egedeniz.warp", // iOS için senin bundle id
          config: config,
          name: "WarpVPN",
        );
      }
      setState(() => isConnected = !isConnected);
    } catch (e) {
      print("Bağlantı Hatası: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Arka plan derin siyah
      body: Stack(
        children: [
          // Arka plandaki havalı ışık hüzmeleri
          Positioned(
            top: -100,
            right: -100,
            child: Container(width: 300, height: 300, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue.withOpacity(0.2), blurRadius: 100)),
          ),
          Center(
            child: GlassmorphicContainer(
              width: 320,
              height: 550,
              borderRadius: 30,
              blur: 25,
              alignment: Alignment.center,
              border: 1.5,
              linearGradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)],
              ),
              borderGradient: LinearGradient(
                colors: [Colors.blueAccent.withOpacity(0.5), Colors.purpleAccent.withOpacity(0.5)],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("WARP", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: 8, color: Colors.white)),
                  SizedBox(height: 10),
                  Text("SECURE TUNNEL", style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.5))),
                  SizedBox(height: 80),
                  
                  // O efsanevi buton
                  GestureDetector(
                    onTap: toggleVpn,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: isConnected 
                          ? [BoxShadow(color: Colors.blueAccent.withOpacity(0.6), blurRadius: 40, spreadRadius: 5)] 
                          : [BoxShadow(color: Colors.black, blurRadius: 20)],
                        gradient: RadialGradient(
                          colors: isConnected 
                            ? [Colors.blueAccent, Colors.blue.shade900] 
                            : [Colors.grey.shade800, Colors.black],
                        ),
                      ),
                      child: Icon(
                        Icons.power_settings_new_rounded, 
                        size: 90, 
                        color: isConnected ? Colors.white : Colors.grey.shade400
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 60),
                  
                  // Durum Bilgisi
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                    decoration: BoxDecoration(
                      color: isConnected ? Colors.blue.withOpacity(0.1) : Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isConnected ? "BAĞLANTI AKTİF" : "KORUMA DEVRE DIŞI",
                      style: TextStyle(
                        color: isConnected ? Colors.blueAccent : Colors.white70,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
