import 'package:cat_breeds_app/core/di/injection_container.dart';
import 'package:cat_breeds_app/core/theme/build_context_theme_ext.dart';
import 'package:cat_breeds_app/features/cats/domain/cat.dart';
import 'package:cat_breeds_app/features/cats/presentation/cat_detail/bloc/cat_detail_bloc.dart';
import 'package:cat_breeds_app/shared/widgets/custom_app_bar.dart';
import 'package:cat_breeds_app/shared/widgets/custom_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CatDetailPage extends StatelessWidget {
  const CatDetailPage({super.key, required this.id});

  static const routeName = '/cats/:id';
  static const routePath = '/cats/:id';

  final String id;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<CatDetailBloc>()..add(CatDetailEvent.initialize(id: id)),
      child: BlocBuilder<CatDetailBloc, CatDetailState>(
        builder: (context, state) {
          final String title =
              state.mapOrNull(loaded: (state) => state.cat.nameBreed) ??
              'CatDetail';
          return Scaffold(
            appBar: CustomAppBar(title: title),
            body: BlocBuilder<CatDetailBloc, CatDetailState>(
              builder: (context, state) {
                return state.map(
                  loading: (_) => _CatInfoSkeleton(),
                  loaded: (state) =>
                      _CatInfo(key: const Key('cat-info'), cat: state.cat),
                  error: (_) => Text('Error loading cat'),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _CatInfo extends StatelessWidget {
  const _CatInfo({super.key, required this.cat});

  final Cat cat;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: CustomNetworkImage(
              url: cat.image?.url ?? '',
              width: cat.image?.width,
              height: cat.image?.height,
            ),
          ),
          SizedBox(height: 16.0),
          Text(
            'DESCRIPCION',
            style: context.textTheme.headlineSmall?.copyWith(fontSize: 15),
          ),
          Text(cat.description),
          SizedBox(height: 16.0),
          Text(
            'HISTORIA',
            style: context.textTheme.headlineSmall?.copyWith(fontSize: 15),
          ),
          Text(cat.history),
        ],
      ),
    );
  }
}

class _CatInfoSkeleton extends StatelessWidget {
  const _CatInfoSkeleton();

  @override
  Widget build(BuildContext context) {
    final Cat cat = Cat(
      id: '',
      nameBreed: 'Skeleton breed',
      origin: 'Skeleton origin',
      description: '',
      lifeSpan: '20-30',
      temperament: ['Smart', 'Skeleton temperament 2', 'Intelligent'],
      history: 'Loreipsum ',
    );
    return Skeletonizer(child: _CatInfo(cat: cat));
  }
}
