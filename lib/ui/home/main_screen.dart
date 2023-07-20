import 'package:acfashion_store/domain/controller/controllerFavoritos.dart';
import 'package:acfashion_store/domain/controller/controllerProductos.dart';
import 'package:acfashion_store/domain/controller/controllerUserAuth.dart';
import 'package:acfashion_store/domain/controller/controllerUserPerfil.dart';
import 'package:acfashion_store/ui/home/dashboard_screen.dart';
import 'package:acfashion_store/ui/home/drawer_screen.dart';
import 'package:acfashion_store/ui/models/favorite_model.dart';
import 'package:acfashion_store/ui/models/theme_model.dart';
import 'package:acfashion_store/ui/styles/my_colors.dart';
import 'package:acfashion_store/ui/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  //CONTROLADORES
  ControlUserAuth controlua = Get.find();
  ControlUserPerfil controlup = Get.put(ControlUserPerfil());
  ControlProducto controlp = Get.put(ControlProducto());
  ControlFavoritos controlf = Get.put(ControlFavoritos());
  //VARIABLES DE CONTROL
  String idUsuario = '';
  String? uid;
  String msg = "";
  int tiempoDeintento = 5;
  String precioFormateado = "";
  //VARIABLES DE PERFIL
  var id = "";
  var foto = "";
  var correo = "";
  var contrasena = "";
  var nombre = "";
  var profesion = "";
  var direccion = "";
  var celular = "";
  //VARIABLES PRODUCTOS
  var idProducto = "";
  var cantidadProducto = 0;
  var catalogoProducto = "";
  var modeloProducto = "";
  var nombreProducto = "";
  var descripcionProducto = "";
  var colorProducto = "";
  var tallaProducto = "";
  var categoriaProducto = "";
  var valoracionProducto = "";
  var precioProducto = 0.0;
  //LISTAS
  List<Map<String, dynamic>> consultaProductos = [];
  List<Map<String, dynamic>> consultaFavoritos = [];
  List<FavoriteModel> favoritos = [];
  List<ProductModel> productos = [];
  //MAPAS
  Map<String, dynamic> perfil = {};

  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    //Se consulta el uid del perfil autenticado
    controlua.consultarUser().then((value) {
      setState(() {
        uid = controlua.uidValido;
        idUsuario = uid!;
      });
      cargarDatos();
    });
  }

  void cargarDatos() {
    //Se obtienen datos de perfil autenticado
    controlup.obtenerperfil(idUsuario).then((value) {
      setState(() {
        msg = controlup.mensajesPerfil;
      });
      if (msg == "Proceso exitoso") {
        setState(() {
          perfil = controlup.datosPerfil;
          id = perfil['id'] ?? '';
          foto = perfil['foto'] ?? '';
          correo = perfil['correo'] ?? '';
          contrasena = perfil['contrasena'] ?? '';
          nombre = perfil['nombre'] ?? '';
          profesion = perfil['profesion'] ?? '';
          direccion = perfil['direccion'] ?? '';
          celular = perfil['celular'] ?? '';
          print("Datos perfil recibidos en MainScreen: $perfil");
        });
      } else {
        print("Error al cargar datos del perfil");
      }
    });
    //Se obtienen datos de productos
    controlp.obtenerproductos().then((value) {
      setState(() {
        msg = controlp.mensajesProducto;
      });
      if (msg == "Proceso exitoso") {
        setState(() {
          consultaProductos = controlp.datosProductos;
          print(
              "Datos de productos recibidos en MainScreen: $consultaProductos");
          for (var i = 0; i < consultaProductos.length; i++) {
            idProducto = consultaProductos[i]['id'] ?? '';
            cantidadProducto = consultaProductos[i]['cantidad'] ?? 0;
            catalogoProducto = consultaProductos[i]['catalogo'] ?? '';
            modeloProducto = consultaProductos[i]['modelo'] ?? '';
            nombreProducto = consultaProductos[i]['nombre'] ?? '';
            descripcionProducto = consultaProductos[i]['descripcion'] ?? '';
            colorProducto = consultaProductos[i]['color'] ?? '';
            tallaProducto = consultaProductos[i]['talla'] ?? '';
            categoriaProducto = consultaProductos[i]['categoria'] ?? '';
            valoracionProducto = consultaProductos[i]['valoracion'] ?? '';
            precioProducto = consultaProductos[i]['precio'] ?? 0.0;
            precioFormateado =
                NumberFormat("#,###", "es_CO").format(precioProducto * 1000);
            productos.add(ProductModel(
              idProducto,
              cantidadProducto,
              catalogoProducto,
              modeloProducto,
              nombreProducto,
              colorProducto,
              tallaProducto,
              categoriaProducto,
              descripcionProducto,
              valoracionProducto,
              precioFormateado,
            ));
          }
        });
      } else {
        print("Error al cargar datos de productos");
      }
    });
    controlf.obtenerfavoritos(idUsuario).then((value) {
      setState(() {
        msg = controlf.mensajesFavorio;
      });
      if (msg == "Proceso exitoso") {
        setState(() {
          consultaFavoritos = controlf.datosFavoritos;
          for (var i = 0; i < consultaFavoritos.length; i++) {
            idUsuario = consultaFavoritos[i]['uid'] ?? '';
            cantidadProducto = consultaFavoritos[i]['cantidad'] ?? 0;
            catalogoProducto = consultaFavoritos[i]['imagen'] ?? '';
            nombreProducto = consultaFavoritos[i]['nombre'] ?? '';
            descripcionProducto = consultaFavoritos[i]['descripcion'] ?? '';
            colorProducto = consultaFavoritos[i]['color'] ?? '';
            tallaProducto = consultaFavoritos[i]['talla'] ?? '';
            categoriaProducto = consultaFavoritos[i]['categoria'] ?? '';
            valoracionProducto = consultaFavoritos[i]['valoracion'] ?? '';
            precioProducto = consultaFavoritos[i]['precio'] ?? 0.0;
            idProducto = consultaFavoritos[i]['id'] ?? '';
            favoritos.add(FavoriteModel(
                idUsuario,
                cantidadProducto,
                catalogoProducto,
                nombreProducto,
                descripcionProducto,
                colorProducto,
                tallaProducto,
                categoriaProducto,
                valoracionProducto,
                precioFormateado,
                idProducto));
          }
        });
      } else {
        print("Error al cargar datos de favoritos");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    var temaActual = theme.getTheme();
    if (temaActual == ThemeData.dark()) {
      _isDarkMode = true;
    } else {
      _isDarkMode = false;
    }
    return Scaffold(
      backgroundColor: _isDarkMode != false ? Colors.black : Colors.white,
      body: Container(
        alignment: Alignment.center,
        child: FutureBuilder(
          future: Future.delayed(
              Duration(seconds: 3)), //Establece el tiempo de carga
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: MyColors.myPurple,
                    backgroundColor: Colors.purple[400],
                  ),
                  Text(
                    "Cargando...",
                    style: TextStyle(
                      color: MyColors.myPurple,
                      fontSize: 20,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              );
            } else {
              if (productos.isNotEmpty && perfil.isNotEmpty) {
                return Scaffold(
                  body: Stack(
                    children: [
                      DrawerScreen(
                        uid: id,
                        nombre: nombre,
                        correo: correo,
                        contrasena: contrasena,
                        celular: celular,
                        direccion: direccion,
                        foto: foto,
                        profesion: profesion,
                      ),
                      //MainScreen(uid: uid, catalogo: catalogo), //Pantalla principal
                      DashboardScreen(
                        id: id,
                        nombre: nombre,
                        correo: correo,
                        contrasena: contrasena,
                        foto: foto,
                        profesion: profesion,
                        direccion: direccion,
                        celular: celular,
                        productos: productos,
                        favoritos: favoritos,
                      ),
                    ],
                  ),
                );

                // return DashboardScreen(
                //           id: id,
                //           nombre: nombre,
                //           correo: correo,
                //           contrasena: contrasena,
                //           catalogo: catalogo,
                //           profesion: profesion,
                //           direccion: direccion,
                //           celular: celular,
                //           productos: productos,
                //         ),
              } else {
                if (snapshot.hasError) {
                  final theme = Provider.of<ThemeChanger>(context);
                  var temaActual = theme.getTheme();
                  if (temaActual == ThemeData.dark()) {
                    _isDarkMode = true;
                  } else {
                    _isDarkMode = false;
                  }
                  return Container(
                    color: _isDarkMode != false ? Colors.black : Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.network_check,
                              color: _isDarkMode != false
                                  ? _isDarkMode != false
                                      ? Colors.red
                                      : Color.fromARGB(255, 231, 30, 15)
                                  : Color.fromARGB(255, 231, 30, 15),
                            ),
                            Icon(
                              Icons.error,
                              color: _isDarkMode != false
                                  ? _isDarkMode != false
                                      ? Colors.red
                                      : Color.fromARGB(255, 231, 30, 15)
                                  : Color.fromARGB(255, 231, 30, 15),
                            ),
                          ],
                        ),
                        Text(
                          "Error: ${snapshot.error}",
                          style: TextStyle(
                            color: _isDarkMode != false
                                ? _isDarkMode != false
                                    ? Colors.red
                                    : Color.fromARGB(255, 231, 30, 15)
                                : Color.fromARGB(255, 231, 30, 15),
                            fontSize: 20,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        Text(
                          "Verifique su conexión a internet",
                          style: TextStyle(
                            color: _isDarkMode != false
                                ? _isDarkMode != false
                                    ? Colors.red
                                    : Color.fromARGB(255, 231, 30, 15)
                                : Color.fromARGB(255, 231, 30, 15),
                            fontSize: 20,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        CircularProgressIndicator(
                          color: Colors.black,
                          backgroundColor: MyColors.myBlack,
                        ),
                        TextButton(
                          onPressed: () {
                            Get.offAll(() => MainScreen());
                          },
                          child: Text(
                            "Intentar de nuevo",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Container(
                    color: _isDarkMode != false ? Colors.black : Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.help_outline,
                          color: _isDarkMode != false
                              ? Colors.red
                              : Color.fromARGB(255, 231, 30, 15),
                        ),
                        Text(
                          "Error desconocido",
                          style: TextStyle(
                            color: _isDarkMode != false
                                ? Colors.red
                                : Color.fromARGB(255, 231, 30, 15),
                            fontSize: 20,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        Text(
                          "Por favor vuelva a ingresar",
                          style: TextStyle(
                            color: _isDarkMode != false
                                ? Colors.red
                                : Color.fromARGB(255, 231, 30, 15),
                            fontSize: 20,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextButton(
                          onPressed: () {
                            Get.offAllNamed("/login");
                          },
                          child: Text(
                            "Volver",
                            style: TextStyle(
                              color: _isDarkMode != false
                                  ? Colors.red
                                  : Color.fromARGB(255, 231, 30, 15),
                              fontSize: 20,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              }
            }
          },
        ),
      ),
    );
  }
}
