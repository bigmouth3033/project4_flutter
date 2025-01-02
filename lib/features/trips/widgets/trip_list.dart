import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:project4_flutter/features/trips/models/booking_minimize_dto.dart';

import 'package:project4_flutter/features/trips/models/trip_count.dart';
import 'package:project4_flutter/features/trips/widgets/booking_detail.dart';
import 'package:project4_flutter/shared/widgets/loading_icon.dart';

import '../bloc/trip_cubit/trip_cubit.dart';
import '../bloc/trip_cubit/trip_state.dart';

const months = [
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December",
];

class TripList extends StatefulWidget {
  const TripList(this.selectedDateRange, {super.key});

  final DateTimeRange selectedDateRange;

  @override
  State<TripList> createState() => TripListState();
}

class TripListState extends State<TripList> {
  List<BookingMinimizeDto> _bookingList = [];
  final _myController = ScrollController();

  String status = "checkout";

  void _myScrollListener() {
    if (_myController.offset >= _myController.position.maxScrollExtent &&
        !_myController.position.outOfRange) {
      reRender(status, widget.selectedDateRange);
    }
    if (_myController.offset <= _myController.position.minScrollExtent &&
        !_myController.position.outOfRange) {
      print("List top");
    }
  }

  List<Map<String, String>> listStatus = [
    {'label': 'Checking out', 'value': 'checkout'},
    {'label': 'Currently Stay-in', 'value': 'stayin'},
    {'label': 'Upcoming', 'value': 'upcoming'},
    {'label': 'Pending review', 'value': 'pending'},
    {'label': 'Stay-in history', 'value': 'history'}
  ];

  void reRender(status, selectedDateRange) {
    var start = selectedDateRange.start;
    var end = selectedDateRange.end;

    context.read<TripCubit>().getBookingList(
        status,
        DateFormat('yyyy-MM-dd').format(start),
        DateFormat('yyyy-MM-dd').format(end));
  }

  void getCount(selectedDateRange) {
    var start = selectedDateRange.start;
    var end = selectedDateRange.end;
    context.read<TripCubit>().getBookingCount(
        DateFormat('yyyy-MM-dd').format(start),
        DateFormat('yyyy-MM-dd').format(end));
  }

  @override
  void initState() {
    super.initState();
    _myController.addListener(_myScrollListener);
    reRender(status, widget.selectedDateRange);
    getCount(widget.selectedDateRange);
  }

  String returnNothing(status) {
    if (status == "checkout") {
      return "You don’t have any stay-in currently checkout.";
    }
    if (status == "stayin") {
      return "You don’t have stay-in today.";
    }
    if (status == "upcoming") {
      return "You don’t have upcoming stay-in";
    }
    if (status == "pending") {
      return "You don’t have any stay-in pending review.";
    }
    if (status == "history") {
      return "You currently don’t have any stay-in history.";
    }

    return "";
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TripCubit, TripState>(
      builder: (context, tripState) {
        _bookingList = context.read<TripCubit>().bookingList;

        var tripCount = context.read<TripCubit>().tripCount;

        List<List<int>> groupDate =
            _bookingList.fold<List<List<int>>>([], (previousValue, booking) {
          DateTime checkInDate = booking.checkInDay;

          int month = checkInDate.month;
          int year = checkInDate.year;

          bool isExist =
              previousValue.any((item) => item[0] == month && item[1] == year);

          // If not, add it
          if (!isExist) {
            previousValue.add([month, year]);
          }

          return previousValue;
        });

        bool isLoading = tripState is TripLoading;
        return buildBodyScaffold(groupDate, isLoading, tripCount);
      },
      listener: (context, state) {
        if (state is TripDateUpdated) {
          DateTimeRange selectedDateRange = state.selectedDateRange;
          getCount(selectedDateRange);
          reRender(status, selectedDateRange);
        }
      },
    );
  }

  Scaffold buildBodyScaffold(
      List<List<int>> groupDate, bool isLoading, TripCount? tripCount) {
    return Scaffold(
      body: (_bookingList.isNotEmpty)
          ? Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    controller: _myController,
                    itemCount: groupDate.length,
                    itemBuilder: (context, index) {
                      var [month, year] = groupDate[index];
                      List<BookingMinimizeDto> selectedBooking =
                          _bookingList.where(
                        (element) {
                          DateTime checkInDate = element.checkInDay;

                          int bookingMonth = checkInDate.month;
                          int bookingYear = checkInDate.year;

                          if (bookingMonth == month && bookingYear == year) {
                            return true;
                          }
                          return false;
                        },
                      ).toList();
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color.fromARGB(25, 0, 0, 0),
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Text(
                                "${months[month - 1]}, $year",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            ...selectedBooking.map(
                              (e) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) {
                                        return BookingDetail(e);
                                      },
                                    ));
                                  },
                                  splashColor: Colors.blue
                                      .withOpacity(0.3), // Ripple effect color
                                  highlightColor:
                                      Colors.blue.withOpacity(0.1), // Hold
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AdvancedAvatar(
                                            name: "room",
                                            foregroundDecoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.red,
                                                    width: 2),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            statusAlignment: Alignment.topRight,
                                            image: NetworkImage(
                                                e.property.propertyImages[0]),
                                            size: 100,
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          ConstrainedBox(
                                            constraints: const BoxConstraints(
                                                maxWidth: 170),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  e.property.propertyTitle,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                Text(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  "Hosted by ${e.property.user.firstName}",
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                Text(
                                                    softWrap: true,
                                                    "${e.checkInDay.day} ${months[e.checkInDay.month - 1].substring(0, 3)} ${e.checkOutDay.year} - ${e.checkOutDay.day} ${months[e.checkOutDay.month - 1].substring(0, 3)} ${e.checkOutDay.year}")
                                              ],
                                            ),
                                          )
                                        ]),
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
                if (isLoading) const LoadingIcon(size: 40),
              ],
            )
          : !isLoading
              ? Center(
                  child: Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width * 0.8,
                    padding: const EdgeInsets.all(20),
                    decoration:
                        const BoxDecoration(color: Color.fromARGB(10, 0, 0, 0)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const HugeIcon(
                          icon: HugeIcons.strokeRoundedAlertCircle,
                          color: Colors.black,
                          size: 34.0,
                        ),
                        Text(
                          returnNothing(status),
                          textAlign: TextAlign.center,
                          softWrap: true,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                )
              : const LoadingIcon(size: 50),
      bottomNavigationBar: buildBottomContainer(tripCount),
    );
  }

  Container buildBottomContainer(TripCount? tripCount) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(
              top: BorderSide(color: Color.fromARGB(25, 0, 0, 0), width: 1))),
      padding: const EdgeInsets.all(10),
      child: SizedBox(
        height: 50,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: listStatus.length,
          itemBuilder: (context, index) {
            int count(status) {
              if (tripCount != null) {
                if (status == "checkout") {
                  return tripCount.checkoutCount;
                }
                if (status == "stayin") {
                  return tripCount.stayInCount;
                }
                if (status == "upcoming") {
                  return tripCount.upcomingCount;
                }
                if (status == "pending") {
                  return tripCount.pendingCount;
                }
                if (status == "history") {
                  return tripCount.historyCount;
                }
              }
              return 0;
            }

            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    backgroundColor: status == listStatus[index]['value']
                        ? Colors.black
                        : null),
                onPressed: () {
                  setState(() {
                    status = listStatus[index]['value']!;
                  });
                  reRender(
                      listStatus[index]['value']!, widget.selectedDateRange);
                },
                child: Text(
                  tripCount == null
                      ? listStatus[index]['label']!
                      : "${listStatus[index]['label']!} (${count(listStatus[index]['value'])})",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: status == listStatus[index]['value']
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
