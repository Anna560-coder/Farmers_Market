// import 'package:farmers_1/Core/Common/color_conversion.dart';
// import 'package:flutter/material.dart';

// class SizeAndColor extends StatefulWidget {
//   final List<dynamic> colors;
//   final List<dynamic> sizes;
//   final Function(int) onColorSelected;
//   final Function(int) onSizeSelected;
//   final int selectedColorIndex;
//   final int selectedSizeIndex;

//   const SizeAndColor({
//     super.key,
//     required this.colors,
//     required this.sizes,
//     required this.onColorSelected,
//     required this.onSizeSelected,
//     required this.selectedColorIndex,
//     required this.selectedSizeIndex,
//   });

//   @override
//   State<SizeAndColor> createState() => _SizeAndColorState();
// }

// class _SizeAndColorState extends State<SizeAndColor> {
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SizedBox(
//           width: size.width / 2.1,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // for color,
//               const Text(
//                 "Color",
//                 style: TextStyle(
//                   color: Colors.black54,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   children: widget.colors.asMap().entries.map<Widget>((entry) {
//                     final int index = entry.key;
//                     final color = entry.value;
//                     return Padding(
//                       padding: const EdgeInsets.only(top: 10, right: 10),
//                       child: CircleAvatar(
//                         radius: 18,
//                         backgroundColor: getColorFromName(color),
//                         child: GestureDetector(
//                           onTap: () {
//                             widget.onColorSelected(index);
//                           },
//                           child: Icon(
//                             Icons.check,
//                             color: widget.selectedColorIndex == index
//                                 ? Colors.white
//                                 : Colors.transparent,
//                           ),
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         // for size
//         SizedBox(
//           width: size.width / 2.4,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // for color,
//               const Text(
//                 "Size",
//                 style: TextStyle(
//                   color: Colors.black54,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   children: widget.sizes.asMap().entries.map<Widget>((entry) {
//                     final int index = entry.key;
//                     final size = entry.value;
//                     return GestureDetector(
//                       onTap: () {
//                         widget.onSizeSelected(index);
//                       },
//                       child: Container(
//                         margin: const EdgeInsets.only(right: 10, top: 10),
//                         height: 35,
//                         width: 35,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: widget.selectedSizeIndex == index
//                               ? Colors.black
//                               : Colors.white,
//                           border: Border.all(
//                             color: widget.selectedSizeIndex == index
//                                 ? Colors.black
//                                 : Colors.black12,
//                           ),
//                         ),
//                         child: Center(
//                           child: Text(
//                             size,
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: widget.selectedSizeIndex == index
//                                   ? Colors.white
//                                   : Colors.black,
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:farmers_1/Core/Common/color_conversion.dart';
import 'package:flutter/material.dart';

class SizeAndColor extends StatefulWidget {
  final List<dynamic> colors;
  final List<dynamic> sizes;
  final Function(int) onColorSelected;
  final Function(int) onSizeSelected;
  final int selectedColorIndex;
  final int selectedSizeIndex;

  const SizeAndColor({
    super.key,
    required this.colors,
    required this.sizes,
    required this.onColorSelected,
    required this.onSizeSelected,
    required this.selectedColorIndex,
    required this.selectedSizeIndex,
  });

  @override
  State<SizeAndColor> createState() => _SizeAndColorState();
}

class _SizeAndColorState extends State<SizeAndColor> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Color section
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Color",
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: widget.colors.asMap().entries.map<Widget>((entry) {
                    final int index = entry.key;
                    final color = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(right: 16, top: 5),
                      child: GestureDetector(
                        onTap: () => widget.onColorSelected(index),
                        child: CircleAvatar(
                          radius: 50, // BIG circle
                          backgroundColor: getColorFromName(color),
                          child: widget.selectedColorIndex == index
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 32,
                                )
                              : null,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 20),

        // Size section
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Size",
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: widget.sizes.asMap().entries.map<Widget>((entry) {
                    final int index = entry.key;
                    final size = entry.value;
                    return GestureDetector(
                      onTap: () => widget.onSizeSelected(index),
                      child: Container(
                        margin: const EdgeInsets.only(right: 16, top: 5),
                        height: 100, // BIG circle
                        width: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.selectedSizeIndex == index
                              ? Colors.black
                              : Colors.white,
                          border: Border.all(
                            color: widget.selectedSizeIndex == index
                                ? Colors.black
                                : Colors.black26,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            size,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: widget.selectedSizeIndex == index
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
