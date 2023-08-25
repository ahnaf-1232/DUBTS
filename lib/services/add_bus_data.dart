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

    //buses from Sadia
    'Srabon': {
      'downTrip_buses': [
        {
          'bus_code': '',
          'ending_point': 5,
          'staring_point': 0,
          'time': TimeOfDay(hour: 12, minute: 15),
        },
        {
          'bus_code': '',
          'ending_point': 5,
          'staring_point': 0,
          'time': TimeOfDay(hour: 13, minute: 30),
        },
        {
          'bus_code': '',
          'ending_point': 5,
          'staring_point': 0,
          'time': TimeOfDay(hour: 14, minute: 20),
        },
        {
          'bus_code': '',
          'ending_point': 5,
          'staring_point': 0,
          'time': TimeOfDay(hour: 15, minute: 40),
        },
        {
          'bus_code': '',
          'ending_point': 5,
          'staring_point': 0,
          'time': TimeOfDay(hour: 16, minute: 30),
        },
        {
          'bus_code': '',
          'ending_point': 5,
          'staring_point': 0,
          'time': TimeOfDay(hour: 17, minute: 00),
        },
        {
          'bus_code': '',
          'ending_point': 5,
          'staring_point': 0,
          'time': TimeOfDay(hour: 17, minute: 30),
        },
      ],
      'upTrip_buses': [
        {
          'bus_code': '',
          'ending_point': 0,
          'staring_point': 5,
          'time': TimeOfDay(hour: 7, minute: 00),
        },
        {
          'bus_code': '',
          'ending_point': 0,
          'staring_point': 5,
          'time': TimeOfDay(hour: 7, minute: 20),
        },
        {
          'bus_code': '',
          'ending_point': 0,
          'staring_point': 5,
          'time': TimeOfDay(hour: 7, minute: 55),
        },
        {
          'bus_code': '',
          'ending_point': 0,
          'staring_point': 5,
          'time': TimeOfDay(hour: 8, minute: 15),
        },
        {
          'bus_code': '',
          'ending_point': 0,
          'staring_point': 5,
          'time': TimeOfDay(hour: 9, minute: 00),
        },
        {
          'bus_code': '',
          'ending_point': 0,
          'staring_point': 5,
          'time': TimeOfDay(hour: 10, minute: 00),
        },
      ],
      'route': [
        'Mugda Stadium',
        'Mugda Bisshoroad',
        'Mugda Medical',
        'Buddha mandir',
        'Bashabo',
        'Khilgaon'
      ],
      'name': 'Srabon',
    },
    'Baishakhi': {
      'downTrip_buses': [
        {
          'bus_code': '6231',
          'ending_point': 10,
          'staring_point': 0,
          'time': TimeOfDay(hour: 12, minute: 30),
        },
        {
          'bus_code': '5817',
          'ending_point': 10,
          'staring_point': 0,
          'time': TimeOfDay(hour: 13, minute: 15),
        },
        {
          'bus_code': '5900',
          'ending_point': 10,
          'staring_point': 0,
          'time': TimeOfDay(hour: 14, minute: 20),
        },
        {
          'bus_code': '6204',
          'ending_point': 10,
          'staring_point': 0,
          'time': TimeOfDay(hour: 15, minute: 30),
        },
        {
          'bus_code': '5866',
          'ending_point': 10,
          'staring_point': 0,
          'time': TimeOfDay(hour: 16, minute: 30),
        },
        {
          'bus_code': '5899',
          'ending_point': 10,
          'staring_point': 0,
          'time': TimeOfDay(hour: 17, minute: 00),
        },
        {
          'bus_code': '6231',
          'ending_point': 10,
          'staring_point': 0,
          'time': TimeOfDay(hour: 17, minute: 30),
        },
      ],
      'upTrip_buses': [
        {
          'bus_code': '5900',
          'ending_point': 0,
          'staring_point': 11,
          'time': TimeOfDay(hour: 6, minute: 30),
        },
        {
          'bus_code': '5817',
          'ending_point': 0,
          'staring_point': 11,
          'time': TimeOfDay(hour: 6, minute: 50),
        },
        {
          'bus_code': '5867',
          'ending_point': 0,
          'staring_point': 10,
          'time': TimeOfDay(hour: 7, minute: 30),
        },
        {
          'bus_code': '6231',
          'ending_point': 0,
          'staring_point': 10,
          'time': TimeOfDay(hour: 8, minute: 00),
        },
        {
          'bus_code': '6204',
          'ending_point': 0,
          'staring_point': 10,
          'time': TimeOfDay(hour: 8, minute: 45),
        },
        {
          'bus_code': '6264',
          'ending_point': 0,
          'staring_point': 10,
          'time': TimeOfDay(hour: 9, minute: 25),
        },
        {
          'bus_code': '5900',
          'ending_point': 0,
          'staring_point': 10,
          'time': TimeOfDay(hour: 10, minute: 00),
        },
      ],
      'route': [
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
    'Taranga': {
      'downTrip_buses': [
        {
          'bus_code': '',
          'ending_point': 26,
          'staring_point': 14,
          'time': TimeOfDay(hour: 12, minute: 15),
        },
        {
          'bus_code': '',
          'ending_point': 26,
          'staring_point': 14,
          'time': TimeOfDay(hour: 13, minute: 30),
        },
        {
          'bus_code': '',
          'ending_point': 26,
          'staring_point': 14,
          'time': TimeOfDay(hour: 14, minute: 20),
        },
        {
          'bus_code': '',
          'ending_point': 26,
          'staring_point': 14,
          'time': TimeOfDay(hour: 15, minute: 30),
        },
        {
          'bus_code': '',
          'ending_point': 26,
          'staring_point': 14,
          'time': TimeOfDay(hour: 16, minute: 30),
        },
        {
          'bus_code': '',
          'ending_point': 26,
          'staring_point': 14,
          'time': TimeOfDay(hour: 17, minute: 00),
        },
        {
          'bus_code': '',
          'ending_point': 26,
          'staring_point': 14,
          'time': TimeOfDay(hour: 17, minute: 30),
        },
        {
          'bus_code': '',
          'ending_point': 26,
          'staring_point': 14,
          'time': TimeOfDay(hour: 17, minute: 35),
        },
      ],
      'upTrip_buses': [
        {
          'bus_code': '',
          'ending_point': 13,
          'staring_point': 0,
          'time': TimeOfDay(hour: 7, minute: 10),
        },
        {
          'bus_code': '',
          'ending_point': 13,
          'staring_point': 0,
          'time': TimeOfDay(hour: 7, minute: 30),
        },
        {
          'bus_code': '',
          'ending_point': 13,
          'staring_point': 0,
          'time': TimeOfDay(hour: 8, minute: 00),
        },
        {
          'bus_code': '',
          'ending_point': 13,
          'staring_point': 0,
          'time': TimeOfDay(hour: 8, minute: 30),
        },
        {
          'bus_code': '',
          'ending_point': 13,
          'staring_point': 0,
          'time': TimeOfDay(hour: 9, minute: 10),
        },
        {
          'bus_code': '',
          'ending_point': 13,
          'staring_point': 0,
          'time': TimeOfDay(hour: 10, minute: 10),
        },
      ],
      'route': [
        //up
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
        'Curzon Hall', //13

            //down
        'Curzon Hall',  //14
        'TSC',
        'VC Chottor',
        'Zigatola',
        'Dhanmondi 15',
        'Star Kabab',
        'Shankar',
        'Graphics Art building',
        'Mohammadpur Bus stand',
        'Noorjahan Road',
        'Salimullah Road',
        'Town hall',
        'Asad Gate' //26
      ],
      'name': 'Taranga',
    },
    'Ullash': {
      'downTrip_buses': [
        {
          'bus_code': '',
          'ending_point': 0,
          'staring_point': 7,
          'time': TimeOfDay(hour: 12, minute: 10),
        },
        {
          'bus_code': '',
          'ending_point': 0,
          'staring_point': 7,
          'time': TimeOfDay(hour: 13, minute: 10),
        },
        {
          'bus_code': '',
          'ending_point': 0,
          'staring_point': 7,
          'time': TimeOfDay(hour: 14, minute: 10),
        },
        {
          'bus_code': '',
          'ending_point': 0,
          'staring_point': 7,
          'time': TimeOfDay(hour: 15, minute: 10),
        },
        {
          'bus_code': '',
          'ending_point': 0,
          'staring_point': 7,
          'time': TimeOfDay(hour: 16, minute: 15),
        },
        {
          'bus_code': '',
          'ending_point': 0,
          'staring_point': 7,
          'time': TimeOfDay(hour: 17, minute: 35),
        },
      ],
      'upTrip_buses': [
        {
          'bus_code': '',
          'ending_point': 7,
          'staring_point': 0,
          'time': TimeOfDay(hour: 7, minute: 00),
        },
        {
          'bus_code': '',
          'ending_point': 7,
          'staring_point': 0,
          'time': TimeOfDay(hour: 8, minute: 00),
        },
        {
          'bus_code': '',
          'ending_point': 7,
          'staring_point': 0,
          'time': TimeOfDay(hour: 8, minute: 30),
        },
        {
          'bus_code': '',
          'ending_point': 7,
          'staring_point': 0,
          'time': TimeOfDay(hour: 9, minute: 00),
        },
        {
          'bus_code': '',
          'ending_point': 7,
          'staring_point': 0,
          'time': TimeOfDay(hour: 9, minute: 30),
        },
        {
          'bus_code': '',
          'ending_point': 7,
          'staring_point': 0,
          'time': TimeOfDay(hour: 10, minute: 00),
        },
      ],
      'route': [
        'Postogola',
        'Jurain',
        'Dholaipaar',
        'Nobinagar',
        'Mir hajaribag',
        'Doyagong',
        'Tikatuli',
        'Campus'
      ],
      'name': 'Ullash',
    },

    // ---buses from Sadia
  };

  Future<void> addBusDetails() async {
    print('Adding bus data');
    await DatabaseService().addBusDetailsToDB(bus_details);
  }
}
