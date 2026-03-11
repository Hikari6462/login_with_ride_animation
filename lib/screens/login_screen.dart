import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'dart:async';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  // Variables para controlar la animación
  StateMachineController? _controller;
  SMIBool? _isChecking; // Agregamos el input para mirar el campo de email
  SMIBool? _isHandsUp; // Agregamos el input para manos arriba
  SMITrigger? _isSuccess; // Agregamos el trigger para éxito
  SMITrigger? _trigFail; // Agregamos el trigger para fallo

  SMINumber? _numLook;

  //1) crear variables para FocusNode
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  Timer? _typingDebounce;
  //controlers para manipular texto
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  ///errores que se veran en el ui
  String? _emailError;
  String? _passwordError;

  //validadores
  bool isValidEmail(String email) {
    // Expresión regular simple para validar email
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }

  bool isValidPassword(String password) {
    // Validar que la contraseña tenga al menos 8 caracteres una mayuscula, una minuscula, un digito y un especial
    return RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
    ).hasMatch(password);
  }

  void _onLogin() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    setState(() {
      // Validamos y asignamos errores si es necesario
      _emailError = isValidEmail(email) ? null : 'Email inválido';
      _passwordError = isValidPassword(password)
          ? null
          : 'La contraseña requiere Mayúscula, minúscula, # y especial';
    });

    if (_emailError == null && _passwordError == null) {
      _isSuccess?.fire(); // Disparamos éxito
    } else {
      _trigFail?.fire(); // Disparamos fallo
    }
  }

  //2) Listeners para FocusNode (Oyentes/Chismosos)

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(() {
      if (_emailFocusNode.hasFocus) {
        _isHandsUp?.value = false; // Bajamos las manos
      }
      _numLook?.value = 50.0;
    });

    _passwordFocusNode.addListener(() {
      //manos arriba en pasword
      _isHandsUp?.value = _passwordFocusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              SizedBox(
                width: size.width,
                height: 250, // Un poco más de espacio para el oso
                child: RiveAnimation.asset(
                  'assets/oso.riv',
                  stateMachines: const ['Login Machine'],
                  onInit: (artboard) {
                    _controller = StateMachineController.fromArtboard(
                      artboard,
                      'Login Machine',
                    );
                    //Verificamos que inicializamos el controlador correctamente, si no, salimos para evitar errores
                    if (_controller == null) return; // Si falla, salimos
                    // Agregamos el controlador al artboard
                    artboard.addController(_controller!);
                    // Vinculamos los inputs
                    _isChecking = _controller!.findSMI(
                      'isChecking',
                    ); // Para mirar el campo de email
                    _isHandsUp = _controller!.findSMI(
                      'isHandsUp',
                    ); // Para manos arriba
                    _isSuccess = _controller!.findSMI(
                      'trigSuccess',
                    ); // Para disparar éxito
                    _trigFail = _controller!.findSMI(
                      'trigFail',
                    ); // Para disparar fallo
                    _numLook = _controller!.findSMI('numLook');
                  },
                ),
              ),
              const SizedBox(height: 10),
              //Campo de texto para email
              TextField(
                //1.3 Asignar FocusNode al TextField
                focusNode: _emailFocusNode,
                controller: _emailController,
                onChanged: (value) {
                  // Cuando el usuario escribe, el oso mira el campo
                  _isHandsUp?.value = false;
                  _isChecking?.value = value.isNotEmpty;

                  // Lógica para que el oso siga el texto (numLook)
                  double lookValue = (value.length * 2.0).clamp(0.0, 100.0);
                  _numLook?.value = lookValue;

                  // Debounce para dejar de mirar después de escribir
                  _typingDebounce?.cancel();
                  _typingDebounce = Timer(const Duration(seconds: 2), () {
                    if (mounted) _isChecking?.value = false;
                  });
                },
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Email',
                  errorText: _emailError, // Mostramos el error si existe
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                //1.3 Asignar FocusNode al TextField
                focusNode: _passwordFocusNode,
                controller: _passwordController,
                onChanged: (value) {
                  // Cuando el usuario escribe, el oso mira el campo
                  if (_isChecking != null) {
                    _isChecking!.value = false;
                  }
                  if (_isHandsUp != null) {
                    _isHandsUp!.value = true;
                  }
                },
                onTap: () {
                  // Cuando el usuario va a escribir la clave, el oso se tapa los ojos
                  if (_isHandsUp != null) _isHandsUp!.value = true;
                },
                obscureText: _obscureText,
                decoration: InputDecoration(
                  hintText: 'Password',
                  errorText: _passwordError, // Mostramos el error si existe
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                        // Si mostramos la clave, el oso baja las manos
                        if (_isHandsUp != null) {
                          _isHandsUp!.value = _obscureText;
                        }
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Texto olvide mi contraseña
              SizedBox(
                width: size.width,
                child: const Text(
                  "Forgot password?",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              MaterialButton(
                minWidth: size.width,
                height: 50,
                color: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onPressed: _onLogin, // Llamamos a la función de login corregida
                child: const Text(
                  "Login",
                  style: TextStyle(color: Colors.white),
                ),
              ),

              // No tienes cuenta
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Register",
                      style: TextStyle(
                        color: Colors.blueAccent,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  //1.4 Liberar memoria/recursos al salir de la pantallla
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _typingDebounce?.cancel();
    super.dispose();
  }
}
