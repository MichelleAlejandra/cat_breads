import 'package:cat_breeds_app/core/theme/build_context_theme_ext.dart';
import 'package:flutter/material.dart';

class ContentStateView extends StatelessWidget {
  const ContentStateView({
    super.key,
    this.onRetry,
    this.contentState = ContentState.failed,
  });

  final VoidCallback? onRetry;
  final ContentState contentState;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: context.colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.priority_high_rounded,
              color: context.colorScheme.primary,
              size: 50,
            ),
          ),
          Text(
            _title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),
          Text(
            _description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15),
          ),
          const SizedBox(height: 10.0),
          if (onRetry != null)
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: Text('Retry' ),
          ),
          const SizedBox(height: 70.0),
        ],
      ),
    );
  }

  String get _title => contentState == ContentState.failed
      ? 'Oops! We couldn\'t load the information.'
      : 'Oops! We did not find a match.';

  String get _description => contentState == ContentState.failed
      ? 'We are unable to retrieve the information at this time. '
            'This may be due to an intermittent network issue or '
            'service maintenance.'
      : 'Try searching with a different term, check the spelling, or clear '
            'the applied filters to view the entire catalog.';
}

enum ContentState { failed, empty }
