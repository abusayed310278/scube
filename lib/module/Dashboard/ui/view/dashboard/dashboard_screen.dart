import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../../../core/constants/assets.dart';
import '../../../../auth/ui/view/login_view.dart';
import 'data_type2_screen.dart';
import 'no_data_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int topTabIndex = 0; // 0=Summary, 1=SLD, 2=Data
  int sourceTabIndex = 0; // 0=Source, 1=Load

  final ScrollController _tilesCtrl = ScrollController();

  @override
  void dispose() {
    _tilesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tiles = <_DataTileModel>[
      _DataTileModel(
        image: const AssetImage(Assets.dataview),
        title: 'Data View',
        statusText: '(Active)',
        statusColor: _Ui.blue,
        d1: '55505.63',
        d2: '58805.63',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ScmScreen()),
          );
        },
      ),
      _DataTileModel(
        image: const AssetImage(Assets.datatype2),
        title: 'Data Type 2',
        statusText: '(Active)',
        statusColor: _Ui.blue,
        d1: '55505.63',
        d2: '58805.63',
        onTap: () {},
      ),
      _DataTileModel(
        image: const AssetImage(Assets.dataview3),
        title: 'Data Type 3',
        statusText: '(Inactive)',
        statusColor: _Ui.red,
        d1: '55505.63',
        d2: '58805.63',
        onTap: () {},
      ),
      // If you add more tiles later, it will scroll safely.
    ];

    return Scaffold(
      backgroundColor: _Ui.bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: _Ui.title),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (_) => false,
            );
          },
        ),
        title: const Text(
          'SCM',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w500, // Medium
            height: 1.5, // 24/16
            letterSpacing: 0,
            color: _Ui.title,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: SizedBox(
              width: 40,
              height: 40,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.notifications_none_outlined,
                      size: 20,
                      color: _Ui.title,
                    ),
                  ),
                  Positioned(
                    right: 10,
                    top: 11,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: _Ui.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, c) {
            final double cardW = math.min(350, c.maxWidth - 48);

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      width: cardW,
                      child: _MainCard(
                        child: Column(
                          children: [
                            _TopTabs(
                              selectedIndex: topTabIndex,
                              onChanged: (i) => setState(() => topTabIndex = i),
                            ),
                            const SizedBox(height: 10),

                            const Text(
                              'Electricity',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                height: 1.0,
                                letterSpacing: 0,
                                color: _Ui.electricity,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(height: 1, color: _Ui.divider),
                            const SizedBox(height: 12),

                            const _PowerRing(
                              label: 'Total Power',
                              valueText: '5.53 kw',
                            ),
                            const SizedBox(height: 14),

                            _SegmentTabs(
                              leftText: 'Source',
                              rightText: 'Load',
                              selectedIndex: sourceTabIndex,
                              onChanged: (i) => setState(() => sourceTabIndex = i),
                            ),
                            const SizedBox(height: 10),

                            // ✅ RED AREA (Scrollable) — small right gap, no overflow
                            _ListContainer(
                              child: SizedBox(
                                height: 205, // adjust if you want (190~220)
                                child: RawScrollbar(
                                  controller: _tilesCtrl,
                                  thumbVisibility: true,
                                  thickness: 4,
                                  radius: const Radius.circular(6),
                                  crossAxisMargin: 0, // ✅ smallest gap
                                  mainAxisMargin: 6,
                                  child: ListView.separated(
                                    controller: _tilesCtrl,
                                    primary: false, // ✅ important in nested scroll
                                    padding: const EdgeInsets.only(right: 4), // ✅ tiny space only
                                    itemCount: tiles.length,
                                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                                    itemBuilder: (context, i) => _DataTile(model: tiles[i]),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    SizedBox(
                      width: cardW,
                      child: _BottomGrid(
                        items: const [
                          _MenuItem('Analysis Pro', Assets.analysis),
                          _MenuItem('G. Generator', Assets.generator),
                          _MenuItem('Plant Summery', Assets.plant),
                          _MenuItem('Natural Gas', Assets.natural),
                          _MenuItem('D. Generator', Assets.water),
                          _MenuItem('Water Process', Assets.generator),
                        ],
                        onTap: (i) {
                          if (i == 3) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const NoDataScreen()),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/* -------------------- UI constants -------------------- */

class _Ui {
  static const bg = Color(0xFFE6EDF7);

  static const border = Color(0xFFB6B8D0);
  static const borderSoft = Color(0xFFB9C7D8);

  static const blue = Color(0xFF0096FC);
  static const title = Color(0xFF04063E);
  static const textGrey = Color(0xFF646984);
  static const electricity = Color(0xFF979797);
  static const divider = Color(0xFFD0D5DD);
  static const red = Color(0xFFE53935);

  static const cardBg = Colors.white;
}

/* -------------------- models -------------------- */

class _DataTileModel {
  const _DataTileModel({
    required this.image,
    required this.title,
    required this.statusText,
    required this.statusColor,
    required this.d1,
    required this.d2,
    required this.onTap,
  });

  final ImageProvider image;
  final String title;
  final String statusText;
  final Color statusColor;
  final String d1;
  final String d2;
  final VoidCallback onTap;
}

/* -------------------- Main Card -------------------- */

class _MainCard extends StatelessWidget {
  const _MainCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _Ui.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _Ui.border, width: 1),
      ),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
      child: child,
    );
  }
}

/* -------------------- Top Tabs -------------------- */

class _TopTabs extends StatelessWidget {
  const _TopTabs({required this.selectedIndex, required this.onChanged});
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _Ui.border, width: 1),
      ),
      child: Row(
        children: [
          _TopTabButton(
            text: 'Summary',
            isSelected: selectedIndex == 0,
            isFirst: true,
            isLast: false,
            onTap: () => onChanged(0),
          ),
          _TopTabButton(
            text: 'SLD',
            isSelected: selectedIndex == 1,
            isFirst: false,
            isLast: false,
            onTap: () => onChanged(1),
          ),
          _TopTabButton(
            text: 'Data',
            isSelected: selectedIndex == 2,
            isFirst: false,
            isLast: true,
            onTap: () => onChanged(2),
          ),
        ],
      ),
    );
  }
}

class _TopTabButton extends StatelessWidget {
  const _TopTabButton({
    required this.text,
    required this.isSelected,
    required this.onTap,
    required this.isFirst,
    required this.isLast,
  });

  final String text;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.only(
      topLeft: isFirst ? const Radius.circular(12) : Radius.zero,
      bottomLeft: isFirst ? const Radius.circular(12) : Radius.zero,
      topRight: isLast ? const Radius.circular(12) : Radius.zero,
      bottomRight: isLast ? const Radius.circular(12) : Radius.zero,
    );

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? _Ui.blue : Colors.transparent,
            borderRadius: radius,
          ),
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              height: 1.0,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
              color: isSelected ? Colors.white : _Ui.textGrey,
            ),
          ),
        ),
      ),
    );
  }
}

/* -------------------- Power Ring -------------------- */

class _PowerRing extends StatelessWidget {
  const _PowerRing({required this.label, required this.valueText});
  final String label;
  final String valueText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 150,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 150,
            height: 150,
            child: CircularProgressIndicator(
              value: 1,
              strokeWidth: 16,
              valueColor: const AlwaysStoppedAnimation(Color(0xFF398FC9)),
              backgroundColor: const Color(0xFF398FC9).withOpacity(0.18),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  height: 1.0,
                  color: _Ui.textGrey,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                valueText,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  height: 1.0,
                  color: _Ui.title,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/* -------------------- Source/Load Segment -------------------- */

class _SegmentTabs extends StatelessWidget {
  const _SegmentTabs({
    required this.leftText,
    required this.rightText,
    required this.selectedIndex,
    required this.onChanged,
  });

  final String leftText;
  final String rightText;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      decoration: BoxDecoration(
        color: const Color(0xFFE3EBF5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: _SegmentButton(
              text: leftText,
              selected: selectedIndex == 0,
              onTap: () => onChanged(0),
            ),
          ),
          Expanded(
            child: _SegmentButton(
              text: rightText,
              selected: selectedIndex == 1,
              onTap: () => onChanged(1),
            ),
          ),
        ],
      ),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  const _SegmentButton({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  final String text;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? _Ui.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            height: 1.0,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? Colors.white : _Ui.textGrey,
          ),
        ),
      ),
    );
  }
}

/* -------------------- List Container -------------------- */

class _ListContainer extends StatelessWidget {
  const _ListContainer({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7FBFF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _Ui.border, width: 1),
      ),
      padding: const EdgeInsets.all(10),
      child: child,
    );
  }
}

/* -------------------- Data Tile (NO OVERFLOW) -------------------- */

class _DataTile extends StatelessWidget {
  const _DataTile({required this.model});
  final _DataTileModel model;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: model.onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF4FF),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: _Ui.borderSoft, width: 1),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: _Ui.borderSoft, width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Image(image: model.image, fit: BoxFit.contain),
                ),
              ),
              const SizedBox(width: 10),

              // ✅ Flexible column so it NEVER overflows
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            model.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              height: 1.0,
                              color: _Ui.title,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          model.statusText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            height: 1.0,
                            color: model.statusColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Data 1   :   ${model.d1}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        height: 1.0,
                        color: _Ui.textGrey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Data 2   :   ${model.d2}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        height: 1.0,
                        color: _Ui.textGrey,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),
              const Icon(Icons.chevron_right, color: _Ui.textGrey),
            ],
          ),
        ),
      ),
    );
  }
}

/* -------------------- Bottom Grid -------------------- */

class _MenuItem {
  const _MenuItem(this.title, this.iconAsset);
  final String title;
  final String iconAsset;
}

class _BottomGrid extends StatelessWidget {
  const _BottomGrid({required this.items, required this.onTap});
  final List<_MenuItem> items;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _Ui.border, width: 1),
      ),
      padding: const EdgeInsets.all(10),
      child: LayoutBuilder(
        builder: (context, c) {
          final itemW = (c.maxWidth - 10) / 2;

          return Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List.generate(items.length, (i) {
              final it = items[i];

              return SizedBox(
                width: itemW,
                height: 42,
                child: InkWell(
                  onTap: () => onTap(i),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: _Ui.border, width: 1),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Image.asset(it.iconAsset, fit: BoxFit.contain),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            it.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              height: 1.0,
                              color: _Ui.textGrey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
