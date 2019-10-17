import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jee1rci/Models/product_model.dart';
import 'package:jee1rci/screens/detail.dart';
import 'package:jee1rci/screens/my_style.dart';
import 'package:barcode_scan/barcode_scan.dart';

class ListAllProduct extends StatefulWidget {
  @override
  _ListAllProductState createState() => _ListAllProductState();
}

class _ListAllProductState extends State<ListAllProduct> {
// Explicit

  List<ProductModel> productModels = [];
  String qrCode;

// Method
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readFireStore();
  }

  Future<void> readFireStore() async {
    Firestore firestore = Firestore.instance;
    CollectionReference collectionReference = firestore.collection('Product');
    await collectionReference.snapshots().listen((response) {
      List<DocumentSnapshot> snapshots = response.documents;
      for (var snapshot in snapshots) {
        print('Name = ${snapshot.data['Name']}');
        ProductModel productModel = ProductModel.fromFireStore(snapshot.data);
        setState(() {
          productModels.add(productModel);
        });
      }
    });
  }

  Widget showImage(int index) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.width * 0.4,
      child: Image.network(productModels[index].pathImage),
    );
  }

  Widget showText(int index) {
    return Container(
      padding: EdgeInsets.all(16.0),
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.width * 0.4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          showName(index),
          showDetailShot(index),
        ],
      ),
    );
  }

  Widget showName(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text(
          productModels[index].name,
          style: TextStyle(
            color: MyStyle().textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget showDetailShot(int index) {
    String detail = productModels[index].detail;
    if (detail.length > 50) {
      detail = detail.substring(0, 50);
      detail = '$detail ...';
    }
    return Text(detail);
  }

  Widget qrCodeButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 20.0, right: 20.0),
              child: FloatingActionButton(
                child: Icon(Icons.list),
                onPressed: () {
                  readQRcode();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> readQRcode() async {
    try {
      String qrCode = await BarcodeScanner.scan();
      print('qrCode = $qrCode');
      for (var productModel in productModels) {
        if (qrCode == productModel.qrCode) {
          MaterialPageRoute materialPageRoute = MaterialPageRoute(
              builder: (BuildContext context) => Detail(
                    productModel: productModel,
                  ));
          Navigator.of(context).push(materialPageRoute);
        } else {
          print('No $qrCode in my Database');
        }
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ListView.builder(
          itemCount: productModels.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              child: Row(
                children: <Widget>[
                  showImage(index),
                  showText(index),
                ],
              ),
              onTap: () {
                MaterialPageRoute materialPageRoute = MaterialPageRoute(
                    builder: (BuildContext context) => Detail(
                          productModel: productModels[index],
                        ));
                Navigator.of(context).push(materialPageRoute);
              },
            );
          },
        ),
        qrCodeButton(),
      ],
    );
  }
}
