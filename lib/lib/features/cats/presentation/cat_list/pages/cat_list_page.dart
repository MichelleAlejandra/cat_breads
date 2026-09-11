import 'package:cached_network_image/cached_network_image.dart';
import 'package:cat_breeds_app/core/di/injection_container.dart';
import 'package:cat_breeds_app/core/theme/app_colors.dart';
import 'package:cat_breeds_app/lib/features/cats/domain/cat.dart';
import 'package:cat_breeds_app/lib/features/cats/presentation/cat_list/bloc/cat_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part '../widgets/cat_list_item.dart';

class CatListPage extends StatelessWidget {
  const CatListPage({super.key});

  static const routeName = '/cats';
  static const routePath = '/cats';

  @override
  Widget build(BuildContext context) {
    final double padding = 16.0;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.pets, color: AppColors.splashTitle),
            const SizedBox(width: 8),
            Text(
              'CatBreeds',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: AppColors.pageBackground,
      body: BlocProvider(
        create: (context) => sl<CatListBloc>()..add(CatListEvent.initialize()),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(padding),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar raza de gato...',
                  suffixIcon: Icon(Icons.search),
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<CatListBloc, CatListState>(
                builder: (context, state) {
                  return state.map(
                    loading: (_) =>
                        const Center(child: CircularProgressIndicator()),
                    loaded: (state) =>
                        _CatListScrollView(cats: state.cats, padding: padding),
                    error: (_) =>
                        const Center(child: Text('Error loading cats')),
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

class _CatListScrollView extends StatefulWidget {
  const _CatListScrollView({required this.cats, required this.padding});

  final List<Cat> cats;
  final double padding;

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
      controller: _scrollController,
      itemCount: widget.cats.length,
      padding: EdgeInsets.symmetric(horizontal: widget.padding),
      itemBuilder: (context, index) {
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
