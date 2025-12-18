// lib/main.dart
//
// Entry point of the Flutter application.
// Defines routes and wires together the home & detail screens.

import 'package:flutter/material.dart';
import 'models.dart';
import 'ticket_service.dart';
import 'ticket_detail_screen.dart';

void main() {
  runApp(const TicketStoreApp());
}

class TicketStoreApp extends StatelessWidget {
  const TicketStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ticket Store',
      // Basic app-wide theme. You can customize fonts, colors, etc.
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      // Named routes for easier navigation.
      onGenerateRoute: (settings) {
        if (settings.name == TicketDetailScreen.routeName) {
          // Expecting a TicketProduct as arguments.
          final product = settings.arguments as TicketProduct;
          return MaterialPageRoute(
            builder: (_) => TicketDetailScreen(product: product),
          );
        }
        return null;
      },
    );
  }
}

// ---------------- HOME SCREEN ----------------

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Hold the future for products so it only loads once.
  late Future<List<TicketProduct>> _productsFuture;

  @override
  void initState() {
    super.initState();
    // Trigger fake API call.
    _productsFuture = TicketService.instance.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket Store'),
      ),
      body: FutureBuilder<List<TicketProduct>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          // Loading state.
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error state.
          if (snapshot.hasError) {
            return Center(
              child: Text('Error loading tickets: ${snapshot.error}'),
            );
          }

          final products = snapshot.data ?? [];

          // Empty state.
          if (products.isEmpty) {
            return const Center(child: Text('No tickets available.'));
          }

          // Main content: list of ticket cards.
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return TicketCard(product: product);
            },
          );
        },
      ),
    );
  }
}

// A card widget representing a single ticket in the list.
class TicketCard extends StatelessWidget {
  final TicketProduct product;

  const TicketCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias, // ensures image corners are rounded
      child: InkWell(
        // Tapping the card navigates to the detail screen.
        onTap: () {
          Navigator.pushNamed(
            context,
            TicketDetailScreen.routeName,
            arguments: product,
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top image area. Uses NetworkImage for remote URLs.
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                product.mainImageUrl,
                fit: BoxFit.cover,
                // You may want caching package in a real app.
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey.shade300,
                  child: const Center(child: Icon(Icons.image_not_supported)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title row with rating.
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product.title,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 18),
                          const SizedBox(width: 4),
                          Text(product.averageRating.toStringAsFixed(1)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.shortDescription,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: Colors.green.shade700),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
