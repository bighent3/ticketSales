// lib/models.dart
//
// This file defines the core data models used in the app.
// In a real project these would typically be backed by a database / API,
// but here we'll keep them as simple Dart classes.

// Represents a customer review for a ticket/product.
class Review {
  // Name or handle of the reviewer.
  final String author;

  // Rating value (e.g., 1–5 stars).
  final double rating;

  // Free-text review content.
  final String comment;

  // Optional date string (ISO, "2025-01-01", etc.) for display.
  final String date;

  Review({
    required this.author,
    required this.rating,
    required this.comment,
    required this.date,
  });
}

// Represents a ticket / product that can be purchased.
class TicketProduct {
  // Unique identifier for the ticket.
  final String id;

  // Human-readable title, e.g., "Sunset Boat Tour".
  final String title;

  // Short description displayed in the card / list.
  final String shortDescription;

  // Detailed description shown on the detail page.
  final String longDescription;

  // Base price of a single ticket.
  final double price;

  // URL or asset path for main image.
  final String mainImageUrl;

  // Optional additional images for a small carousel/gallery on the detail page.
  final List<String> galleryImages;

  // Average rating (computed from reviews in a real system).
  final double averageRating;

  // List of user reviews.
  final List<Review> reviews;

  TicketProduct({
    required this.id,
    required this.title,
    required this.shortDescription,
    required this.longDescription,
    required this.price,
    required this.mainImageUrl,
    this.galleryImages = const [],
    this.averageRating = 0,
    this.reviews = const [],
  });
}
