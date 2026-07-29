import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus_pro/features/ratings/logic/ratings_cubit.dart';
import 'package:immoplus_pro/features/ratings/logic/ratings_state.dart';

class RatingsHistoryPage extends StatelessWidget {
  static const name = 'ratings_history_page';
  static String routePath() => '/rating/history';
  static String route() => '/rating/history';

  const RatingsHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RatingsCubit()..loadHistory(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Historique des évaluations"),
        ),
        body: BlocBuilder<RatingsCubit, RatingsState>(
          builder: (context, state) {
            return state.maybeWhen(
              loading: () => const Center(child: CircularProgressIndicator()),
              failure: (error) => Center(
                child: Text(
                  "Erreur : $error",
                  style: const TextStyle(color: Colors.red),
                ),
              ),
              historyLoaded: (ratings) {
                if (ratings.isEmpty) {
                  return const Center(
                      child: Text("Aucune évaluation trouvée."));
                }
                return ListView.builder(
                  itemCount: ratings.length,
                  itemBuilder: (context, index) {
                    final rating = ratings[index];
                    final score = rating.clientRating > 0
                        ? rating.clientRating
                        : (rating.propertyRating > 0
                            ? rating.propertyRating
                            : rating.hostRating);

                    final feedback = rating.clientFeedback.isNotEmpty
                        ? rating.clientFeedback
                        : (rating.propertyFeedback.isNotEmpty
                            ? rating.propertyFeedback
                            : rating.hostFeedback);

                    final rawDate = rating.ratedAt.isNotEmpty
                        ? rating.ratedAt
                        : rating.reservationId;
                    final dateFormatted = rawDate.contains('T')
                        ? rawDate.split('T').first
                        : rawDate;

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Row(
                          children: [
                            ...List.generate(5, (starIndex) {
                              return Icon(
                                starIndex < score
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.amber,
                                size: 16,
                              );
                            }),
                            const Spacer(),
                            if (dateFormatted.isNotEmpty)
                              Text(
                                dateFormatted,
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                feedback.isNotEmpty
                                    ? feedback
                                    : "Aucun commentaire",
                                style: TextStyle(
                                  fontStyle: feedback.isEmpty
                                      ? FontStyle.italic
                                      : FontStyle.normal,
                                ),
                              ),
                              if (rating.guestBehavior.isNotEmpty ||
                                  rating.propertyCondition.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Wrap(
                                  spacing: 6,
                                  children: [
                                    if (rating.guestBehavior.isNotEmpty)
                                      Chip(
                                        label: Text(rating.guestBehavior,
                                            style: const TextStyle(fontSize: 11)),
                                        padding: EdgeInsets.zero,
                                        visualDensity: VisualDensity.compact,
                                      ),
                                    if (rating.propertyCondition.isNotEmpty)
                                      Chip(
                                        label: Text(rating.propertyCondition,
                                            style: const TextStyle(fontSize: 11)),
                                        padding: EdgeInsets.zero,
                                        visualDensity: VisualDensity.compact,
                                      ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              orElse: () => const Center(child: Text("Chargement...")),
            );
          },
        ),
      ),
    );
  }
}
