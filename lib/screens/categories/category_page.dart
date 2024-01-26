// import 'package:fb_testing/models/user.dart';
// import 'package:flex_color_picker/flex_color_picker.dart';
// import 'package:fb_testing/models/category.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class CategoryPage extends StatefulWidget {
//   const CategoryPage({super.key, this.category});
//   final CategoryModel? category;

//   @override
//   State<CategoryPage> createState() => _CategoryPageState();
// }

// class _CategoryPageState extends State<CategoryPage> {
//   // Define custom colors. The 'guide' color values are from
//   // https://material.io/design/color/the-color-system.html#color-theme-creation
//   static const Color guidePrimary = Color(0xFF6200EE);
//   static const Color guidePrimaryVariant = Color(0xFF3700B3);
//   static const Color guideSecondary = Color(0xFF03DAC6);
//   static const Color guideSecondaryVariant = Color(0xFF018786);
//   static const Color guideError = Color(0xFFB00020);
//   static const Color guideErrorDark = Color(0xFFCF6679);
//   static const Color blueBlues = Color(0xFF174378);

//   // Make a custom ColorSwatch to name map from the above custom colors.
//   final Map<ColorSwatch<Object>, String> colorsNameMap =
//       <ColorSwatch<Object>, String>{
//     ColorTools.createPrimarySwatch(guidePrimary): 'Guide Purple',
//     ColorTools.createPrimarySwatch(guidePrimaryVariant): 'Guide Purple Variant',
//     ColorTools.createAccentSwatch(guideSecondary): 'Guide Teal',
//     ColorTools.createAccentSwatch(guideSecondaryVariant): 'Guide Teal Variant',
//     ColorTools.createPrimarySwatch(guideError): 'Guide Error',
//     ColorTools.createPrimarySwatch(guideErrorDark): 'Guide Error Dark',
//     ColorTools.createPrimarySwatch(blueBlues): 'Blue blues',
//   };
//   late Color screenPickerColor;

//   // Color for the picker in a dialog using onChanged.
//   late Color dialogPickerColor;

//   // Color for picker using the color select dialog.
//   late Color dialogSelectColor;
//   @override
//   void initState() {
//     super.initState();
//     screenPickerColor = Colors.blue; // Material blue.
//     dialogPickerColor = Colors.red; // Material red.
//     dialogSelectColor = const Color(0xFFA239CA); // A purple color.
//   }

//     UserModel? user = Provider.of<UserModel>(context);
//   TextEditingController nameController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {

//     return Scaffold(
//         appBar: AppBar(
//           title: Text(
//             widget.category == null ? "Create a new Category" : "Edit category",
//             style: Theme.of(context).textTheme.titleMedium,
//           ),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             // padding: EdgeInsets.all(20),
//             // primary: false,
//             children: [
//               TextFormField(
//                 controller: nameController,
//                 decoration: const InputDecoration(
//                   label: Text("Name"),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Text(
//                     "Category color: ",
//                     style: Theme.of(context)
//                         .textTheme
//                         .titleSmall!
//                         .copyWith(fontSize: 20),
//                   ),
//                   ColorIndicator(
//                     width: 44,
//                     height: 44,
//                     borderRadius: 4,
//                     color: dialogPickerColor,
//                     onSelectFocus: false,
//                     onSelect: () async {
//                       // Store current color before we open the dialog.
//                       final Color colorBeforeDialog = dialogPickerColor;
//                       // Wait for the picker to close, if dialog was dismissed,
//                       // then restore the color we had before it was opened.
//                       if (!(await colorPickerDialog())) {
//                         setState(() {
//                           dialogPickerColor = colorBeforeDialog;
//                         });
//                       }
//                     },
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               SizedBox(
//                 width: 150,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     CategoryModel m = CategoryModel(
//                         name: nameController.text,
//                         color: dialogPickerColor.value,
//                         count: 0,
//                         id: "${nameController.text} ${user.id}");
//                   },
//                   child: Text(
//                     widget.category == null ? "Create" : "Edit",
//                     style: Theme.of(context)
//                         .textTheme
//                         .titleSmall!
//                         .copyWith(fontSize: 20),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ));
//   }

//   Future<bool> colorPickerDialog() async {
//     return ColorPicker(
//       // Use the dialogPickerColor as start color.
//       color: dialogPickerColor,
//       // Update the dialogPickerColor using the callback.
//       onColorChanged: (Color color) =>
//           setState(() => dialogPickerColor = color),
//       width: 40,
//       height: 40,
//       borderRadius: 4,
//       spacing: 5,
//       runSpacing: 5,
//       wheelDiameter: 155,
//       heading: Text(
//         'Select color',
//         style: Theme.of(context).textTheme.titleSmall,
//       ),
//       subheading: Text(
//         'Select color shade',
//         style: Theme.of(context).textTheme.titleSmall,
//       ),
//       wheelSubheading: Text(
//         'Selected color and its shades',
//         style: Theme.of(context).textTheme.titleSmall,
//       ),
//       showMaterialName: true,
//       showColorName: true,
//       // showColorCode: true,
//       // copyPasteBehavior: const ColorPickerCopyPasteBehavior(
//       //   longPressMenu: true,
//       // ),

//       materialNameTextStyle: Theme.of(context).textTheme.bodySmall,
//       colorNameTextStyle: Theme.of(context).textTheme.bodySmall,
//       colorCodeTextStyle: Theme.of(context).textTheme.bodySmall,
//       pickersEnabled: const <ColorPickerType, bool>{
//         ColorPickerType.both: false,
//         ColorPickerType.primary: true,
//         ColorPickerType.accent: false,
//         ColorPickerType.bw: false,
//         ColorPickerType.custom: false,
//         ColorPickerType.wheel: true,
//       },
//       customColorSwatchesAndNames: colorsNameMap,
//     ).showPickerDialog(
//       context,
//       backgroundColor: Theme.of(context).canvasColor,
//       // New in version 3.0.0 custom transitions support.
//       transitionBuilder: (BuildContext context, Animation<double> a1,
//           Animation<double> a2, Widget widget) {
//         final double curvedValue =
//             Curves.easeInOutBack.transform(a1.value) - 1.0;
//         return Transform(
//           transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
//           child: Opacity(
//             opacity: a1.value,
//             child: widget,
//           ),
//         );
//       },
//       transitionDuration: const Duration(milliseconds: 400),
//       constraints:
//           const BoxConstraints(minHeight: 460, minWidth: 300, maxWidth: 320),
//     );
//   }
// }
