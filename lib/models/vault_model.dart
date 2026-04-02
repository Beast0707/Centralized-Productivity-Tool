class Vault {
  String? passward;

  // Constructor
  Vault({this.passward});

  // Object → Map
  Map<String, dynamic> toMap() {
    return {"passward": passward};
  }

  // Map → Object
  factory Vault.fromMap(Map<String, dynamic> map) {
    return Vault(passward: map["passward"]);
  }
}
