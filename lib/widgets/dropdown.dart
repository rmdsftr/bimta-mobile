import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final List<String> items;
  final String? hint;
  final Function(int index, String value)? onChanged;
  final int? selectedIndex;
  final Color? primaryColor;
  final Color? backgroundColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final IconData? prefixIcon;
  final Color? prefixIconColor;
  final bool enabled;

  const CustomDropdown({
    Key? key,
    required this.items,
    this.hint,
    this.onChanged,
    this.selectedIndex,
    this.primaryColor = Colors.deepPurple,
    this.backgroundColor = const Color(0xFFF5F5F5),
    this.borderRadius = 12.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
    this.textStyle,
    this.hintStyle,
    this.prefixIcon = Icons.arrow_drop_down_circle_outlined,
    this.prefixIconColor,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DropdownButtonFormField<int>(
      value: selectedIndex,
      isExpanded: true,
      hint: Text(
        hint ?? 'Pilih item',
        style: hintStyle ?? TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: enabled ? backgroundColor : Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius!),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius!),
          borderSide: BorderSide.none
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius!),
          borderSide: BorderSide.none
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius!),
          borderSide: BorderSide.none
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius!),
          borderSide: BorderSide.none
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius!),
          borderSide: BorderSide.none
        ),
        prefixIcon: prefixIcon != null
            ? Icon(
          prefixIcon,
          size: 17,
          color: enabled
              ? (prefixIconColor ?? primaryColor)
              : Colors.grey[400],
        )
            : null,
        contentPadding: padding,
        hintStyle: hintStyle ?? TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
        ),
      ),
      style: textStyle ?? TextStyle(
        color: enabled ? Colors.black87 : Colors.grey[600],
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      dropdownColor: Colors.white,
      elevation: 8,
      borderRadius: BorderRadius.circular(borderRadius!),
      items: items.asMap().entries.map((entry) {
        int index = entry.key;
        String value = entry.value;

        return DropdownMenuItem<int>(
          value: index,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              value,
              style: textStyle ?? TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: primaryColor,
                fontFamily: 'Poppins'
              ),
            ),
          ),
        );
      }).toList(),
      onChanged: enabled && onChanged != null ? (int? newIndex) {
        if (newIndex != null) {
          onChanged!(newIndex, items[newIndex]);
        }
      } : null,
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: enabled ? primaryColor : Colors.grey[400],
        size: 19,
      ),
    );
  }
}
