// import 'package:flutter/material.dart';
// import 'package:farmers_1/l10n/app_localizations.dart';
// import 'package:farmers_1/Core/Models/farm_profile.dart';
// import 'package:farmers_1/Core/Services/farm_profile_service.dart';
// import 'package:farmers_1/Views/Role_based_login/User/User Profile/farm_profile_edit_screen.dart';

// class FarmProfileScreen extends StatefulWidget {
//   const FarmProfileScreen({super.key});

//   @override
//   State<FarmProfileScreen> createState() => _FarmProfileScreenState();
// }

// class _FarmProfileScreenState extends State<FarmProfileScreen> {
//   FarmProfile? _farmProfile;
//   bool _isLoading = true;
//   String? _error;

//   @override
//   void initState() {
//     super.initState();
//     _loadFarmProfile();
//   }

//   Future<void> _loadFarmProfile() async {
//     try {
//       setState(() {
//         _isLoading = true;
//         _error = null;
//       });

//       final profile = await FarmProfileService.getCurrentUserFarmProfile();
//       setState(() {
//         _farmProfile = profile;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _error = e.toString();
//         _isLoading = false;
//       });
//     }
//   }

//   Future<void> _deleteFarmProfile() async {
//     if (_farmProfile?.id == null) return;

//     final l10n = AppLocalizations.of(context)!;
//     final confirmed = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(l10n.deleteFarmProfile),
//         content: Text(l10n.confirmDelete),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(false),
//             child: Text(l10n.no),
//           ),
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(true),
//             child: Text(l10n.yes),
//           ),
//         ],
//       ),
//     );

//     if (confirmed == true) {
//       try {
//         await FarmProfileService.deleteFarmProfile(_farmProfile!.id!);
//         if (mounted) {
//           ScaffoldMessenger.of(
//             context,
//           ).showSnackBar(SnackBar(content: Text(l10n.farmProfileDeleted)));
//           _loadFarmProfile();
//         }
//       } catch (e) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('${l10n.farmProfileError}: $e')),
//           );
//         }
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final l10n = AppLocalizations.of(context)!;

//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F5F5),
//       appBar: AppBar(
//         title: Text(l10n.myFarmProfile),
//         backgroundColor: Colors.green,
//         foregroundColor: Colors.white,
//         elevation: 0,
//         actions: [
//           if (_farmProfile != null) ...[
//             IconButton(
//               icon: const Icon(Icons.edit),
//               onPressed: () async {
//                 final result = await Navigator.push<bool>(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) =>
//                         FarmProfileEditScreen(farmProfile: _farmProfile),
//                   ),
//                 );
//                 if (result == true) {
//                   _loadFarmProfile();
//                 }
//               },
//             ),
//             IconButton(
//               icon: const Icon(Icons.delete),
//               onPressed: _deleteFarmProfile,
//             ),
//           ],
//         ],
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : _error != null
//           ? Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.error_outline,
//                     size: 64,
//                     color: Colors.red.shade300,
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     _error!,
//                     style: const TextStyle(color: Colors.red),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: _loadFarmProfile,
//                     child: const Text('Retry'),
//                   ),
//                 ],
//               ),
//             )
//           : _farmProfile == null
//           ? _buildEmptyState(l10n)
//           : _buildFarmProfileContent(l10n),
//       floatingActionButton: _farmProfile == null
//           ? FloatingActionButton(
//               onPressed: () async {
//                 final result = await Navigator.push<bool>(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const FarmProfileEditScreen(),
//                   ),
//                 );
//                 if (result == true) {
//                   _loadFarmProfile();
//                 }
//               },
//               backgroundColor: Colors.green,
//               child: const Icon(Icons.add, color: Colors.white),
//             )
//           : null,
//     );
//   }

//   Widget _buildEmptyState(AppLocalizations l10n) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.agriculture, size: 120, color: Colors.green.shade300),
//             const SizedBox(height: 24),
//             Text(
//               l10n.myFarmProfile,
//               style: const TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'Create your farm profile to get started',
//               style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 32),
//             ElevatedButton.icon(
//               onPressed: () async {
//                 final result = await Navigator.push<bool>(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const FarmProfileEditScreen(),
//                   ),
//                 );
//                 if (result == true) {
//                   _loadFarmProfile();
//                 }
//               },
//               icon: const Icon(Icons.add),
//               label: Text(l10n.addFarmProfile),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green,
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 24,
//                   vertical: 12,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildFarmProfileContent(AppLocalizations l10n) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           // Farm Details Card
//           _buildFarmDetailsCard(l10n),
//           const SizedBox(height: 16),
//           // Contact Information Card
//           _buildContactInfoCard(l10n),
//         ],
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
//             const SizedBox(height: 4),
//             Text(
//               _farmProfile!.farmName,
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey.shade600,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             const SizedBox(height: 20),
//             _buildInfoRow(
//               Icons.location_on,
//               l10n.location,
//               _farmProfile!.location,
//             ),
//             const SizedBox(height: 16),
//             _buildInfoRow(Icons.crop_square, l10n.size, _farmProfile!.size),
//             const SizedBox(height: 16),
//             _buildCropsSection(l10n),
//             const SizedBox(height: 16),
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
//             _buildOwnerInfo(l10n),
//             const SizedBox(height: 16),
//             _buildInfoRow(Icons.email, l10n.email, _farmProfile!.email),
//             const SizedBox(height: 16),
//             _buildInfoRow(Icons.phone, l10n.phone, _farmProfile!.phone),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoRow(IconData icon, String label, String value) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Icon(icon, color: Colors.green, size: 20),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 '$label:',
//                 style: const TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.black87,
//                 ),
//               ),
//               const SizedBox(height: 2),
//               Text(
//                 value,
//                 style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildOwnerInfo(AppLocalizations l10n) {
//     return Row(
//       children: [
//         CircleAvatar(
//           radius: 24,
//           backgroundColor: Colors.grey.shade300,
//           child: Icon(Icons.person, color: Colors.grey.shade600, size: 24),
//         ),
//         const SizedBox(width: 16),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 l10n.ownerName,
//                 style: const TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.black87,
//                 ),
//               ),
//               const SizedBox(height: 2),
//               Text(
//                 _farmProfile!.ownerName,
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.grey.shade700,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildCropsSection(AppLocalizations l10n) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Icon(Icons.eco, color: Colors.green, size: 20),
//             const SizedBox(width: 12),
//             Text(
//               '${l10n.crops}:',
//               style: const TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.black87,
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 8),
//         if (_farmProfile!.crops.isEmpty)
//           Text(
//             'No crops added',
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.grey.shade600,
//               fontStyle: FontStyle.italic,
//             ),
//           )
//         else
//           Wrap(
//             spacing: 8,
//             runSpacing: 8,
//             children: _farmProfile!.crops.map((crop) {
//               return Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 12,
//                   vertical: 6,
//                 ),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF8B4513),
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Text(
//                   crop,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 12,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
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
//         Row(
//           children: [
//             Icon(Icons.pets, color: Colors.green, size: 20),
//             const SizedBox(width: 12),
//             Text(
//               '${l10n.livestock}:',
//               style: const TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.black87,
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 8),
//         if (_farmProfile!.livestock.isEmpty)
//           Text(
//             'No livestock added',
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.grey.shade600,
//               fontStyle: FontStyle.italic,
//             ),
//           )
//         else
//           Wrap(
//             spacing: 8,
//             runSpacing: 8,
//             children: _farmProfile!.livestock.map((animal) {
//               return Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 12,
//                   vertical: 6,
//                 ),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF8B4513),
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Text(
//                   animal,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 12,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
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
import 'package:farmers_1/Views/Role_based_login/User/User Profile/farm_profile_edit_screen.dart';

class FarmProfileScreen extends StatefulWidget {
  const FarmProfileScreen({super.key});

  @override
  State<FarmProfileScreen> createState() => _FarmProfileScreenState();
}

class _FarmProfileScreenState extends State<FarmProfileScreen> {
  FarmProfile? _farmProfile;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadFarmProfile();
  }

  Future<void> _loadFarmProfile() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final profile = await FarmProfileService.getCurrentUserFarmProfile();
      setState(() {
        _farmProfile = profile;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteFarmProfile() async {
    if (_farmProfile?.id == null) return;

    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteFarmProfile),
        content: Text(l10n.confirmDelete),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.no),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.yes),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await FarmProfileService.deleteFarmProfile(_farmProfile!.id!);
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.farmProfileDeleted)));
          _loadFarmProfile();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${l10n.farmProfileError}: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(l10n.myFarmProfile),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (_farmProfile != null) ...[
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                final result = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        FarmProfileEditScreen(farmProfile: _farmProfile),
                  ),
                );
                if (result == true) {
                  _loadFarmProfile();
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteFarmProfile,
            ),
          ],
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _error!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadFarmProfile,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : _farmProfile == null
          ? _buildEmptyState(l10n)
          : _buildFarmProfileContent(l10n),
      floatingActionButton: _farmProfile == null
          ? FloatingActionButton(
              onPressed: () async {
                final result = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FarmProfileEditScreen(),
                  ),
                );
                if (result == true) {
                  _loadFarmProfile();
                }
              },
              backgroundColor: Colors.green,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.agriculture, size: 120, color: Colors.green.shade300),
            const SizedBox(height: 24),
            Text(
              l10n.myFarmProfile,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Create your farm profile to get started',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () async {
                final result = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FarmProfileEditScreen(),
                  ),
                );
                if (result == true) {
                  _loadFarmProfile();
                }
              },
              icon: const Icon(Icons.add),
              label: Text(l10n.addFarmProfile),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFarmProfileContent(AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildFarmDetailsCard(l10n),
          const SizedBox(height: 16),
          _buildContactInfoCard(l10n),
        ],
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
            const SizedBox(height: 4),
            Text(
              _farmProfile!.farmName,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            _buildInfoRow(
              Icons.location_on,
              l10n.location,
              _farmProfile!.location,
            ),
            const SizedBox(height: 16),
            _buildInfoRow(Icons.crop_square, l10n.size, _farmProfile!.size),
            const SizedBox(height: 16),
            _buildCropsSection(l10n),
            const SizedBox(height: 16),
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
            _buildOwnerInfo(l10n),
            const SizedBox(height: 16),
            _buildInfoRow(Icons.email, l10n.email, _farmProfile!.email),
            const SizedBox(height: 16),
            _buildInfoRow(Icons.phone, l10n.phone, _farmProfile!.phone),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.green, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$label:',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOwnerInfo(AppLocalizations l10n) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: Colors.grey.shade300,
          child: Icon(Icons.person, color: Colors.grey.shade600, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.ownerName,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _farmProfile!.ownerName,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCropsSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.eco, color: Colors.green, size: 20),
            const SizedBox(width: 12),
            Text(
              '${l10n.crops}:',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (_farmProfile!.crops.isEmpty)
          Text(
            'No crops added',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontStyle: FontStyle.italic,
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _farmProfile!.crops.map((crop) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B4513),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  crop,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
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
        Row(
          children: [
            Icon(Icons.pets, color: Colors.green, size: 20),
            const SizedBox(width: 12),
            Text(
              '${l10n.livestock}:',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (_farmProfile!.livestock.isEmpty)
          Text(
            'No livestock added',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontStyle: FontStyle.italic,
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _farmProfile!.livestock.map((animal) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B4513),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  animal,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}
