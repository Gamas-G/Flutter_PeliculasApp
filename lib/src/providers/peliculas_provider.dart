import 'dart:convert';

import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/models/actores_model.dart';

/*
 *Esta clase se encarga de obtener los datos de la API como bien indica su nombre un Proveedor en esta caso nos proveera las peliculas y toda su información 
 */
class PeliculasProvider{

  String _apikey   = '';
  String _url      = 'api.themoviedb.org';
  String _language = 'es-ES';

  int _popularesPage = 0;//variables que controla las paginas de la API y obetener mas información
  bool _cargando      = false;

  List<Pelicula> _populares = [];//Esta lista va a ir incrementando a medida del streamBuilder, para añadir mas peliculas en nuestro widget 'MovieHorizontal' creando una lista infinita
  
  
  final _popularesStreamController = StreamController<List<Pelicula>>.broadcast();//Con el broadcast le permito al stream que varios widget escuchen y puedan utilizarlo, sin el broadcast por defecto solo uno puede escuchar un 'SingleSubscription'
  /*
  *popularesSink se le agrega un List<Pelicula> y este metodo avisa al metodo 'popularesStream' que se agrego nueva información por lo cual debera construir nuevos widgets
  en palabras simples este tiene la funcion de avisar que hay nueva información y avisa a su compañero el 'popularesStream' para que su StreamBuilder construya mas widgets
  Para concluir este metodo guarda lal nueva informacion y se la pasa a su compañero 'popularesStream' y es la que va a construir pero lo que retorna es la lista _populares que va 
  almacenando toda la información
  */
  Function(List<Pelicula>) get popularesSink => _popularesStreamController.sink.add;

  /*
   * este metodo tiene el trabajo de estar escuchando a 'popularesSink' y cuando detecta pasara al StreamBuilder nueva informacion almacenada en el '_popularesStreamController'
   */
  Stream<List<Pelicula>> get popularesStream => _popularesStreamController.stream;

  void _disposeStreams(){ //Si utilizamos otro widget utiliza nuestro stream debemos cerrarlo con este metodo. como solo ocupamos un widget no hacemos uso de el
    _popularesStreamController.close();
  }

  Future<List<Pelicula>> _procesarRespuesta(Uri url) async{

    /**Aquí acemos la peticion a la API y reciviremos el JSON */
    final resp = await http.get(url); //y como es una peticion esto podria tomar tiempo y por eso le colocamos el await dejando en segundo plano y dejando nuestra aplicación con funcionalidad
    final decodeData = json.decode(resp.body);//Decodificamos el JSON obteniendo los datos del body porque ahi se encuentran la lista de peliculas y el decode hace que obtengamos un Mapa, osea el JSON es un String y lo pasamos un Mapa que podemos manejar con nuestros models

    final peliculas = new Peliculas.fromJsonList(decodeData['results']);//Obtencio de List<Pelicula> de nuestro modelo Peliculas

    return peliculas.items;

  }

  Future<List<Pelicula>>getEnCines() async{

    final url = Uri.https(_url, '3/movie/now_playing', { //Uri nos contruye la url apartir de sus parametros no es necesarios que uno construya toda la url y sus paremtros 'https://dominion.com/.../...'

      'api_key'  : _apikey,
      'language' : _language

    });

    return await _procesarRespuesta(url);

  }

  Future<List<Pelicula>> getPopulares() async{
    if(_cargando) return [];//Evitamos que las peliculas populares realize muchisimas peticiones.
    
    _cargando = true;

    _popularesPage++;//Cada que llamemos este metodo es porque queremos la siguiente pagina y por eso la incrementamos


    final url = Uri.https(_url, '3/movie/popular', { //Uri nos contruye la url apartir de sus parametros no es necesarios que uno construya toda la url y sus paremtros 'https://dominion.com/.../...'

      'api_key'  : _apikey,
      'language' : _language,
      'page'     : _popularesPage.toString()//el Map del metodo 'https' esta en dynamic pero en url lo pide string y esto no genera error pero el link que se crea no lo encuentra el navagador y se queda cargando nuestra app, la url esta como string por eso lo convertimos

    });

    final resp = await _procesarRespuesta(url);

    _populares.addAll(resp);//EL medoto addAll() añade a la cola y es el que se mostrara

    popularesSink(_populares);
    _cargando = false;

    return resp;

  }



  Future<List<Actor>> getCast( String peliId ) async{

    final url = Uri.https(_url, '3/movie/$peliId/credits', {

      'api_key'  : _apikey,
      'language' : _language,

    });

    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final cast = new Cast.fromJsonList(decodedData['cast']);
    
    
    return cast.actores;

  }


    Future<List<Pelicula>>buscarPelicula( String query ) async{

    final url = Uri.https(_url, '3/search/movie', { //Uri nos contruye la url apartir de sus parametros no es necesarios que uno construya toda la url y sus paremtros 'https://dominion.com/.../...'

      'api_key'  : _apikey,
      'language' : _language,
      'query'    : query

    });

    return await _procesarRespuesta(url);

  }

}