import 'package:booking_app/features/home/presentation/screens/orig_home_screen.dart';
import 'package:booking_app/features/service/presentation/screens/service_detail_screen.dart';
import 'package:booking_app/shared/widgets/favorite_button.dart';
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

class ServiceCardWidget extends StatelessWidget {
  final Service service;

  const ServiceCardWidget({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ServiceDetailScreen(service: service),
          ),
        ),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.image, size: 40, color: Colors.grey[400]),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(service.name,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(service.provider,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star,
                            size: 16, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(service.rating.toString(),
                            style: Theme.of(context).textTheme.bodySmall),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(service.category,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                      color: AppColors.primary, fontSize: 10)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('Rp ${service.price.toStringAsFixed(0)}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.primary,fontWeight: FontWeight.bold)
                    ),
                  ],
                ),
              ),
              FavoriteButton(
                serviceId: service.id,
                serviceName: service.name,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
