import 'package:booking_app/features/service/presentation/screens/service_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../home/presentation/screens/orig_home_screen.dart';
import '../../data/providers/search_provider.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Auto-focus search field when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredServices = ref.watch(filteredServicesProvider);
    final selectedCategory = ref.watch(selectedCategoryFilterProvider);
    final sortOption = ref.watch(sortOptionProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          decoration: InputDecoration(
            hintText: 'Search services...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey[400]),
          ),
          onChanged: (value) {
            ref.read(searchQueryProvider.notifier).state = value;
          },
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                ref.read(searchQueryProvider.notifier).state = '';
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // Filters Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // Category Filter
                  _buildFilterChip(
                    icon: Icons.category,
                    label: selectedCategory ?? 'Category',
                    isActive: selectedCategory != null,
                    onTap: () => _showCategoryFilter(context),
                  ),
                  const SizedBox(width: 8),
                  // Price Filter
                  _buildFilterChip(
                    icon: Icons.attach_money,
                    label: 'Price',
                    isActive: false,
                    onTap: () => _showPriceFilter(context),
                  ),
                  const SizedBox(width: 8),
                  // Sort Filter
                  _buildFilterChip(
                    icon: Icons.sort,
                    label: _getSortLabel(sortOption),
                    isActive: sortOption != 'recommended',
                    onTap: () => _showSortOptions(context),
                  ),
                  const SizedBox(width: 8),
                  // Clear Filters
                  if (selectedCategory != null || sortOption != 'recommended')
                    TextButton(
                      onPressed: () {
                        ref.read(selectedCategoryFilterProvider.notifier).state = null;
                        ref.read(sortOptionProvider.notifier).state = 'recommended';
                        ref.read(priceRangeProvider.notifier).state = const RangeValues(0, 500000);
                      },
                      child: const Text('Clear All'),
                    ),
                ],
              ),
            ),
          ),
          const Divider(height: 1),
          // Results
          Expanded(
            child: filteredServices.isEmpty
                ? _buildEmptyState(context)
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredServices.length,
                    itemBuilder: (context, index) {
                      return _buildServiceCard(context, filteredServices[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? AppColors.primary : Colors.grey[300]!,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isActive ? Colors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : AppColors.textPrimary,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, Service service) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ServiceDetailScreen(service: service),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Service Image
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.image,
                  size: 40,
                  color: Colors.grey[400],
                ),
              ),
              const SizedBox(width: 12),
              // Service Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      service.provider,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 16,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          service.rating.toString(),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            service.category,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.primary,
                                  fontSize: 10,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Rp ${service.price.toStringAsFixed(0)}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
              // Favorite Button
              IconButton(
                icon: const Icon(Icons.favorite_border),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Added to favorites')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 100,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No services found',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters or search query',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textHint,
                ),
          ),
        ],
      ),
    );
  }

  String _getSortLabel(String sortOption) {
    switch (sortOption) {
      case 'price_low':
        return 'Price: Low to High';
      case 'price_high':
        return 'Price: High to Low';
      case 'rating':
        return 'Rating';
      case 'name':
        return 'Name';
      case 'recommended':
      default:
        return 'Sort';
    }
  }

  void _showCategoryFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Category',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            ...categories.map((category) {
              final isSelected = ref.read(selectedCategoryFilterProvider) == category['name'];
              return ListTile(
                leading: Icon(category['icon']),
                title: Text(category['name']),
                trailing: isSelected ? const Icon(Icons.check, color: AppColors.primary) : null,
                onTap: () {
                  ref.read(selectedCategoryFilterProvider.notifier).state = category['name'];
                  Navigator.pop(context);
                },
              );
            }).toList(),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  ref.read(selectedCategoryFilterProvider.notifier).state = null;
                  Navigator.pop(context);
                },
                child: const Text('Clear Filter'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPriceFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          final priceRange = ref.watch(priceRangeProvider);
          return Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Price Range',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Rp ${priceRange.start.toInt()}'),
                    Text('Rp ${priceRange.end.toInt()}'),
                  ],
                ),
                RangeSlider(
                  values: priceRange,
                  min: 0,
                  max: 500000,
                  divisions: 50,
                  activeColor: AppColors.primary,
                  onChanged: (values) {
                    setState(() {
                      ref.read(priceRangeProvider.notifier).state = values;
                    });
                  },
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sort By',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            _buildSortOption(context, 'Recommended', 'recommended'),
            _buildSortOption(context, 'Price: Low to High', 'price_low'),
            _buildSortOption(context, 'Price: High to Low', 'price_high'),
            _buildSortOption(context, 'Rating', 'rating'),
            _buildSortOption(context, 'Name', 'name'),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(BuildContext context, String label, String value) {
    final currentSort = ref.watch(sortOptionProvider);
    final isSelected = currentSort == value;

    return ListTile(
      title: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? AppColors.primary : null,
        ),
      ),
      trailing: isSelected ? const Icon(Icons.check, color: AppColors.primary) : null,
      onTap: () {
        ref.read(sortOptionProvider.notifier).state = value;
        Navigator.pop(context);
      },
    );
  }
}