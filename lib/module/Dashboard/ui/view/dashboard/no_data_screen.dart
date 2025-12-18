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
          icon: const Icon(Icons.arrow_back_sharp, color: Colors.black87, size: 18),
        ),
        title: const Text(
          'SCM',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w500, // Medium
            height: 1.5, // 24/16
            letterSpacing: 0,
            color: Color(0xFF04063E),
          ),
        ),

        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {},
                    child: const Icon(
                      Icons.notifications_none_rounded,
                      size: 20, // ✅ 20x20 like Figma
                      color: Color(0xFF04063E),
                    ),
                  ),
                ),

                // red dot
                Positioned(
                  right: -1,
                  top: -1,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEB5757),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
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
