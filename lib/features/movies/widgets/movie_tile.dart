import 'package:flutter/material.dart';

import '../../../data/models/movie.dart';

class MovieTile extends StatelessWidget {
  const MovieTile({super.key, required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(movie.title),
      subtitle: Text(movie.overview, maxLines: 2, overflow: TextOverflow.ellipsis),
      trailing: Text(movie.rating.toStringAsFixed(1)),
    );
  }
}
