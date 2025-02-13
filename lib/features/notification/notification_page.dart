import 'package:flutter/material.dart';
import 'package:gif/gif.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage>
    with TickerProviderStateMixin {
  late GifController controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = GifController(vsync: this);
    // this.context.read<NotificationCubit>().onGetData(
    //       context: context,
    //     );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: const SafeArea(
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            // CupertinoSliverRefreshControl(
            //   onRefresh: () async {
            //     context.read<NotificationCubit>().onGetData(
            //           context: context,
            //         );
            //   },
            // ),

            // BlocBuilder<NotificationCubit, AppState>(
            //   builder: (context, state) {
            //     if (state is FinishState<List<NotificationModel>>) {
            //       return SliverGroupedListView<NotificationModel, String>(
            //         elements: state.data,
            //         groupBy: (element) => Utils.getTimeAgo(
            //             dateTime: DateTime.parse(
            //                 element.timestamp!.toIso8601String())),

            //         groupSeparatorBuilder: (String groupByValue) => Container(
            //             color: Theme.of(context).colorScheme.secondaryContainer,
            //             height: 30,
            //             child: Center(child: Text(groupByValue))),
            //         indexedItemBuilder:
            //             (context, NotificationModel element, index) =>
            //                 NotifBubble(
            //           seen: index >= NotificationsState.numberOfNotifs,
            //           notificationModel: element,
            //         ),
            //         itemComparator: (item1, item2) => Utils.getTimeAgo(
            //                 dateTime: DateTime.parse(
            //                     item1.timestamp!.toIso8601String()))
            //             .compareTo(Utils.getTimeAgo(
            //                 dateTime: DateTime.parse(item2.timestamp!
            //                     .toIso8601String()))), // optional
            //         // optional
            //         order: GroupedListOrder.DESC, // optional
            //       );
            //     }
            //     if (state is PendingState) {
            //       return SliverFillRemaining(
            //         child: Container(
            //           child: Center(
            //             child: Gif(
            //               width: 250,
            //               height: 250,
            //               autostart: Autostart.loop,
            //               placeholder: (context) =>
            //                   const CupertinoActivityIndicator(),
            //               onFetchCompleted: () {
            //                 controller.reset();
            //                 controller.forward();
            //               },
            //               duration: Duration(milliseconds: 800),
            //               controller: controller,
            //               image: AssetImage(
            //                 "assets/gif/loading.gif",
            //               ),
            //             ),
            //           ),
            //         ),
            //       );
            //     }
            //     return SliverFillRemaining(
            //       child: Center(
            //         child: Text('Aucune notification'),
            //       ),
            //     );
            //   },
            // ),

            // for (int _i = 0; _i < 10; _i++)
            //   NotifBubble(
            //     seen: (_i % 2) == 0,
            //   ),
          ],
        ),
      ),
    );
  }
}
