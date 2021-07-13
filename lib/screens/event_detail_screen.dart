import 'package:carousel_slider/carousel_slider.dart';
import 'package:event_app/models/product_model.dart';
import 'package:event_app/models/sales_model.dart';
import 'package:event_app/models/ticket_model.dart';
import 'package:event_app/screens/view_seatmap_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';

enum statusCode {onsale, offsale, canceled, postponed, rescheduled}

class EventDetailScreen extends StatefulWidget {
  final TicketModel ticket;

  const EventDetailScreen({Key? key, required this.ticket}) : super(key: key);

  @override
  _EventDetailScreenState createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: Text('${widget.ticket.name}'),
      //   centerTitle: true,
      //   leading: IconButton(
      //     icon: Icon(Icons.arrow_back_ios),
      //     onPressed: () => Navigator.pop(context),
      //   ),
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(
                  widget.ticket.name,
                  textAlign: TextAlign.center,
                ),
                background: Image.network(
                  widget.ticket.ticketImages[2].url,
                  fit: BoxFit.cover,
                ),
                // CarouselSlider.builder(
                //     itemCount: widget.ticket.ticketImages.length,
                //     itemBuilder: (BuildContext context, int itemIndex,
                //             int pageViewIndex) =>
                //         Image.network(
                //           widget.ticket.ticketImages[itemIndex].url,
                //           fit: BoxFit.cover,
                //         ),
                //     options: CarouselOptions(
                //       height: 240,
                //       aspectRatio: 16 / 9,
                //       viewportFraction: 1,
                //       initialPage: 0,
                //       enableInfiniteScroll: true,
                //       reverse: false,
                //       autoPlay: true,
                //       autoPlayInterval: Duration(seconds: 3),
                //       autoPlayAnimationDuration: Duration(milliseconds: 800),
                //       autoPlayCurve: Curves.fastOutSlowIn,
                //       enlargeCenterPage: true,
                //       // onPageChanged: callbackFunction,
                //       scrollDirection: Axis.horizontal,
                //     ))
            ),
            expandedHeight: 240,
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                DetailGridWithIcon(
                  title: 'Location',
                  trailingIcon: IconButton(
                    icon: Icon(Icons.location_on_outlined),
                    onPressed: () async {
                      final availableMaps = await MapLauncher.installedMaps;
                      print(
                          availableMaps); // [AvailableMap { mapName: Google Maps, mapType: google }, ...]

                      await availableMaps.first.showMarker(
                        coords: Coords(
                            widget.ticket.location?.position.latitude ?? 0.0,
                            widget.ticket.location?.position.longitude ?? 0.0),
                        title: "${widget.ticket.location?.name}",
                      );
                    },
                  ),
                  infoWidget: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${widget.ticket.location?.name}'),
                      Text('${widget.ticket.location?.address.line1}'),
                      Text('${widget.ticket.location?.city?.name}'),
                      Text('${widget.ticket.location?.postalCode}'),
                      Text('${widget.ticket.location?.state?.name}'),
                      SizedBox(
                        height: 4,
                      ),
                      Text('${widget.ticket.date.start.dateTime}', style: TextStyle(fontWeight: FontWeight.bold),)
                    ],
                  ),
                ),
                PriceGrid(
                    title: 'Price',
                    status: widget.ticket.date.status,
                    startDateTime : widget.ticket.sales.public?.startDateTime ?? '',
                    endDateTime: widget.ticket.sales.public?.endDateTime ?? '',
                    info: widget.ticket.priceRange != null
                        ? '${widget.ticket.priceRange?.minPrice} - ${widget.ticket.priceRange?.maxPrice} ${widget.ticket.priceRange?.currency}'
                        : 'N/A'),
                if(widget.ticket.seatMap != null)
                SeatMapGrid(seatMapUrl: widget.ticket.seatMap?.staticUrl),
                if(widget.ticket.products!.isNotEmpty)
                ProductsGrid(products: widget.ticket.products),
                if(widget.ticket.sales.presales != null && widget.ticket.sales.presales!.isNotEmpty)
                PresalesGrid(presales: widget.ticket.sales.presales,),
                if(widget.ticket.info.isNotEmpty)
                DetailGrid(
                    title: 'Info',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    info: '${widget.ticket.info}'),
                if(widget.ticket.pleaseNote.isNotEmpty)
                DetailGrid(
                    title: 'Note',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    info: '${widget.ticket.pleaseNote}'),
                if(widget.ticket.accessibility != null)
                DetailGrid(
                    title:
                        'Accessibility (Ticket Limits: ${widget.ticket.accessibility?.ticketLimit})',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    info: '${widget.ticket.accessibility?.info}'),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints.tightFor(width: double.infinity),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (await canLaunch(widget.ticket.url)) {
                          launch(widget.ticket.url);
                        }
                      },
                      child: Text(
                        'BUY NOW',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w400),
                      ),
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100.0),
                            ),
                          ),
                          // backgroundColor: MaterialStateProperty.all(Colors.red),
                          padding: MaterialStateProperty.all(
                              EdgeInsets.fromLTRB(50, 16, 50, 16)),
                          textStyle: MaterialStateProperty.all(
                              TextStyle(fontSize: 30))),
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
}

class PriceGrid extends StatelessWidget {
  final String title;
  final String status;
  final String startDateTime;
  final String endDateTime;
  final String info;

  PriceGrid({Key? key, required this.title, required this.status, required this.startDateTime, required this.endDateTime, required this.info})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.fromLTRB(8, 20, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              Text(
                info,
                textAlign: TextAlign.justify,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              StatusContainer(code: status),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          if(startDateTime.isNotEmpty && endDateTime.isNotEmpty)
          RichText(
            text: TextSpan(
              text: 'Sales from ',
              style: TextStyle(fontSize: 14, color: Colors.black),
              // style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                TextSpan(
                    text: '${startDateTime}',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: ' to '),
                TextSpan(
                    text: '${endDateTime}',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DateGrid extends StatelessWidget {
  final String title;
  final String info;

  DateGrid({Key? key, required this.title, required this.info})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.fromLTRB(8, 20, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              Text(
                info,
                textAlign: TextAlign.justify,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class SeatMapGrid extends StatelessWidget {
  final String? seatMapUrl;

  const SeatMapGrid({Key? key, this.seatMapUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.fromLTRB(8, 20, 8, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Seat Map',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => ViewSeatmapScreen(
                        seatMapUrl: seatMapUrl,
                      )),
            ),
            child: Hero(
              tag: 'seatmap',
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: seatMapUrl ?? '',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text(
            'Map above does not reflect availability of tickets.',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
              'Seating charts reflect the general layout for the venue at this time, For some events, the layout and specific seat locations may vary without notice.')
        ],
      ),
    );
  }
}

class StatusContainer extends StatelessWidget {
  final String code;

  StatusContainer(
      {Key? key, required this.code})
      : super(key: key);


  Color colorDeterminer(String code){
    String onsale = statusCode.onsale.toString().split('.').last;
    String offsale = statusCode.offsale.toString().split('.').last;
    String canceled = statusCode.canceled.toString().split('.').last;
    String postponed = statusCode.postponed.toString().split('.').last;
    String rescheduled = statusCode.rescheduled.toString().split('.').last;

    if(code == onsale){
      return Colors.lightGreenAccent;
    } else if(code == offsale || code == canceled){
      return Colors.red;
    } else if(code == postponed || code == rescheduled){
      return Colors.orangeAccent;
    }
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: colorDeterminer(code),
        // border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            code.toUpperCase(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black),
          ),
        ],
      ),
    );
  }
}

class DetailGrid extends StatelessWidget {
  final String title;
  final String info;
  TextStyle? style = TextStyle(fontWeight: FontWeight.w500, fontSize: 20);

  DetailGrid({Key? key, required this.title, required this.info, this.style})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
            ],
          ),
          Text(
            info,
            textAlign: TextAlign.justify,
            style: style,
          )
        ],
      ),
    );
  }
}

class DetailGridWithIcon extends StatelessWidget {
  final String title;
  final Widget infoWidget;
  final Widget trailingIcon;

  DetailGridWithIcon(
      {Key? key,
      required this.title,
      required this.infoWidget,
      required this.trailingIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        width: double.infinity,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                  trailingIcon,
                ],
              ),
              infoWidget
            ]));
  }
}

class ProductsGrid extends StatefulWidget {
  List<ProductModel>? products;

  ProductsGrid({
    Key? key,
    this.products,
  }) : super(key: key);

  @override
  _ProductsGridState createState() => _ProductsGridState();
}

class _ProductsGridState extends State<ProductsGrid> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add-ons',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          ExpansionPanelList(
            elevation: 0,
            dividerColor: Colors.grey,
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                widget.products![index].isExpanded =
                    !widget.products![index].isExpanded;
              });
            },
            children: widget.products!.map((item) {
              return ExpansionPanel(
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return ListTile(
                      // leading: item.iconpic,
                      title: Text(
                    item.type,
                    textAlign: TextAlign.left,
                    style: new TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ));
                },
                isExpanded: item.isExpanded,
                body: Text(
                  item.name,
                  textAlign: TextAlign.center,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class PresalesGrid extends StatefulWidget {
  List<Presales>? presales;

  PresalesGrid({
    Key? key,
    this.presales,
  }) : super(key: key);

  @override
  _PresalesGridState createState() => _PresalesGridState();
}

class _PresalesGridState extends State<PresalesGrid> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Presales',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          ExpansionPanelList(
            elevation: 0,
            dividerColor: Colors.grey,
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                widget.presales![index].isExpanded =
                !widget.presales![index].isExpanded;
              });
            },
            children: widget.presales!.map((item) {
              return ExpansionPanel(
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return ListTile(
                      title: Text(
                        item.name,
                        textAlign: TextAlign.left,
                        style: new TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                  );
                },
                isExpanded: item.isExpanded,
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.description ?? 'No description',
                      textAlign: TextAlign.justify,
                      style: new TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      'From ${item.startDateTime} to ${item.endDateTime}',
                      textAlign: TextAlign.left,
                      style: new TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
