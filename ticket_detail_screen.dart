// lib/ticket_detail_screen.dart
//
// Screen that shows:
// - Title + hero image
// - Optional gallery images
// - Detailed description
// - Reviews list
// - "Buy ticket" button (fake checkout for now)

import 'package:flutter/material.dart';
import 'models.dart';

class TicketDetailScreen extends StatelessWidget {
  static const String routeName = '/ticket_detail';

  final TicketProduct product;

  const TicketDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      floatingActionButton: FloatingActionButton.extended(
        // On press we just show a fake confirmation dialog.
        onPressed: () => _showFakeCheckoutDialog(context),
        icon: const Icon(Icons.shopping_cart),
        label: Text('Buy for \$${product.price.toStringAsFixed(2)}'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main hero image.
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                product.mainImageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey.shade300,
                  child: const Center(child: Icon(Icons.image_not_supported)),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Optional gallery / thumbnails.
            if (product.galleryImages.isNotEmpty)
              SizedBox(
                height: 90,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  scrollDirection: Axis.horizontal,
                  itemCount: product.galleryImages.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final url = product.galleryImages[index];
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Image.network(
                          url,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            color: Colors.grey.shade300,
                            child: const Center(
                                child: Icon(Icons.image_not_supported,
                                    size: 16)),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + price row.
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product.title,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(color: Colors.green.shade700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Rating summary.
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        product.averageRating.toStringAsFixed(1),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 4),
                      Text('(${product.reviews.length} reviews)'),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Long description.
                  Text(
                    'About this ticket',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.longDescription,
                    textAlign: TextAlign.left,
                  ),

                  const SizedBox(height: 16),
                  Divider(color: Colors.grey.shade300),
                  const SizedBox(height: 8),

                  // Reviews section.
                  Text(
                    'Reviews',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  if (product.reviews.isEmpty)
                    const Text('No reviews yet. Be the first to review!')
                  else
                    Column(
                      children: product.reviews
                          .map((r) => _ReviewTile(review: r))
                          .toList(),
                    ),
                  const SizedBox(height: 80), // Space so FAB doesn't overlap.
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFakeCheckoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Checkout (Demo)'),
        content: Text(
            'This is where you would integrate Stripe, PayPal, or another '
            'payment provider to actually charge for "${product.title}".'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Pretend purchase complete! 🎉'),
                ),
              );
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}

// Simple widget for a single review row.
class _ReviewTile extends StatelessWidget {
  final Review review;

  const _ReviewTile({required this.review});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            review.author,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              const Icon(Icons.star, size: 16, color: Colors.amber),
              const SizedBox(width: 2),
              Text(review.rating.toStringAsFixed(1)),
            ],
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(review.comment),
          const SizedBox(height: 4),
          Text(
            review.date,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Divider(color: Colors.grey.shade300),
        ],
      ),
    );
  }
}
