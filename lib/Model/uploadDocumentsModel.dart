class UploadDocumetsModel {
  String? message;
  List<Data>? data;

  UploadDocumetsModel({this.message, this.data});

  UploadDocumetsModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? filename;
  String? filepath;
  String? originalName;
  int? size;
  String? mimetype;
  String? extension;
  String? documentUrl;
  String? sId;
  String? createdAt;
  int? iV;

  Data(
      {this.filename,
        this.filepath,
        this.originalName,
        this.size,
        this.mimetype,
        this.extension,
        this.documentUrl,
        this.sId,
        this.createdAt,
        this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    filename = json['filename'];
    filepath = json['filepath'];
    originalName = json['originalName'];
    size = json['size'];
    mimetype = json['mimetype'];
    extension = json['extension'];
    documentUrl = json['document_url'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['filename'] = this.filename;
    data['filepath'] = this.filepath;
    data['originalName'] = this.originalName;
    data['size'] = this.size;
    data['mimetype'] = this.mimetype;
    data['extension'] = this.extension;
    data['document_url'] = this.documentUrl;
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    return data;
  }
}