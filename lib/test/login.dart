// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:geotemp/profile/profile.dart';
// import 'package:geotemp/test/signup.dart';
// import 'package:lottie/lottie.dart';
//
// class Login extends StatefulWidget {
//   Login({Key? key}) : super(key: key);
//
//   @override
//   _LoginState createState() => _LoginState();
// }
//
// class _LoginState extends State<Login> {
//   final _formKey = GlobalKey<FormState>();
//
//   var email = "";
//   var password = "";
//   // Create a text controller and use it to retrieve the current value
//   // of the TextField.
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final storage = const FlutterSecureStorage();
//
//   userLogin() async {
//
//     try {
//       UserCredential userCredential = await FirebaseAuth.instance
//           .signInWithEmailAndPassword(email: email, password: password);
//       print(userCredential.user?.uid);
//       await storage.write(key: "uid", value: userCredential.user?.uid);
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => Profile(),
//         ),
//       );
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'user-not-found') {
//         print("No User Found for that Email");
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             backgroundColor: Colors.red,
//             content: Text(
//               "No User Found ",
//               style: TextStyle(fontSize: 18.0, color: Colors.black),
//             ),
//           ),
//         );
//       } else if (e.code == 'wrong-password') {
//         print("incorrect Password ");
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             backgroundColor: Colors.red,
//             content: Text(
//               "Wrong Password Provided by User",
//               style: TextStyle(fontSize: 18.0, color: Colors.black),
//             ),
//           ),
//         );
//       }
//     }
//   }
//
//   @override
//   void dispose() {
//     emailController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Form(
//         key: _formKey,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//           child: ListView(
//             children: [
//               SizedBox(
//                 height: 280,
//                 child: Lottie.asset("img/login.json"),
//               ),
//               Container(
//                 margin: const EdgeInsets.symmetric(vertical: 10.0),
//                 child: TextFormField(
//                   autofocus: false,
//                   decoration: const InputDecoration(
//                     labelText: 'Email: ',
//                     labelStyle: TextStyle(fontSize: 20.0),
//                     border: OutlineInputBorder(),
//                     errorStyle:
//                     TextStyle(color: Colors.redAccent, fontSize: 15),
//                   ),
//                   controller: emailController,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please Enter Email';
//                     } else if (!value.contains('@')) {
//                       return 'Please Enter Valid Email';
//                     }
//                     return null;
//                   },
//                 ),
//               ),
//               Container(
//                 margin: const EdgeInsets.symmetric(vertical: 10.0),
//                 child: TextFormField(
//                   autofocus: false,
//                   obscureText: true,
//                   decoration: const InputDecoration(
//                     labelText: 'Password: ',
//                     labelStyle: TextStyle(fontSize: 20.0),
//                     border: OutlineInputBorder(),
//                     errorStyle:
//                     TextStyle(color: Colors.redAccent, fontSize: 15),
//                   ),
//                   controller: passwordController,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please Enter Password';
//                     }
//                     return null;
//                   },
//                 ),
//               ),
//               Container(
//                 margin: const EdgeInsets.only(left: 20.0,right:20),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     ElevatedButton(
//                       onPressed: () {
//                         // Validate returns true if the form is valid, otherwise false.
//                         if (_formKey.currentState!.validate()) {
//                           setState(() {
//                             email = emailController.text;
//                             password = passwordController.text;
//                           });
//                           userLogin();
//                         }
//                       },
//                       child: const Center(
//                         child: Text(
//                           'Login',
//                           style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text("Don't have an Account? "),
//                   TextButton(
//                     onPressed: () => {
//                       Navigator.pushAndRemoveUntil(
//                           context,
//                           PageRouteBuilder(
//                             pageBuilder: (context, a, b) => Signup(),
//                             transitionDuration: const Duration(seconds: 0),
//                           ),
//                               (route) => false)
//                     },
//                     child: const Text('SignUp',
//                         style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic)
//                     ),
//                   ),
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }