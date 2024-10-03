import 'package:flutter/material.dart';
import 'package:wallet/services/card_service.dart';

class CardPage extends StatefulWidget {
  @override
  _CardPageState createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  Future<List<dynamic>>? cardsFuture;

  @override
  void initState() {
    super.initState();
    cardsFuture = CardService.fetchUserCards(); // Fetch user cards
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Cards Section
            FutureBuilder<List<dynamic>>(
              future: cardsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return Text('No cards available');
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      var card = snapshot.data![index];
                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          leading: Icon(Icons.credit_card),
                          title: Text(card['card_name']),
                          subtitle: Text('Card ending in ${card['last4']}'),
                          trailing: ElevatedButton(
                            onPressed: () {
                              // Handle card actions
                            },
                            child: Text('Manage'),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
            SizedBox(height: 20),
            // Add New Card Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle add new card
                },
                child: Text('Add New Card'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
