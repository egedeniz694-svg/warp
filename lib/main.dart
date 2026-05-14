import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:wireguard_flutter/wireguard_flutter.dart';

void main() => runApp(const WarpApp());

class WarpApp extends StatelessWidget {
  const WarpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const WarpHome(),
    );
  }
}

class WarpHome extends StatefulWidget {
  const WarpHome({super.key});

  @override
  State<WarpHome> createState() => _WarpHomeState();
}

class _WarpHomeState extends State<WarpHome> {
  final _wireguard = WireGuardFlutter.instance;
  bool isConnected = false;

  // Senin VDS Konfigürasyonun
  final String vpnConfig = """
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
        await _wireguard.deactivate(); // Hata giderildi: deactivate
      } else {
        await _wireguard.activate(
          bundleId: "com.egedeniz.warp", 
          containerId: "", 
          config: vpnConfig,
          name: "WarpVPN",
        ); // Hata giderildi: activate
      }
      setState(() => isConnected = !isConnected);
    } catch (e) {
      debugPrint("VPN Hatası: $e");
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
          linearGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)],
          ),
          borderGradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.purpleAccent],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("WARP", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 8)),
              const SizedBox(height: 100),
              GestureDetector(
                onTap: toggleVpn,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      if (isConnected) 
                        BoxShadow(color: Colors.blueAccent.withOpacity(0.4), blurRadius: 30, spreadRadius: 5)
                    ],
                    gradient: RadialGradient(
                      colors: isConnected 
                        ? [Colors.blueAccent, Colors.blue.shade900] 
                        : [Colors.grey.shade800, Colors.black],
                    ),
                  ),
                  child: const Icon(Icons.power_settings_new, size: 80, color: Colors.white),
                ),
              ),
              const SizedBox(height: 50),
              Text(
                isConnected ? "BAĞLI" : "BAĞLI DEĞİL", 
                style: TextStyle(color: isConnected ? Colors.blueAccent : Colors.grey, fontWeight: FontWeight.bold)
              ),
            ],
          ),
        ),
      ),
    );
  }
}
