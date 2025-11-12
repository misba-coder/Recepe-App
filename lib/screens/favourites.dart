import 'package:flutter/material.dart';
import '../models/datmodels.dart';
import 'package:fluttertoast/fluttertoast.dart';


class FavouritesPage extends StatefulWidget {
  final List<Recipes> favouriteList;
  final Function(Recipes) toggleFavourite;

  const FavouritesPage({
    super.key,
    required this.favouriteList,
    required this.toggleFavourite,
  });

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favourite Recipes"),
        backgroundColor: Color(0xFFf77f00),
        centerTitle: true,
      ),

      body: widget.favouriteList.isEmpty
          ? const Center(
        child: Text("No favourites added yet"),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: widget.favouriteList.length,
        itemBuilder: (context, index) {
          var r = widget.favouriteList[index];

          return Container(
            height: 120,
            child: Card(
              elevation: 5,
              margin: const EdgeInsets.only(bottom: 15, top: 16),
              child: ListTile(
                contentPadding: const EdgeInsets.all(10),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    r.image ?? "",
                    height: 60,
                    width: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(r.name ?? "", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),),
                trailing: GestureDetector(
                  onTap: () {
                    setState(() {

                    });
                    widget.toggleFavourite(r);
                  Fluttertoast.showToast(
                    msg: "${r.name} removed from favourites",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.black87,
                    textColor: Colors.white,
                    fontSize: 14,
                  ); },

                  child: const Icon(Icons.favorite, color: Colors.red),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
