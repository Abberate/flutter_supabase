import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  late bool _signInLoading = false;
  late bool _signUpLoading = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

 //Sign up & Sign In Syntaxes
 // Sign up syntaxe : supabase.auth.signUp(email: ,password: );
  // Sign in syntaxe : supabase.auth.signInWithPassword(email: , password: );

  @override
  void dispose() {
    supabase.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  SizedBox(height: constraints.maxHeight * 0.1),
                  Image.network(
                    "https://seeklogo.com/images/S/supabase-logo-DCC676FFE2-seeklogo.com.png",
                    height: 150,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.1),
                  Text(
                    "Connexion",
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.05),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        //email field
                        TextFormField(
                          cursorColor: const Color(0xFF00BF6D),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "L'email est obligatoire !!!";
                            } else {
                              return null;
                            }
                          },
                          controller: _emailController,
                          decoration: const InputDecoration(
                            hintText: 'Email',
                            filled: true,
                            fillColor: Color(0xFFF5FCF9),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.0 * 1.5, vertical: 16.0),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,

                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          cursorColor: const Color(0xFF00BF6D),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Le mot de passe est obligatoire !!!";
                            } else {
                              return null;
                            }
                          },
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            hintText: 'Mots de passe',
                            filled: true,
                            fillColor: Color(0xFFF5FCF9),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.0 * 1.5, vertical: 16.0),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        _signInLoading ?  const Center(
                          child: CircularProgressIndicator(color: const Color(0xFF00BF6D),),
                        ) :
                        ElevatedButton(
                          onPressed: () async{
                            final isValidate =
                            _formKey.currentState?.validate();
                            if (isValidate != true) {
                              return null;
                            }
                            setState(() {
                              _signInLoading= true;
                            });

                            try {
                              await supabase.auth.signInWithPassword(email: _emailController.text,password: _passwordController.text);
                              setState(() {
                                _signInLoading = false;
                              });
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erreur! Identifiant ou mot de passe'),backgroundColor: Colors.red,));
                              setState(() {
                                _signInLoading = false;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: const Color(0xFF00BF6D),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 48),
                            shape: const StadiumBorder(),
                          ),
                          child: const Text("Connexion"),
                        ),
                        const SizedBox(height: 16.0),

                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'Mot de passe oublier ?',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color!
                                      .withOpacity(0.64),
                                ),
                          ),
                        ),
                        _signUpLoading
                            ? const Center(
                                child: CircularProgressIndicator(color: const Color(0xFF00BF6D),),
                              )
                            : TextButton(
                                onPressed: () async {
                                  final isValidate =
                                      _formKey.currentState?.validate();
                                  if (isValidate != true) {
                                    return null;
                                  }
                                  setState(() {
                                    _signUpLoading = true;
                                  });

                                  try {
                                    await supabase.auth.signUp(email: _emailController.text,password: _passwordController.text);
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Bravo! email de confirmation envoyer'),backgroundColor: const Color(0xFF00BF6D) ,));
                                    setState(() {
                                      _signUpLoading = false;
                                    });



                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erreur! email de confirmation non envoyer'),backgroundColor: Colors.red));
                                    setState(() {
                                      _signUpLoading = false;
                                    });

                                  }
                                },
                                child: Text.rich(
                                  const TextSpan(
                                    text: "Pas encore de compte ? ",
                                    children: [
                                      TextSpan(
                                        text: "s'inscrire",
                                        style:
                                            TextStyle(color: Color(0xFF00BF6D)),
                                      ),
                                    ],
                                  ),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .color!
                                            .withOpacity(0.64),
                                      ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
