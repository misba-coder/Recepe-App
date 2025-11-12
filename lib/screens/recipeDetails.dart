import 'package:flutter/material.dart';
import 'package:recipe/models/datmodels.dart';
import 'package:recipe/widgets/support_widget.dart';

class RecipeDetails extends StatelessWidget {
  final Recipes recipe;

  const RecipeDetails({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Top right corner Image
          Image.network(
            recipe.image ?? "",
            height: 400,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),

          // Details Card
          Container(
            padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.width / 1.1,
            ),
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),

            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Title
                  Text(
                    recipe.name ?? "",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                    ),
                  ),

                  const Divider(),
                  const SizedBox(height: 10),

                  // Cuisine & Rating
                  Text(
                    "Cuisine: ${recipe.cuisine}",
                    style: Appwidget.boldfeieldTextStyle(),
                  ),
                  const SizedBox(height: 5),

                  Text(
                    "Rating: ${recipe.rating} ⭐ (${recipe.reviewCount} reviews)",
                    style: Appwidget.lightfeildTextStyle(),
                  ),

                  const SizedBox(height: 20),

                  // Ingredients Title
                  Text(
                    "Ingredients",
                    style: Appwidget.boldfeieldTextStyle(),
                  ),
                  const SizedBox(height: 10),

                  // Ingredients List
                  ...List.generate(
                    recipe.ingredients!.length,
                        (index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Text(
                        "• ${recipe.ingredients![index]}",
                        style: Appwidget.lightfeildTextStyle(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Instructions Title
                  Text(
                    "Instructions",
                    style: Appwidget.boldfeieldTextStyle(),
                  ),
                  const SizedBox(height: 10),

                  // Instructions List
                  ...List.generate(
                    recipe.instructions!.length,
                        (index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        "${index + 1}. ${recipe.instructions![index]}",
                        style: Appwidget.lightfeildTextStyle(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
            // Back Button


          ),



        ],
      ),
    );
  }
}
