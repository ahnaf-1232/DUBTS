import 'package:dubts/services/databases.dart';

class AddBusData {
  dynamic bus_details = {
    'Baishakhi': {
      'downTrip_buses': [
        {
          'bus_code': '6231',
          'ending_point': 27,
          'staring_point': 15,
          'time': '12:30 PM',
        },
        {
          'bus_code': '5817',
          'ending_point': 27,
          'staring_point': 15,
          'time': '01:15 PM',
        },
        {
          'bus_code': '5900',
          'ending_point': 27,
          'staring_point': 15,
          'time': '02:20 PM',
        },
        {
          'bus_code': '6204',
          'ending_point': 27,
          'staring_point': 15,
          'time': '03:30 PM',
        },
        {
          'bus_code': '5866',
          'ending_point': 27,
          'staring_point': 15,
          'time': '04:30 PM',
        },
        {
          'bus_code': '5899',
          'ending_point': 27,
          'staring_point': 15,
          'time': '05:00 PM',
        },
        {
          'bus_code': '6231',
          'ending_point': 27,
          'staring_point': 15,
          'time': '05:30 PM',
        },
      ],
      'upTrip_buses': [
        {
          'bus_code': '5900',
          'ending_point': 0,
          'staring_point': 14,
          'time': '06:30 AM',
        },
        {
          'bus_code': '5817',
          'ending_point': 0,
          'staring_point': 13,
          'time': '06:50 AM',
        },
        {
          'bus_code': '5867',
          'ending_point': 0,
          'staring_point': 13,
          'time': '07:30 AM',
        },
        {
          'bus_code': '6231',
          'ending_point': 0,
          'staring_point': 13,
          'time': '08:00 AM',
        },
        {
          'bus_code': '6204',
          'ending_point': 0,
          'staring_point': 13,
          'time': '08:45 AM',
        },
        {
          'bus_code': '6264',
          'ending_point': 0,
          'staring_point': 13,
          'time': '09:25 AM',
        },
        {
          'bus_code': '5900',
          'ending_point': 0,
          'staring_point': 13,
          'time': '10:00 AM',
        },
      ],
      'route': [
        'Campus',
        'Second Gate',
        'Sher-E-Bangla Agricultural University (2nd Gate)',
        'Taltola',
        'Shewrapara bus stand (beside Polce Box)',
        'Kazipara over-bridge',
        '10 number shahjalal islami bank',
        'Water tank',
        '13 number',
        'Police staff college',
        'POlice college',
        '14 number',
        'Mili super market',
        'Pulpar',
        'Kochukhet',
        'Curzon Hall',
        'Sher-E-Bangla Agricultural University (2nd Gate)',
        'Shewrapara',
        'Shewrapara Technical',
        'Kazipara',
        'Al-Helal (Oppsoite Side)',
        '10 number over-bridge',
        'Water Tank',
        '13 number',
        'Police Staff College',
        'Police College',
        '14 number',
        'Pulpar',
      ],
      'name': 'Baishakhi',
    },
    'Basanta': {
      'downTrip_buses': [
        {
          'bus_code': '5992',
          'ending_point': 10,
          'staring_point': 6,
          'time': '12:35 PM',
        },
        {
          'bus_code': '7303',
          'ending_point': 10,
          'staring_point': 6,
          'time': '01:35 PM',
        },
        {
          'bus_code': '6121',
          'ending_point': 10,
          'staring_point': 6,
          'time': '02:35 PM',
        },
        {
          'bus_code': '5973',
          'ending_point': 10,
          'staring_point': 6,
          'time': '03:35 PM',
        },
        {
          'bus_code': '6116',
          'ending_point': 10,
          'staring_point': 6,
          'time': '04:35 PM',
        },
        {
          'bus_code': '5817',
          'ending_point': 10,
          'staring_point': 6,
          'time': '05:35 PM',
        },
      ],
      'upTrip_buses': [
        {
          'bus_code': '6071',
          'ending_point': 0,
          'staring_point': 5,
          'time': '07:00 AM',
        },
        {
          'bus_code': '5973',
          'ending_point': 0,
          'staring_point': 5,
          'time': '07:40 AM',
        },
        {
          'bus_code': '6116',
          'ending_point': 0,
          'staring_point': 5,
          'time': '08:20 AM',
        },
        {
          'bus_code': '5849',
          'ending_point': 0,
          'staring_point': 5,
          'time': '09:00 AM',
        },
        {
          'bus_code': '5973',
          'ending_point': 0,
          'staring_point': 5,
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
        'VC Chattar',
        'Central Library',
        'Annex Building',
        'Curzon Hall',
        'Rampura TV Center'
      ],
      'name': 'Basanta',
    },
    'Falguni': {
      'downTrip_buses': [
        {
          'bus_code': '6139',
          'ending_point': 32,
          'staring_point': 30,
          'time': '01:10 PM',
        },
        {
          'bus_code': '6217',
          'ending_point': 32,
          'staring_point': 30,
          'time': '02:50 PM',
        },
        {
          'bus_code': '6051',
          'ending_point': 32,
          'staring_point': 30,
          'time': '04:10 PM',
        },
        {
          'bus_code': '6139',
          'ending_point': 32,
          'staring_point': 30,
          'time': '05:10 PM',
        },
      ],
      'upTrip_buses': [
        {
          'bus_code': '6051',
          'ending_point': 29,
          'staring_point': 14,
          'time': '06:40 AM',
        },
        {
          'bus_code': '6139',
          'ending_point': 13,
          'staring_point': 0,
          'time': '07:40 AM',
        },
        {
          'bus_code': '6051',
          'ending_point': 13,
          'staring_point': 0,
          'time': '08:40 AM',
        },
      ],
      'route': [
        'link Road',
        'Hossain Market',
        'Uttar Badda',
        'Subastu',
        'Shahzadpur',
        'Bashtola',
        'Natun Bazer',
        'Gulshan-1',
        'TB Gait',
        'Wareless',
        'Amtoli',
        'Mohakhali',
        'Nabisco',
        'Campus',

        'Natun Bazer',
        'Bashtola',
        'Shahzadpur',
        'Subastu',
        'Uttar Badda',
        'Hossain Market',
        'Moddho Badda',
        'Link Road',
        'Gudaraghat',
        'Gulshan-1',
        'TB Gait',
        'Wareless',
        'Amtoli',
        'Mohakhali',
        'Nabisco',
        'Campus',

        'Mall Chattor',
        'Gulshan',
        'Badda',
      ],
      'name': 'Falguni',
    },
    'Khanika': {
      'downTrip_buses': [
        {
          'bus_code': '6262',
          'ending_point': 25,
          'staring_point': 24,
          'time': '12:15 PM',
        },
        {
          'bus_code': '5709',
          'ending_point': 22,
          'staring_point': 21,
          'time': '01:10 PM',
        },
        {
          'bus_code': '5724',
          'ending_point': 26,
          'staring_point': 24,
          'time': '01:45 PM',
        },
        {
          'bus_code': '6249',
          'ending_point': 22,
          'staring_point': 21,
          'time': '02:30 PM',
        },
        {
          'bus_code': '6203',
          'ending_point': 25,
          'staring_point': 24,
          'time': '03:10 PM',
        },
        {
          'bus_code': '6230',
          'ending_point': 23,
          'staring_point': 21,
          'time': '03:50 PM',
        },
        {
          'bus_code': '6213',
          'ending_point': 25,
          'staring_point': 24,
          'time': '04:30 PM',
        },
        {
          'bus_code': '6824',
          'ending_point': 26,
          'staring_point': 24,
          'time': '05:10 PM',
        },
        {
          'bus_code': '6824',
          'ending_point': 26,
          'staring_point': 24,
          'time': '05:40 PM',
        },
      ],
      'upTrip_buses': [
        {
          'bus_code': '6262',
          'ending_point': 20,
          'staring_point': 0,
          'time': '05:50 AM',
        },
        {
          'bus_code': '6213',
          'ending_point': 20,
          'staring_point': 0,
          'time': '06:10 AM',
        },
        {
          'bus_code': '6213',
          'ending_point': 20,
          'staring_point': 7,
          'time': '06:10 AM',
        },
        {
          'bus_code': '6262',
          'ending_point': 20,
          'staring_point': 0,
          'time': '06:40 AM',
        },
        {
          'bus_code': '6262',
          'ending_point': 20,
          'staring_point': 7,
          'time': '06:40 AM',
        },
        {
          'bus_code': '5724',
          'ending_point': 20,
          'staring_point': 7,
          'time': '07:00 AM',
        },
        {
          'bus_code': '6203',
          'ending_point': 20,
          'staring_point': 7,
          'time': '07:30 AM',
        },
        {
          'bus_code': '6824',
          'ending_point': 20,
          'staring_point': 7,
          'time': '08:15 AM',
        },
        {
          'bus_code': '6230',
          'ending_point': 20,
          'staring_point': 7,
          'time': '09:00 AM',
        },
      ],
      'route': [
        'Shib-Bari',
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
        'jashim Uddin',
        'Biman Bandar',
        'Kawla',
        'Khilkhet',
        'Bissho road',
        'Shewra',
        'Kurmitola',
        'Campus',
        'VC Chattar',
        'College gate',
        'Shib-Bari',
        'Curzon Hall',
        'College Gate',
        'Shib-Bari'
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
          'ending_point': 16,
          'staring_point': 7,
          'time': '12:15 PM',
        },
        {
          'bus_code': '',
          'ending_point': 16,
          'staring_point': 8,
          'time': '01:30 PM',
        },
        {
          'bus_code': '',
          'ending_point': 16,
          'staring_point': 7,
          'time': '02:20 PM',
        },
        {
          'bus_code': '',
          'ending_point': 16,
          'staring_point': 8,
          'time': '03:40 PM',
        },
        {
          'bus_code': '',
          'ending_point': 16,
          'staring_point': 8,
          'time': '04:30 PM',
        },
        {
          'bus_code': '',
          'ending_point': 16,
          'staring_point': 7,
          'time': '05:00 PM',
        },
        {
          'bus_code': '',
          'ending_point': 16,
          'staring_point': 7,
          'time': '05:30 PM',
        },
      ],
      'upTrip_buses': [
        {
          'bus_code': '',
          'ending_point': 6,
          'staring_point': 0,
          'time': '07:00 AM',
        },
        {
          'bus_code': '',
          'ending_point': 6,
          'staring_point': 0,
          'time': '07:20 AM',
        },
        {
          'bus_code': '',
          'ending_point': 6,
          'staring_point': 0,
          'time': '07:55 AM',
        },
        {
          'bus_code': '',
          'ending_point': 6,
          'staring_point': 0,
          'time': '08:15 AM',
        },
        {
          'bus_code': '',
          'ending_point': 6,
          'staring_point': 0,
          'time': '09:00 AM',
        },
        {
          'bus_code': '',
          'ending_point': 6,
          'staring_point': 0,
          'time': '10:00 AM',
        },
      ],
      'route': [
        'Mugda Stadium',
        'Mugda Bisshoroad',
        'Mugda Medical',
        'Buddha mandir',
        'Bashabo',
        'Khilgaon Rail-Gate',
        'Campus',
        'Vc Chattar',
        'TSC',
        'DMC',
        'Shahidullah Hall More',
        'Maniknagar',
        'Mugda Garments',
        'Mugda Bisshoroad',
        'Buddha mandir',
        'Bashabo',
        'Khilgaon Rail-Gate',
      ],
      'name': 'Srabon',
    },
    'Taranga': {
      'downTrip_buses': [
        {
          'bus_code': '',
          'ending_point': 14,
          'staring_point': 27,
          'time': '12:30 PM',
        },
        {
          'bus_code': '',
          'ending_point': 14,
          'staring_point': 27,
          'time': '01:15 PM',
        },
        {
          'bus_code': '',
          'ending_point': 14,
          'staring_point': 27,
          'time': '02:00 PM',
        },
        {
          'bus_code': '',
          'ending_point': 14,
          'staring_point': 27,
          'time': '02:45 PM',
        },
        {
          'bus_code': '',
          'ending_point': 14,
          'staring_point': 27,
          'time': '03:30 PM',
        },
        {
          'bus_code': '',
          'ending_point': 14,
          'staring_point': 27,
          'time': '04:15 PM',
        },
        {
          'bus_code': '',
          'ending_point': 14,
          'staring_point': 27,
          'time': '04:45 PM',
        },
        {
          'bus_code': '',
          'ending_point': 14,
          'staring_point': 27,
          'time': '05:15 PM',
        },
        {
          'bus_code': '',
          'ending_point': 14,
          'staring_point': 27,
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
          'staring_point': 1,
          'time': '07:30 AM',
        },
        {
          'bus_code': '',
          'ending_point': 13,
          'staring_point': 1,
          'time': '08:00 AM',
        },
        {
          'bus_code': '',
          'ending_point': 13,
          'staring_point': 1,
          'time': '08:30 AM',
        },
        {
          'bus_code': '',
          'ending_point': 13,
          'staring_point': 1,
          'time': '09:10 AM',
        },
        {
          'bus_code': '',
          'ending_point': 13,
          'staring_point': 1,
          'time': '10:10 AM',
        },
      ],
      'route': [
        'DRMC',
        'Moitree Counter',
        'Mohammadpur Bus stand',
        'Academia',
        'Dhanmondi 27 (Zatri Chauni)',
        'Dhanmondi 19 (Abahoni Field)',
        'Dhanmondi 15 (Kakoli)',
        'Zigatola (Ecstasy Showroom)',
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
        'Graphics College',
        'Shankar',
        'Star Kabab',
        'Dhanmondi 15 (BFC)',
        'Zigatola',
        'VC Chottor',
        'TSC',
        'Motaher Hossain building',
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
          'time': '05:10 PM',
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
    'Moitri': {
      'downTrip_buses': [
        {
          'bus_code': '',
          'ending_point': 0,
          'staring_point': 19,
          'time': '12:15 PM',
        },
        {
          'bus_code': '',
          'ending_point': 0,
          'staring_point': 19,
          'time': '01:15 PM',
        },
        {
          'bus_code': '',
          'ending_point': 0,
          'staring_point': 19,
          'time': '02:15 PM',
        },
        {
          'bus_code': '',
          'ending_point': 0,
          'staring_point': 19,
          'time': '03:15 PM',
        },
        {
          'bus_code': '',
          'ending_point': 0,
          'staring_point': 19,
          'time': '04:05 PM',
        },
        {
          'bus_code': '',
          'ending_point': 0,
          'staring_point': 19,
          'time': '05:15 PM',
        },
      ],
      'upTrip_buses': [
        {
          'bus_code': '',
          'ending_point': 19,
          'staring_point': 0,
          'time': '06:25 AM',
        },
        {
          'bus_code': '',
          'ending_point': 19,
          'staring_point': 0,
          'time': '07:10 AM',
        },
        {
          'bus_code': '',
          'ending_point': 19,
          'staring_point': 10,
          'time': '08:00 AM',
        },
        {
          'bus_code': '',
          'ending_point': 19,
          'staring_point': 0,
          'time': '08:20 AM',
        },
        {
          'bus_code': '',
          'ending_point': 19,
          'staring_point': 0,
          'time': '09:15 AM',
        },
      ],
      'route': [
        'IIT School',
        'Pathangoli',
        'Chowdhuri para',
        '2 number',
        'Jaulapar',
        'Adomji',
        'power House',
        'Siddhirgong',
        'Chittagong road',
        'Golakata',
        'Ranimohol',
        'Sarulia bazar',
        'Staff quarter',
        'basher pool',
        'Konapara',
        'Matuail',
        'Bhanga',
        'Press',
        'Jatrabari',
        'Campus'
      ],
      'name': 'Moitri',
    },
    'Anondo': {
      'downTrip_buses': [
        {
          'bus_code': '',
          'ending_point': 0,
          'staring_point': 12,
          'time': '01:10 PM',
        },
        {
          'bus_code': '',
          'ending_point': 0,
          'staring_point': 12,
          'time': '02:30 PM',
        },
        {
          'bus_code': '',
          'ending_point': 0,
          'staring_point': 12,
          'time': '04:05 PM',
        },
        {
          'bus_code': '',
          'ending_point': 0,
          'staring_point': 12,
          'time': '05:10 PM',
        },
      ],
      'upTrip_buses': [
        {
          'bus_code': '',
          'ending_point': 12,
          'staring_point': 0,
          'time': '06:50 AM',
        },
        {
          'bus_code': '',
          'ending_point': 12,
          'staring_point': 0,
          'time': '07:30 AM',
        },
        {
          'bus_code': '',
          'ending_point': 12,
          'staring_point': 10,
          'time': '08:50 AM',
        },
      ],
      'route': [
        'Nondir para',
        '2 number gate',
        'Kalir bazar',
        'Chashara',
        'Zilla Proshashon',
        'Roni market',
        'Stadium',
        'Buigor',
        'Jalkuri',
        'Sign Board',
        'Curzon Hall',
        'TSC',
        'Mol Chottor',
      ],
      'name': 'Anondo',
    },
    'Hemonto': {
      'downTrip_buses': [
        {
          'bus_code': '',
          'ending_point': 0,
          'staring_point': 10,
          'time': '01:10 PM',
        },
        {
          'bus_code': '',
          'ending_point': 0,
          'staring_point': 10,
          'time': '03:30 PM',
        },
        {
          'bus_code': '',
          'ending_point': 0,
          'staring_point': 10,
          'time': '05:00 PM',
        },
      ],
      'upTrip_buses': [
        {
          'bus_code': '',
          'ending_point': 10,
          'staring_point': 0,
          'time': '06:20 AM',
        },
        {
          'bus_code': '',
          'ending_point': 10,
          'staring_point': 0,
          'time': '07:30 AM',
        },
        {
          'bus_code': '',
          'ending_point': 10,
          'staring_point': 0,
          'time': '08:00 AM',
        },
      ],
      'route': [
        'Savar',
        'Nobinogor joya',
        'Bish mail',
        'CMB',
        'Savar stand',
        'Khana stand',
        'Genda',
        'Fulbaria',
        'Olain',
        'Gabtoli',
        'Campus',
      ],
      'name': 'Hemonto',
    },
    'Esha Kha': {
      'downTrip_buses': [
        {
          'bus_code': '',
          'ending_point': 3,
          'staring_point': 17,
          'time': '12:20 PM',
        },
        {
          'bus_code': '',
          'ending_point': 1,
          'staring_point': 17,
          'time': '01:30 PM',
        },
        {
          'bus_code': '',
          'ending_point': 3,
          'staring_point': 17,
          'time': '01:30 PM',
        },
        {
          'bus_code': '',
          'ending_point': 3,
          'staring_point': 17,
          'time': '02:30 PM',
        },
        {
          'bus_code': '',
          'ending_point': 1,
          'staring_point': 17,
          'time': '03:30 PM',
        },
        {
          'bus_code': '',
          'ending_point': 0,
          'staring_point': 17,
          'time': '04:05 PM',
        },
        {
          'bus_code': '',
          'ending_point': 3,
          'staring_point': 17,
          'time': '04:10 PM',
        },
        {
          'bus_code': '',
          'ending_point': 3,
          'staring_point': 17,
          'time': '04:30 PM',
        },
        {
          'bus_code': '',
          'ending_point': 3,
          'staring_point': 17,
          'time': '05:00 PM',
        },
        {
          'bus_code': '',
          'ending_point': 1,
          'staring_point': 17,
          'time': '05:30 PM',
        },
      ],
      'upTrip_buses': [
        {
          'bus_code': '',
          'ending_point': 17,
          'staring_point': 1,
          'time': '06:40 AM',
        },
        {
          'bus_code': '',
          'ending_point': 17,
          'staring_point': 3,
          'time': '06:50 AM',
        },
        {
          'bus_code': '',
          'ending_point': 17,
          'staring_point': 1,
          'time': '07:30 AM',
        },
        {
          'bus_code': '',
          'ending_point': 17,
          'staring_point': 0,
          'time': '07:45 AM',
        },
        {
          'bus_code': '',
          'ending_point': 17,
          'staring_point': 3,
          'time': '07:50 AM',
        },
        {
          'bus_code': '',
          'ending_point': 17,
          'staring_point': 3,
          'time': '08:20 AM',
        },
        {
          'bus_code': '',
          'ending_point': 17,
          'staring_point': 3,
          'time': '08:50 AM',
        },
        {
          'bus_code': '',
          'ending_point': 17,
          'staring_point': 10,
          'time': '09:05 AM',
        },
        {
          'bus_code': '',
          'ending_point': 17,
          'staring_point': 3,
          'time': '09:50 AM',
        },
        {
          'bus_code': '',
          'ending_point': 17,
          'staring_point': 10,
          'time': '10:05 AM',
        },
      ],
      'route': [
        'Vober Char',
        'Mograpara',
        'Modonpur',
        'Kachpur',
        'Chittagong Road',
        'Doshtola',
        'Mouchak',
        'Sanarpar',
        'Signboard',
        'Madrasa Road',
        'Matuail',
        'Rayerbag',
        'Shanir Akhra',
        'Kajla',
        'DMC',
        'Shahid Minar',
        'TSC',
        'VC Chottor',
      ],
      'name': 'Esha Kha',
    },
    'Chaitali': {
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
          'staring_point': 10,
          'time': '02:30 PM',
        },
        {
          'bus_code': '',
          'ending_point': 0,
          'staring_point': 10,
          'time': '03:30 PM',
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
          'staring_point': 10,
          'time': '05:00 PM',
        },
        {
          'bus_code': '',
          'ending_point': 0,
          'staring_point': 10,
          'time': '05:30 PM',
        },
      ],
      'upTrip_buses': [
        {
          'bus_code': '',
          'ending_point': 10,
          'staring_point': 0,
          'time': '06:40 AM',
        },
        {
          'bus_code': '',
          'ending_point': 10,
          'staring_point': 0,
          'time': '06:40 AM',
        },
        {
          'bus_code': '',
          'ending_point': 10,
          'staring_point': 0,
          'time': '07:10 AM',
        },
        {
          'bus_code': '',
          'ending_point': 10,
          'staring_point': 0,
          'time': '07:10 AM',
        },
        {
          'bus_code': '',
          'ending_point': 10,
          'staring_point': 0,
          'time': '07:50 AM',
        },
        {
          'bus_code': '',
          'ending_point': 10,
          'staring_point': 0,
          'time': '07:50 AM',
        },
        {
          'bus_code': '',
          'ending_point': 10,
          'staring_point': 0,
          'time': '09:25 AM',
        },
        {
          'bus_code': '',
          'ending_point': 10,
          'staring_point': 0,
          'time': '09:25 AM',
        },
      ],
      'route': [
        'Mirpur-12',
        'Mirpur-11.5',
        'Mirpur-6',
        'Mirpur-2',
        'Mirpur-1',
        'Bangla College',
        'Technical',
        'Shamoli',
        'Mall Chattor',
        'TSC',
        'Curzon Hall'
      ],
      'name': 'Chaitali',
    },
  };

  Future<void> addBusDetails() async {
    print('Adding bus data');
    await DatabaseService().addBusDetailsToDB(bus_details);
  }
}
