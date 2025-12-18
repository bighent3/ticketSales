// lib/ticket_service.dart
//
// This file simulates a backend / API layer.
// In production you would replace the hard-coded lists with network calls
// to Firebase, REST APIs, GraphQL, etc.

import 'models.dart';

class TicketService {
  // Singleton pattern for convenience.
  TicketService._internal();
  static final TicketService instance = TicketService._internal();

  // Fake data: normally these would be loaded from a backend.
  final List<TicketProduct> _products = [
    TicketProduct(
      id: 'sunset_cruise',
      title: 'Seattle Sunset Cruise',
      shortDescription: '90-minute evening boat tour with skyline views.',
      longDescription:
          'Enjoy a relaxing 90-minute cruise around the harbor as the sun sets '
          'over the Seattle skyline. Includes complimentary soft drinks and '
          'onboard commentary from a local guide.',
      price: 79.99,
      mainImageUrl:
          'https://images.pexels.com/photos/460680/pexels-photo-460680.jpeg',
      galleryImages: [
        'https://images.pexels.com/photos/247477/pexels-photo-247477.jpeg',
        'https://images.pexels.com/photos/799443/pexels-photo-799443.jpeg',
      ],
      averageRating: 4.7,
      reviews: [
        Review(
          author: 'Alex',
          rating: 5,
          comment: 'Incredible views and super friendly crew!',
          date: '2025-03-10',
        ),
        Review(
          author: 'Jamie',
          rating: 4.5,
          comment: 'Loved it, but wish it was a bit longer.',
          date: '2025-03-02',
        ),
      ],
    ),
    TicketProduct(
      id: 'museum_pass',
      title: 'City Museum Day Pass',
      shortDescription: 'All-day access to three downtown museums.',
      longDescription:
          'Explore art, history, and science with a single day pass granting '
          'entry to the Art Museum, History Museum, and Science Center. Perfect '
          'for families and curious travelers.',
      price: 49.50,
      mainImageUrl:
          'https://images.pexels.com/photos/247502/pexels-photo-247502.jpeg',
      galleryImages: [],
      averageRating: 4.2,
      reviews: [
        Review(
          author: 'Taylor',
          rating: 4,
          comment: 'Great value for a rainy day in the city.',
          date: '2025-02-15',
        ),
      ],
    ),
  ];

  // Simulated "network delay" to feel realistic.
  Future<List<TicketProduct>> fetchProducts() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _products;
  }

  Future<TicketProduct?> fetchProductById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}
