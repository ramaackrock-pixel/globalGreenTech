import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/theme/app_theme.dart';
import '../admin_dashboard_screen.dart';

class JobPhoto {
  final String id;
  final String taskId;
  final String staffName;
  final String photoUrl;
  final String photoType; // 'Before Work', 'After Work', 'Defect / Damage'
  final String description;
  final String date;

  JobPhoto({
    required this.id,
    required this.taskId,
    required this.staffName,
    required this.photoUrl,
    required this.photoType,
    required this.description,
    required this.date,
  });
}

class AdminPhotosView extends ConsumerWidget {
  const AdminPhotosView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final searchQuery = ref.watch(adminSearchQueryProvider).toLowerCase();

    // High quality operational photos from Unsplash
    final List<JobPhoto> mockPhotos = [
      JobPhoto(
        id: '1',
        taskId: 'TSK-0024',
        staffName: 'Rahul Kumar',
        photoUrl: 'https://images.unsplash.com/photo-1585338107529-13afc5f02586?w=600&auto=format&fit=crop&q=60',
        photoType: 'Before Work',
        description: 'Initial status of the sediment filters before replacing. Significant clogging observed.',
        date: '24/06/2026',
      ),
      JobPhoto(
        id: '2',
        taskId: 'TSK-0024',
        staffName: 'Rahul Kumar',
        photoUrl: 'https://images.unsplash.com/photo-1618944913480-b67ee16d7b77?w=600&auto=format&fit=crop&q=60',
        photoType: 'After Work',
        description: 'New multi-stage filtration membranes installed successfully and system pressure re-calibrated.',
        date: '24/06/2026',
      ),
      JobPhoto(
        id: '3',
        taskId: 'TSK-0019',
        staffName: 'Priya Sharma',
        photoUrl: 'https://images.unsplash.com/photo-1504307651254-35680f356dfd?w=600&auto=format&fit=crop&q=60',
        photoType: 'Defect / Damage',
        description: 'Cracked outer pressure valve causing minor water leakage. Recommended immediate replacement.',
        date: '23/06/2026',
      ),
      JobPhoto(
        id: '4',
        taskId: 'TSK-0012',
        staffName: 'Amit Patel',
        photoUrl: 'https://images.unsplash.com/photo-1581094288338-2314dddb7ecc?w=600&auto=format&fit=crop&q=60',
        photoType: 'After Work',
        description: 'Industrial RO unit pre-treatment chambers checkup and chemical dosing verification completed.',
        date: '22/06/2026',
      ),
    ];

    final filteredPhotos = mockPhotos.where((p) {
      return searchQuery.isEmpty ||
          p.staffName.toLowerCase().contains(searchQuery) ||
          p.taskId.toLowerCase().contains(searchQuery) ||
          p.description.toLowerCase().contains(searchQuery);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header gallery info
        Card(
          margin: const EdgeInsets.only(bottom: 20),
          child: Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (isDark ? theme.colorScheme.primary : AppTheme.primaryColor).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.image_search_outlined,
                    color: isDark ? theme.colorScheme.primary : AppTheme.primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Job Gallery',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Review before/after work and defect photos uploaded by field technicians.',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Photo Grid
        Expanded(
          child: filteredPhotos.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image_not_supported_outlined,
                        size: 48,
                        color: isDark ? AppTheme.darkOutlineColor : AppTheme.outlineColor,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No job photos found',
                        style: TextStyle(
                          color: isDark ? AppTheme.darkOnSurfaceVariantColor : AppTheme.onSurfaceVariantColor,
                        ),
                      ),
                    ],
                  ),
                )
              : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.72,
                  ),
                  itemCount: filteredPhotos.length,
                  itemBuilder: (context, index) {
                    final photo = filteredPhotos[index];
                    return _buildPhotoCard(context, photo, isDark);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildPhotoCard(BuildContext context, JobPhoto photo, bool isDark) {
    final theme = Theme.of(context);
    final Color badgeColor = _getBadgeColor(photo.photoType);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _showFullImageDialog(context, photo),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with type badge
            Stack(
              children: [
                Image.network(
                  photo.photoUrl,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 120,
                      color: Colors.grey.withOpacity(0.2),
                      child: const Center(
                        child: Icon(Icons.broken_image_outlined, color: Colors.grey),
                      ),
                    );
                  },
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      photo.taskId,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: badgeColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      photo.photoType.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Description and uploader
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        photo.description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 11,
                          height: 1.3,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.person_outline, size: 12, color: theme.colorScheme.onSurfaceVariant),
                            const SizedBox(width: 4),
                            Text(
                              photo.staffName.split(' ')[0],
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          photo.date,
                          style: TextStyle(
                            fontSize: 10,
                            color: isDark ? AppTheme.darkOutlineColor : AppTheme.outlineColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getBadgeColor(String type) {
    switch (type) {
      case 'Before Work':
        return Colors.orange.shade700;
      case 'After Work':
        return Colors.green.shade700;
      case 'Defect / Damage':
        return Colors.red.shade700;
      default:
        return Colors.blue.shade700;
    }
  }

  void _showFullImageDialog(BuildContext context, JobPhoto photo) {
    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Photo view card
              Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Image.network(
                          photo.photoUrl,
                          width: double.infinity,
                          fit: BoxFit.contain,
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: CircleAvatar(
                            backgroundColor: Colors.black.withOpacity(0.5),
                            child: IconButton(
                              icon: const Icon(Icons.close, color: Colors.white),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                photo.taskId,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _getBadgeColor(photo.photoType),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  photo.photoType,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            photo.description,
                            style: theme.textTheme.bodyMedium,
                          ),
                          const Divider(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Uploaded by: ${photo.staffName}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                              Text(
                                photo.date,
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
