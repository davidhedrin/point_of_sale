import 'dart:io';

import 'package:flutter/material.dart';
import 'package:point_of_sale/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class CategoryPicCard extends StatefulWidget {
  const CategoryPicCard({Key? key}) : super(key: key);

  @override
  State<CategoryPicCard> createState() => _CategoryPicCardState();
}

class _CategoryPicCardState extends State<CategoryPicCard> {
  File? _image;

  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);
    return InkWell(
      onTap: (){
        _authData.getImage().then((image){
          setState(() {
            _image = image;
          });
          if(image!=null){
            _authData.isPickAvail = true;
          }
        });
      },
      child: SizedBox(
        width: 100,
        height: 100,
        child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          child: _image == null ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('pilih gambar', style: TextStyle(fontSize: 15),),
              Icon(Icons.add),
            ],
          ): ClipRRect(
            borderRadius: BorderRadius.circular(50.0),
              child: Image.file(_image!, fit: BoxFit.fill,)
          ),
        ),
      ),
    );
  }
}