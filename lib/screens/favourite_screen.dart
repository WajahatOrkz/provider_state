import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_state/provider/favourite_provider.dart';
import 'package:provider_state/screens/selected_favourite.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favourite Screen "),
        titleTextStyle: TextStyle(fontSize: 20, color: Colors.white),
        centerTitle: true,
        backgroundColor: Colors.black,
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SelectedFavourite()),
              );
            },
            child: Icon(Icons.favorite, color: Colors.red),
          ),
          SizedBox(width: 30),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 40,
              itemBuilder: (context, index) {
                return Card(
                  child: Consumer(
                    builder: (context, value, child) {
                      return ListTile(
                        onTap: () {
                          Provider.of<FavouriteProvider>(
                            context,
                            listen: false,
                          ).toggleItem(index);
                        },
                        title: Text("Item $index"),
                        trailing: Icon(
                          Provider.of<FavouriteProvider>(
                                context,
                              ).selectedItems.contains(index)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color:
                              Provider.of<FavouriteProvider>(
                                    context,
                                  ).selectedItems.contains(index)
                                  ? Colors.red
                                  : Colors.grey,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
