import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:responsi072/models/boxes.dart';
import 'package:responsi072/models/favorite.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late Map<String, dynamic> _userData = {};
  late List<Kopi> favoriteKopis = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadFavorites();
  }

  Future<void> _signOut(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('loggedInUserData');
    context.goNamed("signin");
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('loggedInUserData');
    if (userDataString != null) {
      setState(() {
        _userData = json.decode(userDataString);
      });
      _loadFavorites();
    }
  }

  Future<void> _loadFavorites() async {
    final favoriteBox = Hive.box<Favorite>(HiveBoxes.favorite);
    final favorite = favoriteBox.get(_userData['email']);
    setState(() {
      favoriteKopis = favorite?.kopiList.toList().reversed.toList() ?? [];
    });
    await favoriteBox.close(); // Tutup box setelah selesai digunakan
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favorite',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
            ),
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: favoriteKopis.isEmpty
          ? const Center(
        child: Text(
          'No favorites available',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black54,
          ),
        ),
      )
          : ListView.builder(
        itemCount: favoriteKopis.length,
        itemBuilder: (context, index) {
          final kopi = favoriteKopis[index];
          return ListTile(
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => DetailScreen(kopi: kopi),
              //   ),
              // );
            },
            title: Text(
              kopi.name ?? 'No Name',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              kopi.description ?? 'No Description',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            leading: kopi.imageUrl != null
                ? Image.network(
              kopi.imageUrl!,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            )
                : const Icon(Icons.image),
          );
        },
      ),
    );
  }
}
