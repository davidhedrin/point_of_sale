import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:point_of_sale/screens/add/addCustomer_screen.dart';
import 'package:point_of_sale/screens/details/customer_detail_screen.dart';
import 'package:point_of_sale/screens/home_screen.dart';
import 'package:point_of_sale/services/firebase_services.dart';
import 'package:point_of_sale/widgets/navigation_drawer.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({Key? key}) : super(key: key);

  static const String id = 'customer-screen';

  @override
  _CustomerScreenState createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  final FirebaseServices _services = FirebaseServices();


  late TextEditingController _searchTextController;
  late String searchKey;

  @override
  void initState() {
    super.initState();
    _searchTextController = TextEditingController();
    _searchTextController.addListener(() {
      setState(() {});
    });
  }

  void dispose(){
    super.dispose();
    _searchTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff363636),
        drawer: NavigationDrawerWidget(),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(125),
          child: Column(
            children: [
              AppBar(
                backgroundColor: Color(0xff363636),
                centerTitle: true,
                elevation: 0.0,
                title: Text('Customers', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 17),),
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.home_filled),
                    iconSize: 25.0,
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, HomeScreen.id);
                    },
                    color: Colors.white70,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15.0, left: 15.0, top: 5.0),
                child: TextField(
                  controller: _searchTextController,
                  onChanged: (value){
                    setState(() {
                      searchKey = value;
                    });
                  },
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 15),
                    hintText: 'Search Customer',
                    hintStyle: TextStyle(color: Colors.white60),
                    fillColor: Colors.white.withOpacity(0.5),
                    filled: true,
                    suffixIcon: _searchTextController.text.isEmpty ? IconButton(
                      onPressed: (){},
                      icon: Icon(Icons.search, color: Colors.white70,),
                    ) : IconButton(
                      icon: Icon(Icons.clear, color: Colors.red,),
                      onPressed: (){
                        _searchTextController.clear();
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: ListView(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: _searchTextController.text.isEmpty ? _services.customer.snapshots() :
                    _services.customer.where('nama_customer', isGreaterThanOrEqualTo: searchKey).
                    where('nama_customer', isLessThan: searchKey + 'z').snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                      if(snapshot.hasError){
                        return Text('Terjadi kesalahan');
                      }
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return Center(child: CircularProgressIndicator(),);
                      }
                      if(snapshot.data!.docs.length == 0){//jika data kosong
                        return Center(
                          child: Column(
                            children: [
                              SizedBox(
                                  height: 170,
                                  child: Image.asset('images/EmptyCustomer.png')
                              ),
                              SizedBox(height: 15,),
                              Text('Berlum ada Customer!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
                            ],
                          ),
                        );
                      }else{
                        return Column(
                          children: snapshot.data!.docs.map((DocumentSnapshot document){
                            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                            return Container(
                              margin: EdgeInsets.only(bottom: 17, right: 25, left: 25),
                              height: 140,//tinggi gambar
                              child: InkWell(
                                onTap: (){
                                  Navigator.push(
                                    context, MaterialPageRoute(
                                      builder: (context){
                                        return CustomerDetailScreen(
                                          idCustomer: data['id_customer'],
                                          namaCustomer : data['nama_customer'],
                                        );
                                      }
                                    ),
                                  );
                                },
                                child: Stack(
                                  children: [
                                    Positioned.fill(//background image
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.asset('images/customerImageCard.jpg', fit: BoxFit.cover,),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        height: 140,//tinggi background
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(20),
                                            bottomRight: Radius.circular(20),
                                            topRight: Radius.circular(20),
                                            topLeft: Radius.circular(20),
                                          ),
                                          color: Colors.black.withOpacity(0.7),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 15.0, left: 10.0),
                                      child: Row(
                                        children: [
                                          Text(data['nama_customer'], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 45.0, left: 10.0),
                                      child: Row(
                                        children: [
                                          Text('+62'+data['no_handpone'], style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 15),),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 65.0, left: 10.0),
                                      child: Row(
                                        children: [
                                          Text(data['email_customer'], style: TextStyle(color: Colors.grey, fontSize: 15),),
                                        ],
                                      ),
                                    ),

                                    //Alamat
                                    Padding(
                                      padding: const EdgeInsets.only(top: 110.0, left: 10.0),
                                      child: Column(
                                        children: [
                                          Flexible(
                                            child: Text(data['alamat_customer'],
                                              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 15),
                                              overflow: TextOverflow.ellipsis,),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: (){
            Navigator.pushNamed(context, AddCustomerData.id);
          },
          backgroundColor: Colors.white,
          icon: Icon(Icons.add, color: Colors.black,),
          label: Text('Customer', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),),
        ),
      ),
    );
  }
}
