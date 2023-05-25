class SynchronisationModel {
  int? id;
  String? tableName; // nom de la table modifiée
  int? recordId; // id de la colonne modifiée
  String? operation; // type d'opération => insert, update, delete ...
  String? data; // requete
  int? syncStatus;

  SynchronisationModel(
      {this.id,
      this.tableName,
      this.recordId,
      this.operation,
      this.data,
      this.syncStatus});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tableName': tableName,
      'recordId': recordId,
      'operation': operation,
      'data': data,
      'syncStatus': syncStatus
    };
  }

  factory SynchronisationModel.fromMap(Map<String, dynamic> map) {
    return SynchronisationModel(
      id: map['id'],
      tableName: map['tableName'],
      recordId: map['recordId'],
      operation: map['operation'],
      data: map['data'],
      syncStatus: map['syncStatus'],
    );
  }
}
