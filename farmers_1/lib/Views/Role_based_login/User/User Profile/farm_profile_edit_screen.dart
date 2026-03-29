// import 'package:flutter/material.dart';
// import 'package:farmers_1/l10n/app_localizations.dart';
// import 'package:farmers_1/Core/Models/farm_profile.dart';
// import 'package:farmers_1/Core/Services/farm_profile_service.dart';
// import 'package:farmers_1/Core/Services/location_service.dart';
// import 'package:farmers_1/Core/Services/user_service.dart';

// class FarmProfileEditScreen extends StatefulWidget {
//   final FarmProfile? farmProfile;

//   const FarmProfileEditScreen({super.key, this.farmProfile});

//   @override
//   State<FarmProfileEditScreen> createState() => _FarmProfileEditScreenState();
// }

// class _FarmProfileEditScreenState extends State<FarmProfileEditScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _farmNameController = TextEditingController();
//   final _locationController = TextEditingController();
//   final _sizeController = TextEditingController();
//   final _ownerNameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _cropController = TextEditingController();
//   final _livestockController = TextEditingController();

//   List<String> _crops = [];
//   List<String> _livestock = [];
//   bool _isLoading = false;
//   bool _isGettingLocation = false;

//   @override
//   void initState() {
//     super.initState();
//     if (widget.farmProfile != null) {
//       _populateFields();
//     } else {
//       // For new profiles, populate with user data and get location
//       _populateUserData();
//       _getCurrentLocation();
//     }
//   }

//   void _populateFields() {
//     final profile = widget.farmProfile!;
//     _farmNameController.text = profile.farmName;
//     _locationController.text = profile.location;
//     _sizeController.text = profile.size;
//     _ownerNameController.text = profile.ownerName;
//     _emailController.text = profile.email;
//     _phoneController.text = profile.phone;
//     _crops = List.from(profile.crops);
//     _livestock = List.from(profile.livestock);
//   }

//   /// Populate form fields with current user's information
//   Future<void> _populateUserData() async {
//     try {
//       // Get user's full name
//       final fullName = await UserService.getUserFullName();
//       if (fullName != null && fullName.isNotEmpty) {
//         _ownerNameController.text = fullName;
//       }

//       // Get user's email
//       final email = await UserService.getUserEmail();
//       if (email != null && email.isNotEmpty) {
//         _emailController.text = email;
//       }

//       // Get user's phone number
//       final phone = await UserService.getUserPhoneNumber();
//       if (phone != null && phone.isNotEmpty) {
//         _phoneController.text = phone;
//       }
//     } catch (e) {
//       print('Error populating user data: $e');
//     }
//   }

//   /// Get current location and populate location field
//   Future<void> _getCurrentLocation() async {
//     if (_isGettingLocation) return;

//     setState(() {
//       _isGettingLocation = true;
//     });

//     try {
//       final l10n = AppLocalizations.of(context)!;

//       // Show loading message
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Row(
//             children: [
//               const SizedBox(
//                 width: 20,
//                 height: 20,
//                 child: CircularProgressIndicator(strokeWidth: 2),
//               ),
//               const SizedBox(width: 16),
//               Text(l10n.gettingLocation),
//             ],
//           ),
//           duration: const Duration(seconds: 5),
//         ),
//       );

//       // First check location service status for debugging
//       final status = await LocationService.getLocationServiceStatus();
//       print('Location Service Status: $status');

//       // Get current location address (with South African accuracy)
//       final address = await LocationService.getSouthAfricanLocation();

//       if (address != null &&
//           address.isNotEmpty &&
//           address != 'Unknown Location') {
//         _locationController.text = address;

//         // Show success message
//         ScaffoldMessenger.of(context).hideCurrentSnackBar();
//         String message = 'Location detected: $address';
//         if (!status['serviceEnabled'] || !status['hasPermission']) {
//           message += '\n(Approximate location - you can edit if needed)';
//         }

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(message),
//             backgroundColor: Colors.green,
//             duration: const Duration(seconds: 4),
//           ),
//         );
//       } else {
//         // Show error message with debug info
//         ScaffoldMessenger.of(context).hideCurrentSnackBar();
//         String debugInfo = '';
//         if (!status['serviceEnabled']) {
//           debugInfo =
//               '\nLocation services are disabled. Trying alternative method...';
//         } else if (!status['hasPermission']) {
//           debugInfo =
//               '\nLocation permission not granted. Trying alternative method...';
//         }

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('${l10n.locationError}$debugInfo'),
//             backgroundColor: Colors.orange,
//             duration: const Duration(seconds: 6),
//           ),
//         );
//       }
//     } catch (e) {
//       print('Error getting current location: $e');
//       ScaffoldMessenger.of(context).hideCurrentSnackBar();

//       // Provide more specific error messages
//       final l10n = AppLocalizations.of(context)!;
//       String errorMessage = l10n.locationError;
//       if (e.toString().contains('Location services are disabled')) {
//         errorMessage =
//             'Location services are disabled. Please enable location services in your device settings.';
//       } else if (e.toString().contains('Location permissions are denied')) {
//         errorMessage =
//             'Location permissions are denied. Please allow location access in your device settings.';
//       } else if (e.toString().contains('permanently denied')) {
//         errorMessage =
//             'Location permissions are permanently denied. Please enable location access in your device settings.';
//       }

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(errorMessage),
//           backgroundColor: Colors.red,
//           duration: const Duration(seconds: 5),
//         ),
//       );
//     } finally {
//       setState(() {
//         _isGettingLocation = false;
//       });
//     }
//   }

//   /// Try to get more accurate location using GPS
//   Future<void> _getAccurateLocation() async {
//     if (_isGettingLocation) return;

//     setState(() {
//       _isGettingLocation = true;
//     });

//     try {
//       // Show loading message
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Row(
//             children: [
//               const SizedBox(
//                 width: 20,
//                 height: 20,
//                 child: CircularProgressIndicator(strokeWidth: 2),
//               ),
//               const SizedBox(width: 16),
//               Text('Trying to get accurate GPS location...'),
//             ],
//           ),
//           duration: const Duration(seconds: 10),
//         ),
//       );

//       // Try to get more accurate location
//       final address = await LocationService.getAccurateLocationAddress();

//       if (address != null &&
//           address.isNotEmpty &&
//           address != 'Unknown Location') {
//         _locationController.text = address;

//         // Show success message
//         ScaffoldMessenger.of(context).hideCurrentSnackBar();
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Accurate location detected: $address'),
//             backgroundColor: Colors.green,
//             duration: const Duration(seconds: 4),
//           ),
//         );
//       } else {
//         // Show error message
//         ScaffoldMessenger.of(context).hideCurrentSnackBar();
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               'Could not get accurate location. Please enable location services in your device settings.',
//             ),
//             backgroundColor: Colors.orange,
//             duration: const Duration(seconds: 5),
//           ),
//         );
//       }
//     } catch (e) {
//       print('Error getting accurate location: $e');
//       ScaffoldMessenger.of(context).hideCurrentSnackBar();
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error getting accurate location: $e'),
//           backgroundColor: Colors.red,
//           duration: const Duration(seconds: 5),
//         ),
//       );
//     } finally {
//       setState(() {
//         _isGettingLocation = false;
//       });
//     }
//   }

//   /// Set Bloemfontein as the location
//   void _setBloemfonteinLocation() {
//     _locationController.text = 'Bloemfontein, Free State, South Africa';
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Location set to Bloemfontein, Free State, South Africa'),
//         backgroundColor: Colors.green,
//         duration: Duration(seconds: 2),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _farmNameController.dispose();
//     _locationController.dispose();
//     _sizeController.dispose();
//     _ownerNameController.dispose();
//     _emailController.dispose();
//     _phoneController.dispose();
//     _cropController.dispose();
//     _livestockController.dispose();
//     super.dispose();
//   }

//   Future<void> _saveFarmProfile() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final l10n = AppLocalizations.of(context)!;
//       final farmProfile = FarmProfile(
//         id: widget.farmProfile?.id,
//         userId: '', // Will be set by service
//         farmName: _farmNameController.text.trim(),
//         location: _locationController.text.trim(),
//         size: _sizeController.text.trim(),
//         crops: _crops,
//         livestock: _livestock,
//         ownerName: _ownerNameController.text.trim(),
//         email: _emailController.text.trim(),
//         phone: _phoneController.text.trim(),
//         createdAt: widget.farmProfile?.createdAt ?? DateTime.now(),
//         updatedAt: DateTime.now(),
//       );

//       // Validate the farm profile
//       final validationError = FarmProfileService.validateFarmProfile(
//         farmProfile,
//       );
//       if (validationError != null) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text(validationError)));
//         setState(() {
//           _isLoading = false;
//         });
//         return;
//       }

//       if (widget.farmProfile == null) {
//         // Create new profile
//         await FarmProfileService.createFarmProfile(farmProfile);
//         if (mounted) {
//           ScaffoldMessenger.of(
//             context,
//           ).showSnackBar(SnackBar(content: Text(l10n.farmProfileCreated)));
//           Navigator.of(context).pop(true);
//         }
//       } else {
//         // Update existing profile
//         await FarmProfileService.updateFarmProfile(farmProfile);
//         if (mounted) {
//           ScaffoldMessenger.of(
//             context,
//           ).showSnackBar(SnackBar(content: Text(l10n.farmProfileUpdated)));
//           Navigator.of(context).pop(true);
//         }
//       }
//     } catch (e) {
//       if (mounted) {
//         final l10n = AppLocalizations.of(context)!;
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('${l10n.farmProfileError}: $e')));
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   void _addCrop() {
//     if (_cropController.text.trim().isNotEmpty) {
//       setState(() {
//         _crops.add(_cropController.text.trim());
//         _cropController.clear();
//       });
//     }
//   }

//   void _removeCrop(int index) {
//     setState(() {
//       _crops.removeAt(index);
//     });
//   }

//   void _addLivestock() {
//     if (_livestockController.text.trim().isNotEmpty) {
//       setState(() {
//         _livestock.add(_livestockController.text.trim());
//         _livestockController.clear();
//       });
//     }
//   }

//   void _removeLivestock(int index) {
//     setState(() {
//       _livestock.removeAt(index);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final l10n = AppLocalizations.of(context)!;
//     final isEditing = widget.farmProfile != null;

//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F5F5),
//       appBar: AppBar(
//         title: Text(isEditing ? l10n.editFarmProfile : l10n.addFarmProfile),
//         backgroundColor: Colors.green,
//         foregroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               // Farm Details Card
//               _buildFarmDetailsCard(l10n),
//               const SizedBox(height: 16),
//               // Contact Information Card
//               _buildContactInfoCard(l10n),
//               const SizedBox(height: 32),
//               // Save Button
//               SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton(
//                   onPressed: _isLoading ? null : _saveFarmProfile,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                     foregroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   child: _isLoading
//                       ? const SizedBox(
//                           width: 20,
//                           height: 20,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             valueColor: AlwaysStoppedAnimation<Color>(
//                               Colors.white,
//                             ),
//                           ),
//                         )
//                       : Text(
//                           l10n.saveFarmProfile,
//                           style: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildFarmDetailsCard(AppLocalizations l10n) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               l10n.farmDetails,
//               style: const TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//             const SizedBox(height: 20),
//             _buildTextField(
//               controller: _farmNameController,
//               label: l10n.farmName,
//               icon: Icons.agriculture,
//               validator: (value) {
//                 if (value == null || value.trim().isEmpty) {
//                   return l10n.farmNameRequired;
//                 }
//                 return null;
//               },
//             ),
//             const SizedBox(height: 16),
//             _buildLocationField(l10n),
//             const SizedBox(height: 16),
//             _buildTextField(
//               controller: _sizeController,
//               label: l10n.size,
//               icon: Icons.crop_square,
//               validator: (value) {
//                 if (value == null || value.trim().isEmpty) {
//                   return l10n.sizeRequired;
//                 }
//                 return null;
//               },
//             ),
//             const SizedBox(height: 20),
//             _buildCropsSection(l10n),
//             const SizedBox(height: 20),
//             _buildLivestockSection(l10n),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildContactInfoCard(AppLocalizations l10n) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               l10n.contactInformation,
//               style: const TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//             const SizedBox(height: 20),
//             _buildTextField(
//               controller: _ownerNameController,
//               label: l10n.ownerName,
//               icon: Icons.person,
//               validator: (value) {
//                 if (value == null || value.trim().isEmpty) {
//                   return l10n.ownerNameRequired;
//                 }
//                 return null;
//               },
//             ),
//             const SizedBox(height: 16),
//             _buildTextField(
//               controller: _emailController,
//               label: l10n.email,
//               icon: Icons.email,
//               keyboardType: TextInputType.emailAddress,
//               validator: (value) {
//                 if (value == null || value.trim().isEmpty) {
//                   return l10n.validEmailRequired;
//                 }
//                 final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
//                 if (!emailRegex.hasMatch(value)) {
//                   return l10n.validEmailRequired;
//                 }
//                 return null;
//               },
//             ),
//             const SizedBox(height: 16),
//             _buildTextField(
//               controller: _phoneController,
//               label: l10n.phone,
//               icon: Icons.phone,
//               keyboardType: TextInputType.phone,
//               validator: (value) {
//                 if (value == null || value.trim().isEmpty) {
//                   return l10n.phoneRequired;
//                 }
//                 final phoneRegex = RegExp(r'^[\+]?[0-9\s\-\(\)]{10,}$');
//                 if (!phoneRegex.hasMatch(value)) {
//                   return l10n.validPhoneRequired;
//                 }
//                 return null;
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     TextInputType? keyboardType,
//     String? Function(String?)? validator,
//   }) {
//     return TextFormField(
//       controller: controller,
//       keyboardType: keyboardType,
//       validator: validator,
//       decoration: InputDecoration(
//         labelText: label,
//         prefixIcon: Icon(icon, color: Colors.green),
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: const BorderSide(color: Colors.green, width: 2),
//         ),
//       ),
//     );
//   }

//   Widget _buildLocationField(AppLocalizations l10n) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Expanded(
//               child: TextFormField(
//                 controller: _locationController,
//                 validator: (value) {
//                   if (value == null || value.trim().isEmpty) {
//                     return l10n.locationRequired;
//                   }
//                   return null;
//                 },
//                 decoration: InputDecoration(
//                   labelText: l10n.location,
//                   prefixIcon: const Icon(
//                     Icons.location_on,
//                     color: Colors.green,
//                   ),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                     borderSide: const BorderSide(color: Colors.green, width: 2),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 8),
//             Column(
//               children: [
//                 ElevatedButton.icon(
//                   onPressed: _isGettingLocation ? null : _getCurrentLocation,
//                   icon: _isGettingLocation
//                       ? const SizedBox(
//                           width: 16,
//                           height: 16,
//                           child: CircularProgressIndicator(strokeWidth: 2),
//                         )
//                       : const Icon(Icons.my_location, size: 20),
//                   label: Text(_isGettingLocation ? 'Getting...' : 'Auto'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blue,
//                     foregroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 12,
//                       vertical: 8,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 TextButton(
//                   onPressed: _isGettingLocation ? null : _getAccurateLocation,
//                   child: Text(
//                     'Try GPS',
//                     style: TextStyle(fontSize: 10, color: Colors.blue.shade700),
//                   ),
//                 ),
//                 const SizedBox(height: 2),
//                 TextButton(
//                   onPressed: _setBloemfonteinLocation,
//                   child: Text(
//                     'Set Bloemfontein',
//                     style: TextStyle(
//                       fontSize: 10,
//                       color: Colors.green.shade700,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         const SizedBox(height: 8),
//         Text(
//           'Tap "Auto" to detect your current location automatically\nTap "Set Bloemfontein" for quick access to Bloemfontein location\nNote: If detected location is incorrect, you can edit it manually',
//           style: TextStyle(
//             fontSize: 12,
//             color: Colors.grey.shade600,
//             fontStyle: FontStyle.italic,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildCropsSection(AppLocalizations l10n) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           l10n.crops,
//           style: const TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//             color: Colors.black87,
//           ),
//         ),
//         const SizedBox(height: 12),
//         Row(
//           children: [
//             Expanded(
//               child: TextField(
//                 controller: _cropController,
//                 decoration: InputDecoration(
//                   hintText: l10n.enterCropName,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   contentPadding: const EdgeInsets.symmetric(
//                     horizontal: 12,
//                     vertical: 8,
//                   ),
//                 ),
//                 onSubmitted: (_) => _addCrop(),
//               ),
//             ),
//             const SizedBox(width: 8),
//             ElevatedButton(
//               onPressed: _addCrop,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green,
//                 foregroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               child: Text(l10n.addCrop),
//             ),
//           ],
//         ),
//         const SizedBox(height: 12),
//         if (_crops.isNotEmpty)
//           Wrap(
//             spacing: 8,
//             runSpacing: 8,
//             children: _crops.asMap().entries.map((entry) {
//               return Chip(
//                 label: Text(entry.value),
//                 backgroundColor: const Color(0xFF8B4513),
//                 labelStyle: const TextStyle(color: Colors.white),
//                 deleteIcon: const Icon(
//                   Icons.close,
//                   color: Colors.white,
//                   size: 18,
//                 ),
//                 onDeleted: () => _removeCrop(entry.key),
//               );
//             }).toList(),
//           ),
//       ],
//     );
//   }

//   Widget _buildLivestockSection(AppLocalizations l10n) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           l10n.livestock,
//           style: const TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//             color: Colors.black87,
//           ),
//         ),
//         const SizedBox(height: 12),
//         Row(
//           children: [
//             Expanded(
//               child: TextField(
//                 controller: _livestockController,
//                 decoration: InputDecoration(
//                   hintText: l10n.enterLivestockName,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   contentPadding: const EdgeInsets.symmetric(
//                     horizontal: 12,
//                     vertical: 8,
//                   ),
//                 ),
//                 onSubmitted: (_) => _addLivestock(),
//               ),
//             ),
//             const SizedBox(width: 8),
//             ElevatedButton(
//               onPressed: _addLivestock,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green,
//                 foregroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               child: Text(l10n.addLivestock),
//             ),
//           ],
//         ),
//         const SizedBox(height: 12),
//         if (_livestock.isNotEmpty)
//           Wrap(
//             spacing: 8,
//             runSpacing: 8,
//             children: _livestock.asMap().entries.map((entry) {
//               return Chip(
//                 label: Text(entry.value),
//                 backgroundColor: const Color(0xFF8B4513),
//                 labelStyle: const TextStyle(color: Colors.white),
//                 deleteIcon: const Icon(
//                   Icons.close,
//                   color: Colors.white,
//                   size: 18,
//                 ),
//                 onDeleted: () => _removeLivestock(entry.key),
//               );
//             }).toList(),
//           ),
//       ],
//     );
//   }
// }

//wworking on this please!!

// import 'package:flutter/material.dart';
// import 'package:farmers_1/l10n/app_localizations.dart';
// import 'package:farmers_1/Core/Models/farm_profile.dart';
// import 'package:farmers_1/Core/Services/farm_profile_service.dart';
// import 'package:farmers_1/Core/Services/user_service.dart';

// class FarmProfileEditScreen extends StatefulWidget {
//   final FarmProfile? farmProfile;

//   const FarmProfileEditScreen({super.key, this.farmProfile});

//   @override
//   State<FarmProfileEditScreen> createState() => _FarmProfileEditScreenState();
// }

// class _FarmProfileEditScreenState extends State<FarmProfileEditScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _farmNameController = TextEditingController();
//   final _locationController = TextEditingController();
//   final _sizeController = TextEditingController();
//   final _ownerNameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _cropController = TextEditingController();
//   final _livestockController = TextEditingController();

//   List<String> _crops = [];
//   List<String> _livestock = [];
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     if (widget.farmProfile != null) {
//       _populateFields();
//     } else {
//       _populateUserData();
//     }
//   }

//   void _populateFields() {
//     final profile = widget.farmProfile!;
//     _farmNameController.text = profile.farmName;
//     _locationController.text = profile.location;
//     _sizeController.text = profile.size;
//     _ownerNameController.text = profile.ownerName;
//     _emailController.text = profile.email;
//     _phoneController.text = profile.phone;
//     _crops = List.from(profile.crops);
//     _livestock = List.from(profile.livestock);
//   }

//   Future<void> _populateUserData() async {
//     try {
//       final fullName = await UserService.getUserFullName();
//       if (fullName != null && fullName.isNotEmpty) {
//         _ownerNameController.text = fullName;
//       }

//       final email = await UserService.getUserEmail();
//       if (email != null && email.isNotEmpty) {
//         _emailController.text = email;
//       }

//       final phone = await UserService.getUserPhoneNumber();
//       if (phone != null && phone.isNotEmpty) {
//         _phoneController.text = phone;
//       }
//     } catch (e) {
//       print('Error populating user data: $e');
//     }
//   }

//   @override
//   void dispose() {
//     _farmNameController.dispose();
//     _locationController.dispose();
//     _sizeController.dispose();
//     _ownerNameController.dispose();
//     _emailController.dispose();
//     _phoneController.dispose();
//     _cropController.dispose();
//     _livestockController.dispose();
//     super.dispose();
//   }

//   Future<void> _saveFarmProfile() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final l10n = AppLocalizations.of(context)!;
//       final farmProfile = FarmProfile(
//         id: widget.farmProfile?.id,
//         userId: '',
//         farmName: _farmNameController.text.trim(),
//         location: _locationController.text.trim(),
//         size: _sizeController.text.trim(),
//         crops: _crops,
//         livestock: _livestock,
//         ownerName: _ownerNameController.text.trim(),
//         email: _emailController.text.trim(),
//         phone: _phoneController.text.trim(),
//         createdAt: widget.farmProfile?.createdAt ?? DateTime.now(),
//         updatedAt: DateTime.now(),
//       );

//       final validationError = FarmProfileService.validateFarmProfile(
//         farmProfile,
//       );
//       if (validationError != null) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text(validationError)));
//         setState(() {
//           _isLoading = false;
//         });
//         return;
//       }

//       if (widget.farmProfile == null) {
//         await FarmProfileService.createFarmProfile(farmProfile);
//         if (mounted) {
//           ScaffoldMessenger.of(
//             context,
//           ).showSnackBar(SnackBar(content: Text(l10n.farmProfileCreated)));
//           Navigator.of(context).pop(true);
//         }
//       } else {
//         await FarmProfileService.updateFarmProfile(farmProfile);
//         if (mounted) {
//           ScaffoldMessenger.of(
//             context,
//           ).showSnackBar(SnackBar(content: Text(l10n.farmProfileUpdated)));
//           Navigator.of(context).pop(true);
//         }
//       }
//     } catch (e) {
//       if (mounted) {
//         final l10n = AppLocalizations.of(context)!;
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('${l10n.farmProfileError}: $e')));
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   void _addCrop() {
//     if (_cropController.text.trim().isNotEmpty) {
//       setState(() {
//         _crops.add(_cropController.text.trim());
//         _cropController.clear();
//       });
//     }
//   }

//   void _removeCrop(int index) {
//     setState(() {
//       _crops.removeAt(index);
//     });
//   }

//   void _addLivestock() {
//     if (_livestockController.text.trim().isNotEmpty) {
//       setState(() {
//         _livestock.add(_livestockController.text.trim());
//         _livestockController.clear();
//       });
//     }
//   }

//   void _removeLivestock(int index) {
//     setState(() {
//       _livestock.removeAt(index);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final l10n = AppLocalizations.of(context)!;
//     final isEditing = widget.farmProfile != null;

//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F5F5),
//       appBar: AppBar(
//         title: Text(isEditing ? l10n.editFarmProfile : l10n.addFarmProfile),
//         backgroundColor: Colors.green,
//         foregroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               _buildFarmDetailsCard(l10n),
//               const SizedBox(height: 16),
//               _buildContactInfoCard(l10n),
//               const SizedBox(height: 32),
//               SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton(
//                   onPressed: _isLoading ? null : _saveFarmProfile,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                     foregroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   child: _isLoading
//                       ? const SizedBox(
//                           width: 20,
//                           height: 20,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             valueColor: AlwaysStoppedAnimation<Color>(
//                               Colors.white,
//                             ),
//                           ),
//                         )
//                       : Text(
//                           l10n.saveFarmProfile,
//                           style: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildFarmDetailsCard(AppLocalizations l10n) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               l10n.farmDetails,
//               style: const TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//             const SizedBox(height: 20),
//             _buildTextField(
//               controller: _farmNameController,
//               label: l10n.farmName,
//               icon: Icons.agriculture,
//               validator: (value) {
//                 if (value == null || value.trim().isEmpty) {
//                   return l10n.farmNameRequired;
//                 }
//                 return null;
//               },
//             ),
//             const SizedBox(height: 16),
//             _buildTextField(
//               controller: _locationController,
//               label: l10n.location,
//               icon: Icons.location_on,
//               validator: (value) {
//                 if (value == null || value.trim().isEmpty) {
//                   return l10n.locationRequired;
//                 }
//                 return null;
//               },
//             ),
//             const SizedBox(height: 16),
//             _buildTextField(
//               controller: _sizeController,
//               label: l10n.size,
//               icon: Icons.crop_square,
//               validator: (value) {
//                 if (value == null || value.trim().isEmpty) {
//                   return l10n.sizeRequired;
//                 }
//                 return null;
//               },
//             ),
//             const SizedBox(height: 20),
//             _buildCropsSection(l10n),
//             const SizedBox(height: 20),
//             _buildLivestockSection(l10n),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildContactInfoCard(AppLocalizations l10n) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               l10n.contactInformation,
//               style: const TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//             const SizedBox(height: 20),
//             _buildTextField(
//               controller: _ownerNameController,
//               label: l10n.ownerName,
//               icon: Icons.person,
//               validator: (value) {
//                 if (value == null || value.trim().isEmpty) {
//                   return l10n.ownerNameRequired;
//                 }
//                 return null;
//               },
//             ),
//             const SizedBox(height: 16),
//             _buildTextField(
//               controller: _emailController,
//               label: l10n.email,
//               icon: Icons.email,
//               keyboardType: TextInputType.emailAddress,
//               validator: (value) {
//                 if (value == null || value.trim().isEmpty) {
//                   return l10n.validEmailRequired;
//                 }
//                 final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
//                 if (!emailRegex.hasMatch(value)) {
//                   return l10n.validEmailRequired;
//                 }
//                 return null;
//               },
//             ),
//             const SizedBox(height: 16),
//             _buildTextField(
//               controller: _phoneController,
//               label: l10n.phone,
//               icon: Icons.phone,
//               keyboardType: TextInputType.phone,
//               validator: (value) {
//                 if (value == null || value.trim().isEmpty) {
//                   return l10n.phoneRequired;
//                 }
//                 final phoneRegex = RegExp(r'^[\+]?[0-9\s\-\(\)]{10,}$');
//                 if (!phoneRegex.hasMatch(value)) {
//                   return l10n.validPhoneRequired;
//                 }
//                 return null;
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     TextInputType? keyboardType,
//     String? Function(String?)? validator,
//   }) {
//     return TextFormField(
//       controller: controller,
//       keyboardType: keyboardType,
//       validator: validator,
//       decoration: InputDecoration(
//         labelText: label,
//         prefixIcon: Icon(icon, color: Colors.green),
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: const BorderSide(color: Colors.green, width: 2),
//         ),
//       ),
//     );
//   }

//   Widget _buildCropsSection(AppLocalizations l10n) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           l10n.crops,
//           style: const TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//             color: Colors.black87,
//           ),
//         ),
//         const SizedBox(height: 12),
//         Row(
//           children: [
//             Expanded(
//               child: TextField(
//                 controller: _cropController,
//                 decoration: InputDecoration(
//                   hintText: l10n.enterCropName,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   contentPadding: const EdgeInsets.symmetric(
//                     horizontal: 12,
//                     vertical: 8,
//                   ),
//                 ),
//                 onSubmitted: (_) => _addCrop(),
//               ),
//             ),
//             const SizedBox(width: 8),
//             ElevatedButton(
//               onPressed: _addCrop,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green,
//                 foregroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               child: Text(l10n.addCrop),
//             ),
//           ],
//         ),
//         const SizedBox(height: 12),
//         if (_crops.isNotEmpty)
//           Wrap(
//             spacing: 8,
//             runSpacing: 8,
//             children: _crops.asMap().entries.map((entry) {
//               return Chip(
//                 label: Text(entry.value),
//                 backgroundColor: const Color(0xFF8B4513),
//                 labelStyle: const TextStyle(color: Colors.white),
//                 deleteIcon: const Icon(
//                   Icons.close,
//                   color: Colors.white,
//                   size: 18,
//                 ),
//                 onDeleted: () => _removeCrop(entry.key),
//               );
//             }).toList(),
//           ),
//       ],
//     );
//   }

//   Widget _buildLivestockSection(AppLocalizations l10n) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           l10n.livestock,
//           style: const TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//             color: Colors.black87,
//           ),
//         ),
//         const SizedBox(height: 12),
//         Row(
//           children: [
//             Expanded(
//               child: TextField(
//                 controller: _livestockController,
//                 decoration: InputDecoration(
//                   hintText: l10n.enterLivestockName,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   contentPadding: const EdgeInsets.symmetric(
//                     horizontal: 12,
//                     vertical: 8,
//                   ),
//                 ),
//                 onSubmitted: (_) => _addLivestock(),
//               ),
//             ),
//             const SizedBox(width: 8),
//             ElevatedButton(
//               onPressed: _addLivestock,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green,
//                 foregroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               child: Text(l10n.addLivestock),
//             ),
//           ],
//         ),
//         const SizedBox(height: 12),
//         if (_livestock.isNotEmpty)
//           Wrap(
//             spacing: 8,
//             runSpacing: 8,
//             children: _livestock.asMap().entries.map((entry) {
//               return Chip(
//                 label: Text(entry.value),
//                 backgroundColor: const Color(0xFF8B4513),
//                 labelStyle: const TextStyle(color: Colors.white),
//                 deleteIcon: const Icon(
//                   Icons.close,
//                   color: Colors.white,
//                   size: 18,
//                 ),
//                 onDeleted: () => _removeLivestock(entry.key),
//               );
//             }).toList(),
//           ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:farmers_1/l10n/app_localizations.dart';
import 'package:farmers_1/Core/Models/farm_profile.dart';
import 'package:farmers_1/Core/Services/farm_profile_service.dart';
import 'package:farmers_1/Core/Services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FarmProfileEditScreen extends StatefulWidget {
  final FarmProfile? farmProfile;

  const FarmProfileEditScreen({super.key, this.farmProfile});

  @override
  State<FarmProfileEditScreen> createState() => _FarmProfileEditScreenState();
}

class _FarmProfileEditScreenState extends State<FarmProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _farmNameController = TextEditingController();
  final _locationController = TextEditingController();
  final _sizeController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cropController = TextEditingController();
  final _livestockController = TextEditingController();

  List<String> _crops = [];
  List<String> _livestock = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.farmProfile != null) {
      _populateFields();
    } else {
      _populateUserData();
    }
  }

  void _populateFields() {
    final profile = widget.farmProfile!;
    _farmNameController.text = profile.farmName;
    _locationController.text = profile.location;
    _sizeController.text = profile.size;
    _ownerNameController.text = profile.ownerName;
    _emailController.text = profile.email;
    _phoneController.text = profile.phone;
    _crops = List.from(profile.crops);
    _livestock = List.from(profile.livestock);
  }

  Future<void> _populateUserData() async {
    try {
      final fullName = await UserService.getUserFullName();
      if (fullName != null && fullName.isNotEmpty)
        _ownerNameController.text = fullName;

      final email = await UserService.getUserEmail();
      if (email != null && email.isNotEmpty) _emailController.text = email;

      final phone = await UserService.getUserPhoneNumber();
      if (phone != null && phone.isNotEmpty) _phoneController.text = phone;
    } catch (e) {
      print('Error populating user data: $e');
    }
  }

  @override
  void dispose() {
    _farmNameController.dispose();
    _locationController.dispose();
    _sizeController.dispose();
    _ownerNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _cropController.dispose();
    _livestockController.dispose();
    super.dispose();
  }

  Future<void> _saveFarmProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final l10n = AppLocalizations.of(context)!;
      final farmProfile = FarmProfile(
        id: widget.farmProfile?.id,
        userId: FirebaseAuth.instance.currentUser?.uid ?? '',
        farmName: _farmNameController.text.trim(),
        location: _locationController.text.trim(),
        size: _sizeController.text.trim(),
        crops: _crops,
        livestock: _livestock,
        ownerName: _ownerNameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        createdAt: widget.farmProfile?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final validationError = FarmProfileService.validateFarmProfile(
        farmProfile,
      );
      if (validationError != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(validationError)));
        setState(() => _isLoading = false);
        return;
      }

      if (widget.farmProfile == null) {
        await FarmProfileService.createFarmProfile(farmProfile);
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.farmProfileCreated)));
          Navigator.of(context).pop(true);
        }
      } else {
        await FarmProfileService.updateFarmProfile(farmProfile);
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.farmProfileUpdated)));
          Navigator.of(context).pop(true);
        }
      }
    } catch (e) {
      final l10n = AppLocalizations.of(context)!;
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${l10n.farmProfileError}: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _addCrop() {
    final text = _cropController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _crops.add(text);
        _cropController.clear();
      });
    }
  }

  void _removeCrop(int index) {
    setState(() => _crops.removeAt(index));
  }

  void _addLivestock() {
    final text = _livestockController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _livestock.add(text);
        _livestockController.clear();
      });
    }
  }

  void _removeLivestock(int index) {
    setState(() => _livestock.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isEditing = widget.farmProfile != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(isEditing ? l10n.editFarmProfile : l10n.addFarmProfile),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildFarmDetailsCard(l10n),
              const SizedBox(height: 16),
              _buildContactInfoCard(l10n),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveFarmProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Text(
                          l10n.saveFarmProfile,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFarmDetailsCard(AppLocalizations l10n) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.farmDetails,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _farmNameController,
              label: l10n.farmName,
              icon: Icons.agriculture,
              validator: (v) =>
                  v == null || v.isEmpty ? l10n.farmNameRequired : null,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _locationController,
              label: l10n.location,
              icon: Icons.location_on,
              validator: (v) =>
                  v == null || v.isEmpty ? l10n.locationRequired : null,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _sizeController,
              label: l10n.size,
              icon: Icons.crop_square,
              validator: (v) =>
                  v == null || v.isEmpty ? l10n.sizeRequired : null,
            ),
            const SizedBox(height: 20),
            _buildCropsSection(l10n),
            const SizedBox(height: 20),
            _buildLivestockSection(l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfoCard(AppLocalizations l10n) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.contactInformation,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _ownerNameController,
              label: l10n.ownerName,
              icon: Icons.person,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _emailController,
              label: l10n.email,
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _phoneController,
              label: l10n.phone,
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.green),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.green, width: 2),
        ),
      ),
    );
  }

  Widget _buildCropsSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.crops,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _cropController,
                decoration: InputDecoration(
                  hintText: l10n.enterCropName,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                onSubmitted: (_) => _addCrop(),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: _addCrop,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(l10n.addCrop),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_crops.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _crops.asMap().entries.map((e) {
              return Chip(
                label: Text(e.value),
                backgroundColor: const Color(0xFF8B4513),
                labelStyle: const TextStyle(color: Colors.white),
                deleteIcon: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 18,
                ),
                onDeleted: () => _removeCrop(e.key),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildLivestockSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.livestock,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _livestockController,
                decoration: InputDecoration(
                  hintText: l10n.enterLivestockName,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                onSubmitted: (_) => _addLivestock(),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: _addLivestock,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(l10n.addLivestock),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_livestock.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _livestock.asMap().entries.map((e) {
              return Chip(
                label: Text(e.value),
                backgroundColor: const Color(0xFF8B4513),
                labelStyle: const TextStyle(color: Colors.white),
                deleteIcon: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 18,
                ),
                onDeleted: () => _removeLivestock(e.key),
              );
            }).toList(),
          ),
      ],
    );
  }
}
