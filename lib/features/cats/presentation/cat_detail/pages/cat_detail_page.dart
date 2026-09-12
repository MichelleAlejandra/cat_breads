import 'package:cat_breeds_app/core/di/injection_container.dart';
import 'package:cat_breeds_app/core/theme/app_colors.dart';
import 'package:cat_breeds_app/core/theme/build_context_theme_ext.dart';
import 'package:cat_breeds_app/features/cats/domain/cat.dart';
import 'package:cat_breeds_app/features/cats/domain/cat_image.dart';
import 'package:cat_breeds_app/features/cats/presentation/cat_detail/bloc/cat_detail_bloc.dart';
import 'package:cat_breeds_app/shared/widgets/custom_app_bar.dart';
import 'package:cat_breeds_app/shared/widgets/custom_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

part '../widgets/cat_info_skeleton.dart';
part '../widgets/cat_flash_info_grid.dart';
part '../widgets/cat_image_info.dart';
part '../widgets/extended_info_card.dart';

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
            appBar: CustomAppBar(title: title, isSecondary: true),
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
    final double padding = 18.0;

    return Padding(
      padding: EdgeInsets.only(left: padding, right: padding, top: padding),
      child: Column(
        children: [
          _CatImageInformation(
            image: cat.image,
            breedGroup: cat.breedGroup,
            padding: padding,
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _CatFlashInfoGrid(cat: cat),
                  SizedBox(height: 16.0),
                  _ExtendedInfoCard(
                    title: 'GENERAL INFORMATION',
                    description: cat.description,
                  ),
                  SizedBox(height: 16.0),
                  _ExtendedInfoCard(
                    title: 'TEMPERAMENT',
                    child: Container(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: cat.temperament
                            .map((e) => _Skill(value: e))
                            .toList(),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  _ExtendedInfoCard(title: 'HISTORY', description: cat.history),
                  SizedBox(height: 35.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Skill extends StatelessWidget {
  const _Skill({required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Text(
        value,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
  }
}


class _Card extends StatelessWidget {
  const _Card({required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.cardBorder, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }
}
