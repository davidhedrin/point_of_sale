
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:point_of_sale/services/cart_service.dart';

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({Key? key, this.idTrans}) : super(key: key);
  final idTrans;

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  CartService _cart = CartService();
  DocumentSnapshot <Map<String, dynamic>>? docs;

  int nomorInvoice = 1;

  @override
  void initState() {
    getTransDetailData();
    super.initState();
  }

  Future<void> getTransDetailData() async {
    _cart.trans.doc(widget.idTrans).get().then((DocumentSnapshot document){
      if(document.exists){
        setState(() {
          docs = document as dynamic;
        });
      }
    });
  }

  Future<void> getPDF() async {
    // buat class pdf
    final pdf = pw.Document();

    // my font
    var dataFont = await rootBundle.load("assets/Oxygen-Regular.ttf");
    var myFont = pw.Font.ttf(dataFont);

    // my images
    var dataImage = await rootBundle.load("images/pokdakan.png");
    var myImage = dataImage.buffer.asUint8List();

    // buat pages
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context){
          return [
            pw.Column(
              children: [
                pw.Container(
                  alignment: pw.Alignment.center,
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Image(
                        pw.MemoryImage(myImage),
                        width: 50,
                        height: 50,
                      ),
                      pw.Text(
                        ' PT. Pokdakan Mitra Bersama',
                        style: pw.TextStyle(
                          fontSize: 25,
                          font: myFont,
                        ),
                      ),
                    ]
                  )
                ),
                pw.Divider(color: PdfColors.black,),
                pw.SizedBox(height: 10.0),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Column(
                      children: [
                        pw.Container(
                          color: PdfColors.blueGrey,
                          padding: pw.EdgeInsets.only(right: 10.0, left: 10.0, top: 5.0, bottom: 5.0),
                          child: pw.Text(
                            "INVOICE",
                            style: pw.TextStyle(
                              fontSize: 26,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.white,
                            ),
                          ),
                        ),
                        pw.Text(
                          widget.idTrans,
                          style: pw.TextStyle(
                            fontSize: 12,
                            color: PdfColors.black,
                            font: myFont,
                          ),
                        ),
                      ]
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          '${DateFormat('kk:mm,  d MMM y').format(DateTime.parse(docs!.data()!['waktu_trans']))}',
                          style: pw.TextStyle(
                            fontSize: 12,
                            color: PdfColors.black,
                            font: myFont,
                          ),
                        ),
                        pw.Text(
                          'Met.Bayar: ${docs!.data()!['metode_bayar']}',
                          style: pw.TextStyle(
                            fontSize: 12,
                            color: PdfColors.black,
                            font: myFont,
                          ),
                        ),
                        pw.Text(
                          'Met.Kirim: ${docs!.data()!['metode_kirim']}',
                          style: pw.TextStyle(
                            fontSize: 12,
                            color: PdfColors.black,
                            font: myFont,
                          ),
                        ),
                      ]
                    )
                  ]
                ),

                pw.SizedBox(height: 8),
                pw.Row(
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          docs!.data()!['customer']['nama_cutomer'],
                          style: pw.TextStyle(
                            fontSize: 30,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.black,
                          ),
                        ),
                        pw.Text(
                          docs!.data()!['customer']['id_customer'],
                          style: pw.TextStyle(
                            fontSize: 14,
                            color: PdfColors.black,
                            font: myFont,
                          ),
                        ),
                      ]
                    ),
                  ]
                ),

                pw.SizedBox(height: 8),
                pw.Text(
                  'Pesanan',
                  style: pw.TextStyle(
                    fontSize: 15,
                    color: PdfColors.black,
                    font: myFont,
                  ),
                ),
                pw.Divider(color: PdfColors.black,),

                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'No',
                      style: pw.TextStyle(
                        fontSize: 14,
                        color: PdfColors.black,
                        font: myFont,
                      ),
                    ),
                    pw.Text(
                      'Nama Barang',
                      style: pw.TextStyle(
                        fontSize: 14,
                        color: PdfColors.black,
                        font: myFont,
                      ),
                    ),
                    pw.Text(
                      'Satuan/kg',
                      style: pw.TextStyle(
                        fontSize: 14,
                        color: PdfColors.black,
                        font: myFont,
                      ),
                    ),
                    pw.Text(
                      'Banyak',
                      style: pw.TextStyle(
                        fontSize: 14,
                        color: PdfColors.black,
                        font: myFont,
                      ),
                    ),
                    pw.Text(
                      'Total Harga',
                      style: pw.TextStyle(
                        fontSize: 14,
                        color: PdfColors.black,
                        font: myFont,
                      ),
                    ),
                  ]
                ),
                pw.Divider(color: PdfColors.black,),

                pw.ListView.builder(
                  itemCount: docs!.data()!['produks'].length,
                  itemBuilder: (_, int index){
                    return pw.Column(
                      children: [
                        pw.Padding(
                          padding: pw.EdgeInsets.only(top: 5),
                          child: pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text(
                                '${nomorInvoice++}',
                                style: pw.TextStyle(
                                  fontSize: 14,
                                  color: PdfColors.black,
                                  font: myFont,
                                ),
                              ),
                              pw.Row(
                                children: [
                                  pw.Text(
                                    docs!.data()!['produks'][index]['nama_produk'],
                                    style: pw.TextStyle(
                                      fontSize: 14,
                                      color: PdfColors.black,
                                      font: myFont,
                                    ),
                                  ),
                                  pw.SizedBox(width: 5),
                                  pw.Container(
                                    decoration: pw.BoxDecoration(
                                      borderRadius: pw.BorderRadius.circular(2),
                                      color: PdfColors.deepOrange,
                                    ),
                                    padding: pw.EdgeInsets.only(right: 3.0, left: 3.0, top: 1.0, bottom: 1.0),
                                    child: pw.Text(
                                      docs!.data()!['produks'][index]['kode_produk'],
                                      style: pw.TextStyle(
                                        color: PdfColors.white,
                                        font: myFont,
                                      ),
                                    ),
                                  ),
                                ]
                              ),
                              pw.Text(
                                '${NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: 'Rp ').format(docs!.data()!['produks'][index]['harga_produk'])}',
                                style: pw.TextStyle(
                                  fontSize: 14,
                                  color: PdfColors.black,
                                  font: myFont,
                                ),
                              ),
                              pw.Text(
                                'x ${docs!.data()!['produks'][index]['unit_produk']}',
                                style: pw.TextStyle(
                                  fontSize: 14,
                                  color: PdfColors.black,
                                  font: myFont,
                                ),
                              ),
                              pw.Text(
                                '${NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: 'Rp ').format(docs!.data()!['produks'][index]['harga_produk']*docs!.data()!['produks'][index]['unit_produk'])}',
                                style: pw.TextStyle(
                                  fontSize: 14,
                                  color: PdfColors.black,
                                  font: myFont,
                                ),
                              ),
                            ]
                          ),
                        ),
                      ],
                    );
                  }
                ),
                pw.Divider(color: PdfColors.black,),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Text(
                      'Total Bayar: ',
                      style: pw.TextStyle(
                        fontSize: 14,
                        color: PdfColors.black,
                        font: myFont,
                      ),
                    ),
                    pw.Text(
                      NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: 'Rp ').format(docs!.data()!['sub_total_harga']),
                      style: pw.TextStyle(
                        fontSize: 17,
                        color: PdfColors.black,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ]
                ),
                pw.Divider(color: PdfColors.black,),
                pw.Text(
                  'PT. Pokdakan Mitra Bersama',
                  style: pw.TextStyle(
                    fontSize: 14,
                    color: PdfColors.black,
                    font: myFont,
                  ),
                ),
                pw.Text(
                  'Jln. Nusantara indah Bekasi Timur No.34, Jawa Barat, Indonesia',
                  style: pw.TextStyle(
                    fontSize: 13,
                    color: PdfColors.black,
                    font: myFont,
                  ),
                ),
              ]
            ),
          ];
        }
      )
    ); // Page

    // simpan
    Uint8List bytes = await pdf.save();

    // buat file kosong di direktori
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/${widget.idTrans}.pdf');

    // timpa file kosong dengan file pdf
    await file.writeAsBytes(bytes);

    // open pdf
    await OpenFile.open(file.path);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar:
        AppBar(
          backgroundColor: Color(0xff363636),
          elevation: 0.0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white,),
            color: Colors.black,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Column(
            children: [
              Text('Detail Pesanan',style: TextStyle(color: Colors.white60, fontSize: 12)),
              Text(widget.idTrans, style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16),),
            ],
          ),
        ),
        body: ListView(
          children: [
            StreamBuilder<DocumentSnapshot <Map <String, dynamic>>>(
              stream: _cart.firestoreTrans.collection('transaksis').doc(widget.idTrans).snapshots(),
              builder: (context, snapshot){
                if(snapshot.hasError){
                  print('Terdapat masalah');
                }
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(child: CircularProgressIndicator(),);
                }

                var data = snapshot.data!.data();

                return Column(
                  children: [
                    Container(
                      color: Color(0xff363636),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 15.0, left: 15.0),
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(data!['customer']['nama_cutomer'], style: TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.bold),),
                                      Text(data['customer']['id_customer'], style: TextStyle(color: Colors.white70, fontSize: 15,),),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 15,),
                            Padding(
                              padding: const EdgeInsets.only(right: 15.0, left: 15.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(Icons.wysiwyg, color: Colors.white, size: 50,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '${DateFormat('kk:mm,  d MMM y').format(DateTime.parse(data['waktu_trans']))}',
                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 3,),
                                      Text(
                                        '${data['metode_bayar']} - ${data['metode_kirim']}',
                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text('Items:'),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: data['produks'].length,
                      itemBuilder: (BuildContext context, int index){
                        return Column(
                          children: [
                            Divider(color: Colors.black87,),
                            ListTile(
                              horizontalTitleGap: 10,
                              leading: CircleAvatar(
                                radius: 30.0,
                                backgroundImage: NetworkImage(data['produks'][index]['imageUrl'],),
                              ),
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        data['produks'][index]['nama_produk'],
                                        style: TextStyle(fontSize: 15, color: Colors.black87, fontWeight: FontWeight.bold),
                                      ),
                                      Card(
                                        color: Colors.deepOrange,
                                        child: Padding(
                                          padding: const EdgeInsets.only(right: 5.0, left: 5.0, top: 3.0, bottom: 3.0),
                                          child: Column(
                                            children: [
                                              Text(
                                                data['produks'][index]['kode_produk'],
                                                style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '${NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: 'Rp ').format(data['produks'][index]['harga_produk']*data['produks'][index]['unit_produk'])}',
                                    style: TextStyle(color: Colors.black87, fontSize: 14,),
                                  ),
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '${NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: 'Rp ').format(data['produks'][index]['harga_produk'])}/kg',
                                        style: TextStyle(fontSize: 12, color: Colors.black87,),
                                      ),
                                      Text(
                                        ' x ${data['produks'][index]['unit_produk']}',
                                        style: TextStyle(fontSize: 12, color: Colors.blue,),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    data['produks'][index]['ket_produk'],
                                    style: TextStyle(color: Colors.black87, fontSize: 13,),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    Divider(color: Colors.black87,),
                    Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Total bayar:  ', style: TextStyle(color: Colors.black54, fontSize: 16),),
                          Text(
                            NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: 'Rp ').format(data['sub_total_harga']),
                            style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),


        floatingActionButton: FloatingActionButton(
          onPressed: (){
            getPDF();
          },
          backgroundColor: Colors.blue,
          child: Icon(Icons.print, color: Colors.white,),
        ),
      ),
    );
  }
}