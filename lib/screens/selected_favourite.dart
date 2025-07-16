import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_state/provider/favourite_provider.dart';
import 'package:provider_state/screens/favourite_screen.dart';

class SelectedFavourite extends StatefulWidget {
  const SelectedFavourite({super.key});

  @override
  State<SelectedFavourite> createState() => _SelectedFavouriteState();
}

class _SelectedFavouriteState extends State<SelectedFavourite> {
  @override
  Widget build(BuildContext context) {
    final selectedFavourite = Provider.of<FavouriteProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(
              context,
              MaterialPageRoute(builder: (context) => FavouriteScreen()),
            );
          },
          child: Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text("Selected Favourite Screen "),
        titleTextStyle: TextStyle(fontSize: 20, color: Colors.white),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: selectedFavourite.selectedItems.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Consumer(
                    builder: (context, value, child) {
                      return ListTile(
                        onTap: () {
                          selectedFavourite.toggleItem(
                            selectedFavourite.selectedItems[index],
                          );
                        },
                        title: Text(
                          "Item${selectedFavourite.selectedItems[index]}",
                        ),
                        trailing: Icon(Icons.favorite, color: Colors.red),
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
