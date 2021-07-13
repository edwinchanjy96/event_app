import 'package:event_app/models/ticket_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transparent_image/transparent_image.dart';

enum statusCode {onsale, offsale, canceled, postponed, rescheduled}

class EventItem extends StatelessWidget {
  final TicketModel item;
  final Function onTapCallback;

  EventItem({Key? key, required this.item, required this.onTapCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTapCallback();
      },
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: item.ticketImages.first.url,
                      fit: BoxFit.cover,
                      height: 120,
                      width: 120,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 14,
                              ),
                              Expanded(
                                  child: Text(
                                '${item.location?.name}',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                              )),
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            '${item.date.start.dateTime}',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                          // Text(
                          //   '${item.date.start.localTime}',
                          //   style: TextStyle(fontSize: 14),
                          //   maxLines: 4,
                          //   overflow: TextOverflow.ellipsis,
                          // ),
                          SizedBox(
                            height: 8,
                          ),
                          Visibility(
                            visible: item.sales.public != null && item.sales.public!.startDateTime.isNotEmpty,
                            child: RichText(
                              text: TextSpan(
                                text: 'Sales from\n',
                                style: TextStyle(fontSize: 13, color: Colors.black),
                                // style: DefaultTextStyle.of(context).style,
                                children: <TextSpan>[
                                  TextSpan(
                                      text: '${item.sales.public?.startDateTime}',
                                      style: TextStyle(fontWeight: FontWeight.bold)),
                                  TextSpan(text: ' to '),
                                  TextSpan(
                                      text: '${item.sales.public?.endDateTime}',
                                      style: TextStyle(fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 8,
                          ),
                          Visibility(
                            visible: item.products!.isNotEmpty,
                            child: Text(
                              'Add-ons Available',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.blue),
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                height: 65,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                      DetailContainer(
                          title: 'Price',
                          details:
                          item.priceRange != null ? '${item.priceRange?.minPrice} - ${item.priceRange?.maxPrice} ${item.priceRange?.currency}' : 'N/A'),
                    if (item.ageRestrictions != null)
                    SizedBox(
                      width: 12,
                    ),
                    if (item.ageRestrictions != null)
                    DetailContainer(
                        title: 'Age Restricted',
                        details: '${item.ageRestrictions?.legalAgeEnforced}' == 'false' ? 'NO' : 'YES'),
                    SizedBox(
                      width: 12,
                    ),
                    StatusContainer(code: item.date.status,)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DetailContainer extends StatelessWidget {
  final String title;
  final String details;

  DetailContainer(
      {Key? key, required this.title, required this.details})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            Text(details, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13), textAlign: TextAlign.center,)
          ],
        ),
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
    return Expanded(
      child: Container(
        padding: EdgeInsets.fromLTRB(8, 16, 8, 16),
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
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
