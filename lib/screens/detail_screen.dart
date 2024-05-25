import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:responsi072/models/favorite.dart';
import 'package:responsi072/models/kopi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailScreen extends StatefulWidget {
  final JenisKopi kopi;

  const DetailScreen({Key? key, required this.kopi}) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late bool isFavorite = false;
  late Map<String, dynamic> _userData = {};

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _checkIfFavorite();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('loggedInUserData');
    if (userDataString != null) {
      setState(() {
        _userData = json.decode(userDataString);
      });
    }
  }

  Future<void> _checkIfFavorite() async {
    final favoriteBox = await Hive.openBox<Favorite>('favoriteBox');
    final favorite = favoriteBox.get(_userData['email']);
    setState(() {
      isFavorite = favorite?.kopiList.any((kopi) => kopi.id == widget.kopi.id) ?? false;
    });
  }

  Future<void> _toggleFavorite() async {
    final favoriteBox = await Hive.openBox<Favorite>('favoriteBok');
    setState(() {
      isFavorite = !isFavorite;
    });

    Favorite? favorite = favoriteBox.get(_userData['email']);
    if (isFavorite) {
      if (favorite == null) {
        favorite = Favorite(email: _userData['email'], kopiList: [convertJenisKopi(widget.kopi)]);
        favoriteBox.put(_userData['email'], favorite);
      } else {
        favorite.kopiList.add(convertJenisKopi(widget.kopi));
        favorite.save();
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Added to favorites'),
        ),
      );
    } else {
      if (favorite != null) {
        favorite.kopiList.removeWhere((kopi) => kopi.id == widget.kopi.id);
        favorite.save();
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Removed from favorites'),
        ),
      );
    }
  }

  Kopi convertJenisKopi(JenisKopi kopi) {
    return Kopi(
      id: kopi.id ?? 0,
      name: kopi.name ?? '',
      description: kopi.description ?? '',
      price: kopi.price ?? 0.0,
      region: kopi.region ?? '',
      weight: kopi.weight ?? 0,
      flavorProfile: kopi.flavorProfile ?? [],
      grindOption: kopi.grindOption ?? [],
      roastLevel: kopi.roastLevel ?? 0,
      imageUrl: kopi.imageUrl ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.kopi.name ?? 'Coffee Detail',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _toggleFavorite,
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: const Offset(0, 2),
                  ),
                ],
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    widget.kopi.imageUrl ?? '',
                    width: 200,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.kopi.name ?? 'No Name',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.kopi.description ?? 'No Description Available',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.kopi.price != null ? '\$${widget.kopi.price!.toStringAsFixed(2)}' : 'No Price',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.kopi.region ?? 'No Region',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Flavor Profile',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.kopi.flavorProfile?.map((flavor) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  '- $flavor',
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              )).toList() ?? [Text('No Flavor Profile Available')],
            ),
            const SizedBox(height: 20),
            const Text(
              'Grind Options',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.kopi.grindOption?.map((option) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  '- $option',
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              )).toList() ?? [Text('No Grind Options Available')],
            ),
            const SizedBox(height: 20),
            const Text(
              'Roast Level',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.kopi.roastLevel?.toString() ?? 'No Roast Level Available',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (widget.kopi.imageUrl != null) {
            _launchURL(widget.kopi.imageUrl!);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('No URL Available'),
              ),
            );
          }
        },
        tooltip: 'Open Image in Browser',
        child: const Icon(Icons.search),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
