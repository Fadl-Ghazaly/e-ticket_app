import 'package:equatable/equatable.dart';

class Ticket extends Equatable {
  final String id;
  final String title;
  final String description;
  final double price;
  final DateTime date;
  final String imageUrl;

  // Constructor HARUS di dalam class
  const Ticket({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.date,
    required this.imageUrl,
    

  });

  // Factory method dari JSON
  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      date: DateTime.parse(json['date']),
      imageUrl: json['imageUrl'],
    );
  }

  // Method to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'date': date.toIso8601String(),
      'imageUrl': imageUrl,
    };
  }

  // Props untuk Equatable
  @override
  List<Object?> get props => [id, title, description, price, date, imageUrl];
}