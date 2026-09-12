part of '../pages/cat_detail_page.dart';

class _ExtendedInfoCard extends StatelessWidget {
  const _ExtendedInfoCard({required this.title, this.description, this.child});

  final String title;
  final String? description;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return AppCard(
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
