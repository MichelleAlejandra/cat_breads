import 'package:cat_breeds_app/core/di/injection_container.dart';
import 'package:cat_breeds_app/core/theme/app_colors.dart';
import 'package:cat_breeds_app/core/theme/build_context_theme_ext.dart';
import 'package:cat_breeds_app/features/cats/domain/cat.dart';
import 'package:cat_breeds_app/features/cats/presentation/cat_detail/pages/cat_detail_page.dart';
import 'package:cat_breeds_app/features/cats/presentation/cat_list/bloc/cat_list_bloc.dart';
import 'package:cat_breeds_app/shared/widgets/chip_wrap.dart';
import 'package:cat_breeds_app/shared/widgets/custom_app_bar.dart';
import 'package:cat_breeds_app/shared/widgets/custom_network_image.dart';
import 'package:cat_breeds_app/shared/widgets/content_state_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

part '../widgets/cat_list_item.dart';
part '../widgets/cat_list_item_skeleton.dart';

class CatListPage extends StatelessWidget {
  const CatListPage({super.key});

  static const routeName = '/cats';
  static const routePath = '/cats';

  @override
  Widget build(BuildContext context) {
    final double padding = 16.0;
    return Scaffold(
      appBar: CustomAppBar(title: 'CatBreeds'),
      body: BlocProvider(
        create: (context) => sl<CatListBloc>()..add(CatListEvent.initialize()),
        child: Column(
          children: [
            const SizedBox(height: 6),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: padding, vertical: 12),
              child: _SearchTexfield(key: const Key('search-textfield')),
            ),
            Expanded(
              child: BlocBuilder<CatListBloc, CatListState>(
                builder: (context, state) {
                  return state.map(
                    loading: (_) =>
                        const Center(child: CircularProgressIndicator()),
                    loaded: (state) => state.cats.isNotEmpty
                        ? _CatListScrollView(
                            cats: state.cats,
                            padding: padding,
                            isLoadingMore: state.isLoadingMore,
                          )
                        : ContentStateView(
                            key: const Key('cat-list-empty'),
                            contentState: ContentState.empty,
                          ),
                    error: (_) => ContentStateView(
                      key: const Key('cat-list-error'),
                      onRetry: () => context.read<CatListBloc>().add(
                        CatListEvent.initialize(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchTexfield extends StatelessWidget {
  const _SearchTexfield({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search for a cat breed...',
        suffixIcon: Icon(Icons.search),
      ),
      onChanged: (value) {
        context.read<CatListBloc>().add(CatListEvent.search(query: value));
      },
    );
  }
}

class _CatListScrollView extends StatefulWidget {
  const _CatListScrollView({
    required this.cats,
    required this.padding,
    required this.isLoadingMore,
  });

  final List<Cat> cats;
  final double padding;
  final bool isLoadingMore;

  @override
  State<_CatListScrollView> createState() => _CatListScrollViewState();
}

class _CatListScrollViewState extends State<_CatListScrollView> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 300) {
        context.read<CatListBloc>().add(const CatListEvent.loadMore());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: const Key('cat-list'),
      controller: _scrollController,
      itemCount: widget.cats.length + (widget.isLoadingMore ? 1 : 0),
      padding: EdgeInsets.symmetric(horizontal: widget.padding, vertical: 16),
      itemBuilder: (context, index) {
        if (index >= widget.cats.length) {
          return const _CatListItemSkeleton();
        }
        final cat = widget.cats[index];
        return _CatListItem(cat: cat, key: Key('cat-${cat.id}'));
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
