import 'package:booking_app/features/booking/data/provider/saved_address_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/saved_address_model.dart';
import '../../../auth/data/provider/auth_provider.dart';

class ManageAddressesScreen extends ConsumerStatefulWidget {
  const ManageAddressesScreen({super.key});

  @override
  ConsumerState<ManageAddressesScreen> createState() => _ManageAddressesScreenState();
}

class _ManageAddressesScreenState extends ConsumerState<ManageAddressesScreen> {
  Future<void> _addNewAddress() async {
    // Navigate to delivery address screen in ADD mode
    final result = await context.push<Map<String, dynamic>>(
      '/delivery-address',
      extra: {
        'address': null,
        'isEditMode': false,
        'addressId': null,
      },
    );
    
    if (result != null && mounted) {
      await _showSaveAddressDialog(result);
    }
  }

  Future<void> _showSaveAddressDialog(Map<String, dynamic> addressData) async {
    final user = ref.read(authProvider).user;
    if (user == null) {
      _showError('User not found');
      return;
    }

    // Check if address already exists
    final addressExists = ref.read(savedAddressProvider.notifier).addressExists(
          addressData['latitude'] as double,
          addressData['longitude'] as double,
        );

    if (addressExists) {
      _showError('This address is already saved');
      return;
    }

    AddressType? selectedType = AddressType.home;
    final labelController = TextEditingController();
    bool setAsDefault = false;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Save Address'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  addressData['fullAddress'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Address Type'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: AddressType.values.map((type) {
                    final labels = {
                      AddressType.home: 'Home 🏠',
                      AddressType.work: 'Work 💼',
                      AddressType.other: 'Other 📍',
                    };
                    return ChoiceChip(
                      label: Text(labels[type]!),
                      selected: selectedType == type,
                      onSelected: (selected) {
                        setDialogState(() => selectedType = type);
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: labelController,
                  decoration: InputDecoration(
                    labelText: 'Label (optional)',
                    hintText: selectedType == AddressType.home
                        ? 'Home'
                        : selectedType == AddressType.work
                            ? 'Work'
                            : 'My Address',
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Set as default address'),
                  value: setAsDefault,
                  onChanged: (value) {
                    setDialogState(() => setAsDefault = value ?? false);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );

    if (confirmed == true) {
      String label = labelController.text.trim();
      if (label.isEmpty) {
        label = selectedType == AddressType.home
            ? 'Home'
            : selectedType == AddressType.work
                ? 'Work'
                : 'My Address';
      }

      await ref.read(savedAddressProvider.notifier).saveAddress(
            userId: user.id,
            type: selectedType!,
            label: label,
            latitude: addressData['latitude'] as double,
            longitude: addressData['longitude'] as double,
            fullAddress: addressData['fullAddress'] as String,
            street: addressData['street'] as String,
            city: addressData['city'] as String,
            postalCode: addressData['postalCode'] as String? ?? '',
            houseNumber: addressData['houseNumber'] as String? ?? '',
            notes: addressData['notes'] as String?,
            setAsDefault: setAsDefault,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Address saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final savedAddresses = ref.watch(savedAddressProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Addresses'),
        elevation: 0,
      ),
      body: savedAddresses.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: savedAddresses.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final address = savedAddresses[index];
                return _AddressCard(
                  address: address,
                  onTap: () => _showAddressOptions(address),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNewAddress,
        icon: const Icon(Icons.add_location_alt),
        label: const Text('Add Address'),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bookmark_border,
              size: 80,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            Text(
              'No Saved Addresses',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              'Save your frequently used addresses for quick booking',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _addNewAddress,
              icon: const Icon(Icons.add),
              label: const Text('Add Your First Address'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddressOptions(SavedAddressModel address) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.star, color: AppColors.primary),
              title: const Text('Set as Default'),
              enabled: !address.isDefault,
              onTap: () async {
                Navigator.pop(context);
                await ref.read(savedAddressProvider.notifier).setDefaultAddress(address.id);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Default address updated'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.edit, color: AppColors.primary),
              title: const Text('Edit Address'),
              onTap: () {
                Navigator.pop(context);
                _editAddress(address);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete Address'),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation(address);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _editAddress(SavedAddressModel address) async {
    print('Editing address: ${address.label}');
    print('Current address data: ${address.toDeliveryAddress()}');
    
    // Navigate to edit screen with address data and EDIT MODE flag
    final result = await context.push<Map<String, dynamic>>(
      '/delivery-address',
      extra: {
        'address': address.toDeliveryAddress(),
        'isEditMode': true,
        'addressId': address.id,
      },
    );
    
    print('Edit result: $result');
    
    // If user confirmed changes, update the address
    if (result != null && mounted) {
      final updatedAddress = address.copyWith(
        latitude: result['latitude'] as double,
        longitude: result['longitude'] as double,
        fullAddress: result['fullAddress'] as String,
        street: result['street'] as String,
        city: result['city'] as String,
        postalCode: result['postalCode'] as String? ?? address.postalCode,
        houseNumber: result['houseNumber'] as String? ?? '',
        notes: result['notes'] as String?,
      );
      
      print('Updating address to: ${updatedAddress.toDeliveryAddress()}');
      
      await ref.read(savedAddressProvider.notifier).updateAddress(
        address.id,
        updatedAddress,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Address updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      print('No result returned or widget not mounted');
    }
  }

  void _showDeleteConfirmation(SavedAddressModel address) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Address'),
        content: Text('Are you sure you want to delete "${address.label}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(savedAddressProvider.notifier).deleteAddress(address.id);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Address deleted'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  final SavedAddressModel address;
  final VoidCallback onTap;

  const _AddressCard({
    required this.address,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: address.isDefault
            ? BorderSide(color: AppColors.primary, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: Text(
                  address.icon,
                  style: const TextStyle(fontSize: 28),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          address.label,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (address.isDefault) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Default',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    if (address.houseNumber.isNotEmpty) ...[
                      Text(
                        address.houseNumber,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 2),
                    ],
                    Text(
                      address.fullAddress,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (address.notes != null && address.notes!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 14,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                address.notes!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                  fontStyle: FontStyle.italic,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(Icons.more_vert),
            ],
          ),
        ),
      ),
    );
  }
}