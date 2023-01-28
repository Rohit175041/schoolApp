// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:geotemp/test/login.dart';
// import 'package:geotemp/profile/HomeScreen.dart';
// import 'package:lottie/lottie.dart';
//
//
// class Signup extends StatefulWidget {
//   Signup({Key? key}) : super(key: key);
//
//   @override
//   _SignupState createState() => _SignupState();
// }
//
// class _SignupState extends State<Signup> {
//   final _formKey = GlobalKey<FormState>();
//   var email = "";
//   var password = "";
//   var confirmPassword = "";
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final confirmPasswordController = TextEditingController();
//
//   @override
//   void dispose() {
//     emailController.dispose();
//     passwordController.dispose();
//     confirmPasswordController.dispose();
//     super.dispose();
//   }
//
//   registration() async {
//     if (password == confirmPassword) {
//       try {
//         UserCredential userCredential = await FirebaseAuth.instance
//             .createUserWithEmailAndPassword(email: email, password: password);
//         print(userCredential);
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             backgroundColor: Colors.green,
//             content: Text(
//               "Registered Successful",
//               style: TextStyle(fontSize: 20.0),
//             ),
//           ),
//         );
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => Profile(),
//           ),
//         );
//       } on FirebaseAuthException catch (e) {
//         if (e.code == 'weak-password') {
//           print("Password is too Weak");
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               backgroundColor: Colors.red,
//               content: Text(
//                 "weak-password",
//                 style: TextStyle(fontSize: 18.0, color: Colors.black),
//               ),
//             ),
//           );
//         } else if (e.code == 'email-already-in-use') {
//           print("Account Already exists");
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               backgroundColor: Colors.red,
//               content: Text(
//                 "Account Already exists",
//                 style: TextStyle(fontSize: 18.0, color: Colors.black),
//               ),
//             ),
//           );
//         }
//       }
//     } else {
//       print("Password and Confirm Password doesn't match");
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           backgroundColor: Colors.orangeAccent,
//           content: Text(
//             "Password doesn't match",
//             style: TextStyle(fontSize: 16.0, color: Colors.black),
//           ),
//         ),
//       );
//     }
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
//                 height: 220,
//                 child: Lottie.asset("img/signup.json"),
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
//                       return 'Enter Password';
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
//                     labelText: 'Confirm Password: ',
//                     labelStyle: TextStyle(fontSize: 20.0),
//                     border: OutlineInputBorder(),
//                     errorStyle:
//                     TextStyle(color: Colors.redAccent, fontSize: 15),
//                   ),
//                   controller: confirmPasswordController,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Enter confirm Password';
//                     }
//                     return null;
//                   },
//                 ),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   ElevatedButton(
//                     onPressed: () {
//                       // Validate returns true if the form is valid, otherwise false.
//                       if (_formKey.currentState!.validate()) {
//                         setState(() {
//                           email = emailController.text;
//                           password = passwordController.text;
//                           confirmPassword = confirmPasswordController.text;
//                         });
//                         registration();
//                       }
//                     },
//                     child: const Text(
//                       'Sign Up',
//                       style: TextStyle(fontSize: 18.0),
//                     ),
//                   ),
//                 ],
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text("Already have an Account? "),
//                   TextButton(
//                       onPressed: () => {
//                         Navigator.pushReplacement(
//                           context,
//                           PageRouteBuilder(
//                             pageBuilder:
//                                 (context, animation1, animation2) =>
//                                 Login(),
//                             transitionDuration: const Duration(seconds: 0),
//                           ),
//                         )
//                       },
//                       child: const Text('Login'))
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }