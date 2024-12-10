import 'package:auth_app/components/my_button.dart';
import 'package:auth_app/components/my_textfield.dart';
import 'package:auth_app/views/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPassowordController = TextEditingController();

  void showAlert(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(title: Text(message));
      },
    );
  }

  void registerUser() async {

    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try{

      if(passwordController.text == confirmPassowordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: userNameController.text,
          password: passwordController.text
        );
        Navigator.pop(context);
        showAlert("Usuário Cadastrado com Sucesso!");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          )
        );
      }
      else {
        Navigator.pop(context);
        showAlert("Senhas não conferem!");
      }
    }on FirebaseAuthException catch(e) {
      print(e.code);
      if(e.code == 'email-already-in-use') {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(title: Text('Esse e-mail já está cadastrado!'));
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget> [
                const SizedBox(height: 50.0),
                Text(
                  'Crie sua conta',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 25.0),
                MyTextfield(
                  controller: userNameController,
                  hintText: "E-mail",
                  obscureText: false,
                ),
                const SizedBox(height: 15.0),
                MyTextfield(
                  controller: passwordController,
                  hintText: "Senha",
                  obscureText: true,
                ),
                const SizedBox(height: 15.0),
                MyTextfield(
                  controller: confirmPassowordController,
                  hintText: "Confirmar Senha",
                  obscureText: true,
                ),
                const SizedBox(height: 25.0),
                MyButton(
                  onTap: registerUser,
                  text: "Cadastrar",
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}