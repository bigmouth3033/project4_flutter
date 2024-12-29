import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:project4_flutter/shared/bloc/category_cubit/category_cubit.dart';
import 'package:project4_flutter/shared/bloc/category_cubit/category_state.dart';
import 'package:project4_flutter/shared/bloc/property_cubit/property_cubit.dart';
import 'package:project4_flutter/shared/bloc/property_cubit/property_state.dart';
import 'package:project4_flutter/shared/utils/address_convert.dart';
import 'package:project4_flutter/shared/utils/limit_text_to300_words.dart';
class PropertyDetail extends StatelessWidget {
  const PropertyDetail({super.key});
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        context.read<PropertyCubit>().getProperty();
      },
    );
    return MultiBlocListener(
      listeners: [
        BlocListener<PropertyCubit, PropertyState>(
          listener: (context, state) {
            if (state is PropertyError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
        ),
      ],
      child: BlocBuilder<PropertyCubit, PropertyState>(
        builder: (context, propertyState) {
          if (propertyState is PropertyLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (propertyState is PropertySuccess) {
            String addressCode = propertyState.property.addressCode;

            return BlocBuilder<CategoryCubit, CategoryState>(
              builder: (context, categoryState) {
                if (categoryState is CategoryLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (categoryState is CategorySuccess) {
                  final categories = categoryState.categories;

                  final category = categories?.firstWhere((cat) =>
                      cat.id == propertyState.property.propertyCategoryID);
                  final aboutProperty = propertyState.property.aboutProperty;
                  return Scaffold(
                    backgroundColor: Colors.white,
                    body: SingleChildScrollView(
                      // Đảm bảo SingleChildScrollView bao quanh Column
                      child: Column(
                        children: [
                          SizedBox(
                            height: 280,
                            child: PageView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: propertyState.property.propertyImages.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                                  child: GestureDetector(
                                    child: ClipRRect(
                                      child: Image.network(
                                        propertyState.property.propertyImages[index],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                20.0, 10.0, 20.0, 0.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(
                                  children: [
                                    Text(
                                      "${propertyState.property.propertyTitle} with ${propertyState.property.propertyType}",
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      softWrap: true,
                                    )
                                  ],
                                ),
                                FutureBuilder<String>(
                                  future: convertAddressCode(addressCode),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Text(
                                        '${category?.categoryName} in ${snapshot.data!}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        softWrap: true,
                                      );
                                    } else if (snapshot.hasError) {
                                      return const Text('Error loading data');
                                    } else {
                                      return const Text('Loading...');
                                    }
                                  },
                                ),
                                Wrap(
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(" ${propertyState.property.maximumGuest} clients ",
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                        const Icon(Icons.circle, size: 4),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(" ${propertyState.property.numberOfBedRoom} bedroom ",
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                        const Icon(Icons.circle, size: 4),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(" ${propertyState.property.numberOfBed} beds ",
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                        const Icon(Icons.circle, size: 4),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(" ${propertyState.property.numberOfBathRoom} bathroom",
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.star, size: 25),
                                      Text("4.67 ",
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                      Icon(Icons.circle, size: 4),
                                      Text(" "),
                                      Text("158 reviews",
                                        style: TextStyle(
                                          fontSize: 18,
                                          decoration: TextDecoration.underline,
                                          decorationThickness: 3.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
                            child: Row(
                              children: [

                                GestureDetector(
                                  child: ClipOval(
                                    child: propertyState.property.user?.avatar != null &&
                                            propertyState.property.user!.avatar!.isNotEmpty
                                        ? Image.network(
                                            propertyState.property.user!.avatar!,
                                            width: 40,
                                            height: 40,
                                            fit: BoxFit.cover,
                                          )
                                        : CircleAvatar(
                                            radius: 25,
                                            backgroundColor: Colors.grey.shade300,
                                            child: Text(
                                              propertyState.property.user!.firstName!.isNotEmpty
                                                  ? propertyState.property.user!.firstName![0].toUpperCase()
                                                  : '?',
                                              style: const TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(" ${propertyState.property.user?.firstName} ${propertyState.property.user?.lastName}",
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(20.0, 20.0, 0.0, 0.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("What this place offers",
                                    style:  TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold))
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
                            child: ListView.builder(
                              itemCount: 5,
                              shrinkWrap: true, // Dùng shrinkWrap để không sử dụng toàn bộ không gian
                              itemBuilder: (context, index) {
                                final amenity = propertyState.property.amenity[index];
                                return Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 0, 20, 10),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Image.network(
                                        amenity.image,
                                        width: 30,
                                        height: 30,
                                        fit: BoxFit.cover,
                                      ),
                                      const SizedBox(width: 18),
                                      Expanded(
                                        child: Text("${amenity.name}", style: const TextStyle(fontSize: 18),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              showModalBottomSheet(
                                backgroundColor: Colors.white,
                                context: context,
                                isScrollControlled: true, // Cho phép chiếm toàn màn hình nếu cần
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
                                ),
                                builder: (BuildContext context) {
                                  return DraggableScrollableSheet(
                                    expand: false,
                                    initialChildSize: 0.9, // Chiều cao ban đầu chiếm 60% màn hình
                                    minChildSize: 0.4, // Chiều cao tối thiểu khi kéo xuống
                                    maxChildSize: 0.9, // Chiều cao tối đa khi kéo lên
                                    builder: (BuildContext context,
                                        ScrollController scrollController) {
                                      return SingleChildScrollView(
                                        controller: scrollController, // Kết nối với draggable scroll
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      IconButton(
                                                        icon: const Icon(Icons.close, size: 35),
                                                        onPressed: () {Navigator.pop(context);
                                                        },
                                                      ),
                                                      const SizedBox(width: 4),
                                                      const Text('What this place offers',
                                                        style: TextStyle(
                                                            fontSize: 26,
                                                            fontWeight:FontWeight.bold),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 16),
                                              for (var type in propertyState.property.amenity.map(
                                                      (amenity) => amenity.type)
                                                  .toSet()) ...[

                                                Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                                                  child: Text(type,
                                                    style: const TextStyle(
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                                for (var amenity in propertyState.property.amenity
                                                    .where((amenity) => amenity.type == type))
                                                  Padding(
                                                    padding: const EdgeInsets.only(bottom: 8.0),
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Image.network(
                                                          amenity.image,
                                                          width: 50,
                                                          height: 50,
                                                          fit: BoxFit.cover,
                                                        ),
                                                        const SizedBox(width: 16),

                                                        Text(
                                                          amenity.name,
                                                          style: const TextStyle(fontSize: 20),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                              ],
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white, // Màu nền
                              minimumSize: const Size(320, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0), // Bo tròn các góc
                                side: const BorderSide(
                                  color: Colors.black, // Màu của border
                                  width: 1.0, // Độ dày của border
                                ),
                              ),
                            ),
                            child: Text(
                              'Show ${propertyState.property.amenity.length} amenity',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
                            child: Html(data: limitTextTo300Words(aboutProperty)),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  backgroundColor: Colors.white,
                                  context: context,
                                  isScrollControlled: true, // Cho phép chiếm toàn màn hình nếu cần
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(16.0)),
                                  ),
                                  builder: (BuildContext context) {
                                    return DraggableScrollableSheet(
                                      expand: false,
                                      initialChildSize: 0.9, // Chiều cao ban đầu chiếm 60% màn hình
                                      minChildSize: 0.4, // Chiều cao tối thiểu khi kéo xuống
                                      maxChildSize: 0.9, // Chiều cao tối đa khi kéo lên
                                      builder: (BuildContext context,
                                          ScrollController scrollController) {
                                        return SingleChildScrollView(
                                          controller: scrollController, // Kết nối với draggable scroll
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        IconButton(
                                                          icon: const Icon(Icons.close, size: 35),
                                                          onPressed: () {Navigator.pop(context); // Đóng bottom sheet
                                                          },
                                                        ),
                                                        const SizedBox(width: 4),
                                                        const Text('About of the property',
                                                          style: TextStyle(
                                                              fontSize: 26,
                                                              fontWeight: FontWeight.bold),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 16),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                                  child: Column(
                                                    children: [
                                                      const Row(
                                                        children: [
                                                          Text("About this place",
                                                              style: TextStyle(
                                                                fontSize: 24,
                                                                fontWeight: FontWeight.bold,
                                                              )),
                                                        ],
                                                      ),
                                                      Html(data: aboutProperty),
                                                      const Row(
                                                        children: [
                                                          Text("Guest access",
                                                              style: TextStyle(
                                                                fontSize: 24,
                                                                fontWeight: FontWeight.bold,
                                                              )),
                                                        ],
                                                      ),
                                                      Html(
                                                          data: propertyState.property.guestAccess),
                                                      const Row(
                                                        children: [
                                                          Text("Other things to note",
                                                              style: TextStyle(
                                                                fontSize: 24,
                                                                fontWeight: FontWeight.bold,
                                                              )),
                                                        ],
                                                      ),
                                                      Html(
                                                          data: propertyState.property.detailToNote),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white, // Màu nền
                                minimumSize: const Size(500, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0.0), // Bo tròn các góc
                                ),
                              ),
                              child: const Row(
                                children: [
                                   Text('Show more amenity',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      decoration: TextDecoration.underline,
                                      decorationThickness: 3.0,
                                      height: 1.5, // This will create space between the text and underline
                                    ),
                                  )
                                ],
                              )),
                          const Padding(padding:  EdgeInsets.fromLTRB(20, 10, 20, 20), child:  Row(children: [Text("Meet your host", style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold),)],),),
                          Padding(
                            padding:const EdgeInsets.fromLTRB(20,20,20,20),
                            child: Container(
                              height: 150, // Đặt chiều cao cố định
                              width: double.infinity, // Đảm bảo đủ rộng
                              padding: const EdgeInsets.all(2.0),
                              decoration: BoxDecoration(

                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 0.0,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5), // Màu đổ bóng với độ mờ
                                    spreadRadius: 2, // Độ lan của bóng
                                    blurRadius: 5, // Độ mờ của bóng
                                    offset: const Offset(2, 3), // Độ lệch ngang và dọc của bóng
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(10), // Bo góc
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center, // Căn giữa theo trục dọc
                                      crossAxisAlignment: CrossAxisAlignment.center, // Căn giữa theo trục ngang
                                      children: [
                                        GestureDetector(
                                          child: ClipOval(
                                            child: propertyState.property.user?.avatar != null &&
                                                propertyState.property.user!.avatar!.isNotEmpty
                                                ? Image.network(
                                              propertyState.property.user!.avatar!,
                                              width: 70,
                                              height: 70,
                                              fit: BoxFit.cover,
                                            )
                                                : CircleAvatar(
                                              radius: 25,
                                              backgroundColor: Colors.grey.shade300,
                                              child: Text(
                                                propertyState.property.user!.firstName!.isNotEmpty
                                                    ? propertyState.property.user!.firstName![0]
                                                    .toUpperCase()
                                                    : '?',
                                                style: const TextStyle(
                                                    fontSize: 24, fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8), // Khoảng cách giữa các thành phần
                                         Text(
                                          "${propertyState.property.user!.firstName} ${propertyState.property.user!.lastName}",
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center, // Căn giữa theo trục dọc
                                      crossAxisAlignment: CrossAxisAlignment.center, // Căn giữa theo trục ngang
                                      children: [
                                        const Text(
                                          'Cột 2',
                                          style: TextStyle(color: Colors.black, fontSize: 16),
                                        ),
                                        const SizedBox(height: 8), // Khoảng cách giữa các thành phần
                                        const Icon(Icons.info, size: 24, color: Colors.black),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )


                        ],
                      ),
                    ),
                  );
                } else if (categoryState is CategoryError) {
                  return Center(child: Text("Error: ${categoryState.message}"));
                }
                return const Center(child: Text("Loading categories..."));
              },
            );
          } else if (propertyState is PropertyError) {
            return Center(child: Text("Error: ${propertyState.message}"));
          }
          return const Center(child: Text("No data available."));
        },
      ),
    );
  }
}
