class PaymentModel {
  String? id;
  String? resource;
  String? mode;
  Amount? amount;
  String? description;
  String? method;
  String? redirectUrl;
  String? webhookUrl;
  String? status;
  String? organizationId;
  String? sequenceType;
  Map<String, dynamic>? metadata;
  String? createdAt;
  String? expiresAt;
  Links? links;

  PaymentModel({
    this.id,
    this.resource,
    this.mode,
    this.amount,
    this.description,
    this.method,
    this.redirectUrl,
    this.webhookUrl,
    this.status,
    this.organizationId,
    this.sequenceType,
    this.metadata,
    this.createdAt,
    this.expiresAt,
    this.links,
  });

  // Deserialize from JSON
  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] as String?,
      resource: json['resource'] as String?,
      mode: json['mode'] as String?,
      amount: json['amount'] != null ? Amount.fromJson(json['amount']) : null,
      description: json['description'] as String?,
      method: json['method'] as String?,
      redirectUrl: json['redirectUrl'] as String?,
      webhookUrl: json['webhookUrl'] as String?,
      status: json['status'] as String?,
      organizationId: json['organizationId'] as String?,
      sequenceType: json['sequenceType'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: json['createdAt'] as String?,
      expiresAt: json['expiresAt'] as String?,
      links: json['_links'] != null ? Links.fromJson(json['_links']) : null,
    );
  }

  // Serialize to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'resource': resource,
      'mode': mode,
      'amount': amount?.toJson(),
      'description': description,
      'method': method,
      'redirectUrl': redirectUrl,
      'webhookUrl': webhookUrl,
      'status': status,
      'organizationId': organizationId,
      'sequenceType': sequenceType,
      'metadata': metadata,
      'createdAt': createdAt,
      'expiresAt': expiresAt,
      '_links': links?.toJson(),
    };
  }
}

class Amount {
  String? value;
  String? currency;

  Amount({this.value, this.currency});

  factory Amount.fromJson(Map<String, dynamic> json) {
    return Amount(
      value: json['value'] as String?,
      currency: json['currency'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'currency': currency,
    };
  }
}

class Links {
  Self? self;
  Checkout? checkout;
  Dashboard? dashboard;

  Links({this.self, this.checkout, this.dashboard});

  factory Links.fromJson(Map<String, dynamic> json) {
    return Links(
      self: json['self'] != null ? Self.fromJson(json['self']) : null,
      checkout: json['checkout'] != null ? Checkout.fromJson(json['checkout']) : null,
      dashboard: json['dashboard'] != null ? Dashboard.fromJson(json['dashboard']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'self': self?.toJson(),
      'checkout': checkout?.toJson(),
      'dashboard': dashboard?.toJson(),
    };
  }
}

class Self {
  String? href;
  String? type;

  Self({this.href, this.type});

  factory Self.fromJson(Map<String, dynamic> json) {
    return Self(
      href: json['href'] as String?,
      type: json['type'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'href': href,
      'type': type,
    };
  }
}

class Checkout {
  String? href;
  String? type;

  Checkout({this.href, this.type});

  factory Checkout.fromJson(Map<String, dynamic> json) {
    return Checkout(
      href: json['href'] as String?,
      type: json['type'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'href': href,
      'type': type,
    };
  }
}

class Dashboard {
  String? href;
  String? type;

  Dashboard({this.href, this.type});

  factory Dashboard.fromJson(Map<String, dynamic> json) {
    return Dashboard(
      href: json['href'] as String?,
      type: json['type'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'href': href,
      'type': type,
    };
  }
}
