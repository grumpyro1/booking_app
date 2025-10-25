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
  final _searchFocusNode = FocusNode();
  
  LatLng _currentPosition = const LatLng(14.5547, 121.0244); // Default: Makati
  bool _isLoadingLocation = false;
  bool _isLoadingAddress = false;
  bool _isSearching = false;
  String _fullAddress = '';
  String _street = '';
  String _city = '';
  String _postalCode = '';
  
  final Set<Marker> _markers = {};
  List<Location> _searchResults = [];
  bool _showSearchResults = false;
  bool _hasSelectedLocation = false;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
    _searchFocusNode.addListener(_onSearchFocusChange);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _notesController.dispose();
    _houseNumberController.dispose();
    _searchFocusNode.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  void _onSearchFocusChange() {
    if (!_searchFocusNode.hasFocus) {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          setState(() => _showSearchResults = false);
        }
      });
    }
  }

  Future<void> _initializeLocation() async {
    if (widget.initialAddress != null) {
      final lat = widget.initialAddress!['latitude'] as double?;
      final lng = widget.initialAddress!['longitude'] as double?;
      if (lat != null && lng != null) {
        _currentPosition = LatLng(lat, lng);
        _fullAddress = widget.initialAddress!['fullAddress'] ?? '';
        _street = widget.initialAddress!['street'] ?? '';
        _city = widget.initialAddress!['city'] ?? '';
        _searchController.text = _fullAddress;
        _notesController.text = widget.initialAddress!['notes'] ?? '';
        _houseNumberController.text = widget.initialAddress!['houseNumber'] ?? '';
        _hasSelectedLocation = true;
        _updateMarker(_currentPosition);
        return;
      }
    }
    
    await _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoadingLocation = true);

    try {
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

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final latLng = LatLng(position.latitude, position.longitude);
      
      setState(() {
        _currentPosition = latLng;
      });

      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: latLng, zoom: 16),
        ),
      );

      // Auto-select current location
      await _selectLocation(latLng);
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
          
          if (!_searchFocusNode.hasFocus) {
            _searchController.text = _fullAddress;
          }
        });
      }
    } catch (e) {
      print('Error getting address: $e');
    }
  }

  // Long press on map to select location
  Future<void> _onMapLongPress(LatLng position) async {
    await _selectLocation(position);
  }

  // Tap on marker to re-center
  void _onMarkerTap() {
    if (_markers.isNotEmpty) {
      final marker = _markers.first;
      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: marker.position, zoom: 16),
        ),
      );
    }
  }

  Future<void> _selectLocation(LatLng position) async {
    setState(() {
      _currentPosition = position;
      _isLoadingAddress = true;
      _hasSelectedLocation = true;
    });

    _updateMarker(position);
    await _getAddressFromLatLng(position);

    setState(() => _isLoadingAddress = false);
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
            await _selectLocation(newPosition);
          },
          onTap: _onMarkerTap,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    });
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty || query.length < 3) {
      setState(() {
        _searchResults = [];
        _showSearchResults = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _showSearchResults = true;
    });

    try {
      final locations = await locationFromAddress(query);
      
      setState(() {
        _searchResults = locations;
        _isSearching = false;
      });
    } catch (e) {
      print('Search error: $e');
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
    }
  }

  Future<void> _selectSearchResult(Location location) async {
    final latLng = LatLng(location.latitude, location.longitude);

    setState(() {
      _showSearchResults = false;
    });

    _searchFocusNode.unfocus();

    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: 16),
      ),
    );

    await _selectLocation(latLng);
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
    if (_fullAddress.isEmpty || !_hasSelectedLocation) {
      _showError('Please select a delivery address by tapping on the map');
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
              if (widget.initialAddress != null) {
                _updateMarker(_currentPosition);
              }
            },
            markers: _markers,
            onTap: (position) async {
              // Single tap also works
              await _selectLocation(position);
            },
            onLongPress: _onMapLongPress,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
          ),

          // Instruction Banner (if no location selected)
          if (!_hasSelectedLocation)
            Positioned(
              bottom: 450,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.touch_app,
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Tap anywhere on the map to pin your delivery location',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Loading Indicator
          if (_isLoadingAddress)
            Positioned(
              top: _showSearchResults ? 320 : 80,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Getting address...',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Search Bar with Results
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Column(
              children: [
                // Search Input
                Container(
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
                    focusNode: _searchFocusNode,
                    decoration: InputDecoration(
                      hintText: 'Search address (e.g., Abreeza Mall)',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchResults = [];
                                  _showSearchResults = false;
                                });
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                    onChanged: (value) {
                      _performSearch(value);
                    },
                  ),
                ),

                // Search Results Dropdown
                if (_showSearchResults)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    constraints: const BoxConstraints(maxHeight: 300),
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
                    child: _isSearching
                        ? const Padding(
                            padding: EdgeInsets.all(20),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : _searchResults.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(20),
                                child: Center(
                                  child: Text(
                                    'No results found',
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              )
                            : ListView.separated(
                                shrinkWrap: true,
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                itemCount: _searchResults.length,
                                separatorBuilder: (context, index) => const Divider(height: 1),
                                itemBuilder: (context, index) {
                                  final location = _searchResults[index];
                                  return ListTile(
                                    leading: Icon(
                                      Icons.location_on,
                                      color: AppColors.primary,
                                    ),
                                    title: FutureBuilder<List<Placemark>>(
                                      future: placemarkFromCoordinates(
                                        location.latitude,
                                        location.longitude,
                                      ),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                                          final place = snapshot.data!.first;
                                          final address = [
                                            place.name,
                                            place.locality,
                                            place.subAdministrativeArea,
                                          ].where((e) => e != null && e.isNotEmpty).join(', ');
                                          
                                          return Text(
                                            address,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          );
                                        }
                                        return Text(
                                          '${location.latitude.toStringAsFixed(4)}, ${location.longitude.toStringAsFixed(4)}',
                                          style: TextStyle(
                                            color: AppColors.textSecondary,
                                          ),
                                        );
                                      },
                                    ),
                                    onTap: () => _selectSearchResult(location),
                                  );
                                },
                              ),
                  ),
              ],
            ),
          ),

          // Current Location Button
          Positioned(
            top: _showSearchResults ? 320 : 80,
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
                              if (_fullAddress.isEmpty && !_isLoadingAddress)
                                Text(
                                  'Tap on map to select location',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: AppColors.textSecondary,
                                        fontStyle: FontStyle.italic,
                                      ),
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