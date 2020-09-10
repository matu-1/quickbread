final pedidosData = [
  {
    'id': 1,
    'fecha': '2020-05-05',
    'hora': '08:08:00',
    'observacion': null,
    'coordenada': '-17.8, -63.11',
    'total': 150.0,
    'fecha_hora': '2020-05-05 02:50',
    'tipo_entrega': 'Recoger al local',
    'direccion': 'san juan 13',
    'referencia': 'porton verde',
    'estado': 'En espera',
    'cliente': {
      'id': 1,
      'nombre': 'matias',
      'apellido': 'flores',
      'telefono_celular': '75455454',
      'direccion': 'azurduy 12'
    },
    'detalles': [
      {
        'producto': {
          'id': 1,
          'nombre': 'Pan de arroz',
          'descripcion': 'rico pan de arroz pidelo ya',
          'precio': 0.5,
          'foto':
              'https://www.recetas.com.bo/sites/default/files/2018-03/pan-de-arroz-recetas-com-bo.jpg',
          'categoria': {'id': 1, 'nombre': 'pan'},
        },
        'cantidad': 20
      },
      {
        'producto': {
          'id': 2,
          'nombre': 'Pan de leche',
          'descripcion': 'rico pan de leche pidelo ya',
          'precio': 1.0,
          'foto':
              'https://img-global.cpcdn.com/recipes/92b8eb7ea7b58f58/1200x630cq70/photo.jpg',
          'categoria': {'id': 1, 'nombre': 'pan'},
        },
        'cantidad': 20
      }
    ]
  },
  {
    'id': 1,
    'fecha': '2020-10-05',
    'hora': '10:08:00',
    'observacion': null,
    'coordenada': '-17.8, -63.11',
    'direccion': 'San maria 12',
    'referencia': 'porton verde',
    'total': 120.0,
    'fecha_hora': '2020-09-05 02:50',
    'tipo_entrega': 'A domicilio',
    'estado': 'En proceso',
    'cliente': {
      'id': 1,
      'nombre': 'matias',
      'apellido': 'flores',
      'telefono_celular': '75455454',
      'direccion': 'azurduy 12'
    },
    'detalles': [
      {
        'producto': {
          'id': 2,
          'nombre': 'Pan de leche',
          'descripcion': 'rico pan de leche pidelo ya',
          'precio': 1.0,
          'foto':
              'https://img-global.cpcdn.com/recipes/92b8eb7ea7b58f58/1200x630cq70/photo.jpg',
          'categoria': {'id': 1, 'nombre': 'pan'},
        },
        'cantidad': 20
      },
      {
        'producto': {
          'id': 1,
          'nombre': 'Pan de arroz',
          'descripcion': 'rico pan de arroz pidelo ya',
          'precio': 0.5,
          'foto':
              'https://www.recetas.com.bo/sites/default/files/2018-03/pan-de-arroz-recetas-com-bo.jpg',
          'categoria': {'id': 1, 'nombre': 'pan'},
        },
        'cantidad': 20
      },
    ]
  }
];
