class GetDocumentsListModel {
  List<Data>? data;

  GetDocumentsListModel({this.data});

  GetDocumentsListModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? sId;
  String? filename;
  String? originalName;
  int? size;
  String? documentUrl;
  String? createdAt;

  Data(
      {this.sId,
        this.filename,
        this.originalName,
        this.size,
        this.documentUrl,
        this.createdAt});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    filename = json['filename'];
    originalName = json['originalName'];
    size = json['size'];
    documentUrl = json['document_url'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['filename'] = this.filename;
    data['originalName'] = this.originalName;
    data['size'] = this.size;
    data['document_url'] = this.documentUrl;
    data['createdAt'] = this.createdAt;
    return data;
  }
}