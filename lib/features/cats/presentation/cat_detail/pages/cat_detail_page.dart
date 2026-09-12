import 'package:cat_breeds_app/core/di/injection_container.dart';
import 'package:cat_breeds_app/core/theme/app_colors.dart';
import 'package:cat_breeds_app/core/theme/build_context_theme_ext.dart';
import 'package:cat_breeds_app/features/cats/domain/cat.dart';
import 'package:cat_breeds_app/features/cats/domain/cat_image.dart';
import 'package:cat_breeds_app/features/cats/presentation/cat_detail/bloc/cat_detail_bloc.dart';
import 'package:cat_breeds_app/shared/widgets/app_card.dart';
import 'package:cat_breeds_app/shared/widgets/chip_wrap.dart';
import 'package:cat_breeds_app/shared/widgets/custom_app_bar.dart';
import 'package:cat_breeds_app/shared/widgets/custom_network_image.dart';
import 'package:cat_breeds_app/shared/widgets/content_state_view.dart';
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
                  loading: (_) =>
                      _CatInfoSkeleton(key: const Key('cat-info-skeleton')),
                  loaded: (state) =>
                      _CatInfo(key: const Key('cat-info'), cat: state.cat),
                  error: (_) => ContentStateView(
                    key: const Key('cat-detail-error'),
                    onRetry: () => context.read<CatDetailBloc>().add(
                      CatDetailEvent.initialize(id: id),
                    ),
                  ),
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
          _CatImageInformation(image: cat.image, breedGroup: cat.breedGroup),
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
                      child: ChipWrap(values: cat.temperament),
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
