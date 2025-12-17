import 'package:flutter/material.dart';

import '../../../../../core/constants/assets.dart';

class NoDataScreen extends StatelessWidget {
  const NoDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFE6EDF7);
    const border = Color(0xFFB9C7D8);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          onPressed: () => Navigator.maybePop(context),
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 18),
        ),
        title: const Text(
          'SCM',
          style: TextStyle(
            color: Color(0xFF0A2A3A),
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                Image.asset(
                      Assets.appLogo,
                      width: 120,
                      height: 120,
                      fit: BoxFit.contain,
                    ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                  ),
                )
              ],
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Container(
                width: double.infinity,
                height: MediaQuery.sizeOf(context).height * 0.78,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: border, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 18,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Illustration (replace asset path if needed)
                      Image.asset(
                        Assets.group,
                        width: 259,
                        height: 239,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 18),

                      
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
