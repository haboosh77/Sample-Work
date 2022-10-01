import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendorpro/modules/homescreen/homescreen.dart';
import 'package:vendorpro/shared/network/remote/providers/authprovider.dart';

class RegisterForm extends StatefulWidget {

  const RegisterForm({Key? key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
 final _formkey=GlobalKey<FormState>();
 var _nameTextController= TextEditingController();
  var _emailTextController= TextEditingController();
 var _passTextController= TextEditingController();
 var _CpassTextController= TextEditingController();
 var _addTextController= TextEditingController();
 var _dialogTextController= TextEditingController();
 String? email;
 String? password;
 String? mobail;
 String? shopName;
 bool _isloading=false;

 Future<String?> uploadFile(filePath) async {
   File file = File(filePath);
   FirebaseStorage _storage= FirebaseStorage.instance;
   try {
     await _storage.ref('uploads/shopProfilOic/${_nameTextController.text}').putFile(file);
   } on FirebaseException catch (e) {
     // e.g, e.code == 'canceled'
     print(e.code);
   }
   String downloadURL = await _storage
       .ref('uploads/shopProfilOic/${_nameTextController.text}')
       .getDownloadURL();
   return downloadURL;
 }

  @override
  Widget build(BuildContext context) {
    final _authrData=Provider.of<AuthProvider>(context);
    scaffoldmessage(message){
      return    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
    return _isloading? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),):Form(

      key:_formkey ,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(

              validator: (value){
                if(value!.isEmpty){
                  return 'Enter Shope Name';
                }setState(() {
                  _nameTextController.text=value;
                });
                setState(() {
                  shopName=value;
                });
                return null;
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.add_business),
                labelText: 'Business Name',
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2,color: Theme.of(context).primaryColor),
                ),
                focusColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              maxLength:10,
              keyboardType: TextInputType.number,
              validator: (value){
                if(value!.isEmpty){
                  return 'Enter Mobile Number';

                }
                setState(() {
                  mobail=value;
                });
                return null;
              },

              decoration: InputDecoration(
                prefixText:'+962',
                prefixIcon: Icon(Icons.phone_android),
                labelText: 'Mobile Numbur',
                contentPadding: EdgeInsets.zero,

                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2,color: Theme.of(context).primaryColor),
                ),
                focusColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),

            child: TextFormField(

              controller:_emailTextController,
              keyboardType:TextInputType.emailAddress,
              validator: (value){
                if(value!.isEmpty){
                  return 'Enter Email';
                }
                final bool _isvalid=EmailValidator.validate(_emailTextController.text);
                if(!_isvalid){
                  return 'Invalid Email Formate';
                }setState(() {
                  email=value;
                });
                return null;
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email_outlined),
                labelText: 'Emaile',
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2,color: Theme.of(context).primaryColor),
                ),
                focusColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),

            child: TextFormField(
              controller:_passTextController ,
              obscureText: true,
              validator: (value){
                if(value!.isEmpty){
                  return 'Enter Password';
                }if(value.length<6){
                  return 'your password must be more than 6 characters';
                }setState(() {
                  password=value;
                });
                return null;
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.remove_red_eye),
                labelText: 'Password',
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2,color: Theme.of(context).primaryColor),
                ),
                focusColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              controller:_CpassTextController ,
              obscureText: true,
              validator: (value){

                if(value!.isEmpty){
                  return 'Enter Confirm Password';
                }if(value.length<6){
                  return 'your password must be more than 6 characters';
                }
                if(_passTextController.text!=_CpassTextController.text){
                  return 'Password doesn\'t match';
                }

                return null;
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.remove_red_eye),
                labelText: 'Confirm Password',
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2,color: Theme.of(context).primaryColor),
                ),
                focusColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              maxLines: 6,
              controller: _addTextController,
              keyboardType: TextInputType.text,
              validator: (value){
                if(value!.isEmpty){
                  return 'select your currant location ';
                }if(_authrData.shoplatitude==null){
                  return 'select your currant location ';
                }
                return null;
              },

              decoration: InputDecoration(
                prefixIcon: IconButton(onPressed: (){
                  _addTextController.text='Locating...\nplease wait';
                  _authrData.getCurrentAddress().then((address) {
                    if(address!=null){
                      setState(() {
                        _addTextController.text='${_authrData.placeN}\n${_authrData.shopeAdress}';
                      });
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not find location....Try again')));
                    }
                  });
                },
                    icon:Icon( Icons.location_searching)),
                labelText: 'Business location',
                contentPadding: EdgeInsets.zero,

                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2,color: Theme.of(context).primaryColor),
                ),
                focusColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              onChanged: (value){
                _dialogTextController.text=value;
              },

              decoration: InputDecoration(
                prefixIcon: Icon(Icons.comment),
                labelText: 'Shope Dialog',
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2,color: Theme.of(context).primaryColor),
                ),
                focusColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
          SizedBox(height: 20.0,),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                    style:ElevatedButton.styleFrom(primary: Theme.of(context).primaryColor

                    ),
                    onPressed: (){
                      if(_authrData.isPicAvail==true){
                        if(_formkey.currentState!.validate()){
                          setState(() {
                            _isloading=true;
                          });
                       _authrData.registerVendor(email, password).then((credential) {
                         if(credential!.user!.uid!=null){
                           //user regesterd
                         uploadFile(_authrData.image).then((url) {
                           if(url!=null){
                             //save
                             _authrData.savedatatodb(
                               url: url,
                               mobail: mobail,
                               shopeName: shopName,
                               dialog: _dialogTextController.text,

                             ).then((value) {
                               setState(() {

                                 _formkey.currentState!.reset();
                                 _isloading=false;
                               });
                               Navigator.pushReplacementNamed(context, HomeScreen.id);
                             });

                           }else{
                             scaffoldmessage('faild to upload profile');
                           }
                         });
                         }else{
                           scaffoldmessage(_authrData.error);

                           //register faild
                         }
                       });
                        }
                      }else{
                       scaffoldmessage('Add Shop Picture');
                      }

                    }, child: Text('Register',style:TextStyle(color:Colors.white,))),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
