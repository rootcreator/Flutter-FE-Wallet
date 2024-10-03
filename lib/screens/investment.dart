import 'package:flutter/material.dart';
import 'package:wallet/services/investment_service.dart';

class InvestmentPage extends StatefulWidget {
  @override
  _InvestmentPageState createState() => _InvestmentPageState();
}

class _InvestmentPageState extends State<InvestmentPage> {
  Future<double>? portfolioValueFuture;
  Future<List<dynamic>>? investmentOptionsFuture;

  @override
  void initState() {
    super.initState();
    portfolioValueFuture = InvestmentService.fetchPortfolioValue(); // Fetch portfolio value
    investmentOptionsFuture = InvestmentService.fetchInvestmentOptions(); // Fetch investment options
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Portfolio Value Section
            FutureBuilder<double>(
              future: portfolioValueFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Text(
                    'Total Portfolio Value: \$${snapshot.data!.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green),
                  );
                }
              },
            ),
            SizedBox(height: 20),
            // Available Investments Section
            FutureBuilder<List<dynamic>>(
              future: investmentOptionsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return Text('No investment options available');
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      var option = snapshot.data![index];
                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          title: Text(option['name']),
                          subtitle: Text(option['description']),
                          trailing: ElevatedButton(
                            onPressed: () {
                              // Handle investment
                            },
                            child: Text('Invest'),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
