import 'package:flutter/material.dart';
import '../../../../core/constants/assets.dart';
import '../../../Dashboard/ui/view/dashboard/dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _username = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF0A9BFF);

    final size = MediaQuery.of(context).size;
    final headerHeight = size.height * 0.42;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    OutlineInputBorder border(Color c) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: c, width: 1.2),
    );

    return Scaffold(
      backgroundColor: primaryBlue,
      body: Stack(
        children: [
          // Header (logo + text) - SafeArea only for TOP
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: headerHeight,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      Assets.appLogo,
                      width: 96,
                      height: 98,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'SCUBE',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w600, // Semi Bold
                        height: 1.0, // line-height 100%
                        letterSpacing: 0, // Figma: 0px
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Control & Monitoring System',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600, // Semi Bold
                        height: 28 / 20, // line-height 28px
                        letterSpacing: 0, // Figma: 0px
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),

          // White sheet fills bottom (no blue strip)
          Positioned(
            left: 0,
            right: 0,
            top: headerHeight,
            bottom: -bottomInset, //  extend into gesture/nav area
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              child: Material(
                color: Colors.white,
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(24, 26, 24, 24 + bottomInset),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 6),
                      const Center(
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 24,
                            fontWeight: FontWeight.w700, // Bold
                            height: 1.5, // 150%
                            letterSpacing: 0,
                            color: Color(0xFF082438),
                          ),
                        ),

                      ),
                      const SizedBox(height: 22),

                      SizedBox(
                        height: 56,
                        child: TextField(
                          controller: _username,
                          decoration: InputDecoration(
                            hintText: 'Username',
                            hintStyle: const TextStyle(
                              fontFamily: 'Inter',
                              color: Color(0xFF94A3B8),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
                            enabledBorder: figmaBorder(),
                            focusedBorder: figmaBorder(),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      SizedBox(
                        height: 56,
                        child: TextField(
                          controller: _password,
                          obscureText: _obscure,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            hintStyle: const TextStyle(
                              fontFamily: 'Inter',
                              color: Color(0xFF94A3B8),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
                            enabledBorder: figmaBorder(),
                            focusedBorder: figmaBorder(),
                            suffixIcon: IconButton(
                              onPressed: () => setState(() => _obscure = !_obscure),
                              icon: Icon(
                                _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                          ),
                        ),
                      ),


                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () {},
                          child: const Text(
                            'Forget password?',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              height: 1.2, // ✅ important (don’t use 1.0)
                              color: Color(0xFF5E5E5E),
                              decoration: TextDecoration.underline,
                              decorationColor: Color(0xFF5E5E5E), // ✅ force underline color
                              decorationThickness: 1.2,           // ✅ visible underline
                            ),
                          ),
                        ),
                      ),



                      const SizedBox(height: 8),

                      SizedBox(
                        width: 336,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => const DashboardScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0096FC),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),


                      const SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Don’t have any account? ",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: FontWeight.w500, // Medium
                              height: 1.0, // 100%
                              letterSpacing: 0,
                              color: Color(0xFF475569),
                            ),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () {},
                            child: const Text(
                              'Register Now',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.w500, // Medium
                                height: 1.0, // 100%
                                letterSpacing: 0,
                                color: Color(0xFF0096FC),
                              ),
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


OutlineInputBorder figmaBorder() => OutlineInputBorder(
  borderRadius: BorderRadius.circular(10),
  borderSide: const BorderSide(color: Color(0xFFB9C6D6), width: 1),
);
