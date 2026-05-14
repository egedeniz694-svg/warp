import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:wireguard_flutter/wireguard_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const WarpApp());
}

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
  final WireGuardFlutter _wireguard = WireGuardFlutter.instance;

  bool isConnected = false;
  bool isLoading = false;

  final String interfaceName = "wg0";
  final String serverAddress = "100.27.231.149:51820";

  // WireGuard config
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

  @override
  void initState() {
    super.initState();
    _initWireGuard();
  }

  Future<void> _initWireGuard() async {
    try {
      await _wireguard.initialize(interfaceName: interfaceName);
    } catch (e) {
      debugPrint("WireGuard initialize hatası: $e");
    }
  }

  Future<void> toggleVpn() async {
    if (isLoading) return;

    setState(() => isLoading = true);

    try {
      if (isConnected) {
        await _wireguard.stopVpn();
        if (!mounted) return;
        setState(() => isConnected = false);
      } else {
        await _wireguard.startVpn(
          serverAddress: serverAddress,
          wgQuickConfig: vpnConfig,
          providerBundleIdentifier: "com.egedeniz.warp",
        );
        if (!mounted) return;
        setState(() => isConnected = true);
      }
    } catch (e) {
      debugPrint("VPN Hatası: $e");
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool active = isConnected && !isLoading;

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
            colors: [
              Colors.white.withOpacity(0.10),
              Colors.white.withOpacity(0.05),
            ],
          ),
          borderGradient: const LinearGradient(
            colors: [Colors.blueAccent, Colors.purpleAccent],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "WARP",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 8,
                ),
              ),
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
                      if (active)
                        BoxShadow(
                          color: Colors.blueAccent.withOpacity(0.4),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                    ],
                    gradient: RadialGradient(
                      colors: active
                          ? [Colors.blueAccent, Colors.blue.shade900]
                          : [Colors.grey.shade800, Colors.black],
                    ),
                  ),
                  child: Center(
                    child: isLoading
                        ? const SizedBox(
                            width: 34,
                            height: 34,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                            ),
                          )
                        : const Icon(
                            Icons.power_settings_new,
                            size: 80,
                            color: Colors.white,
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Text(
                isLoading
                    ? "BAĞLANIYOR..."
                    : (isConnected ? "BAĞLI" : "BAĞLI DEĞİL"),
                style: TextStyle(
                  color: active ? Colors.blueAccent : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
