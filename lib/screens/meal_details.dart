import 'package:flutter/material.dart';
import 'package:mealsapp/models/meal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mealsapp/providers/favorites_providers.dart';

class MealDetailsScreen extends ConsumerWidget {
  const MealDetailsScreen({super.key, required this.mealItem});

  final Meal mealItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteMeal = ref.watch(favoriteMealsProvider);

    final isFavorite = favoriteMeal.contains(mealItem);

    return Scaffold(
      appBar: AppBar(
        title: Text(mealItem.title),
        actions: [
          IconButton(
            onPressed: () {
              final wasAdded = ref
                  .read(favoriteMealsProvider.notifier)
                  .toggleMealsFavoriteStatus(mealItem);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      wasAdded ? 'Meal added as a favorite!' : 'Meal removed!'),
                ),
              );
            },
            icon: AnimatedSwitcher(
              duration: const Duration(microseconds: 3000),
              transitionBuilder: (child, animation) {
                return RotationTransition(
                  turns: Tween<double>(begin: 0.5, end: 1).animate(animation),
                  child: child,
                );
              },
              child: Icon(
                isFavorite ? Icons.star : Icons.star_border,
                key: ValueKey(isFavorite),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
              tag: mealItem.id,
              child: Image(
                width: double.infinity,
                fit: BoxFit.cover,
                image: NetworkImage(mealItem.imageUrl),
              ),
            ),
            const SizedBox(
              height: 14,
            ),
            Text(
              "Ingredeints",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 14,
            ),
            for (final ingredient in mealItem.ingredients)
              Text(
                ingredient,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground),
              ),
            const SizedBox(
              height: 24,
            ),
            Text(
              "Steps",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold),
            ),
            for (final step in mealItem.steps)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text(
                  step,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
