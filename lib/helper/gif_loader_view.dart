import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
import 'package:real_true_date/core/themes/app_icons.dart';

class GifLoaderView extends StatelessWidget {
  final bool isLoading;

  const GifLoaderView({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return const SizedBox();

    return Container(
      color: Colors.black.withOpacity(0.4),
      child: Center(
        child: GifView.asset(
          AppIcons.gifLogo,
          height: 200,
          width: 200,
        ),
      ),
    );
  }
}
