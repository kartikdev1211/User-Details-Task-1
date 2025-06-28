import 'dart:convert';

class Geo {
  final String lat;
  final String lng;
  Geo({required this.lat, required this.lng});
  factory Geo.fromJson(Map<String, dynamic> j) =>
      Geo(lat: j['lat'], lng: j['lng']);
  Map<String, dynamic> toJson() => {'lat': lat, 'lng': lng};
}

class Address {
  final String street, suite, city, zipcode;
  final Geo geo;
  Address({
    required this.street,
    required this.suite,
    required this.city,
    required this.zipcode,
    required this.geo,
  });
  factory Address.fromJson(Map<String, dynamic> j) => Address(
    street: j['street'],
    suite: j['suite'],
    city: j['city'],
    zipcode: j['zipcode'],
    geo: Geo.fromJson(j['geo']),
  );
  Map<String, dynamic> toJson() => {
    'street': street,
    'suite': suite,
    'city': city,
    'zipcode': zipcode,
    'geo': geo.toJson(),
  };
}

class Company {
  final String name, catchPhrase, bs;
  Company({required this.name, required this.catchPhrase, required this.bs});
  factory Company.fromJson(Map<String, dynamic> j) =>
      Company(name: j['name'], catchPhrase: j['catchPhrase'], bs: j['bs']);
  Map<String, dynamic> toJson() =>
      {'name': name, 'catchPhrase': catchPhrase, 'bs': bs};
}

class User {
  final int id;
  final String name, username, email, phone, website;
  final Address address;
  final Company company;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    required this.website,
    required this.address,
    required this.company,
  });

  factory User.fromJson(Map<String, dynamic> j) => User(
    id: j['id'],
    name: j['name'],
    username: j['username'],
    email: j['email'],
    phone: j['phone'],
    website: j['website'],
    address: Address.fromJson(j['address']),
    company: Company.fromJson(j['company']),
  );

  /// Flatten nested objects for SQLite.
  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'username': username,
    'email': email,
    'phone': phone,
    'website': website,
    'address': jsonEncode(address.toJson()),
    'company': jsonEncode(company.toJson()),
  };

  factory User.fromMap(Map<String, dynamic> m) => User(
    id: m['id'],
    name: m['name'],
    username: m['username'],
    email: m['email'],
    phone: m['phone'],
    website: m['website'],
    address: Address.fromJson(jsonDecode(m['address'])),
    company: Company.fromJson(jsonDecode(m['company'])),
  );
}
