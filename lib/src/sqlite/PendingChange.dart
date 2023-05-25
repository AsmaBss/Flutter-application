class PendingChange {
  int? id;
  int? entityId;
  String? entityType;
  String? operationType;
  String? data;

  PendingChange(
      {this.id, this.entityId, this.entityType, this.operationType, this.data});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'entityId': entityId,
      'entityType': entityType,
      'operationType': operationType,
      'data': data,
    };
  }

  factory PendingChange.fromMap(Map<String, dynamic> map) {
    return PendingChange(
      id: map['id'],
      entityId: map['entityId'],
      entityType: map['entityType'],
      operationType: map['operationType'],
      data: map['data'],
    );
  }
}
