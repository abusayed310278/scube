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

  // --- sample values (same as your screenshot) ---
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
          style: TextStyle(
            color: Color(0xFF1F2A44),
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),

        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1F2A44)),
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
                  right: 10,
                  top: 11,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(color: Color(0xFFEB5757), shape: BoxShape.circle),
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
                padding: EdgeInsets.fromLTRB(16 * s, 0, 16 * s, 16 * s),
                child: Column(
                  children: [
                    // ---- Gauge (NO card container – matches screenshot) ----
                    _GaugeOnly(
                      scale: s,
                      valueText: _tab == 0
                          ? (_customDate ? _gaugeValueDataCustom.toStringAsFixed(2) : _gaugeValueData.toStringAsFixed(2))
                          : _revenueValue.toString(),
                      unitText: _tab == 0 ? "kWh/Sqft" : "tk",
                      progress: 0.62,
                    ),

                    SizedBox(height: 8 * s),

                    if (_tab == 0) ...[
                      _TodayCustomRow(
                        scale: s,
                        custom: _customDate,
                        onToday: () => setState(() => _customDate = false),
                        onCustom: () => setState(() => _customDate = true),
                      ),

                      SizedBox(height: 8 * s),

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
                        SizedBox(height: 10 * s),
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

// ============================ HEADER (curved white sheet) ============================

class _HeaderTop extends StatelessWidget {
  final double scale;
  final int tab;
  final ValueChanged<int> onTab;

  const _HeaderTop({required this.scale, required this.tab, required this.onTab});

  @override
  Widget build(BuildContext context) {
    final s = scale;

    return SizedBox(
      height: 78 * s,
      child: Stack(
        children: [
          // light blue bar
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



          // SEGMENTED TABS (FULL WIDTH INSIDE SHEET)
          Positioned(
            left: 30 * s,
            right: 30 * s,
            bottom: 20 * s,
            child: Container(
              height: 42 * s,
              width:30*s,
              padding: EdgeInsets.all(3 * s),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12 * s),
                border: Border.all(color: const Color(0xFFCCD5E6)),
              ),
              child: _SegmentTabsRadio(
                scale: s,
                value: tab,
                onChanged: onTab,
              ),
            ),
          ),
        ],
      ),
    );
  }
}



class _HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // Creates the side “ears” like your screenshot
    final w = size.width;
    final h = size.height;

    final p = Path();
    p.moveTo(0, 18);
    p.quadraticBezierTo(0, 0, 18, 0);
    p.lineTo(w - 18, 0);
    p.quadraticBezierTo(w, 0, w, 18);

    // down right side
    p.lineTo(w, h);
    p.lineTo(0, h);
    p.close();
    return p;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

// ============================ SEGMENT TABS (radio style) ============================

class _SegmentTabsRadio extends StatelessWidget {
  final double scale;
  final int value;
  final ValueChanged<int> onChanged;

  const _SegmentTabsRadio({required this.scale, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final s = scale;
    return Container(
      height: 42 * s,
      padding: EdgeInsets.all(3 * s),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12 * s),
        // border: Border.all(color: const Color(0xFFCCD5E6)),
      ),
      child: Row(
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
      ),
    );
  }
}

class _SegBtn extends StatelessWidget {
  final double scale;
  final bool selected;
  final String label;
  final VoidCallback onTap;

  const _SegBtn({required this.scale, required this.selected, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final s = scale;
    final textColor = selected ? const Color(0xFF2F80ED) : const Color(0xFF7A869A);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8 * s),
      child: Container(
        height: 36 * s,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8 * s),
        ),
        padding: EdgeInsets.symmetric(horizontal: 10 * s),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _RadioDot(scale: s, selected: selected),
            SizedBox(width: 8 * s),
            Text(
              label,
              style: TextStyle(fontSize: 13 * s, fontWeight: FontWeight.w800, color: textColor),
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
    if (selected) {
      return Container(
        width: 14 * s,
        height: 14 * s,
        decoration: const BoxDecoration(color: Color(0xFF2F80ED), shape: BoxShape.circle),
        child: Center(
          child: Container(
            width: 6 * s,
            height: 6 * s,
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          ),
        ),
      );
    }
    return Container(
      width: 14 * s,
      height: 14 * s,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFB0B9CC), width: 2 * s),
      ),
    );
  }
}

// ============================ GAUGE (no card container) ============================

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
      height: 160 * s,
      child: Center(
        child: CustomPaint(
          size: Size(170 * s, 170 * s),
          painter: _GaugePainter(progress: progress),
          child: SizedBox(
            width: 170 * s,
            height: 170 * s,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  valueText,
                  style: TextStyle(
                    fontSize: 18 * s,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF1F2A44),
                  ),
                ),
                SizedBox(height: 2 * s),
                Text(
                  unitText,
                  style: TextStyle(fontSize: 12 * s, fontWeight: FontWeight.w600, color: const Color(0xFF1F2A44)),
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
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.38;

    final base = Paint()
      ..color = const Color(0xFFDCEBFF)
      ..strokeWidth = size.width * 0.07
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final active = Paint()
      ..color = const Color(0xFF2F80ED)
      ..strokeWidth = size.width * 0.07
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const start = math.pi; // left
    const sweepTotal = math.pi;

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), start, sweepTotal, false, base);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      start,
      sweepTotal * progress.clamp(0.0, 1.0),
      false,
      active,
    );
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) => oldDelegate.progress != progress;
}

// ============================ TODAY / CUSTOM RADIO ============================

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

    Widget item(bool selected, String text, VoidCallback onTap) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10 * s),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12 * s,
              height: 12 * s,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? const Color(0xFF2F80ED) : const Color(0xFF4B5565),
              ),
            ),
            SizedBox(width: 8 * s),
            Text(
              text,
              style: TextStyle(
                fontSize: 12.5 * s,
                fontWeight: FontWeight.w800,
                color: selected ? const Color(0xFF2F80ED) : const Color(0xFF4B5565),
              ),
            ),
          ],
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        item(!custom, "Today Data", onToday),
        SizedBox(width: 18 * s),
        item(custom, "Custom Date Data", onCustom),
      ],
    );
  }
}

// ============================ DATE RANGE ROW ============================

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
              border: Border.all(color: const Color(0xFFBFC9DA)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value.isEmpty ? hint : value,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11.5 * s,
                      fontWeight: FontWeight.w700,
                      color: value.isEmpty ? const Color(0xFF8A95A6) : const Color(0xFF1F2A44),
                    ),
                  ),
                ),
                Icon(Icons.calendar_month_rounded, size: 16 * s, color: const Color(0xFF6B778C)),
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
              border: Border.all(color: const Color(0xFF2F80ED), width: 1.2),
            ),
            child: Icon(Icons.search_rounded, size: 18 * s, color: const Color(0xFF2F80ED)),
          ),
        ),
      ],
    );
  }
}

// ============================ ENERGY CARD (exact style) ============================

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
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(12 * s, 10 * s, 12 * s, 10 * s),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10 * s),
        border: Border.all(color: const Color(0xFFBFC9DA)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Energy Chart",
                style: TextStyle(fontSize: 12 * s, fontWeight: FontWeight.w800, color: const Color(0xFF1F2A44)),
              ),
              const Spacer(),
              Text(
                "${energyKw.toStringAsFixed(2)} kw",
                style: TextStyle(fontSize: 22 * s, fontWeight: FontWeight.w900, color: const Color(0xFF0D164A)),
              ),
            ],
          ),
          SizedBox(height: 10 * s),
          for (int i = 0; i < items.length; i++) ...[
            _EnergyRowExact(scale: s, item: items[i]),
            if (i != items.length - 1) SizedBox(height: 8 * s),
          ],
        ],
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

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10 * s, vertical: 8 * s),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6 * s),
        border: Border.all(color: const Color(0xFFBFC9DA)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // LEFT FIXED BLOCK (dot top + label bottom)
          SizedBox(
            width: 56 * s,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8 * s,
                  height: 8 * s,
                  decoration: BoxDecoration(color: item.dot, shape: BoxShape.circle),
                ),
                SizedBox(height: 4 * s),
                Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 12 * s,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF0D164A),
                  ),
                ),
              ],
            ),
          ),

          // VERTICAL DIVIDER (exact like screenshot)
          Container(
            width: 1,
            height: 34 * s,
            margin: EdgeInsets.symmetric(horizontal: 10 * s),
            color: const Color(0xFFBFC9DA),
          ),

          // RIGHT CONTENT
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Text("Data", style: TextStyle(fontSize: 11 * s, fontWeight: FontWeight.w600, color: const Color(0xFF7A869A))),
                    Text("  :  ", style: TextStyle(fontSize: 11 * s, fontWeight: FontWeight.w700, color: const Color(0xFF7A869A))),
                    Expanded(
                      child: Text(
                        item.data,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 11 * s, fontWeight: FontWeight.w900, color: const Color(0xFF0D164A)),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4 * s),
                Row(
                  children: [
                    Text("Cost", style: TextStyle(fontSize: 11 * s, fontWeight: FontWeight.w600, color: const Color(0xFF7A869A))),
                    Text("  :  ", style: TextStyle(fontSize: 11 * s, fontWeight: FontWeight.w700, color: const Color(0xFF7A869A))),
                    Expanded(
                      child: Text(
                        item.cost,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 11 * s, fontWeight: FontWeight.w900, color: const Color(0xFF0D164A)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


// ============================ REVENUE PANEL (exact toggle) ============================

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
        border: Border.all(color: const Color(0xFFBFC9DA)),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12 * s, vertical: 10 * s),
              child: Row(
                children: [
                  Icon(Icons.bar_chart_rounded, size: 18 * s, color: const Color(0xFF2F80ED)),
                  SizedBox(width: 10 * s),
                  Text(
                    "Data & Cost Info",
                    style: TextStyle(fontSize: 12.5 * s, fontWeight: FontWeight.w900, color: const Color(0xFF0D164A)),
                  ),
                  const Spacer(),

                  // BLUE FILLED CIRCLE (matches your screenshot)
                  Container(
                    width: 30 * s,
                    height: 30 * s,
                    decoration: const BoxDecoration(
                      color: Color(0xFF2F80ED),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        expanded ? Icons.keyboard_double_arrow_up_rounded : Icons.keyboard_double_arrow_down_rounded,
                        color: Colors.white,
                        size: 18 * s,
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),

          if (expanded) ...[
            Divider(height: 1, thickness: 1, color: const Color(0xFFBFC9DA)),
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
                            style: TextStyle(fontSize: 12 * s, fontWeight: FontWeight.w600, color: const Color(0xFF7A869A)),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            lines[i].v,
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 12 * s, fontWeight: FontWeight.w900, color: const Color(0xFF0D164A)),
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

// ============================ Models ============================

class _DataItem {
  final String label;
  final Color dot;
  final String data;
  final String cost;
  const _DataItem({required this.label, required this.dot, required this.data, required this.cost});
}

class _KVLine {
  final String k;
  final String v;
  const _KVLine({required this.k, required this.v});
}
