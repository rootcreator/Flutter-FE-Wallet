import 'api_service.dart';

class CardService {
  // Fetch the user's cards
  static Future<List<dynamic>> fetchUserCards() async {
    final response = await ApiService.getRequest('cards');
    return response['cards']; // Assuming the response contains a 'cards' list
  }

  // Add a new card
  static Future<dynamic> addNewCard(Map<String, dynamic> cardData) async {
    final response = await ApiService.postRequest('cards/add', cardData);
    return response;
  }
}
