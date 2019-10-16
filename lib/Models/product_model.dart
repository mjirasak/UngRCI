class ProductModel {
// Field
  String name, detail, pathImage, qrCode;

// Constuctor
  ProductModel(this.name, this.detail, this.pathImage, this.qrCode);

  ProductModel.fromFireStore(Map<String, dynamic> mapFireStore) {
    name = mapFireStore['Name'];
    detail = mapFireStore['Detail'];
    pathImage = mapFireStore['PathImage'];
    qrCode = mapFireStore['QRcode'];
  }
}
