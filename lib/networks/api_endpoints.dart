class ApiEndPoints {
  static const String baseUrl = 'http://103.184.181.9/api/';
  static _AuthEndPoints authEndpoints = _AuthEndPoints();
}

class _AuthEndPoints {
  final String login = 'loginkios';
  final String product = 'products';
  final String saveTransaction = 'savetransaction';
  final String getTransactions = 'transactions';
  final String deleteTransaction = 'deletetransaction';
  final String getTransactionDetails = 'transactiondetails';
  final String categories = 'productCategory';
}
