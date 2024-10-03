import 'api_service.dart';

class InvestmentService {
  // Fetch portfolio data
  static Future<double> fetchPortfolioValue() async {
    final response = await ApiService.getRequest('investment/portfolio');
    return response['portfolio_value']; // Assuming the response contains a 'portfolio_value' key
  }

  // Fetch available investment options
  static Future<List<dynamic>> fetchInvestmentOptions() async {
    final response = await ApiService.getRequest('investment/options');
    return response['options']; // Assuming the response contains an 'options' list
  }
}
