import 'dart:convert';

class FormModel {
  const FormModel(
    this.id,
    this.fileUrl,
    this.screenType,
    this.formType,
    this.availableStatus,
    this.createdAt,
    this.updatedAt,
  );

  final String id;
  final String fileUrl;
  final int screenType;
  final int formType;
  final bool availableStatus;
  final DateTime createdAt;
  final DateTime updatedAt;

  FormModel copyWith({
    String? id,
    String? fileUrl,
    int? screenType,
    int? formType,
    bool? availableStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FormModel(
      id ?? this.id,
      fileUrl ?? this.fileUrl,
      screenType ?? this.screenType,
      formType ?? this.formType,
      availableStatus ?? this.availableStatus,
      createdAt ?? this.createdAt,
      updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fileUrl': fileUrl,
      'screenType': screenType,
      'formType': formType,
      'availableStatus': availableStatus,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory FormModel.fromMap(Map<String, dynamic> map) {
    return FormModel(
      map['id'],
      map['fileUrl'],
      map['screenType'],
      map['formType'],
      map['availableStatus'],
      DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory FormModel.fromJson(String source) =>
      FormModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'FormModel(id: $id, fileUrl: $fileUrl, screenType: $screenType, formType: $formType, availableStatus: $availableStatus, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FormModel &&
        other.id == id &&
        other.fileUrl == fileUrl &&
        other.screenType == screenType &&
        other.formType == formType &&
        other.availableStatus == availableStatus &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        fileUrl.hashCode ^
        screenType.hashCode ^
        formType.hashCode ^
        availableStatus.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
