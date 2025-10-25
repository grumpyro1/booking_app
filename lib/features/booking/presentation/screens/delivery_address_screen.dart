// lib/features/booking/presentation/screens/delivery_address_screen.dart

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/button_widget.dart';

class DeliveryAddressScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic>? initialAddress;
  
  const DeliveryAddressScreen({super.key, this.initialAddress});

  @override
  ConsumerState<DeliveryAddressScreen> createState() => _DeliveryAddressScreenState();
}

class _DeliveryAddressScreenState extends ConsumerState<DeliveryAddressScreen> {
  GoogleMapController? _mapController;
  final _searchController = TextEditingController();
  final _notesController = TextEditingController();
  final _houseNumberController = TextEditingController();
  
  LatLng _currentPosition = const LatLng(14.5547, 121.0244); // Default: Makati
  bool _isLoadingLocation = false;
  String _fullAddress = '';
  String _street = '';
  String _city = '';
  String _postalCode = '';
  
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _notesController.dispose();
    _houseNumberController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _initializeLocation() async {
    if (widget.initialAddress != null) {
      // Load saved address if available
      final lat = widget.initialAddress!['latitude'] as double?;
      final lng = widget.initialAddress!['longitude'] as double?;
      if (lat != null && lng != null) {
        _currentPosition = LatLng(lat, lng);
        _fullAddress = widget.initialAddress!['fullAddress'] ?? '';
        _street = widget.initialAddress!['street'] ?? '';
        _city = widget.initialAddress!['city'] ?? '';
        _notesController.text = widget.initialAddress!['notes'] ?? '';
        _updateMarker(_currentPosition);
        return;
      }
    }
    
    // Otherwise get current location
    await _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoadingLocation = true);

    try {
      // Check permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showError('Location permission denied');
          setState(() => _isLoadingLocation = false);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showError('Location permission permanently denied');
        setState(() => _isLoadingLocation = false);
        return;
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final latLng = LatLng(position.latitude, position.longitude);
      
      setState(() {
        _currentPosition = latLng;
      });

      // Move camera and update address
      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: latLng, zoom: 16),
        ),
      );

      await _getAddressFromLatLng(latLng);
      _updateMarker(latLng);
    } catch (e) {
      _showError('Failed to get location: $e');
    } finally {
      setState(() => _isLoadingLocation = false);
    }
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        setState(() {
          _street = '${place.street ?? ''}';
          _city = '${place.locality ?? place.subAdministrativeArea ?? ''}';
          _postalCode = place.postalCode ?? '';
          _fullAddress = [
            place.street,
            place.subLocality,
            place.locality,
            place.subAdministrativeArea,
            place.postalCode,
          ].where((e) => e != null && e.isNotEmpty).join(', ');
          
          _searchController.text = _fullAddress;
        });
      }
    } catch (e) {
      print('Error getting address: $e');
    }
  }

  Future<void> _searchAddress(String query) async {
    if (query.isEmpty) return;

    setState(() => _isLoadingLocation = true);

    try {
      final locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        final location = locations.first;
        final latLng = LatLng(location.latitude, location.longitude);

        setState(() {
          _currentPosition = latLng;
        });

        _mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: latLng, zoom: 16),
          ),
        );

        await _getAddressFromLatLng(latLng);
        _updateMarker(latLng);
      } else {
        _showError('Address not found');
      }
    } catch (e) {
      _showError('Failed to search address');
    } finally {
      setState(() => _isLoadingLocation = false);
    }
  }

  void _updateMarker(LatLng position) {
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: const MarkerId('delivery_location'),
          position: position,
          draggable: true,
          onDragEnd: (newPosition) async {
            setState(() => _currentPosition = newPosition);
            await _getAddressFromLatLng(newPosition);
          },
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    });
  }

  void _onMapTap(LatLng position) async {
    setState(() {
      _currentPosition = position;
      _isLoadingLocation = true;
    });
    
    await _getAddressFromLatLng(position);
    _updateMarker(position);
    
    setState(() => _isLoadingLocation = false);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _confirmAddress() {
    if (_fullAddress.isEmpty) {
      _showError('Please select a delivery address');
      return;
    }

    final addressData = {
      'latitude': _currentPosition.latitude,
      'longitude': _currentPosition.longitude,
      'fullAddress': _fullAddress,
      'street': _street,
      'city': _city,
      'postalCode': _postalCode,
      'houseNumber': _houseNumberController.text.trim(),
      'notes': _notesController.text.trim(),
    };

    // Return address data to previous screen
    context.pop(addressData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Address'),
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentPosition,
              zoom: 16,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
              _updateMarker(_currentPosition);
            },
            markers: _markers,
            onTap: _onMapTap,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
          ),

          // Search Bar at Top
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search address...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                onSubmitted: _searchAddress,
              ),
            ),
          ),

          // Current Location Button
          Positioned(
            top: 80,
            right: 16,
            child: FloatingActionButton.small(
              onPressed: _getCurrentLocation,
              backgroundColor: Colors.white,
              child: _isLoadingLocation
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(Icons.my_location, color: AppColors.primary),
            ),
          ),

          // Address Details Bottom Sheet
          DraggableScrollableSheet(
            initialChildSize: 0.35,
            minChildSize: 0.35,
            maxChildSize: 0.7,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  children: [
                    // Drag Handle
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Address Header
                    Row(
                      children: [
                        Icon(Icons.location_on, color: AppColors.primary, size: 28),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Delivery Location',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              if (_fullAddress.isNotEmpty)
                                Text(
                                  _fullAddress,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(color: AppColors.textSecondary),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // House/Unit Number
                    TextFormField(
                      controller: _houseNumberController,
                      decoration: const InputDecoration(
                        labelText: 'House/Unit Number',
                        hintText: 'e.g., Unit 123, Building A',
                        prefixIcon: Icon(Icons.home_outlined),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Delivery Notes
                    TextFormField(
                      controller: _notesController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Delivery Instructions (Optional)',
                        hintText: 'e.g., Ring doorbell, leave at gate',
                        prefixIcon: Icon(Icons.note_outlined),
                        alignLabelWithHint: true,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Confirm Button
                    ButtonWidget(
                      label: 'Confirm Address',
                      onPressed: _confirmAddress,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}