import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:recipe/screens/recipeDetails.dart';
import 'package:recipe/widgets/support_widget.dart';
import '../models/datmodels.dart';
import 'favourites.dart';
import 'profile_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Datmodels? model;
  List<Recipes> allRecipes = [];
  List<Recipes> filteredRecipes = [];
  List<Recipes> favouriteList = [];


  String userName = "";
  String avatarUrl = "";

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
    fetchRecipes();
  }

  Future<void> fetchUserInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userName = user.displayName ?? user.email!.split('@')[0];
        avatarUrl = "https://api.dicebear.com/7.x/bottts/png?seed=${userName.replaceAll(" ", "")}";
      });
    }
  }



  Future<void> fetchRecipes() async {
    final response = await http.get(Uri.parse("https://dummyjson.com/recipes"));

    if (response.statusCode == 200) {
      var data = Datmodels.fromJson(jsonDecode(response.body));
      setState(() {
        model = data;
        allRecipes = data.recipes ?? [];
        filteredRecipes = allRecipes;
      });
    }
  }


  void searchRecipe(String text) {
    setState(() {
      filteredRecipes = allRecipes
          .where((e) => e.name!.toLowerCase().contains(text.toLowerCase()))
          .toList();
    });
  }

  void toggleFavourite(Recipes recipe) {
    setState(() {
      if (favouriteList.contains(recipe)) {
        favouriteList.remove(recipe);
      } else {
        favouriteList.add(recipe);
      }
    });
  }

  bool isFavourite(Recipes recipe) {
    return favouriteList.contains(recipe);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    FavouritesPage(favouriteList: favouriteList,
                        toggleFavourite: toggleFavourite),
              ),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) =>  ProfilePage(userName: userName,
                avatarUrl: avatarUrl,)
              ),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined, size: 35,), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border, size: 35), label: "Favourites"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline, size: 35), label: "Profile"),
        ],
      ),

      body: homeUI(),
    );
  }


  Widget homeUI() {
    return Container(
      margin: const EdgeInsets.only(top: 50, left: 20),
      child: model == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // HEADER
          Padding(
            padding: const EdgeInsets.only(right: 20.0, top: 12),
            child: Row(
              children: [
                 Text(
                  " Hello, $userName\nLooking for your favourite meal?",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(avatarUrl,
                      height: 60, width: 60, fit: BoxFit.cover),

                )
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Search
          Container(
            padding: const EdgeInsets.only(left: 10),
            margin: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 226, 226, 236),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              onChanged: searchRecipe,
              decoration: const InputDecoration(
                hintText: "Search Recipe...",
                suffixIcon: Icon(Icons.search),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // small cards
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filteredRecipes.length.clamp(0, 6),
              itemBuilder: (context, index) {
                var r = filteredRecipes[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RecipeDetails(recipe: r),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 20),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                r.image ?? "",
                                height: 150,
                                width: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              right: 8,
                              top: 8,
                              child: GestureDetector(
                                onTap: () => toggleFavourite(r),
                                child: Icon(
                                  isFavourite(r)
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isFavourite(r) ? Colors.red : Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          r.name ?? "",
                          style: Appwidget.lightfeildTextStyle(),
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 10),
          Row( mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Trending Recipes", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),)
            ],
          ),
          const SizedBox(height: 20),

          // large cards
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filteredRecipes.length,
              itemBuilder: (context, index) {
                var r = filteredRecipes[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RecipeDetails(recipe: r),
                      ),
                    );
                  },

                  child: Container(
                    margin: const EdgeInsets.only(right: 20),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                r.image ?? "",
                                height: 300,
                                width: 300,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              right: 10,
                              top: 10,
                              child: GestureDetector(
                                onTap: () => toggleFavourite(r),
                                child: Icon(
                                  isFavourite(r)
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isFavourite(r) ? Colors.red : Colors.white,
                                  size: 32,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          r.name ?? "",
                          style: Appwidget.boldfeieldTextStyle(),
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
