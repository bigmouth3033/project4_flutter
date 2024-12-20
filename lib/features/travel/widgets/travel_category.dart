import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project4_flutter/shared/bloc/category_cubit/category_cubit.dart';
import 'package:project4_flutter/shared/bloc/category_cubit/category_state.dart';
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

  void _onScroll() {
    if (_categories == null || _categories!.isEmpty) return;
    double offset = _scrollController.offset;
    double itemWidth = 50.0; // Approximate width of each item, adjust as needed
    int currentScrollIndex = (offset / itemWidth).round();
    int currentIndex =
        _categories!.indexWhere((category) => category.id == widget.categoryId);

    if (currentScrollIndex >= 0 && currentScrollIndex < _categories!.length) {
      setState(() {
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
        widget.changeCategory(_categories![currentScrollIndex].id!);
        _previousOffset = offset;
      });
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
          return const Center(
            child: CircularProgressIndicator(),
          );
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
            height: 85,
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
              child: ListView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                children: _categories!.map((category) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        widget.changeCategory(category.id!);
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 25),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 30,
                            child: Image.network(
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                } else {
                                  return const Skeletonizer(
                                    enabled: true,
                                    child: Text("ssss"),
                                  );
                                }
                              },
                              category.categoryImage!,
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
                                            color: Colors.black, width: 3)
                                        : BorderSide.none)),
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
                }).toList(),
              ),
            ),
          );
        }

        return const Text("Loading...");
      },
    );
  }
}
