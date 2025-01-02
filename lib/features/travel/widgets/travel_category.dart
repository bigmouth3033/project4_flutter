import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project4_flutter/shared/bloc/category_cubit/category_cubit.dart';
import 'package:project4_flutter/shared/bloc/category_cubit/category_state.dart';
import 'package:project4_flutter/shared/widgets/loading_icon.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../shared/models/category.dart';

class TravelCategory extends StatefulWidget {
  const TravelCategory(this.categoryId, this.changeCategory, {super.key});

  final int categoryId;
  final void Function(int) changeCategory;

  @override
  State<TravelCategory> createState() => TravelCategoryState();
}

class TravelCategoryState extends State<TravelCategory> {
  final ScrollController _scrollController = ScrollController();
  late List<Category>? _categories;
  double _previousOffset = 0.0;
  bool _hasInitialized = false;

  Timer? _debounceTimer;

  void _onScroll() {
    if (_categories == null || _categories!.isEmpty) return;

    double offset = _scrollController.offset;

    double itemWidth = 40.0; // Approximate width of each item, adjust as needed
    int currentScrollIndex = (offset / itemWidth).round();
    int currentIndex =
        _categories!.indexWhere((category) => category.id == widget.categoryId);

    if ((_previousOffset - offset).abs() < 40) {
      return;
    }

    if (currentScrollIndex >= 0 && currentScrollIndex < _categories!.length) {
      if (_previousOffset > offset) {
        // scroll to left
        if (currentIndex < currentScrollIndex) {
          return;
        }
      }

      if (_previousOffset <= offset) {
        if (currentIndex > currentScrollIndex) {
          return;
        }
      }

      setState(() {
        _previousOffset = offset;
      });
      widget.changeCategory(_categories![currentScrollIndex].id!);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoading) {
          return const LoadingIcon(size: 40);
        }

        if (state is CategorySuccess) {
          _categories = state.categories;

          if (!_hasInitialized) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              widget.changeCategory(_categories![0].id!);
              setState(() {
                _hasInitialized = true;
              });
            });
          }

          return Container(
            height: 84,
            padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
            decoration: const BoxDecoration(
              border: Border(
                bottom:
                    BorderSide(color: Color.fromARGB(50, 0, 0, 0), width: 1),
              ),
            ),
            child: NotificationListener(
              onNotification: (ScrollNotification notification) {
                if (notification is ScrollUpdateNotification) {
                  _onScroll();
                }
                return true;
              },
              child: Scrollbar(
                child: ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories!.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    var category = _categories![index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          widget.changeCategory(category.id!);
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 20),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 30,
                              child: CachedNetworkImage(
                                imageUrl: category.categoryImage!,
                                placeholder: (context, url) =>
                                    const Skeletonizer(
                                  enabled: true,
                                  child: Text("Loading..."),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                color: widget.categoryId == category.id
                                    ? Colors.black
                                    : const Color.fromARGB(150, 0, 0, 0),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: widget.categoryId == category.id
                                      ? const BorderSide(
                                          color: Colors.black,
                                          width: 3,
                                        )
                                      : BorderSide.none,
                                ),
                              ),
                              child: Text(
                                category.categoryName!,
                                style: TextStyle(
                                  color: widget.categoryId == category.id
                                      ? Colors.black
                                      : const Color.fromARGB(150, 0, 0, 0),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        }

        return const Text("Loading...");
      },
    );
  }
}
