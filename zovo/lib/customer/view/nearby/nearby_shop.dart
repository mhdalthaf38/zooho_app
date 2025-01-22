    import 'package:flutter/material.dart';
    import 'package:webview_flutter/webview_flutter.dart';

    class RestaurantListPage extends StatelessWidget {
      final List<Map<String, dynamic>> restaurants = [
        {
          'name': 'Ayathil Mohanan Chettante Chaya Kada',
          'rating': 4.4,
          'reviews': 1065,
          'distance': '700 m',
          'type': 'Restaurant',
          'price': '₹1–200',
          'openStatus': 'Open',
          'closingTime': '9:30 pm',
          'images': ['image_url_1', 'image_url_2', 'image_url_3'],
          'location': 'Kollam-Ayoor Rd, Ayathil, Kollam, Kerala 691004',
        },
        {
          'name': 'Le Chique Restaurant',
          'rating': 3.4,
          'reviews': 543,
          'distance': '650 m',
          'type': 'Chinese',
          'price': '₹200–400',
          'openStatus': 'Open',
          'closingTime': '11:00 pm',
          'images': ['image_url_4', 'image_url_5', 'image_url_6'],
          'location': 'Kollam-Ayoor Rd, Ayathil, Kollam, Kerala 691004',
        },
      ];

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Restaurants', style: TextStyle(color: Colors.black)),
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
          ),
          body: ListView.builder(
            itemCount: restaurants.length,
            itemBuilder: (context, index) {
              final restaurant = restaurants[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RestaurantDetailPage(restaurant: restaurant),
                    ),
                  );
                },
                child: Card(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: restaurant['images'].length,
                          itemBuilder: (context, imageIndex) {
                            return Image.network(
                              restaurant['images'][imageIndex],
                              width: 200,
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              restaurant['name'],
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Icon(Icons.star, color: Colors.yellow, size: 16),
                                Text('${restaurant['rating']}'),
                                SizedBox(width: 5),
                                Text('(${restaurant['reviews']})'),
                                Spacer(),
                                Text(restaurant['distance']),
                              ],
                            ),
                            SizedBox(height: 5),
                            Text('${restaurant['type']} · ${restaurant['price']}'),
                            SizedBox(height: 5),
                            Text(
                              '${restaurant['openStatus']} · Closes ${restaurant['closingTime']}',
                              style: TextStyle(color: Colors.green),
                            ),
                          ],
                        ),
                      ),
                      ButtonBar(
                        alignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: () {
                          
                            },
                            child: Row(
                              children: [Icon(Icons.directions), Text(' Directions')],
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Row(
                              children: [Icon(Icons.menu_book), Text(' Menu')],
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Row(
                              children: [Icon(Icons.share), Text(' Share')],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }
    }

    class RestaurantDetailPage extends StatelessWidget {
      final Map<String, dynamic> restaurant;

      RestaurantDetailPage({required this.restaurant});

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text(restaurant['name'], style: TextStyle(color: Colors.black)),
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 300,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: restaurant['images'].length,
                    itemBuilder: (context, index) {
                      return Image.network(
                        restaurant['images'][index],
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        restaurant['name'],
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text('${restaurant['type']} · ${restaurant['price']}'),
                      SizedBox(height: 10),
                      Text(
                        '${restaurant['openStatus']} · Closes ${restaurant['closingTime']}',
                        style: TextStyle(color: Colors.green),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.grey),
                          Expanded(child: Text(restaurant['location'])),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                             
                            },
                            icon: Icon(Icons.directions),
                            label: Text('Directions'),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.phone),
                            label: Text('Call'),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.share),
                            label: Text('Share'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }
