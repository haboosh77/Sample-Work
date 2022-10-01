


import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendorpro/shared/network/remote/providers/authprovider.dart';

class SopePicCard extends StatefulWidget {
  static const String id='SopePicCard-screen';

  @override
  _SopePicCardState createState() => _SopePicCardState();
}

class _SopePicCardState extends State<SopePicCard> {
 File? _image;
  @override
  Widget build(BuildContext context) {
  final _authData=Provider.of<AuthProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: InkWell(
        onTap: (){
          _authData.PickImage().then((image){
            setState(() {
              _image=image!;
            });
            if(_image!=null){
              _authData.isPicAvail=true;
            }
          } );
        },
        child: SizedBox(
          height: 150,
          width: 150,
          child: Card(
            child:_image==null? Center(
              child: Text('Add Shop Image',//if no image picker
                style: TextStyle(
                color: Colors.grey,
              ),),
            ):Image.file(_image!,fit:BoxFit.fill,width: 150,height: 150,), //after picked
          ),
        )
      ),
    );
  }
}
