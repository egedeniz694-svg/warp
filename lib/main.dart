import 'package:flutter/material.dart';

void main() {
  runApp(const WarpApp());
}

class WarpApp extends StatelessWidget {
  const WarpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Warp VPN',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1E1E1E), // Şık koyu gri arka plan
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  bool isConnected = false;

  void toggleConnection() {
    setState(() {
      isConnected = !isConnected;
    });
    // Not: Buraya daha sonra WireGuard (VDS) bağlanma kodumuzu ekleyeceğiz!
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'WARP',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 8,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                isConnected ? 'BAĞLANDI' : 'BAĞLANTI YOK',
                style: TextStyle(
                  color: isConnected ? Colors.greenAccent : Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 80),
              GestureDetector(
                onTap: toggleConnection,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isConnected 
                        ? Colors.blueAccent.withOpacity(0.15) 
                        : Colors.grey.withOpacity(0.05),
                    border: Border.all(
                      color: isConnected ? Colors.blueAccent : Colors.grey.shade800,
                      width: 4,
                    ),
                    boxShadow: isConnected
                        ? [
                            BoxShadow(
                              color: Colors.blueAccent.withOpacity(0.4),
                              blurRadius: 40,
                              spreadRadius: 5,
                            )
                          ]
                        : [],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.power_settings_new,
                      size: 100,
                      color: isConnected ? Colors.blueAccent : Colors.grey.shade700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 80),
              Text(
                isConnected 
                  ? 'İnternet trafiğiniz şifreleniyor.' 
                  : 'Gizliliğinizi korumak için dokunun.',
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
