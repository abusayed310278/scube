import 'dart:math' as math;
import 'package:flutter/material.dart';

class DataType2Screen extends StatefulWidget {
  const DataType2Screen({super.key});

  @override
  State<DataType2Screen> createState() => _DataType2ScreenState();
}

class _DataType2ScreenState extends State<DataType2Screen> {
  int topMode = 0; // 0 = Data View, 1 = Revenue View
  int dateMode = 0; // 0 = Today Data, 1 = Custom Date Data

  DateTime? fromDate;
  DateTime? toDate;

  bool revenueExpanded = true;

  static const bg = Color(0xFFE6EDF7);
  static const primary = Color(0xFF0B88F1);
  static const border = Color(0xFFB9C7D8);
  static const textDark = Color(0xFF0A2A3A);

  String _fmt(DateTime? d) {
    if (d == null) return '';
    return '${d.day.toString().padLeft(2, '0')}-'
        '${d.month.toString().padLeft(2, '0')}-'
        '${d.year}';
  }

  Future<void> _pickFromDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: fromDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => fromDate = picked);
  }

  Future<void> _pickToDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: toDate ?? (fromDate ?? DateTime.now()),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => toDate = picked);
  }

  void _onSearch() {
    if (fromDate == null || toDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select From Date and To Date')),
      );
      return;
    }
    if (toDate!.isBefore(fromDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('To Date must be after From Date')),
      );
      return;
    }

    // TODO: call API using fromDate & toDate
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final bool showCustomUI = (topMode == 0 && dateMode == 1); // Data View + Custom Date
    final bool isRevenue = topMode == 1;

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
          style: TextStyle(color: textDark, fontWeight: FontWeight.w800, fontSize: 16),
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 18),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Container(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: border, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 16,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _TopModePill(
                      selected: topMode,
                      onChanged: (i) => setState(() => topMode = i),
                    ),
                    const SizedBox(height: 18),

                    // Gauge
                    _ArcGauge(
                      value: isRevenue ? 0.72 : (showCustomUI ? 0.57 : 0.55),
                      centerTopText: isRevenue ? '8897455' : (showCustomUI ? '57.00' : '55.00'),
                      centerBottomText: isRevenue ? 'tk' : 'kWh/Sqft',
                    ),
                    const SizedBox(height: 10),

                    // ✅ Data View only: Today/Custom
                    if (!isRevenue) ...[
                      _SmallRadioRow(
                        selected: dateMode,
                        onChanged: (i) => setState(() => dateMode = i),
                      ),
                      const SizedBox(height: 14),

                      if (showCustomUI) ...[
                        _DateRangeBar(
                          fromText: _fmt(fromDate),
                          toText: _fmt(toDate),
                          onPickFrom: _pickFromDate,
                          onPickTo: _pickToDate,
                          onSearch: _onSearch,
                        ),
                        const SizedBox(height: 12),
                      ],

                      // Energy cards
                      if (showCustomUI) ...[
                        _EnergyChartCard(
                          totalKwText: '20.05 kw',
                          rows: const [
                            _RowData(dotColor: Color(0xFF0B88F1), label: 'Data A', dataText: '2798.50 (29.53%)', costText: '35689 ৳'),
                            _RowData(dotColor: Color(0xFF8CC6FF), label: 'Data B', dataText: '72598.50 (35.39%)', costText: '5259689 ৳'),
                            _RowData(dotColor: Color(0xFF8B5CF6), label: 'Data C', dataText: '6598.36 (83.90%)', costText: '5698756 ৳'),
                            _RowData(dotColor: Color(0xFFFFB020), label: 'Data D', dataText: '6598.26 (36.59%)', costText: '356987 ৳'),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _EnergyChartCard(
                          totalKwText: '5.53 kw',
                          rows: const [
                            _RowData(dotColor: Color(0xFF0B88F1), label: 'Data A', dataText: '2798.50 (29.53%)', costText: '35689 ৳'),
                            _RowData(dotColor: Color(0xFF8CC6FF), label: 'Data B', dataText: '72598.50 (35.39%)', costText: '5259689 ৳'),
                            _RowData(dotColor: Color(0xFF8B5CF6), label: 'Data C', dataText: '6598.36 (83.90%)', costText: '5698756 ৳'),
                            _RowData(dotColor: Color(0xFFFFB020), label: 'Data D', dataText: '6598.26 (36.59%)', costText: '356987 ৳'),
                          ],
                        ),
                      ] else ...[
                        _EnergyChartCard(
                          totalKwText: '5.53 kw',
                          rows: const [
                            _RowData(dotColor: Color(0xFF0B88F1), label: 'Data A', dataText: '2798.50 (29.53%)', costText: '35689 ৳'),
                            _RowData(dotColor: Color(0xFF8CC6FF), label: 'Data B', dataText: '72598.50 (35.39%)', costText: '5259689 ৳'),
                            _RowData(dotColor: Color(0xFF8B5CF6), label: 'Data C', dataText: '6598.36 (83.90%)', costText: '5698756 ৳'),
                            _RowData(dotColor: Color(0xFFFFB020), label: 'Data D', dataText: '6598.26 (36.59%)', costText: '356987 ৳'),
                          ],
                        ),
                      ],
                    ],

                    // ✅ Revenue View UI (your screenshot)
                    if (isRevenue) ...[
                      const SizedBox(height: 10),
                      _CollapsibleInfoCard(
                        title: 'Data & Cost Info',
                        expanded: revenueExpanded,
                        onToggle: () => setState(() => revenueExpanded = !revenueExpanded),
                        children: const [
                          _InfoLine(index: 1, data: '2798.50 (29.53%)', cost: '35689 ৳'),
                          _InfoLine(index: 2, data: '2798.50 (29.53%)', cost: '35689 ৳'),
                          _InfoLine(index: 3, data: '2798.50 (29.53%)', cost: '35689 ৳'),
                          _InfoLine(index: 4, data: '2798.50 (29.53%)', cost: '35689 ৳'),
                        ],
                      ),
                      const SizedBox(height: 6),
                    ],
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

/* ------------------ Top pill: Data View / Revenue View ------------------ */

class _TopModePill extends StatelessWidget {
  const _TopModePill({required this.selected, required this.onChanged});
  final int selected;
  final ValueChanged<int> onChanged;

  static const border = Color(0xFFB9C7D8);
  static const primary = Color(0xFF0B88F1);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F7FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => onChanged(0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _RadioDot(isOn: selected == 0),
                  const SizedBox(width: 8),
                  Text(
                    'Data View',
                    style: TextStyle(
                      color: selected == 0 ? primary : Colors.grey.shade600,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () => onChanged(1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _RadioDot(isOn: selected == 1),
                  const SizedBox(width: 8),
                  Text(
                    'Revenue View',
                    style: TextStyle(
                      color: selected == 1 ? primary : Colors.grey.shade600,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RadioDot extends StatelessWidget {
  const _RadioDot({required this.isOn});
  final bool isOn;

  static const primary = Color(0xFF0B88F1);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: isOn ? primary : const Color(0xFF9AA8B7), width: 1.6),
      ),
      child: Center(
        child: Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isOn ? primary : Colors.transparent,
          ),
        ),
      ),
    );
  }
}

/* ------------------ Arc Gauge ------------------ */

class _ArcGauge extends StatelessWidget {
  const _ArcGauge({
    required this.value,
    required this.centerTopText,
    required this.centerBottomText,
  });

  final double value; // 0..1
  final String centerTopText;
  final String centerBottomText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 190,
      height: 150,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(190, 150),
            painter: _ArcGaugePainter(value: value),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                centerTopText,
                style: const TextStyle(
                  color: Color(0xFF0A2A3A),
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                centerBottomText,
                style: const TextStyle(
                  color: Color(0xFF0A2A3A),
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ArcGaugePainter extends CustomPainter {
  _ArcGaugePainter({required this.value});
  final double value;

  static const primary = Color(0xFF3B82F6);
  static const bgArc = Color(0xFFD7EBFF);

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = 14.0;
    final center = Offset(size.width / 2, size.height / 2 + 10);
    final radius = math.min(size.width, size.height) / 2 - stroke;

    final start = 0.75 * math.pi;
    final sweepTotal = 1.5 * math.pi;

    final rect = Rect.fromCircle(center: center, radius: radius);

    final pBg = Paint()
      ..color = bgArc
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    final pFg = Paint()
      ..color = primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, start, sweepTotal, false, pBg);
    canvas.drawArc(rect, start, sweepTotal * value.clamp(0, 1), false, pFg);
  }

  @override
  bool shouldRepaint(covariant _ArcGaugePainter oldDelegate) => oldDelegate.value != value;
}

/* ------------------ Today / Custom Radio Row ------------------ */

class _SmallRadioRow extends StatelessWidget {
  const _SmallRadioRow({required this.selected, required this.onChanged});
  final int selected;
  final ValueChanged<int> onChanged;

  static const primary = Color(0xFF0B88F1);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () => onChanged(0),
          child: Row(
            children: [
              _MiniDot(isOn: selected == 0),
              const SizedBox(width: 6),
              Text(
                'Today Data',
                style: TextStyle(
                  color: selected == 0 ? primary : Colors.grey.shade700,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 18),
        InkWell(
          onTap: () => onChanged(1),
          child: Row(
            children: [
              _MiniDot(isOn: selected == 1),
              const SizedBox(width: 6),
              Text(
                'Custom Date Data',
                style: TextStyle(
                  color: selected == 1 ? primary : Colors.grey.shade700,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MiniDot extends StatelessWidget {
  const _MiniDot({required this.isOn});
  final bool isOn;

  static const primary = Color(0xFF0B88F1);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isOn ? primary : const Color(0xFF9AA8B7),
      ),
    );
  }
}

/* ------------------ Date range row ------------------ */

class _DateRangeBar extends StatelessWidget {
  const _DateRangeBar({
    required this.fromText,
    required this.toText,
    required this.onPickFrom,
    required this.onPickTo,
    required this.onSearch,
  });

  final String fromText;
  final String toText;
  final VoidCallback onPickFrom;
  final VoidCallback onPickTo;
  final VoidCallback onSearch;

  static const border = Color(0xFFB9C7D8);
  static const primary = Color(0xFF0B88F1);

  @override
  Widget build(BuildContext context) {
    Widget box({required String hint, required String value, required VoidCallback onTap}) {
      return Expanded(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: border),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value.isEmpty ? hint : value,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: value.isEmpty ? Colors.grey.shade500 : const Color(0xFF0A2A3A),
                    ),
                  ),
                ),
                const Icon(Icons.calendar_month_outlined, size: 18, color: Color(0xFF6B7C8B)),
              ],
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        box(hint: 'From Date', value: fromText, onTap: onPickFrom),
        const SizedBox(width: 10),
        box(hint: 'To Date', value: toText, onTap: onPickTo),
        const SizedBox(width: 10),
        InkWell(
          onTap: onSearch,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: border),
            ),
            child: const Icon(Icons.search, color: primary),
          ),
        ),
      ],
    );
  }
}

/* ------------------ Energy Chart Card (reusable) ------------------ */

class _RowData {
  const _RowData({
    required this.dotColor,
    required this.label,
    required this.dataText,
    required this.costText,
  });

  final Color dotColor;
  final String label;
  final String dataText;
  final String costText;
}

class _EnergyChartCard extends StatelessWidget {
  const _EnergyChartCard({
    required this.totalKwText,
    required this.rows,
  });

  final String totalKwText;
  final List<_RowData> rows;

  static const border = Color(0xFFB9C7D8);
  static const textDark = Color(0xFF0A2A3A);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border, width: 1),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                'Energy Chart',
                style: TextStyle(
                  color: textDark,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              Text(
                totalKwText,
                style: const TextStyle(
                  color: textDark,
                  fontWeight: FontWeight.w900,
                  fontSize: 26,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          for (int i = 0; i < rows.length; i++) ...[
            _DataRowTile(
              dotColor: rows[i].dotColor,
              label: rows[i].label,
              dataText: rows[i].dataText,
              costText: rows[i].costText,
            ),
            if (i != rows.length - 1) const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

class _DataRowTile extends StatelessWidget {
  const _DataRowTile({
    required this.dotColor,
    required this.label,
    required this.dataText,
    required this.costText,
  });

  final Color dotColor;
  final String label;
  final String dataText;
  final String costText;

  static const border = Color(0xFFB9C7D8);
  static const textDark = Color(0xFF0A2A3A);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: border, width: 1),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 56,
            child: Row(
              children: [
                Container(width: 8, height: 8, decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle)),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: textDark,
                      fontWeight: FontWeight.w900,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(width: 1, height: 34, color: border.withOpacity(0.9)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Data   :   $dataText',
                  style: const TextStyle(
                    color: textDark,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Cost   :   $costText',
                  style: const TextStyle(
                    color: textDark,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/* ------------------ Revenue collapsible panel ------------------ */

class _CollapsibleInfoCard extends StatelessWidget {
  const _CollapsibleInfoCard({
    required this.title,
    required this.expanded,
    required this.onToggle,
    required this.children,
  });

  final String title;
  final bool expanded;
  final VoidCallback onToggle;
  final List<Widget> children;

  static const border = Color(0xFFB9C7D8);
  static const primary = Color(0xFF0B88F1);
  static const textDark = Color(0xFF0A2A3A);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: Row(
                children: [
                  const Icon(Icons.bar_chart, size: 18, color: Color(0xFF5B6B7B)),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      color: textDark,
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 26,
                    height: 26,
                    decoration: const BoxDecoration(color: primary, shape: BoxShape.circle),
                    child: Icon(
                      expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF7FBFF),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
                border: Border(top: BorderSide(color: border)),
              ),
              child: Column(children: children),
            ),
            crossFadeState: expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({
    required this.index,
    required this.data,
    required this.cost,
  });

  final int index;
  final String data;
  final String cost;

  static const textDark = Color(0xFF0A2A3A);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Data $index  :  $data',
            style: const TextStyle(
              color: textDark,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Cost $index  :  $cost',
            style: const TextStyle(
              color: textDark,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
