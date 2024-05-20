class EmployeeModel {
  String? name;
  String? phone;
  String? email;
  String? password;
  String? salary;
  String? company;
  String? id;
  String? priorityService;
  Locations? locations;
  String? shift;

  EmployeeModel({
    this.name,
    this.phone,
    this.email,
    this.password,
    this.salary,
    this.id,
    this.company,
    this.priorityService,
    this.locations,
    this.shift,
  });

  EmployeeModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    password = json['password'];
    id = json['id'];
    salary = json['salary'];
    company = json['company'];
    priorityService = json['Priority Service'];
    shift = json['shift'];
    locations = json['locations'] != null
        ? Locations.fromJson(json['locations'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['phone'] = phone;
    data['email'] = email;
    data['password'] = password;
    data['salary'] = salary;
    data['id'] = id;
    data['company'] = company;
    data['Priority Service'] = priorityService;
    data['shift'] = shift;
    if (locations != null) {
      data['locations'] = locations!.toJson();
    }
    return data;
  }
}

class Locations {
  String? location1;
  String? location2;
  String? location3;
  String? location4;

  Locations({this.location1, this.location2, this.location3, this.location4});

  Locations.fromJson(Map<String, dynamic> json) {
    location1 = json['location1'];
    location2 = json['location2'];
    location3 = json['location3'];
    location4 = json['location4'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['location1'] = location1;
    data['location2'] = location2;
    data['location3'] = location3;
    data['location4'] = location4;
    return data;
  }
}
