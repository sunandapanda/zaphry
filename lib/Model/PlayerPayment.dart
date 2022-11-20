class PlayerPayment {
  String id = "";
  String date = "";
  String startTime = "";
  String dateTime = "";
  String sessionType = "";
  String coach = "";
  String status = "";
  String paymentDate = "";
  String transactionID = "";
  String price = "";

  PlayerPayment.fromMapObject(Map<String, dynamic> map) {
    this.id = map['session_id'];
    if (map['date'] != null) {
      this.date = map['date'];
    }
    if (map['start_time'] != null) {
      this.startTime = map['start_time'];
    }
    if (map['date_time'] != null) {
      this.dateTime = map['date_time'];
    }
    this.sessionType = map['session_type'];
    this.coach = map['coach'];
    this.status = map['status'];
    if (map['payment_date'] != null) {
      this.paymentDate = map['payment_date'];
    }
    if (map['transaction_id'] != null) {
      this.transactionID = map['transaction_id'];
    }
    this.price = map['price'];
  }
}
