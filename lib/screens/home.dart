import 'package:event_app/models/ticket_model.dart';
import 'package:event_app/providers/ticket_provider.dart';
import 'package:event_app/screens/event_detail_screen.dart';
import 'package:event_app/widgets/event_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late SearchBar searchBar;

  String keyword = '';
  bool hasKeyword = false;

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
        title: Text('Events'), actions: [searchBar.getSearchAction(context)]);
  }

  void onSubmitted(String value) {
    final ticketProvider = Provider.of<TicketProvider>(context, listen: false);
    ticketProvider.submitSearch(value);
    setState(() {
      keyword = value;
      hasKeyword = true;
    });
    // setState(() => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: new Text('You wrote $value!'))));
  }

  _HomeState() {
    searchBar = new SearchBar(
        inBar: false,
        buildDefaultAppBar: buildAppBar,
        setState: setState,
        hintText: 'Search for artists, venues and events',
        onSubmitted: onSubmitted,
        onCleared: () {
          final ticketProvider =
              Provider.of<TicketProvider>(context, listen: false);
          ticketProvider.refreshList();
        },
        onClosed: () {
          // final ticketProvider = Provider.of<TicketProvider>(context, listen: false);
          // ticketProvider.refreshList();
        });
  }

  @override
  Widget build(BuildContext context) {
    final ticketProvider = Provider.of<TicketProvider>(context, listen: false);
    return Scaffold(
      appBar: searchBar.build(context),
      body: RefreshIndicator(
        onRefresh: () async {
          ticketProvider.refreshList();
        },
        child: Container(
            // width: double.infinity,
            // height: double.infinity,color
            color: Colors.grey.shade50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Visibility(
                    visible: hasKeyword,
                    child: Card(
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        alignment: WrapAlignment.center,
                        children: [
                          SizedBox(
                            width: 8,
                          ),
                          Text('Keyword: $keyword'),
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                hasKeyword = false;
                                keyword = '';
                              });
                              ticketProvider.refreshList();
                            },
                          )
                        ],
                      ),
                    )),
                Consumer<TicketProvider>(
                  builder: (context, ticketProvider, child) {
                    if (!ticketProvider.loaded)
                      return Stack(
                        children: [
                          Center(
                            child: CircularProgressIndicator(),
                          ),
                        ],
                      );
                    else if (ticketProvider.ticketList.isEmpty)
                      return Center(
                          child: Text('There is no ticket available.'));
                    else
                      return Expanded(
                        child: ListView.builder(
                            itemCount: ticketProvider.ticketList.length,
                            itemBuilder: (context, index) {
                              return EventItem(
                                item: ticketProvider.ticketList[index],
                                onTapCallback: () {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) => EventDetailScreen(
                                              ticket: ticketProvider
                                                  .ticketList[index],
                                            )),
                                  );
                                },
                              );
                            }),
                      );
                  },
                ),
              ],
            )),
      ),
    );
  }
}
