import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pragma_cat_breeds/l10n/app_localizations.dart';

import 'package:pragma_cat_breeds/src/presentation/cat_breeds/bloc/cat_breeds_bloc.dart';
import 'package:pragma_cat_breeds/src/presentation/cat_breeds/bloc/events/cat_breeds_event.dart';

/// Search bar widget for filtering cat breeds
class CatBreedsSearchBar extends StatefulWidget {
  const CatBreedsSearchBar({super.key});

  @override
  State<CatBreedsSearchBar> createState() => _CatBreedsSearchBarState();
}

class _CatBreedsSearchBarState extends State<CatBreedsSearchBar> {
  late final TextEditingController _controller;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {}); // Update suffixIcon visibility
    
    // Cancel previous timer
    _debounceTimer?.cancel();
    
    // Create new timer for debouncing search
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      context.read<CatBreedsBloc>().add(
        CatBreedsSearchRequested(query),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: l10n.searchHint,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _controller.clear();
                    context.read<CatBreedsBloc>().add(
                          const CatBreedsSearchCleared(),
                        );
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        onChanged: _onSearchChanged,
      ),
    );
  }
}
