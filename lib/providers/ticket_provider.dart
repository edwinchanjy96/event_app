import 'dart:convert';

import 'package:event_app/models/ticket_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TicketProvider with ChangeNotifier {
  List<TicketModel> _ticketList = [];
  List<TicketModel> get ticketList => _ticketList;

  bool _loaded = false;
  bool get loaded => _loaded;

  // int _currentPage = 1;
  // int get currentPage => _currentPage;
  //
  // int _totalPages = 0;
  // int get totalPages => _totalPages;

  TicketProvider(){
    populateTickets();
  }

  Future retrieveTickets() async {
    var url = Uri.parse(
        'https://app.ticketmaster.com/discovery/v2/events?apikey=7elxdku9GGG5k8j0Xm8KWdANDgecHMV0&locale=*&page=1&size=30');
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var result = json.decode(response.body);
        return result;
      } else {
        print('[getTickets] : Failed to retrieve.');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  populateTickets() async {
    List<TicketModel> item = [];
    retrieveTickets().then((value) {
      if(value != null){
        if (value['_embedded']['events'] != null) {
          (value['_embedded']['events'] as List).forEach((element) {
            item.add(TicketModel.fromJson(element));
          });

          _ticketList = item;
          _loaded = true;
          notifyListeners();
        }
      }
    });
  }

  Future searchTickets(String keyword) async {
    var url = Uri.parse(
        'https://app.ticketmaster.com/discovery/v2/events?apikey=7elxdku9GGG5k8j0Xm8KWdANDgecHMV0&locale=*&page=1&size=30&keyword=$keyword');
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var result = json.decode(response.body);
        return result;
      } else {
        print('[getTickets] : Failed to retrieve.');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  refreshList () async {
    _loaded = false;
    _ticketList.clear();
    notifyListeners();
    List<TicketModel> item = [];
    retrieveTickets().then((value) {
      if(value != null){
        if (value['_embedded']['events'] != null) {
          (value['_embedded']['events'] as List).forEach((element) {
            item.add(TicketModel.fromJson(element));
          });

          _ticketList = item;
          _loaded = true;

          notifyListeners();
        }
      }
    });
  }

  submitSearch (String keyword) async {
    _loaded = false;
    _ticketList.clear();
    notifyListeners();
    List<TicketModel> item = [];
    searchTickets(keyword).then((value) {
      if(value != null){
        if (value['_embedded'] != null) {
          (value['_embedded']['events'] as List).forEach((element) {
            item.add(TicketModel.fromJson(element));
          });

          _ticketList = item;
          _loaded = true;
        } else {
          _ticketList = [];
          _loaded = true;
        }
        notifyListeners();
      }
    });
  }
}
