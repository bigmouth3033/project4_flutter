import 'dart:ffi' as ffi;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:project4_flutter/features/authentication/authentication.dart';
import 'package:project4_flutter/features/property_detail/widgets/checkout_details.dart';
import 'package:project4_flutter/features/property_detail/widgets/custom_divider.dart';
import 'package:project4_flutter/features/property_detail/widgets/date_picker_modal.dart';
import 'package:project4_flutter/features/property_detail/widgets/property_images_view.dart';
import 'package:project4_flutter/features/property_detail/widgets/show_popup.dart';
import 'package:project4_flutter/features/property_detail/widgets/transaction.dart';
import 'package:project4_flutter/shared/bloc/booking/booking.dart';
import 'package:project4_flutter/shared/bloc/booking/date_booking.dart';
import 'package:project4_flutter/shared/bloc/booking/guest_booking.dart';
import 'package:project4_flutter/shared/bloc/category_cubit/category_cubit.dart';
import 'package:project4_flutter/shared/bloc/category_cubit/category_state.dart';
import 'package:project4_flutter/shared/bloc/policy_cubit/policy_cubit.dart';
import 'package:project4_flutter/shared/bloc/policy_cubit/policy_state.dart';
import 'package:project4_flutter/shared/bloc/property_cubit/property_cubit.dart';
import 'package:project4_flutter/shared/bloc/property_cubit/property_state.dart';
import 'package:project4_flutter/shared/bloc/read_review_cubit/review_cubit.dart';
import 'package:project4_flutter/shared/bloc/read_review_cubit/review_state.dart';
import 'package:project4_flutter/shared/bloc/user_cubit/user_cubit.dart';
import 'package:project4_flutter/shared/bloc/user_cubit/user_state.dart';
import 'package:project4_flutter/shared/models/booking_dto.dart';
import 'package:project4_flutter/shared/models/category.dart';
import 'package:project4_flutter/shared/models/exception_date.dart';
import 'package:project4_flutter/shared/models/user.dart';
import 'package:project4_flutter/shared/utils/address_convert.dart';
import 'package:project4_flutter/shared/utils/calculate_host_time.dart';
import 'package:project4_flutter/shared/utils/is_same_day.dart';
import 'package:project4_flutter/shared/widgets/format_date_range.dart';
import 'package:project4_flutter/shared/widgets/format_dolar.dart';
import 'package:project4_flutter/shared/utils/limit_text_to300_words.dart';

class PropertyDetail extends StatefulWidget {
  const PropertyDetail({super.key});
  @override
  State<PropertyDetail> createState() => _PropertyDetailState();
}

class _PropertyDetailState extends State<PropertyDetail> {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        context.read<PropertyCubit>().getProperty(789);
        context.read<ReviewCubit>().getReviewOfProperty();
        context.read<PolicyCubit>().getPolicy();
        context.read<DateBookingCubit>();
      },
    );
    return RefreshIndicator(
      onRefresh: () {
        return context.read<PropertyCubit>().getProperty(789);
      },
      child: MultiBlocListener(
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
              return const Scaffold(
                  body: Center(
                child: Text(""),
              ));
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
                    final startArv = (propertyState.property.cleanlinessScore +
                            propertyState.property.communicationScore +
                            propertyState.property.accuracyScore +
                            propertyState.property.checkinScore) /
                        4;
                    return Scaffold(
                      backgroundColor: Colors.white,
                      body: SingleChildScrollView(
                        child: Column(
                          children: [
                            buildPropertyImagesView(propertyState),
                            buildAddress(
                                propertyState, addressCode, category, startArv),
                            buildAmenity(propertyState),
                            buildTilteOffers(),
                            buildViewAmenity(propertyState),
                            buildShowAmenity(context, propertyState),
                            const CustomDivider(),
                            buildAbout(aboutProperty),
                            buildShowAbout(
                                context, aboutProperty, propertyState),
                            const CustomDivider(),
                            buildCheckCalendar(propertyState, startArv),
                            const CustomDivider(),
                            buildTilteHost(),
                            buildMeetHost(propertyState, startArv),
                            const CustomDivider(),
                            buildTilteRule(),
                            buildRule(propertyState),
                            buildShowRule(context, propertyState),
                            const CustomDivider(),
                            buildCancel(propertyState),
                          ],
                        ),
                      ),
                      bottomNavigationBar:
                          buildBottomBar(propertyState, startArv),
                    );
                  } else if (categoryState is CategoryError) {
                    return Center(
                        child: Text("Error: ${categoryState.message}"));
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
      ),
    );
  }

  Container buildBottomBar(PropertySuccess propertyState, double startArv) {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.black12, width: 0.5),
        ),
      ),
      child: BlocBuilder<DateBookingCubit, DateBookingState>(
          builder: (context, state) {
        final startDate = context.read<DateBookingCubit>().startDate;
        final endDate = context.read<DateBookingCubit>().endDate;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            startDate != null && endDate != null
                ? TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CheckoutDetails()));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        formatPrice(propertyState.property.basePrice),
                        formatDateRange(startDate, endDate)
                      ],
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Choose dates",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.star, size: 20),
                          Text(
                            startArv.toString(),
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
            if (startDate != null && endDate != null)
              TextButton(
                onPressed: () async {
                  final userCubit = context.read<UserCubit>().state;
                  if (userCubit is UserSuccess) {
                    final bookingCubit = context.read<BookingCubit>();
                    final datesCubit = context.read<DateBookingCubit>();
                    final guestBooking = context.read<GuestBookingCubit>();
                    final state = context.read<UserCubit>().state;
                    User? userBooking;
                    if (state is UserSuccess) {
                      userBooking = state.user;
                    }
                    final booking = BookingDto(
                      children: guestBooking.children,
                      adult: guestBooking.adult,
                      hostFee: 12,
                      websiteFee: 13,
                      customerId: userBooking?.id,
                      hostId: propertyState.property.userId,
                      propertyId: propertyState.property.id,
                      amount: 244,
                      checkInDay: datesCubit.startDate!,
                      checkOutDay:
                          datesCubit.endDate!.add(const Duration(days: 1)),
                    );
                    var rs = await bookingCubit.initBookingProcess(booking);
                    if (context.mounted) {
                      final state = context.read<BookingCubit>().state;
                      String message = "";
                      if (state is BookingFail) {
                        context
                            .read<DateBookingCubit>()
                            .updateDates(null, null);
                        message = state.message;
                      }
                      if (rs != null) {
                        context
                            .read<DateBookingCubit>()
                            .updateDates(null, null);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    TransactionModal(booking: rs)));
                      } else {
                        context
                            .read<DateBookingCubit>()
                            .updateDates(null, null);
                        showErrorDialog(context, message);
                      }
                    }
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Authentication()));
                  }
                },
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFFFF0000),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 55, vertical: 18),
                  // Padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Booking',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white),
                ),
              )
            else
              ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return DatePickerModal(
                        startArv: startArv,
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF0000),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  minimumSize: const Size(160, 60),
                ),
                child: const Text(
                  "Check calendar",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              )
          ],
        );
      }),
    );
  }

  double calculate_total_base_price(DateTime? startDate, DateTime? endDate,
      List<ExceptionDate> exceptionDates, PropertySuccess propertyState) {
    DateTime? tempStart = startDate;
    DateTime? tempEnd = endDate;
    List<DateTime> dateList = [];
    while (
        startDate!.isBefore(endDate!) || startDate.isAtSameMomentAs(endDate)) {
      dateList.add(startDate);
      startDate = startDate.add(const Duration(days: 1));
    }
    int nightBase = dateList.length -
        showExceptionDates(tempStart, tempEnd, exceptionDates).length;
    double basePriceTotal = nightBase * propertyState.property.basePrice;
    double exceptionPriceTotal = 0;
    for (var date in showExceptionDates(tempStart, tempEnd, exceptionDates)) {
      exceptionPriceTotal += date.basePrice;
    }
    return basePriceTotal + exceptionPriceTotal;
  }

  List<ExceptionDate> showExceptionDates(DateTime? startDate, DateTime? endDate,
      List<ExceptionDate> exceptionDates) {
    List<ExceptionDate> dateListReturn = [];
    List<DateTime> dateList = [];
    while (
        startDate!.isBefore(endDate!) || startDate.isAtSameMomentAs(endDate)) {
      dateList.add(startDate);
      startDate = startDate.add(const Duration(days: 1));
    }
    for (var date in dateList) {
      for (var exDate in exceptionDates) {
        if (isSameDate(date, exDate.date)) {
          dateListReturn.add(exDate);
        }
      }
    }
    dateListReturn.sort((a, b) => a.date.compareTo(b.date));
    return dateListReturn;
  }

  Padding buildCancel(PropertySuccess propertyState) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(23.0, 20.0, 23.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Cancel policy",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          BlocBuilder<PolicyCubit, PolicyState>(
            builder: (context, state) {
              if (state is PolicyLoading) {
                return const CircularProgressIndicator();
              } else if (state is PolicySuccess) {
                final matchingPolicy = state.policies.firstWhere(
                  (policy) =>
                      policy.id == propertyState.property.refundPolicyId,
                );
                return Text(
                  "Refund policy: ${matchingPolicy.policyDescription}",
                  // Hiển thị thông tin
                  style: const TextStyle(fontSize: 16),
                );
              } else if (state is PolicyFailure) {
                return const Text(
                  "Policy not found",
                  style: TextStyle(color: Colors.red),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Padding buildShowRule(BuildContext context, PropertySuccess propertyState) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ElevatedButton(
          onPressed: () {
            showModalBottomSheet(
              backgroundColor: Colors.white,
              context: context,
              isScrollControlled: true,
              builder: (BuildContext context) {
                return DraggableScrollableSheet(
                  expand: false,
                  initialChildSize: 1,
                  minChildSize: 0.9,
                  maxChildSize: 1,
                  builder: (BuildContext context,
                      ScrollController scrollController) {
                    return SingleChildScrollView(
                      controller: scrollController,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.arrow_back, size: 25),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Text(
                                  'House rules',
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  const Text(
                                    "You'll be staying in someone's home, so please treat it with care and respect.",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  const SizedBox(height: 30),
                                  const Row(
                                    children: [
                                      Text("Checking in and out",
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 40, 0, 40),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.access_time,
                                              size: 30.0,
                                              color: Colors.black,
                                            ),
                                            const SizedBox(width: 16),
                                            Text(
                                              "Check-in after: ${propertyState.property.checkInAfter}",
                                              style:
                                                  const TextStyle(fontSize: 18),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        const Divider(
                                            thickness: 1,
                                            color: Colors.black12),
                                        const SizedBox(height: 20),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.access_time,
                                              size: 30.0,
                                              color: Colors.black,
                                            ),
                                            const SizedBox(width: 16),
                                            Text(
                                              "Check-out before:  ${propertyState.property.checkInAfter}",
                                              style:
                                                  const TextStyle(fontSize: 18),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        const Divider(
                                            thickness: 1,
                                            color: Colors.black12),
                                        const SizedBox(height: 20),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.door_front_door_outlined,
                                              size: 30.0,
                                              color: Colors.black,
                                            ),
                                            const SizedBox(width: 18),
                                            Text(
                                              propertyState.property.selfCheckIn
                                                  ? "Safe check-in"
                                                  : "Check in with host",
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  //During your stay
                                  const Row(
                                    children: [
                                      Text("During your stay",
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 30, 0, 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.groups_3_outlined,
                                              size: 30.0,
                                              color: Colors.black,
                                            ),
                                            const SizedBox(width: 16),
                                            Text(
                                              "Maximum guest : ${propertyState.property.maximumGuest}",
                                              style:
                                                  const TextStyle(fontSize: 18),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        const Divider(
                                            thickness: 1,
                                            color: Colors.black12),
                                        const SizedBox(height: 20),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.pets,
                                              size: 30.0,
                                              color: Colors.black,
                                            ),
                                            const SizedBox(width: 16),
                                            Text(
                                              propertyState.property.petAllowed
                                                  ? 'Pet(s) live on property'
                                                  : 'No pets',
                                              style:
                                                  const TextStyle(fontSize: 18),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        const Divider(
                                            thickness: 1,
                                            color: Colors.black12),
                                        const SizedBox(height: 20),
                                        const Row(
                                          children: [
                                            Icon(
                                              Icons.smoke_free_outlined,
                                              size: 30.0,
                                              color: Colors.black,
                                            ),
                                            SizedBox(width: 16),
                                            Text(
                                              "No smoking",
                                              style: TextStyle(fontSize: 18),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
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
            minimumSize: const Size(350, 40),
            elevation: 0,
          ),
          child: const Row(
            children: [
              Text(
                'Show more',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  decoration: TextDecoration.underline,
                  decorationThickness: 3.0,
                  height: 1.5,
                ),
              )
            ],
          )),
    );
  }

  Align buildRule(PropertySuccess propertyState) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(23, 20, 23, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Check-in after: ${propertyState.property.checkInAfter}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "Check-out before: ${propertyState.property.checkOutBefore}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 5),
            Text(
              'Maximum guest: ${propertyState.property.maximumGuest} ',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }

  Padding buildTilteRule() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(23, 20, 23, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "House rules",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Padding buildMeetHost(PropertySuccess propertyState, double startArv) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        height: 200,
        width: double.infinity,
        padding: const EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.white,
            width: 0.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(2, 3),
            ),
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    child: ClipOval(
                      child: propertyState.property.user?.avatar != null &&
                              propertyState.property.user!.avatar!.isNotEmpty
                          ? Image.network(
                              propertyState.property.user!.avatar!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            )
                          : CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.grey.shade300,
                              child: Text(
                                propertyState
                                        .property.user!.firstName!.isNotEmpty
                                    ? propertyState.property.user!.firstName![0]
                                        .toUpperCase()
                                    : '?',
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${propertyState.property.user!.firstName} ${propertyState.property.user!.lastName}",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BlocBuilder<ReviewCubit, ReviewState>(
                      builder: (context, state) {
                        if (state is ReviewLoading) {
                          return const CircularProgressIndicator();
                        } else if (state is ReviewSuccess) {
                          final customPaging = state.custom_paging;
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '${customPaging.totalCount}',
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const Row(
                                children: [
                                  Text(
                                    'reviews',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              )
                            ],
                          );
                        } else if (state is ReviewFailure) {
                          return Text(state.message,
                              style: const TextStyle(color: Colors.red));
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    const SizedBox(height: 8),
                    Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              startArv.toString(),
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            const Icon(
                              Icons.star,
                              size: 18,
                            ),
                          ],
                        ),
                        const Row(
                          children: [
                            Text(
                              "ratings",
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      () {
                        final hostTime = calculateHostTime(
                            propertyState.property.user!.createdAt);
                        final years = hostTime['years'] ?? 0;
                        final months = hostTime['months'] ?? 0;

                        if (years > 0) {
                          return "$years years hosting";
                        } else if (months > 0) {
                          return "$months months hosting";
                        } else {
                          return "Host new";
                        }
                      }(),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding buildTilteHost() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(23, 10, 23, 20),
      child: Row(
        children: [
          Text(
            "Meet your host",
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  BlocBuilder<DateBookingCubit, DateBookingState> buildCheckCalendar(
      PropertySuccess propertyState, double startArv) {
    return BlocBuilder<DateBookingCubit, DateBookingState>(
        builder: (context, state) {
      final startDate = context.read<DateBookingCubit>().startDate;
      final endDate = context.read<DateBookingCubit>().endDate;
      return ElevatedButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (BuildContext context) {
                return DatePickerModal(
                  startArv: startArv,
                );
              },
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white, // Màu nền
            minimumSize: const Size(500, 50),

            elevation: 0,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Row(children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Check calendar',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  startDate != null && endDate != null
                      ? formatDateRange(startDate, endDate)
                      : const Text(""),
                ],
              ),
              const Spacer(),
              const Icon(
                Icons.arrow_right,
                size: 40,
              )
            ]),
          ));
    });
  }

  ElevatedButton buildShowAbout(BuildContext context, String aboutProperty,
      PropertySuccess propertyState) {
    return ElevatedButton(
        onPressed: () {
          showModalBottomSheet(
            backgroundColor: Colors.white,
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return DraggableScrollableSheet(
                expand: false,
                initialChildSize: 1,
                minChildSize: 0.9,
                maxChildSize: 1,
                builder:
                    (BuildContext context, ScrollController scrollController) {
                  return SingleChildScrollView(
                    controller: scrollController,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back, size: 25),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                'About of the property',
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.all(20),
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
                                Html(
                                  data: aboutProperty,
                                  style: {
                                    "*": Style(
                                      fontSize: FontSize(16),
                                    ),
                                  },
                                ),
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
                                  data: propertyState.property.guestAccess,
                                  style: {
                                    "*": Style(
                                      fontSize: FontSize(16),
                                    ),
                                  },
                                ),
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
                                  data: propertyState.property.detailToNote,
                                  style: {
                                    "*": Style(
                                      fontSize: FontSize(16),
                                    ),
                                  },
                                ),
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
          elevation: 0,
        ),
        child: const Row(
          children: [
            Text(
              'Show more about place',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                decoration: TextDecoration.underline,
                decorationThickness: 3.0,
                height: 1.5,
              ),
            )
          ],
        ));
  }

  Padding buildAbout(String aboutProperty) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10.0, 16, 0.0),
      child: Html(
        data: limitTextTo300Words(aboutProperty),
        style: {
          "*": Style(
            fontSize: FontSize(16),
          ),
        },
      ),
    );
  }

  Padding buildShowAmenity(
      BuildContext context, PropertySuccess propertyState) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: ElevatedButton(
        onPressed: () {
          showModalBottomSheet(
            backgroundColor: Colors.white,
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
            ),
            builder: (BuildContext context) {
              return DraggableScrollableSheet(
                expand: false,
                initialChildSize: 1,
                minChildSize: 0.9,
                maxChildSize: 1,
                builder:
                    (BuildContext context, ScrollController scrollController) {
                  return SingleChildScrollView(
                    controller: scrollController,
                    // Kết nối với draggable scroll
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    icon:
                                        const Icon(Icons.arrow_back, size: 23),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  const SizedBox(width: 4),
                                  const Text(
                                    'What this place offers',
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          for (var type in propertyState.property.amenity
                              .map((amenity) => amenity.type)
                              .toSet()) ...[
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                type,
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.w600),
                              ),
                            ),
                            for (var amenity in propertyState.property.amenity
                                .where((amenity) => amenity.type == type))
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 12, 20, 12),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Image.network(
                                          amenity.image,
                                          width: 40,
                                          height: 40,
                                          fit: BoxFit.cover,
                                        ),
                                        const SizedBox(width: 16),
                                        Text(
                                          amenity.name,
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                      ],
                                    ),
                                    const Column(
                                      children: [
                                        Divider(
                                            thickness: 1,
                                            color: Colors.black12),
                                      ],
                                    )
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
              color: Colors.black12, // Màu của border
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
    );
  }

  Padding buildViewAmenity(PropertySuccess propertyState) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20, 10.0),
      child: ListView.builder(
        itemCount: 5,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
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
                  child: Text(
                    amenity.name,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Padding buildTilteOffers() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(20.0, 20.0, 0.0, 0.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("What this place offers",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))
        ],
      ),
    );
  }

  Padding buildAmenity(PropertySuccess propertyState) {
    return Padding(
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
                            ? propertyState.property.user!.firstName![0]
                                .toUpperCase()
                            : '?',
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            " ${propertyState.property.user?.firstName} ${propertyState.property.user?.lastName}",
            style: const TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }

  Padding buildAddress(PropertySuccess propertyState, String addressCode,
      Category? category, double startArv) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            children: [
              Text(
                "${propertyState.property.propertyTitle} with ${propertyState.property.propertyType == 'sharedroom' ? 'Share room' : propertyState.property.propertyType == 'hottel' ? 'Hotel' : 'Full house'}",
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
                  Text(
                    " ${propertyState.property.maximumGuest} clients ",
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
                  Text(
                    " ${propertyState.property.numberOfBedRoom} bedroom ",
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
                  Text(
                    " ${propertyState.property.numberOfBed} beds ",
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
                  Text(
                    " ${propertyState.property.numberOfBathRoom} bathroom",
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 10, 4, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.star, size: 23),
                Text(
                  startArv.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                const Icon(Icons.circle, size: 4),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BlocBuilder<ReviewCubit, ReviewState>(
                          builder: (context, state) {
                            if (state is ReviewLoading) {
                              return const CircularProgressIndicator();
                            } else if (state is ReviewSuccess) {
                              final customPaging = state.custom_paging;
                              return Row(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '${customPaging.totalCount}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 3,
                                  ),
                                  const Row(
                                    children: [
                                      Text(
                                        'reviews',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  )
                                ],
                              );
                            } else if (state is ReviewFailure) {
                              return Text(state.message,
                                  style: const TextStyle(color: Colors.red));
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PropertyImagesView buildPropertyImagesView(PropertySuccess propertyState) {
    return PropertyImagesView(
      images: propertyState.property.propertyImages,
      initialIndex: 0,
    );
  }
}