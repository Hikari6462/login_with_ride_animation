import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

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


//1) crear variables para FocusNode
final _emailFocusNode = FocusNode();
final _passwordFocusNode = FocusNode();

//2) Listeners para FocusNode (Oyentes/Chismosos)

@override
void initState() {
   super.initState();
  _emailFocusNode.addListener(() {
    if (_emailFocusNode.hasFocus) {
      if (_emailFocusNode.hasFocus){
        //VErifica que no sea nulo
        if (_isHandsUp  != null) {
          _isHandsUp?.change(false); // Bajamos las manos
        }
      }
    }
  
    }
  ) 
  _passwordFocusNode.addListener((){
    //manos arriba en pasword
    _isHandsUp?.change(_passwordFocusNode.hasFocus);
  });
}


  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              SizedBox(
                width: size.width,
                height: 250, // Un poco más de espacio para el oso
                child: RiveAnimation.asset(
                  'assets/animated_login_bear.riv',
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
                  },
                ),
              ),
              const SizedBox(height: 10),
              //Campo de texto para email
              TextField(
                //1.3 Asignar FocusNode al TextField
                focusNode: _emailFocusNode,
                onChanged: (value) {
                  // Cuando el usuario escribe, el oso mira el campo
                  if (_isHandsUp != null) {
                   // _isHandsUp!.change(false); // Bajamos las manos
                  }
                  // Si el campo no está vacío, el oso mira, si está vacío, el oso baja la mirada
                  if (_isChecking == null) return;
                  // Si el campo tiene texto, el oso mira, si está vacío, el oso baja la mirada
                  _isChecking!.change(true);
                },
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Email',
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
                onChanged: (value) {
                  // Cuando el usuario escribe, el oso mira el campo
                  if (_isChecking != null) {
                    //No quiero modo chismoso, así que el oso no mira el campo de password, solo baja las manos
                   // _isChecking!.change(false); // Bajamos las manos
                  }
                  //Si HandsUp es null, salimos para evitar errores
                  if (_isHandsUp == null) return;
                  // Si el campo tiene texto, el oso baja las manos, si está vacío, el oso sube las manos
                  _isHandsUp!.change(true);
                },
                onTap: () {
                  // Cuando el usuario va a escribir la clave, el oso se tapa los ojos
                  if (_isHandsUp != null) _isHandsUp!.value = true;
                },
                obscureText: _obscureText,
                decoration: InputDecoration(
                  hintText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                        // Si mostramos la clave, el oso baja las manos
                        if (_isHandsUp != null)
                          _isHandsUp!.value = _obscureText;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    ); 
  }
  //1.4 Liberar memoria/recursos al salir de la pantalla
  @override(){
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }
}