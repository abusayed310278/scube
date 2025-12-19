import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScmScreen extends StatefulWidget {
  const ScmScreen({super.key});

  @override
  State<ScmScreen> createState() => _ScmScreenState();
}

class _ScmScreenState extends State<ScmScreen> {
  int _tab = 0; // 0 Data, 1 Revenue
  bool _customDate = false;

  DateTime? _from;
  DateTime? _to;

  bool _revenueExpanded = true;

  // sample values
  final double _gaugeValueData = 55.00;
  final double _gaugeValueDataCustom = 57.00;
  final double _energyKwToday = 5.53;
  final double _energyKwCustom = 20.05;

  final int _revenueValue = 8897455;

  final _dataItemsToday = const [
    _DataItem(label: "Data A", dot: Color(0xFF2F80ED), data: "2798.50 (29.53%)", cost: "35689 ৳"),
    _DataItem(label: "Data B", dot: Color(0xFF6FCF97), data: "72598.50 (35.39%)", cost: "5259689 ৳"),
    _DataItem(label: "Data C", dot: Color(0xFF9B51E0), data: "6598.36 (83.90%)", cost: "5698756 ৳"),
    _DataItem(label: "Data D", dot: Color(0xFFF2994A), data: "6598.26 (36.59%)", cost: "356987 ৳"),
  ];

  final _dataItemsCustomTop = const [
    _DataItem(label: "Data A", dot: Color(0xFF2F80ED), data: "2798.50 (29.53%)", cost: "35689 ৳"),
    _DataItem(label: "Data B", dot: Color(0xFF6FCF97), data: "72598.50 (35.39%)", cost: "5259689 ৳"),
    _DataItem(label: "Data C", dot: Color(0xFF9B51E0), data: "6598.36 (83.90%)", cost: "5698756 ৳"),
    _DataItem(label: "Data D", dot: Color(0xFFF2994A), data: "6598.26 (36.59%)", cost: "356987 ৳"),
  ];

  final _dataItemsCustomBottom = const [
    _DataItem(label: "Data A", dot: Color(0xFF2F80ED), data: "2798.50 (29.53%)", cost: "35689 ৳"),
    _DataItem(label: "Data B", dot: Color(0xFF6FCF97), data: "72598.50 (35.39%)", cost: "5259689 ৳"),
    _DataItem(label: "Data C", dot: Color(0xFF9B51E0), data: "6598.36 (83.90%)", cost: "5698756 ৳"),
    _DataItem(label: "Data D", dot: Color(0xFFF2994A), data: "6598.26 (36.59%)", cost: "356987 ৳"),
  ];

  final _revenueLines = const [
    _KVLine(k: "Data 1", v: "2798.50 (29.53%)"),
    _KVLine(k: "Cost 1", v: "35689 ৳"),
    _KVLine(k: "Data 2", v: "2798.50 (29.53%)"),
    _KVLine(k: "Cost 2", v: "35689 ৳"),
    _KVLine(k: "Data 3", v: "2798.50 (29.53%)"),
    _KVLine(k: "Cost 3", v: "35689 ৳"),
    _KVLine(k: "Data 4", v: "2798.50 (29.53%)"),
    _KVLine(k: "Cost 4", v: "35689 ৳"),
  ];

  @override
  Widget build(BuildContext context) {
    final s = MediaQuery.of(context).size.width / 375.0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "SCM",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            height: 24 / 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 0,
            color: Color(0xFF04063E),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_sharp, color: Color(0xFF1F2A44)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_none_rounded, color: Color(0xFF1F2A44)),
                  onPressed: () {},
                ),
                Positioned(
                  left: 25,
                  top: 11,
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration: const BoxDecoration(
                      color: Color(0xFFDF2222),
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
        child: Column(
          children: [
            _HeaderTop(
              scale: s,
              tab: _tab,
              onTab: (v) => setState(() => _tab = v),
            ),
            Expanded(
              child: SingleChildScrollView(
                // ✅ Figma: left/right 24 so card becomes 312 wide
                padding: EdgeInsets.fromLTRB(24 * s, 0, 24 * s, 16 * s),
                child: Column(
                  children: [
                    _GaugeOnly(
                      scale: s,
                      valueText: _tab == 0
                          ? (_customDate
                          ? _gaugeValueDataCustom.toStringAsFixed(2)
                          : _gaugeValueData.toStringAsFixed(2))
                          : _revenueValue.toString(),
                      unitText: _tab == 0 ? "kWh/Sqft" : "tk",
                      progress: 0.764,
                    ),
                    SizedBox(height: 10 * s),

                    if (_tab == 0) ...[
                      _TodayCustomRow(
                        scale: s,
                        custom: _customDate,
                        onToday: () => setState(() => _customDate = false),
                        onCustom: () => setState(() => _customDate = true),
                      ),
                      SizedBox(height: 10 * s),

                      if (_customDate) ...[
                        _DateRangeRow(
                          scale: s,
                          from: _from,
                          to: _to,
                          onPickFrom: () async {
                            final d = await showDatePicker(
                              context: context,
                              initialDate: _from ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (d != null) setState(() => _from = d);
                          },
                          onPickTo: () async {
                            final d = await showDatePicker(
                              context: context,
                              initialDate: _to ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (d != null) setState(() => _to = d);
                          },
                          onSearch: () {},
                        ),
                        SizedBox(height: 12 * s),
                      ],

                      _EnergyCardExact(
                        scale: s,
                        energyKw: _customDate ? _energyKwCustom : _energyKwToday,
                        items: _customDate ? _dataItemsCustomTop : _dataItemsToday,
                      ),

                      if (_customDate) ...[
                        SizedBox(height: 12 * s),
                        _EnergyCardExact(
                          scale: s,
                          energyKw: _energyKwToday,
                          items: _dataItemsCustomBottom,
                        ),
                      ],
                    ] else ...[
                      SizedBox(height: 12 * s),
                      _RevenuePanelExact(
                        scale: s,
                        expanded: _revenueExpanded,
                        onToggle: () => setState(() => _revenueExpanded = !_revenueExpanded),
                        lines: _revenueLines,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================ HEADER ============================

class _HeaderTop extends StatelessWidget {
  final double scale;
  final int tab;
  final ValueChanged<int> onTab;

  const _HeaderTop({
    required this.scale,
    required this.tab,
    required this.onTab,
  });

  @override
  Widget build(BuildContext context) {
    final s = scale;

    return SizedBox(
      height: 78 * s,
      child: Stack(
        children: [
          Container(
            height: 46 * s,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFD7E1F0), Color(0xFFEEF3FB)],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 38 * s,
            child: Container(
              height: 64 * s,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(22),
                  topRight: Radius.circular(22),
                ),
              ),
            ),
          ),
          Positioned(
            left: 24 * s,
            right: 24 * s,
            bottom: 20 * s,
            child: Container(
              height: 48 * s,
              padding: EdgeInsets.all(3 * s),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12 * s),
                border: Border.all(width: 1, color: const Color(0xFFA5A7B9)),
              ),
              child: _SegmentTabsRadio(scale: s, value: tab, onChanged: onTab),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================ SEGMENTED TABS ============================

class _SegmentTabsRadio extends StatelessWidget {
  final double scale;
  final int value;
  final ValueChanged<int> onChanged;

  const _SegmentTabsRadio({
    required this.scale,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final s = scale;

    // ✅ no extra padding container (outer already has padding)
    return Row(
      children: [
        Expanded(
          child: _SegBtn(
            scale: s,
            selected: value == 0,
            label: "Data View",
            onTap: () => onChanged(0),
          ),
        ),
        SizedBox(width: 6 * s),
        Expanded(
          child: _SegBtn(
            scale: s,
            selected: value == 1,
            label: "Revenue View",
            onTap: () => onChanged(1),
          ),
        ),
      ],
    );
  }
}

class _SegBtn extends StatelessWidget {
  final double scale;
  final bool selected;
  final String label;
  final VoidCallback onTap;

  const _SegBtn({
    required this.scale,
    required this.selected,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final s = scale;

    const blue = Color(0xFF0096FC);
    const grey = Color(0xFF646984);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8 * s),
      child: Container(
        height: 42 * s,
        padding: EdgeInsets.symmetric(horizontal: 10 * s),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _RadioDot(scale: s, selected: selected),
            SizedBox(width: 8 * s),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14 * s,
                height: 1.0,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                color: selected ? blue : grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RadioDot extends StatelessWidget {
  final double scale;
  final bool selected;

  const _RadioDot({required this.scale, required this.selected});

  @override
  Widget build(BuildContext context) {
    final s = scale;
    const blue = Color(0xFF0096FC);
    const grey = Color(0xFFA5A7B9);

    return Container(
      width: 14 * s,
      height: 14 * s,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: selected ? blue : grey, width: 1.5 * s),
      ),
      child: selected
          ? Padding(
        padding: EdgeInsets.all(2 * s),
        child: const DecoratedBox(
          decoration: BoxDecoration(color: blue, shape: BoxShape.circle),
        ),
      )
          : const SizedBox.shrink(),
    );
  }
}

// ============================ GAUGE ============================

class _GaugeOnly extends StatelessWidget {
  final double scale;
  final String valueText;
  final String unitText;
  final double progress;

  const _GaugeOnly({
    required this.scale,
    required this.valueText,
    required this.unitText,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final s = scale;

    return SizedBox(
      width: 160 * s,
      height: 130 * s,
      child: Center(
        child: CustomPaint(
          size: Size(160 * s, 130 * s),
          painter: _GaugePainter(progress: progress),
          child: SizedBox(
            width: 160 * s,
            height: 130 * s,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  valueText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 20 * s,
                    height: 1.0,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF04063E),
                  ),
                ),
                SizedBox(height: 6 * s),
                Text(
                  unitText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14 * s,
                    height: 1.0,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF04063E),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double progress;

  _GaugePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final minSide = math.min(size.width, size.height);
    final center = Offset(size.width / 2, size.height / 2);

    final radius = minSide * 0.46;
    final stroke = minSide * 0.11;

    const activeColor = Color(0xFF4E91FD);
    const baseColor = Color(0xFFE6F4FF);

    final base = Paint()
      ..color = baseColor
      ..strokeWidth = stroke
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final active = Paint()
      ..color = activeColor
      ..strokeWidth = stroke
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final start = 139 * math.pi / 180;
    final sweepTotal = 258 * math.pi / 180;

    final rect = Rect.fromCircle(center: center, radius: radius);

    canvas.drawArc(rect, start, sweepTotal, false, base);
    canvas.drawArc(rect, start, sweepTotal * progress.clamp(0.0, 1.0), false, active);
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) => oldDelegate.progress != progress;
}

// ============================ TODAY / CUSTOM ROW ============================

class _TodayCustomRow extends StatelessWidget {
  final double scale;
  final bool custom;
  final VoidCallback onToday;
  final VoidCallback onCustom;

  const _TodayCustomRow({
    required this.scale,
    required this.custom,
    required this.onToday,
    required this.onCustom,
  });

  @override
  Widget build(BuildContext context) {
    final s = scale;

    const blue = Color(0xFF0096FC);
    const grey = Color(0xFF646984);

    Widget radioDot(bool selected) {
      return Container(
        width: 10 * s,
        height: 10 * s,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(
            color: selected ? blue : grey,
            width: 0.5 * s,
          ),
        ),
        child: selected
            ? Center(
          child: Container(
            width: 6 * s,
            height: 6 * s,
            decoration: const BoxDecoration(color: blue, shape: BoxShape.circle),
          ),
        )
            : const SizedBox.shrink(),
      );
    }

    Widget item(bool selected, String text, VoidCallback onTap) {
      return InkWell(
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            radioDot(selected),
            SizedBox(width: 6 * s),
            Text(
              text,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14 * s,
                height: 1.0,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                color: selected ? blue : grey,
              ),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      width: 246 * s,
      height: 17 * s,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          item(!custom, "Today Data", onToday),
          item(custom, "Custom Date Data", onCustom),
        ],
      ),
    );
  }
}

// ============================ DATE RANGE ============================

class _DateRangeRow extends StatelessWidget {
  final double scale;
  final DateTime? from;
  final DateTime? to;
  final VoidCallback onPickFrom;
  final VoidCallback onPickTo;
  final VoidCallback onSearch;

  const _DateRangeRow({
    required this.scale,
    required this.from,
    required this.to,
    required this.onPickFrom,
    required this.onPickTo,
    required this.onSearch,
  });

  String _fmt(DateTime? d) => d == null ? "" : DateFormat("dd/MM/yyyy").format(d);

  @override
  Widget build(BuildContext context) {
    final s = scale;

    Widget field(String hint, String value, VoidCallback onTap) {
      return Expanded(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(6 * s),
          child: Container(
            height: 32 * s,
            padding: EdgeInsets.symmetric(horizontal: 10 * s),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6 * s),
              border: Border.all(color: const Color(0xFFB6B8D0)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value.isEmpty ? hint : value,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12 * s,
                      height: 1.0,
                      fontWeight: FontWeight.w500,
                      color: value.isEmpty ? const Color(0xFF8A95A6) : const Color(0xFF04063E),
                    ),
                  ),
                ),
                Icon(Icons.calendar_month_rounded, size: 16 * s, color: const Color(0xFF646984)),
              ],
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        field("From Date", _fmt(from), onPickFrom),
        SizedBox(width: 10 * s),
        field("To Date", _fmt(to), onPickTo),
        SizedBox(width: 10 * s),
        InkWell(
          onTap: onSearch,
          borderRadius: BorderRadius.circular(6 * s),
          child: Container(
            width: 32 * s,
            height: 32 * s,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6 * s),
              border: Border.all(color: const Color(0xFF0096FC), width: 1),
            ),
            child: Icon(Icons.search_rounded, size: 18 * s, color: const Color(0xFF0096FC)),
          ),
        ),
      ],
    );
  }
}

// ============================ ENERGY CARD ============================

class _EnergyCardExact extends StatelessWidget {
  final double scale;
  final double energyKw;
  final List<_DataItem> items;

  const _EnergyCardExact({
    required this.scale,
    required this.energyKw,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final s = scale;

    return SizedBox(
      height: 267 * s, // ✅ Figma: 267
      child: Container(
        width: double.infinity, // ✅ becomes 312 because outer padding is 24
        padding: EdgeInsets.fromLTRB(12 * s, 10 * s, 12 * s, 10 * s),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10 * s),
          border: Border.all(color: const Color(0xFFB6B8D0)),
        ),
        child: Column(
          children: [
            // ✅ header group height 39
            SizedBox(
              height: 39 * s,
              child: Row(
                children: [
                  SizedBox(
                    width: 90 * s,
                    child: Text(
                      "Energy Chart",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14 * s,
                        height: 1.0,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF04063E),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    "${energyKw.toStringAsFixed(2)} kw",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 32 * s,
                      height: 1.0,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF04063E),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8 * s),
            for (int i = 0; i < items.length; i++) ...[
              _EnergyRowExact(scale: s, item: items[i]),
              if (i != items.length - 1) SizedBox(height: 6 * s),
            ],
          ],
        ),
      ),
    );
  }
}

class _EnergyRowExact extends StatelessWidget {
  final double scale;
  final _DataItem item;

  const _EnergyRowExact({required this.scale, required this.item});

  @override
  Widget build(BuildContext context) {
    final s = scale;

    const borderC = Color(0xFFB6B8D0);
    const dark = Color(0xFF04063E);
    const grey = Color(0xFF646984);

    return SizedBox(
      height: 42 * s, // ✅ Figma: 42
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10 * s),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6 * s),
          border: Border.all(color: borderC),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 39 * s,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 6 * s,
                    height: 6 * s,
                    decoration: BoxDecoration(color: item.dot, shape: BoxShape.circle),
                  ),
                  SizedBox(height: 4 * s),
                  Text(
                    item.label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12 * s,
                      height: 1.0,
                      fontWeight: FontWeight.w600,
                      color: dark,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 1,
              height: 34 * s,
              margin: EdgeInsets.symmetric(horizontal: 10 * s),
              color: borderC,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                        "Data",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12 * s,
                          height: 1.0,
                          fontWeight: FontWeight.w500,
                          color: grey,
                        ),
                      ),
                      Text(
                        "  :  ",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12 * s,
                          height: 1.0,
                          fontWeight: FontWeight.w500,
                          color: grey,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          item.data,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12 * s,
                            height: 1.0,
                            fontWeight: FontWeight.w600,
                            color: dark,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4 * s),
                  Row(
                    children: [
                      Text(
                        "Cost",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12 * s,
                          height: 1.0,
                          fontWeight: FontWeight.w500,
                          color: grey,
                        ),
                      ),
                      Text(
                        "  :  ",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12 * s,
                          height: 1.0,
                          fontWeight: FontWeight.w500,
                          color: grey,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          item.cost,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12 * s,
                            height: 1.0,
                            fontWeight: FontWeight.w600,
                            color: dark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================ REVENUE PANEL ============================

class _RevenuePanelExact extends StatelessWidget {
  final double scale;
  final bool expanded;
  final VoidCallback onToggle;
  final List<_KVLine> lines;

  const _RevenuePanelExact({
    required this.scale,
    required this.expanded,
    required this.onToggle,
    required this.lines,
  });

  @override
  Widget build(BuildContext context) {
    final s = scale;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10 * s),
        border: Border.all(color: const Color(0xFFB6B8D0)),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            child: SizedBox(
              height: 42 * s,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12 * s),
                child: Row(
                  children: [
                    Icon(Icons.bar_chart_rounded, size: 18 * s, color: const Color(0xFF646984)),
                    SizedBox(width: 10 * s),
                    Text(
                      "Data & Cost Info",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12 * s,
                        height: 1.0,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF04063E),
                      ),
                    ),
                    const Spacer(),

                    // 24x24, border 1, blue, rotate 90
                    Container(
                      width: 24 * s,
                      height: 24 * s,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0096FC),
                        shape: BoxShape.circle,
                        border: Border.all(width: 1, color: const Color(0xFF0096FC)),
                      ),
                      child: Icon(
                        expanded
                            ? Icons.keyboard_double_arrow_up
                            : Icons.keyboard_double_arrow_down,
                        size: 18 * s,
                        color: Colors.white,
                      ),

                    ),

                  ],
                ),
              ),
            ),
          ),
          if (expanded) ...[
            const Divider(height: 1, thickness: 1, color: Color(0xFFB6B8D0)),
            Padding(
              padding: EdgeInsets.fromLTRB(12 * s, 10 * s, 12 * s, 12 * s),
              child: Column(
                children: [
                  for (int i = 0; i < lines.length; i++) ...[
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "${lines[i].k}  :",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12 * s,
                              height: 1.0,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF646984),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            lines[i].v,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12 * s,
                              height: 1.0,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF04063E),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6 * s),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ============================ MODELS ============================

class _DataItem {
  final String label;
  final Color dot;
  final String data;
  final String cost;

  const _DataItem({
    required this.label,
    required this.dot,
    required this.data,
    required this.cost,
  });
}

class _KVLine {
  final String k;
  final String v;

  const _KVLine({required this.k, required this.v});
}
