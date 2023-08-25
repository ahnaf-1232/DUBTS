import 'package:dubts/services/databases.dart';
import 'package:flutter/material.dart';

class AddBusData {
  dynamic bus_details = {
    'Basanta': {
      'downTrip_buses': {
        [
          {
            'bus_code': '5992',
            'ending_point': 0,
            'staring_point': 4,
            'time': TimeOfDay(hour: 12, minute: 35),
          },
          {
            'bus_code': '7303',
            'ending_point': 0,
            'staring_point': 4,
            'time': TimeOfDay(hour: 13, minute: 35),
          },
          {
            'bus_code': '6121',
            'ending_point': 0,
            'staring_point': 4,
            'time': TimeOfDay(hour: 14, minute: 35),
          },
          {
            'bus_code': '5973',
            'ending_point': 0,
            'staring_point': 4,
            'time': TimeOfDay(hour: 15, minute: 35),
          },
          {
            'bus_code': '6116',
            'ending_point': 0,
            'staring_point': 4,
            'time': TimeOfDay(hour: 16, minute: 35),
          },
          {
            'bus_code': '5817',
            'ending_point': 0,
            'staring_point': 4,
            'time': TimeOfDay(hour: 17, minute: 35),
          },
        ]
      },
      'upTrip_buses': {
        [
          {
            'bus_code': '6071',
            'ending_point': 4,
            'staring_point': 0,
            'time': TimeOfDay(hour: 7, minute: 00),
          },
          {
            'bus_code': '5973',
            'ending_point': 4,
            'staring_point': 0,
            'time': TimeOfDay(hour: 7, minute: 40),
          },
          {
            'bus_code': '6116',
            'ending_point': 4,
            'staring_point': 0,
            'time': TimeOfDay(hour: 8, minute: 20),
          },
          {
            'bus_code': '5849',
            'ending_point': 4,
            'staring_point': 0,
            'time': TimeOfDay(hour: 9, minute: 00),
          },
          {
            'bus_code': '5973',
            'ending_point': 4,
            'staring_point': 0,
            'time': TimeOfDay(hour: 10, minute: 00),
          },
        ],
      },
      'route': [
        'Khilgaon Police Fari',
        'Malibagh Community Center',
        'Hazipara Petrol Pump',
        'Rampura Bazer',
        'Rampura TV Center',
      ],
      'name': 'Basanta',
    },
  };

  Future<void> addBusDetails() async {
    print('Adding bus data');
    await DatabaseService().addBusDetailsToDB(bus_details);
  }
}

// 'up_trip': {
// 'Kinchit': {
// '7:00 AM': {
// 'route': ['Arambagh', 'Kamalapur', 'Ideal School and College gate', 'Rajarbagh', 'Malibagh', 'Mouchak', 'Wireless', 'VC Chattar', 'Curzon Hall'],
// 'starting_point': 'Arambagh',
// 'starting_time': TimeOfDay(hour: 7, minute: 00),
// },
// '8:00 AM': {
// 'route': ['Arambagh', 'Kamalapur', 'Ideal School and College gate', 'Rajarbagh', 'Malibagh', 'Mouchak', 'Wireless', 'VC Chattar', 'Curzon Hall'],
// 'starting_point': 'Arambagh',
// 'starting_time': TimeOfDay(hour: 8, minute: 00),
//
// },
// '8:50 AM': {
// 'route': ['Arambagh', 'Kamalapur', 'Ideal School and College gate', 'Rajarbagh', 'Malibagh', 'Mouchak', 'Wireless', 'VC Chattar', 'Curzon Hall'],
// 'starting_point': 'Arambagh',
// 'starting_time': TimeOfDay(hour: 8, minute: 50),
// },
// '9:50 AM': {
// 'route': ['Arambagh', 'Kamalapur', 'Ideal School and College gate', 'Rajarbagh', 'Malibagh', 'Mouchak', 'Wireless', 'VC Chattar', 'Curzon Hall'],
// 'starting_point': 'Arambagh',
// 'starting_time': TimeOfDay(hour: 9, minute: 50),
// },
// },
// 'Khanika': {
// '5:50 AM': {
// 'route': ['Shibbari', 'Chourasta', 'Bypass', 'Maleker Bari', 'Signboard', 'Board Bazer', 'Boro Bari', 'College Gate', 'Station Road', 'Tongi Bazer', 'Abdullahpur', 'House Building', 'Azampur', 'DU'],
// 'starting_point': 'Shibbari',
// 'bus_code': '6249',
// 'starting_time': TimeOfDay(hour: 5, minute: 50),
// },
// '6:10 AM': {
// 'route': ['Shibbari', 'Chourasta', 'Bypass', 'Maleker Bari', 'Signboard', 'Board Bazer', 'Boro Bari', 'College Gate', 'Station Road', 'Tongi Bazer', 'Abdullahpur', 'House Building', 'Azampur', 'DU'],
// 'starting_point': 'Shibbari',
// 'bus_code': '6213',
// 'starting_time': TimeOfDay(hour: 6, minute: 10),
// },
// '6:20 AM': {
// 'route': ['College Gate', 'Station Road', 'Tongi Bazer', 'Abdullahpur', 'House Building', 'Azampur', 'DU'],
// 'starting_point': 'College Gate',
// 'bus_code': '6262',
// 'starting_time': TimeOfDay(hour: 6, minute: 20),
// },
// '6:40 AM': {
// 'route': ['College Gate', 'Station Road', 'Tongi Bazer', 'Abdullahpur', 'House Building', 'Azampur','DU'],
// 'starting_point': 'College Gate',
// 'bus_code': '5709',
// 'starting_time': TimeOfDay(hour: 6, minute: 40),
// },
// '7:00 AM': {
// 'route': ['College Gate', 'Station Road', 'Tongi Bazer', 'Abdullahpur', 'House Building', 'Azampur', 'DU'],
// 'starting_point': 'College Gate',
// 'bus_code': '5724',
// 'starting_time': TimeOfDay(hour: 7, minute: 00),
// },
// '7:30 AM': {
// 'route': ['College Gate', 'Station Road', 'Tongi Bazer', 'Abdullahpur', 'House Building', 'Azampur', 'DU'],
// 'starting_point': 'College Gate',
// 'bus_code': '6203',
// 'starting_time': TimeOfDay(hour: 7, minute: 30),
// },
// '8:15 AM': {
// 'route': ['College Gate', 'Station Road', 'Tongi Bazer', 'Abdullahpur', 'House Building', 'Azampur', 'DU'],
// 'starting_point': 'College Gate',
// 'bus_code': '6824',
// 'starting_time': TimeOfDay(hour: 8, minute: 15),
// },
// '9:00 AM': {
// 'route': ['College Gate', 'Station Road', 'Tongi Bazer', 'Abdullahpur', 'House Building', 'Azampur', 'DU'],
// 'starting_point': 'College Gate',
// 'bus_code': '6230',
// 'starting_time': TimeOfDay(hour: 9, minute: 00),
// },
//
// }
//
// },
// 'down_trip': {
// 'Kinchit': {
// '12:30 PM': {
// 'route': ['Curzon Hall', 'VC Chattar', 'Wireless', 'Mouchak', 'Malibagh', 'Rajarbagh', 'Ideal School and College gate', 'Kamalapur', 'Arambagh'],
// 'starting_point': 'Curzon Hall',
// 'starting_time': TimeOfDay(hour: 12, minute: 30),
// },
// '1:30 AM': {
// 'route': ['Curzon Hall', 'VC Chattar', 'Wireless', 'Mouchak', 'Malibagh', 'Rajarbagh', 'Ideal School and College gate', 'Kamalapur', 'Arambagh'],
// 'starting_point': 'Curzon Hall',
// 'starting_time': TimeOfDay(hour: 13, minute: 30),
// },
// '2:30 AM': {
// 'route': ['Curzon Hall', 'VC Chattar', 'Wireless', 'Mouchak', 'Malibagh', 'Rajarbagh', 'Ideal School and College gate', 'Kamalapur', 'Arambagh'],
// 'starting_point': 'Curzon Hall',
// 'starting_time': TimeOfDay(hour: 14, minute: 30),
// },
// '3:20 AM': {
// 'route': ['Curzon Hall', 'VC Chattar', 'Wireless', 'Mouchak', 'Malibagh', 'Rajarbagh', 'Ideal School and College gate', 'Kamalapur', 'Arambagh'],
// 'starting_point': 'Curzon Hall',
// 'starting_time': TimeOfDay(hour: 15, minute: 20),
// },
// '4:20 AM': {
// 'route': ['Curzon Hall', 'VC Chattar', 'Wireless', 'Mouchak', 'Malibagh', 'Rajarbagh', 'Ideal School and College gate', 'Kamalapur', 'Arambagh'],
// 'starting_point': 'Curzon Hall',
// 'starting_time': TimeOfDay(hour: 16, minute: 20),
// },
// '5:30 AM': {
// 'route': ['Curzon Hall', 'VC Chattar', 'Wireless', 'Mouchak', 'Malibagh', 'Rajarbagh', 'Ideal School and College gate', 'Kamalapur', 'Arambagh'],
// 'starting_point': 'Curzon Hall',
// 'starting_time': TimeOfDay(hour: 17, minute: 30),
// },
// },
// 'Khanika': {
// '12:15 PM': {
// 'route': ['Curzon Hall', 'Azampur', 'House Building', 'Abdullahpur', 'Tongi Bazer', 'Station Road', 'College Gate'],
// 'starting_point': 'Curzon Hall',
// 'bus_code': '6262',
// 'starting_time': TimeOfDay(hour: 12, minute: 15),
// },
// '1:10 PM': {
// 'route': ['Curzon Hall', 'Azampur', 'House Building', 'Abdullahpur', 'Tongi Bazer', 'Station Road', 'College Gate'],
// 'starting_point': 'Curzon Hall',
// 'bus_code': '5709',
// 'starting_time': TimeOfDay(hour: 13, minute: 10),
// },
// '1:50 PM': {
// 'route': ['Mall Chattar', 'Azampur', 'House Building', 'Abdullahpur', 'Tongi Bazer', 'Station Road', 'College Gate'],
// 'starting_point': 'Mall Chattar',
// 'bus_code': '5724',
// 'starting_time': TimeOfDay(hour: 13, minute: 50),
// },
// '2:30 PM': {
// 'route': ['Curzon Hall', 'Azampur', 'House Building', 'Abdullahpur', 'Tongi Bazer', 'Station Road', 'College Gate', 'Boro Bari', 'Board Bazer', 'Signboard', 'Maleker Bari', 'Bypass', 'Chourasta', 'Shibbari'],
// 'starting_point': 'Curzon Hall',
// 'bus_code': '6249',
// 'starting_time': TimeOfDay(hour: 14, minute: 30),
// },
// '3:30 PM': {
// 'route': ['VC Chattar', 'Azampur', 'House Building', 'Abdullahpur', 'Tongi Bazer', 'Station Road', 'College Gate'],
// 'starting_point': 'VC Chattar',
// 'bus_code': '6203',
// 'starting_time': TimeOfDay(hour: 15, minute: 30),
// },
// '4:15 PM': {
// 'route': ['Curzon Hall', 'Azampur', 'House Building', 'Abdullahpur', 'Tongi Bazer', 'Station Road', 'College Gate'],
// 'starting_point': 'Curzon Hall',
// 'bus_code': '6230',
// 'starting_time': TimeOfDay(hour: 16, minute: 15),
// },
// '5:00 PM': {
// 'route': ['Curzon Hall', 'Azampur', 'House Building', 'Abdullahpur', 'Tongi Bazer', 'Station Road', 'College Gate', 'Boro Bari', 'Board Bazer', 'Signboard', 'Maleker Bari', 'Bypass', 'Chourasta', 'Shibbari'],
// 'starting_point': 'Curzon Hall',
// 'bus_code': '6213',
// 'starting_time': TimeOfDay(hour: 17, minute: 00),
// },
// '5:40 PM': {
// 'route': ['Curzon Hall', 'Azampur', 'House Building', 'Abdullahpur', 'Tongi Bazer', 'Station Road', 'College Gate'],
// 'starting_point': 'Curzon Hall',
// 'bus_code': '6824',
// 'starting_time': TimeOfDay(hour: 17, minute: 40),
// },
// },
// },
