import 'package:cat_breeds_app/core/di/injection_container.dart';
import 'package:cat_breeds_app/core/theme/app_colors.dart';
import 'package:cat_breeds_app/core/theme/build_context_theme_ext.dart';
import 'package:cat_breeds_app/features/cats/domain/cat.dart';
import 'package:cat_breeds_app/features/cats/presentation/cat_detail/bloc/cat_detail_bloc.dart';
import 'package:cat_breeds_app/shared/widgets/custom_app_bar.dart';
import 'package:cat_breeds_app/shared/widgets/custom_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

part '../widgets/cat_info_skeleton.dart';

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
    final double padding = 18.0;
    final double width = (MediaQuery.of(context).size.width - padding * 2);
    final double? height = cat.image?.heightForWidth(width);
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: CustomNetworkImage(
                    url: cat.image?.url ?? '',
                    height: height,
                    width: width,
                  ),
                ),
              ),
              Positioned(
                bottom: 8.0,
                left: 8.0,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: AppColors.primary.withValues(alpha: 0.8),
                  ),
                  child: Row(
                    spacing: 4.0,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.sell_outlined, color: Colors.white, size: 16),
                      Text(
                        // TODO
                        cat.breedGroup,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FlashInfo(cat: cat),
                  SizedBox(height: 16.0),
                  _Paragraph(
                    title: 'GENERAL INFORMATION',
                    description: cat.description,
                  ),
                  SizedBox(height: 16.0),
                  _Paragraph(
                    title: 'TEMPERAMENT',
                    child: Container(
                      padding: const EdgeInsets.only(top: 8.0),
                      width: double.infinity,
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
                  _Paragraph(title: 'HISTORY', description: cat.history),
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

class _Paragraph extends StatelessWidget {
  const _Paragraph({required this.title, this.description, this.child});

  final String title;
  final String? description;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.only(
        left: 16.0,
        top: 10.0,
        bottom: 14.0,
        right: 16.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 5.0,
        children: [
          _Title(title: title),
          if (child != null)
            child!
          else if (description != null)
            Text(description!),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: '•  ',
        style: TextStyle(
          fontSize: 20,
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
          height: 1.0,
        ),
        children: [
          TextSpan(
            text: title,
            style: context.textTheme.headlineSmall?.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _FlashInfo extends StatelessWidget {
  const _FlashInfo({super.key, required this.cat});

  final Cat cat;

  @override
  Widget build(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.2,
      ),
      children: [
        _CardInfo(
          description: 'LONGEVITY',
          value: '${cat.lifeSpan} years',
          color: Colors.red,
          icon: Icons.favorite_border_rounded,
        ),
        _CardInfo(
          description: 'WEIGHT',
          value: '${cat.weight} kg',
          color: Colors.orange,
          icon: Icons.balance_outlined,
        ),
        _CardInfo(
          description: 'HEIGHT',
          value: '${cat.height} cm',
          color: Colors.blue,
          icon: Icons.height_outlined,
        ),
        _CardInfo(
          description: 'ORIGIN',
          value: cat.origin,
          color: Colors.green,
          icon: Icons.public_outlined,
        ),
      ],
    );
  }
}

class _CardInfo extends StatelessWidget {
  const _CardInfo({
    required this.description,
    required this.value,
    required this.color,
    required this.icon,
  });

  final String description, value;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        spacing: 10.0,
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          Flexible(
            child: Column(
              spacing: 2.0,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(description, style: context.textTheme.headlineSmall),
                Text(
                  value,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    height: 1.0,
                  ),
                ),
              ],
            ),
          ),
        ],
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
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.cardBorder, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }
}
