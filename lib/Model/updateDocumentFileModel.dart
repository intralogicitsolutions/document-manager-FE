class UpdateDocumentFileModel {
  String? message;
  Data? data;

  UpdateDocumentFileModel({this.message, this.data});

  UpdateDocumentFileModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? sId;
  String? filename;
  String? filepath;
  String? originalName;
  int? size;
  String? documentUrl;
  String? createdAt;
  int? iV;

  Data(
      {this.sId,
        this.filename,
        this.filepath,
        this.originalName,
        this.size,
        this.documentUrl,
        this.createdAt,
        this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    filename = json['filename'];
    filepath = json['filepath'];
    originalName = json['originalName'];
    size = json['size'];
    documentUrl = json['document_url'];
    createdAt = json['createdAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['filename'] = this.filename;
    data['filepath'] = this.filepath;
    data['originalName'] = this.originalName;
    data['size'] = this.size;
    data['document_url'] = this.documentUrl;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    return data;
  }
}