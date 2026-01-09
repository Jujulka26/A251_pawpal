class Donation {
  String? donationId;
  String? userId;
  String? petId;
  String? petName;
  String? donationType;
  String? amount;
  String? description;
  String? donationDate;

  Donation({
    this.donationId,
    this.userId,
    this.petId,
    this.petName,
    this.donationType,
    this.amount,
    this.description,
    this.donationDate,
  });

  Donation.fromJson(Map<String, dynamic> json) {
    donationId = json['donation_id'];
    userId = json['user_id'];
    petId = json['pet_id'];
    petName = json['pet_name'];
    donationType = json['donation_type'];
    amount = json['amount'];
    description = json['description'];
    donationDate = json['donation_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['donation_id'] = donationId;
    data['user_id'] = userId;
    data['pet_id'] = petId;
    data['pet_name'] = petName;
    data['donation_type'] = donationType;
    data['amount'] = amount;
    data['description'] = description;
    data['donation_date'] = donationDate;
    return data;
  }
}
