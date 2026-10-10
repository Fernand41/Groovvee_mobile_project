import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

// SignupScreen décrit l’écran, et Flutter lui associe _SignupScreenState pour gérer les changements de cet écran.
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>(); 
  final _firstNameController = TextEditingController(); 
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true; 
  bool _isLoading = false;  
  bool _isEnabled = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
// fonction appellé quand la personne valide le formulaire d'inscritption 
  Future<void> _submit() async {
    FocusScope.of(context).unfocus();  // ferme le clavier 

/*
    if (!_formKey.currentState!.validate()) return; // il va permettre de vérifier ce que contient tous les champs 

    setState(() {
      _isLoading = true; // si un champ n'est pas valide on ne fait rien et on retourne
    });
*/
    try {
      
      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;
      Navigator.of(
        context,
      ).pushReplacementNamed('/login', arguments: _emailController.text.trim());
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Inscription impossible. Réessaie.')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: Colors.black,
        actions: [
          Switch(
            value: _isEnabled, // indique si le switch est activé ou non
            onChanged: (value) { // indique ce qu'il se passe quand on change l'état du switch
              setState(() { // setState permet de redessiner l'interface avec les nouvelles valeurs
                _isEnabled = value; // on met à jour la valeur de _isEnabled avec la nouvelle valeur du switch
              });
            },
            activeThumbColor: Colors.white, // 
            activeTrackColor: Colors.black, //
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.black,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Image de fond
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Contenu : défile quand le clavier s'ouvre
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),
                  Text(
                    'Hi!',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 30,
                      color: const Color(0xff252525),
                    ),
                  ),
                  Text(
                    'Create your account',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 19,
                    ),
                  ),
                  const SizedBox(height: 28),

                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Prénom + Nom côte à côte
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _firstNameController,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  hint: Text(
                                    "First Name",
                                    style: GoogleFonts.poppins(
                                      color: Color(0xff79797B),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.only(
                                    left: 12,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Required';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: _lastNameController,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  hint: Text(
                                    "Last Name",
                                    style: GoogleFonts.poppins(
                                      color: Color(0xff79797B),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.only(
                                    left: 12,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Important';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Email
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            hint: Text(
                              "Email",
                              style: GoogleFonts.poppins(
                                color: Color(0xff79797B),
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            contentPadding: const EdgeInsets.only(top: 10),
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: Color(0xff79797B),
                            ),
                          ),
                          validator: (value) {
                            final v = value?.trim() ?? '';
                            if (v.isEmpty) return 'Enter your email';
                            final ok = RegExp(
                              r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                            ).hasMatch(v);
                            if (!ok) return 'Invalid email';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Mot de passe
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          style: const TextStyle(color: Color(0xff252525)),
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _submit(),
                          decoration: InputDecoration(
                            hint: Text(
                              "*********",
                              style: GoogleFonts.poppins(
                                color: Color(0xff79797B),
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            contentPadding: const EdgeInsets.only(top: 20),
                            hintTextDirection: TextDirection.rtl,
                            prefixIcon: Icon(
                              Icons.lock_outlined,
                              color: Color(0xff79797B),
                            ),
                            suffixIcon: IconButton(
                              tooltip: _obscurePassword
                                  ? 'Show password'
                                  : 'Hide password',
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: const Color(0xff79797B),
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Saisis ton mot de passe';
                            }

                            final password = value.trim();

                            if (password.length < 8) {
                              return '8 caractères minimum';
                            }
                            if (!RegExp(r'(?=.*[A-Z])').hasMatch(password)) {
                              return '1 majuscule minimum';
                            }
                            if (!RegExp(r'(?=.*[a-z])').hasMatch(password)) {
                              return '1 minuscule minimum';
                            }
                            if (!RegExp(r'(?=.*\d)').hasMatch(password)) {
                              return '1 chiffre minimum';
                            }
                            if (!RegExp(r'(?=.*[^A-Za-z0-9])').hasMatch(password)) {
                              return '1 caractère spécial minimum';
                            }

                            return null;
                          },
                        ),
                        const SizedBox(height: 30),

                        // Bouton
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    'Sign Up',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                          ),
                        ),
                        SizedBox(height: 40),
                        Row(
                          children: [
                            const Expanded(
                              child: Divider(
                                thickness: 1,
                                color: Color(0xffD0D0D0),
                                endIndent:
                                    12, // espace entre la ligne et le texte
                              ),
                            ),
                            Text(
                              "OR",
                              style: GoogleFonts.poppins(
                                color: const Color(0xff000000),
                                fontSize: 12,
                              ),
                            ),
                            const Expanded(
                              child: Divider(
                                thickness: 1,
                                color: Color(0xffD0D0D0),
                                indent: 12, // espace entre le texte et la ligne
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 40),
                        Text(
                          "Sign Up With Social Media",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff252525),
                          ),
                        ),
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/google.png",
                              width: 24,
                              height: 24,
                            ),
                            SizedBox(width: 10),
                            Image.asset(
                              "assets/apple.png",
                              width: 24,
                              height: 24,
                            ),
                          ],
                        ),
                        SafeArea(
                          top: false,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account?",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(
                                    context,
                                  ).pushReplacementNamed('/login');
                                },
                                child: Text(
                                  "Login",
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xff1C1B20),
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
