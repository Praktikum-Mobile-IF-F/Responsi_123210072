import 'package:flutter/material.dart';
import 'package:responsi072/models/kopi.dart';
import 'package:go_router/go_router.dart';
import 'package:responsi072/screens/detail_screen.dart';
import 'package:responsi072/services/kopi_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<JenisKopi>?> _kopiFuture;
  List<JenisKopi> _filteredKopis = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _kopiFuture = KopiService().fetchKopi();
  }

  Future<void> _signOut(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('loggedInUserData');
    context.goNamed("signin");
  }

  void _filterKopiList(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredKopis = [];
      } else {
        _kopiFuture.then((kopiList) {
          if (kopiList != null) {
            setState(() {
              _filteredKopis = kopiList
                  .where((kopi) =>
              kopi.name?.toLowerCase().contains(query.toLowerCase()) ?? false)
                  .toList();
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterKopiList,
              decoration: InputDecoration(
                labelText: 'Search',
                hintText: 'Search for coffee...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<JenisKopi>?>(
              future: _kopiFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return Center(child: Text('No data found'));
                } else {
                  final List<JenisKopi> kopis =
                  _filteredKopis.isEmpty ? snapshot.data! : _filteredKopis;
                  return ListView.builder(
                    itemCount: kopis.length,
                    itemBuilder: (context, index) {
                      final kopi = kopis[index];
                      return ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(kopi: kopi),
                            ),
                          );
                        },
                        title: Text(
                          kopi.name ?? 'No Name',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
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
                            : Icon(Icons.image),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
