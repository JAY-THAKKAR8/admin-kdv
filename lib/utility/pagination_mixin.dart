import 'package:flutter/material.dart';

mixin PaginatisonMixin<T extends StatefulWidget> on State<T> {
  final scrollPaginationController = ScrollController();
  int itemCount = 0;

  void onReachedLast();

  void initiatePagination() {
    scrollPaginationController.addListener(_paginationReachedEnd);
  }

  void disposePagination() {
    scrollPaginationController
      ..removeListener(_paginationReachedEnd)
      ..dispose();
  }

  void _paginationReachedEnd() {
    if (_isBottom) onReachedLast();
  }

  bool get _isBottom {
    if (!scrollPaginationController.hasClients) return false;
    final maxScroll = scrollPaginationController.position.maxScrollExtent;
    final currentScroll = scrollPaginationController.offset;
    return currentScroll >= (maxScroll * 1);
  }
}

mixin PaginatisonPagviewMixin<T extends StatefulWidget> on State<T> {
  final scrollPaginationController = PageController();
  int itemCount = 0;

  void onReachedLast();

  void initiatePagination() {
    scrollPaginationController.addListener(_paginationReachedEnd);
  }

  void disposePagination() {
    scrollPaginationController
      ..removeListener(_paginationReachedEnd)
      ..dispose();
  }

  void _paginationReachedEnd() {
    if (_isBottom) onReachedLast();
  }

  bool get _isBottom {
    if (!scrollPaginationController.hasClients) return false;
    final maxScroll = scrollPaginationController.position.maxScrollExtent;
    final currentScroll = scrollPaginationController.offset;
    return currentScroll >= (maxScroll * 1);
  }
}
