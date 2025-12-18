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

  static const bg = Color(0xFFE6EDF7);
  static const border = Color(0xFFB9C7D8);

  final ScrollController _tilesCtrl = ScrollController();

  @override
  void dispose() {
    _tilesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ scrollable area height (adjust if you want)
    final double tilesBoxHeight = 260;

    final tiles = <_DataTileModel>[
      _DataTileModel(
        image: AssetImage(Assets.dataview),
        title: 'Data View',
        statusText: '(Active)',
        statusColor: const Color(0xFF0B88F1),
        d1: '55505.63',
        d2: '58805.63',
      ),
      _DataTileModel(
        image: AssetImage(Assets.datatype2),
        title: 'Data Type 2',
        statusText: '(Active)',
        statusColor: const Color(0xFF0B88F1),
        d1: '55505.63',
        d2: '58805.63',
      ),
      _DataTileModel(
        image: AssetImage(Assets.dataview3),
        title: 'Data Type 3',
        statusText: '(Inactive)',
        statusColor: const Color(0xFF0B88F1),
        d1: '55505.63',
        d2: '58805.63',
      ),
      _DataTileModel(
        image: AssetImage(Assets.dataview),
        title: 'Total Solar',
        statusText: '(Active)',
        statusColor: const Color(0xFF0B88F1),
        d1: '55505.63',
        d2: '58805.63',
      ),
    ];

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_sharp, color: Color(0xFF1F2A44)),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
            );
          },
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
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_none, color: Colors.black87),
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
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
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(height: 1, color: Colors.black26),
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

                    // ✅ SCROLLABLE LIST CONTAINER (red area)
                    _ListContainer(
                      borderColor: border,
                      child: SizedBox(
                        height: tilesBoxHeight,
                        child: Scrollbar(
                          controller: _tilesCtrl,
                          thumbVisibility: true,
                          child: ListView.separated(
                            controller: _tilesCtrl,
                            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0), // space for scrollbar
                            itemCount: tiles.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 10),
                            itemBuilder: (context, i) {
                              final t = tiles[i];
                              return _DataTile(
                                image: t.image,
                                title: t.title,
                                statusText: t.statusText,
                                statusColor: t.statusColor,
                                d1: t.d1,
                                d2: t.d2,
                                onTap: () {

                                  if (t.title == 'Data View') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (_) => const ScmScreen()),
                                    );
                                  }

                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    _BottomGrid(
                      items: const [
                        _MenuItem('Analysis Pro', Assets.analysis),
                        _MenuItem('G. Generator', Assets.generator),
                        _MenuItem('Plant Summery', Assets.plant),
                        _MenuItem('Natural Gas', Assets.natural),
                        _MenuItem('Water Process', Assets.generator),
                        _MenuItem('D. Generator', Assets.water),
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/* -------------------- models -------------------- */

class _DataTileModel {
  _DataTileModel({
    required this.image,
    required this.title,
    required this.statusText,
    required this.statusColor,
    required this.d1,
    required this.d2,
  });

  final ImageProvider image;
  final String title;
  final String statusText;
  final Color statusColor;
  final String d1;
  final String d2;
}

/* -------------------- Main Card -------------------- */

class _MainCard extends StatelessWidget {
  const _MainCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F7FF),
        borderRadius: BorderRadius.circular(18),
      ),
      child: child,
    );
  }
}

/* -------------------- Top Tabs -------------------- */

class _TopTabs extends StatelessWidget {
  const _TopTabs({required this.selectedIndex, required this.onChanged});
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  static const primary = Color(0xFF0B88F1);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10), // ✅ same as container radius
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFB9C7D8)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            _TopTabButton(
              text: 'Summary', // (optional) fix spelling
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

  static const primary = Color(0xFF0B88F1);

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.only(
      topLeft: isFirst ? const Radius.circular(10) : Radius.zero,
      bottomLeft: isFirst ? const Radius.circular(10) : Radius.zero,
      topRight: isLast ? const Radius.circular(10) : Radius.zero,
      bottomRight: isLast ? const Radius.circular(10) : Radius.zero,
    );

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? primary : Colors.transparent,
            borderRadius: radius, // ✅ only edges are rounded
          ),
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey.shade700,
              fontWeight: FontWeight.w800,
              fontSize: 13,
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

  static const ringColor = Color(0xFF2C8ED6);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 150,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 140,
            height: 140,
            child: CircularProgressIndicator(
              value: 1,
              strokeWidth: 16,
              valueColor: const AlwaysStoppedAnimation(ringColor),
              backgroundColor: ringColor.withOpacity(0.16),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF0A2A3A),
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                valueText,
                style: const TextStyle(
                  color: Color(0xFF0A2A3A),
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
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

  static const primary = Color(0xFF0B88F1);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFFE3EBF5),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => onChanged(0),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selectedIndex == 0 ? primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Text(
                  leftText,
                  style: TextStyle(
                    color: selectedIndex == 0 ? Colors.white : Colors.grey.shade700,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () => onChanged(1),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selectedIndex == 1 ? primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Text(
                  rightText,
                  style: TextStyle(
                    color: selectedIndex == 1 ? Colors.white : Colors.grey.shade700,
                    fontWeight: FontWeight.w800,
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

/* -------------------- List Container -------------------- */

class _ListContainer extends StatelessWidget {
  const _ListContainer({required this.child, required this.borderColor});
  final Widget child;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FBFF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: child,
    );
  }
}

/* -------------------- Data Tile -------------------- */

class _DataTile extends StatelessWidget {
  const _DataTile({
    required this.image,
    required this.title,
    required this.statusText,
    required this.statusColor,
    required this.d1,
    required this.d2,
    this.onTap,
  });

  final ImageProvider image;
  final String title;
  final String statusText;
  final Color statusColor;
  final String d1;
  final String d2;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF4FF),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFB9C7D8)),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFB9C7D8)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image(image: image, fit: BoxFit.contain),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: Color(0xFF0A2A3A),
                            fontWeight: FontWeight.w900,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          statusText,
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.w800,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Data 1   :   $d1',
                      style: const TextStyle(
                        color: Color(0xFF314A5B),
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Data 2   :   $d2',
                      style: const TextStyle(
                        color: Color(0xFF314A5B),
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.black54),
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
    return LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth;
        final itemW = (w - 10) / 2;

        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: List.generate(items.length, (i) {
            final it = items[i];

            return SizedBox(
              width: itemW,
              height: 54,
              child: InkWell(
                onTap: () => onTap(i),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFB9C7D8)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F7FF),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFB9C7D8)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Image.asset(it.iconAsset, fit: BoxFit.contain),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          it.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF4A5A6A),
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
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
    );
  }
}
