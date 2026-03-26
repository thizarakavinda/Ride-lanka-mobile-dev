import 'package:flutter/material.dart';

class BudgetTabSwitch extends StatefulWidget {
  final List<String> values;
  final ValueChanged<int> onToggleCallback;

  const BudgetTabSwitch({
    super.key,
    required this.values,
    required this.onToggleCallback,
  });

  @override
  State<BudgetTabSwitch> createState() => _BudgetTabSwitchState();
}

class _BudgetTabSwitchState extends State<BudgetTabSwitch> {
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.8;

    return Container(
      width: width,
      height: 60,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFFEDF4F6),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            alignment: Alignment(
              -1 + (_selectedIndex * (2 / (widget.values.length - 1))),
              0,
            ),
            child: Container(
              width: (width / widget.values.length) - 10,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
          ),

          Row(
            children: List.generate(
              widget.values.length,
              (index) => Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    setState(() => _selectedIndex = index);
                    widget.onToggleCallback(index);
                  },
                  child: Center(
                    child: Text(
                      widget.values[index],
                      style: const TextStyle(
                        color: Color(0xFF4A4A4A),
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
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
