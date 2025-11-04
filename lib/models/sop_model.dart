class SopModel {
  int? id;
  String? sopName;
  String? sopFile;

  SopModel({this.id, this.sopName, this.sopFile});

  SopModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sopName = json['sop_name'];
    sopFile = json['sop_file'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sop_name'] = sopName;
    data['sop_file'] = sopFile;
    return data;
  }
}
