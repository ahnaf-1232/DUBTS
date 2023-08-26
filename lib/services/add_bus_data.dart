import 'package:dubts/services/databases.dart';
import 'package:flutter/material.dart';

class AddBusData {
  dynamic bus_details = {
    'Baishakhi': {
      'downTrip_buses': [
        {
          'bus_code': '6231',
          'ending_point': 11,
          'staring_point': 0,
          'time': '12:30 PM',
        },
        {
          'bus_code': '5817',
          'ending_point': 11,
          'staring_point': 0,
          'time': '01:15 PM',
        },
        {
          'bus_code': '5900',
          'ending_point': 11,
          'staring_point': 0,
          'time': '02:20 PM',
        },
        {
          'bus_code': '6204',
          'ending_point': 11,
          'staring_point': 0,
          'time': '03:30 PM',
        },
        {
          'bus_code': '5866',
          'ending_point': 11,
          'staring_point': 0,
          'time': '04:30 PM',
        },
        {
          'bus_code': '5899',
          'ending_point': 11,
          'staring_point': 0,
          'time': '05:00 PM',
        },
        {
          'bus_code': '6231',
          'ending_point': 11,
          'staring_point': 0,
          'time': '05:30 PM',
        },
      ],
      'upTrip_buses': [
        {
          'bus_code': '5900',
          'ending_point': 0,
          'staring_point': 12,
          'time': '06:30 AM',
        },
        {
          'bus_code': '5817',
          'ending_point': 0,
          'staring_point': 11,
          'time': '06:50 AM',
        },
        {
          'bus_code': '5867',
          'ending_point': 0,
          'staring_point': 11,
          'time': '07:30 AM',
        },
        {
          'bus_code': '6231',
          'ending_point': 0,
          'staring_point': 11,
          'time': '08:00 AM',
        },
        {
          'bus_code': '6204',
          'ending_point': 0,
          'staring_point': 11,
          'time': '08:45 AM',
        },
        {
          'bus_code': '6264',
          'ending_point': 0,
          'staring_point': 11,
          'time': '09:25 AM',
        },
        {
          'bus_code': '5900',
          'ending_point': 0,
          'staring_point': 11,
          'time': '10:00 AM',
        },
      ],
      'route': [
        'Campus',
        'Second Gate',
        'Taltola',
        'Shewrapara bus stand',
        'Kazipara over bridge',
        '10 number islami bank',
        'Water tank',
        '13 number',
        'Police staff college',
        'POlice college',
        '14 number',
        'Mili super market',
        'kochukhet',
      ],
      'name': 'Baishakhi',
    },
    'Basanta': {
      'downTrip_buses': [
        {
          'bus_code': '5992',
          'ending_point': 0,
          'staring_point': 5,
          'time': '12:35 PM',
        },
        {
          'bus_code': '7303',
          'ending_point': 0,
          'staring_point': 5,
          'time': '01:35 PM',
        },
        {
          'bus_code': '6121',
          'ending_point': 0,
          'staring_point': 5,
          'time': '02:35 PM',
        },
        {
          'bus_code': '5973',
          'ending_point': 0,
          'staring_point': 5,
          'time': '03:35 PM',
        },
        {
          'bus_code': '6116',
          'ending_point': 0,
          'staring_point': 5,
          'time': '04:35 PM',
        },
        {
          'bus_code': '5817',
          'ending_point': 0,
          'staring_point': 5,
          'time': '05:35 PM',
        },
      ],
      'upTrip_buses': [
        {
          'bus_code': '6071',
          'ending_point': 5,
          'staring_point': 0,
          'time': '07:00 AM',
        },
        {
          'bus_code': '5973',
          'ending_point': 5,
          'staring_point': 0,
          'time': '07:40 AM',
        },
        {
          'bus_code': '6116',
          'ending_point': 5,
          'staring_point': 0,
          'time': '08:20 AM',
        },
        {
          'bus_code': '5849',
          'ending_point': 5,
          'staring_point': 0,
          'time': '09:00 AM',
        },
        {
          'bus_code': '5973',
          'ending_point': 5,
          'staring_point': 0,
          'time': '10:00 AM',
        },
      ],
      'route': [
        'Campus',
        'Khilgaon Police Fari',
        'Malibagh Community Center',
        'Hazipara Petrol Pump',
        'Rampura Bazer',
        'Rampura TV Center',
      ],
      'name': 'Basanta',
    },
    'Falguni': {
      'downTrip_buses': [
        {
          'bus_code': '6139',
          'ending_point': 5,
          'staring_point': 0,
          'time': '01:10 PM',
        },
        {
          'bus_code': '6217',
          'ending_point': 0,
          'staring_point': 0,
          'time': '02:50 PM',
        },
        {
          'bus_code': '6051',
          'ending_point': 0,
          'staring_point': 0,
          'time': '04:10 PM',
        },
        {
          'bus_code': '6139',
          'ending_point': 0,
          'staring_point': 0,
          'time': '05:10 PM',
        },
      ],
      'upTrip_buses': [
        {
          'bus_code': '6051',
          'ending_point': 0,
          'staring_point': 0,
          'time': '06:40 AM',
        },
        {
          'bus_code': '6139',
          'ending_point': 0,
          'staring_point': 0,
          'time': '07:40 AM',
        },
        {
          'bus_code': '6051',
          'ending_point': 0,
          'staring_point': 0,
          'time': '08:40 AM',
        },
      ],
      'route': [
        'No Route'
      ],
      'name': 'Falguni',
    },
    'Khanika': {
      'downTrip_buses': [
        {
          'bus_code': '6262',
          'ending_point': 7,
          'staring_point': 14,
          'time': '12:15 PM',
        },
        {
          'bus_code': '5709',
          'ending_point': 7,
          'staring_point': 14,
          'time': '01:10 PM',
        },
        {
          'bus_code': '5724',
          'ending_point': 7,
          'staring_point': 16,
          'time': '01:50 PM',
        },
        {
          'bus_code': '6249',
          'ending_point': 0,
          'staring_point': 14,
          'time': '02:30 PM',
        },
        {
          'bus_code': '6203',
          'ending_point': 7,
          'staring_point': 15,
          'time': '03:30 PM',
        },
        {
          'bus_code': '6230',
          'ending_point': 7,
          'staring_point': 14,
          'time': '04:15 PM',
        },
        {
          'bus_code': '6213',
          'ending_point': 0,
          'staring_point': 14,
          'time': '05:00 PM',
        },
        {
          'bus_code': '6824',
          'ending_point': 7,
          'staring_point': 14,
          'time': '05:40 PM',
        },
      ],
      'upTrip_buses': [
        {
          'bus_code': '6262',
          'ending_point': 13,
          'staring_point': 0,
          'time': '05:50 AM',
        },
        {
          'bus_code': '6213',
          'ending_point': 13,
          'staring_point': 0,
          'time': '06:10 AM',
        },
        {
          'bus_code': '6262',
          'ending_point': 13,
          'staring_point': 7,
          'time': '06:20 AM',
        },
        {
          'bus_code': '5709',
          'ending_point': 13,
          'staring_point': 7,
          'time': '06:40 AM',
        },
        {
          'bus_code': '5724',
          'ending_point': 13,
          'staring_point': 7,
          'time': '07:00 AM',
        },
        {
          'bus_code': '6203',
          'ending_point': 13,
          'staring_point': 7,
          'time': '07:30 AM',
        },
        {
          'bus_code': '6824',
          'ending_point': 13,
          'staring_point': 7,
          'time': '08:15 AM',
        },
        {
          'bus_code': '6230',
          'ending_point': 13,
          'staring_point': 7,
          'time': '09:00 AM',
        },
      ],
      'route': [
        'Shibbari',
        'Chourasta',
        'Bypass',
        'Maleker Bari',
        'Signboard',
        'Board Bazer',
        'Boro Bari',
        'College Gate',
        'Station Road',
        'Tongi Bazer',
        'Abdullahpur',
        'House Building',
        'Azampur',
        'DU',
        'Curzon Hall',
        'VC Chattar',
        'Mall Chattar',
      ],
      'name': 'Khanika',
    },
    'Kinchit': {
      'downTrip_buses': [
        {
          'bus_code': '',
          'ending_point': 0,
          'staring_point': 8,
          'time': '12:30 PM',
        },
        {
          'bus_code': '',
          'ending_point': 0,
          'staring_point': 8,
          'time': '01:30 PM',
        },
        {
          'bus_code': '',
          'ending_point': 0,
          'staring_point': 8,
          'time': '02:30 PM',
        },
        {
          'bus_code': '',
          'ending_point': 0,
          'staring_point': 8,
          'time': '03:20 PM',
        },
        {
          'bus_code': '',
          'ending_point': 0,
          'staring_point': 8,
          'time': '04:20 PM',
        },
        {
          'bus_code': '',
          'ending_point': 0,
          'staring_point': 8,
          'time': '05:30 PM',
        },
      ],
      'upTrip_buses': [
        {
          'bus_code': '',
          'ending_point': 8,
          'staring_point': 0,
          'time': '07:00 AM',
        },
        {
          'bus_code': '',
          'ending_point': 8,
          'staring_point': 0,
          'time': '08:00 AM',
        },
        {
          'bus_code': '',
          'ending_point': 8,
          'staring_point': 0,
          'time': '08:50 AM',
        },
        {
          'bus_code': '',
          'ending_point': 8,
          'staring_point': 0,
          'time': '09:50 AM',
        },
        {
          'bus_code': '',
          'ending_point': 8,
          'staring_point': 0,
          'time': '08:50 AM',
        },
      ],
      'route': [
        'Arambagh',
        'Kamalapur',
        'Ideal School and College gate',
        'Rajarbagh',
        'Malibagh',
        'Mouchak',
        'Wireless',
        'VC Chattar',
        'Curzon Hall',
      ],
      'name': 'Kinchit',
    },
    'Srabon': {
      'downTrip_buses': [
        {
          'bus_code': '',
          'ending_point': 6,
          'staring_point': 0,
          'time': '12:15 PM',
        },
        {
          'bus_code': '',
          'ending_point': 6,
          'staring_point': 0,
          'time': '01:30 PM',
        },
        {
          'bus_code': '',
          'ending_point': 6,
          'staring_point': 0,
          'time': '02:20 PM',
        },
        {
          'bus_code': '',
          'ending_point': 6,
          'staring_point': 0,
          'time': '03:40 PM',
        },
        {
          'bus_code': '',
          'ending_point': 6,
          'staring_point': 0,
          'time': '04:30 PM',
        },
        {
          'bus_code': '',
          'ending_point': 6,
          'staring_point': 0,
          'time': '05:00 PM',
        },
        {
          'bus_code': '',
          'ending_point': 6,
          'staring_point': 0,
          'time': '05:30 PM',
        },
      ],
      'upTrip_buses': [
        {
          'bus_code': '',
          'ending_point': 0,
          'staring_point': 6,
          'time': '07:00 AM',
        },
        {
          'bus_code': '',
          'ending_point': 0,
          'staring_point': 6,
          'time': '07:20 AM',
        },
        {
          'bus_code': '',
          'ending_point': 0,
          'staring_point': 6,
          'time': '07:55 AM',
        },
        {
          'bus_code': '',
          'ending_point': 0,
          'staring_point': 6,
          'time': '08:15 AM',
        },
        {
          'bus_code': '',
          'ending_point': 0,
          'staring_point': 6,
          'time': '09:00 AM',
        },
        {
          'bus_code': '',
          'ending_point': 0,
          'staring_point': 6,
          'time': '10:00 AM',
        },
      ],
      'route': [
        'Mugda Stadium',
        'Mugda Bisshoroad',
        'Mugda Medical',
        'Buddha mandir',
        'Bashabo',
        'Khilgaon',
        'Campus'
      ],
      'name': 'Srabon',
    },
    'Taranga': {
      'downTrip_buses': [
        {
          'bus_code': '',
          'ending_point': 14,
          'staring_point': 26,
          'time': '12:15 PM',
        },
        {
          'bus_code': '',
          'ending_point': 14,
          'staring_point': 26,
          'time': '01:30 PM',
        },
        {
          'bus_code': '',
          'ending_point': 14,
          'staring_point': 26,
          'time': '02:20 PM',
        },
        {
          'bus_code': '',
          'ending_point': 26,
          'staring_point': 14,
          'time': '03:30 PM',
        },
        {
          'bus_code': '',
          'ending_point': 14,
          'staring_point': 26,
          'time': '04:30 PM',
        },
        {
          'bus_code': '',
          'ending_point': 14,
          'staring_point': 26,
          'time': '05:00 PM',
        },
        {
          'bus_code': '',
          'ending_point': 14,
          'staring_point': 26,
          'time': '05:30 PM',
        },
        {
          'bus_code': '',
          'ending_point': 14,
          'staring_point': 26,
          'time': '05:35 PM',
        },
      ],
      'upTrip_buses': [
        {
          'bus_code': '',
          'ending_point': 13,
          'staring_point': 0,
          'time': '07:10 AM',
        },
        {
          'bus_code': '',
          'ending_point': 13,
          'staring_point': 0,
          'time': '07:30 AM',
        },
        {
          'bus_code': '',
          'ending_point': 13,
          'staring_point': 0,
          'time': '08:00 AM',
        },
        {
          'bus_code': '',
          'ending_point': 13,
          'staring_point': 0,
          'time': '08:30 AM',
        },
        {
          'bus_code': '',
          'ending_point': 13,
          'staring_point': 0,
          'time': '09:10 AM',
        },
        {
          'bus_code': '',
          'ending_point': 13,
          'staring_point': 0,
          'time': '10:10 AM',
        },
      ],
      'route': [
        'DRMC',
        'Moitree Counter',
        'Mohammadpur Bus stand',
        'Academia',
        'Dhanmondi 27',
        'Dhanmondi 19',
        'Dhanmondi 15',
        'Zigatola',
        'Neelkhet mor',
        'Arts building',
        'TSC',
        'Motaher Hossain building',
        'Mokarram building',
        'Curzon Hall',
        'Asad Gate',
        'Town hall',
        'Salimullah Road',
        'Noorjahan Road',
        'Mohammadpur Bus stand',
        'Graphics Art building',
        'Shankar',
        'Star Kabab',
        'Dhanmondi 15',
        'Zigatola',
        'VC Chottor',
        'TSC',
        'Curzon Hall',
      ],
      'name': 'Taranga',
    },
    'Ullash': {
      'downTrip_buses': [
        {
          'bus_code': '',
          'ending_point': 8,
          'staring_point': 16,
          'time': '12:10 PM',
        },
        {
          'bus_code': '',
          'ending_point': 8,
          'staring_point': 16,
          'time': '01:10 PM',
        },
        {
          'bus_code': '',
          'ending_point': 8,
          'staring_point': 16,
          'time': '02:10 PM',
        },
        {
          'bus_code': '',
          'ending_point': 8,
          'staring_point': 16,
          'time': '03:10 PM',
        },
        {
          'bus_code': '',
          'ending_point': 8,
          'staring_point': 16,
          'time': '04:15 PM',
        },
        {
          'bus_code': '',
          'ending_point': 8,
          'staring_point': 16,
          'time': '05:35 PM',
        },
      ],
      'upTrip_buses': [
        {
          'bus_code': '',
          'ending_point': 7,
          'staring_point': 0,
          'time': '07:00 AM',
        },
        {
          'bus_code': '',
          'ending_point': 7,
          'staring_point': 0,
          'time': '08:00 AM',
        },
        {
          'bus_code': '',
          'ending_point': 7,
          'staring_point': 0,
          'time': '08:30 AM',
        },
        {
          'bus_code': '',
          'ending_point': 7,
          'staring_point': 0,
          'time': '09:00 AM',
        },
        {
          'bus_code': '',
          'ending_point': 7,
          'staring_point': 0,
          'time': '09:30 AM',
        },
        {
          'bus_code': '',
          'ending_point': 7,
          'staring_point': 0,
          'time': '10:00 AM',
        },
      ],
      'route': [
        'Postogola',
        'Jurain',
        'Dholaipar',
        'Nabi Nagar',
        'Mir Hazirbag',
        'DoyaGanj',
        'Tikatuli',
        'Campus',
        'Doyaganj',
        'Mir Hazirbag',
        'NabiNagar',
        'Dholaipar',
        'Jurain',
        'Postogola',
        'Dholaipar',
        'Tikatuli (Flyover)',
        'Campus',
      ],
      'name': 'Ullash',
    },
  };

  Future<void> addBusDetails() async {
    print('Adding bus data');
    await DatabaseService().addBusDetailsToDB(bus_details);
  }
}
