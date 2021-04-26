// import 'dart:convert';

class Peliculas{

  List<Pelicula> items = [];
  Peliculas();

  /*
  * Recordemos que el JSON que recivimos de la API es una lista de 'Pelicula' entonces se generaran muchas clases de 'Pelicula' osea varias peliculas
  *entonces lo que se genera es una lista de tipo 'Pelicula', pero esta en formato json entonces iremos instanciando cada pelicula e irlas lamacenando en un list de su mismo tipo
  */
  Peliculas.fromJsonList(List<dynamic> jsonList){//Este constructor recive el JSON que son todas las Peliculas que obtenemos de la API

    if(jsonList == null) return;//Una pequeña validación si la API no nos otorga la información

    for(var item in jsonList){ //Usamos un for para recorrer las secciones del JSON que son las peliculas y la cual intanciaremos con nuestra clase 'Pelicula'
      final pelicula = new Pelicula.fromJsonMap(item);//Intanciamos cada pelicula
      items.add(pelicula);//Y aquí guardamos nuestra instancia en nuestra lista de tipo 'Pelicula'
    }
  }

}

/*
 * Esta clase modela una pelicula
 * Cuyas propiedades seran otorgadas por la clase 'Pelculas' y generando una Lista de 'Pelicula'
 */
class Pelicula {

  String uniqueId;

  bool adult;
  String backdropPath;
  List<int> genreIds;
  int id;
  String originalLanguage;
  String originalTitle;
  String overview;
  double popularity;
  String posterPath;
  String releaseDate;
  String title;
  bool video;
  double voteAverage;
  int voteCount;

  Pelicula({
    this.adult,
    this.backdropPath,
    this.genreIds,
    this.id,
    this.originalLanguage,
    this.originalTitle,
    this.overview,
    this.popularity,
    this.posterPath,
    this.releaseDate,
    this.title,
    this.video,
    this.voteAverage,
    this.voteCount,
  });


  /*
  *Esto es un constructor con nombre, dart tiene esta sintaxi mucho mas comoda y facil de entender.
   * Es lo mismo que una sobrecarda de constructores pero envez de poner el mismo nombre 
   * pero diferentes paramatreos este cuenta con un nombre.
   */
  /*
   *Este Constructor nos va a servir para mapear los datos que contiene el JSON. Recuerda recivimos una un listado de peliculas como un Map el cual recivimos con
   y recorremos con la clase 'Peliculas' y para instanciar cada pelicula con sus propiedades mapeamos cada pelicula en 'Pelicula'
   * 
   */
  Pelicula.fromJsonMap(Map<String, dynamic> json){
    adult            = json['adult'];
    backdropPath     = json['backdrop_path'];
    genreIds         = json['genre_ids'].cast<int>(); //Aquí al parecer como obtenemos una lista de enteros debemos castear el valor
    id               = json['id'];
    originalLanguage = json['original_language'];
    originalTitle    = json['original_title'];
    overview         = json['overview'];
    popularity       = json['popularity'] / 1;
    posterPath       = json['poster_path'];
    releaseDate      = json['release_date'];
    title            = json['title'];
    video            = json['video'];
    voteAverage      = json['vote_average'] / 1; //Aquí lo que se esta haciendo es que para no ocasionar errores por el double lo dividimos entre uno, asi si el número es entero con esta division dart lo pasa a double.
    voteCount        = json['vote_count'];
  }

  getPosterImg(){
    if(posterPath == null){
      return 'https://i.stack.imgur.com/y9DpT.jpg';
    }else{
    return 'https://www.themoviedb.org/t/p/original/$posterPath';
    }
  }

  getBackdropPath(){
    if(posterPath == null){
      return 'https://i.stack.imgur.com/y9DpT.jpg';
    }else{
    return 'https://www.themoviedb.org/t/p/original/$backdropPath';
    }
  }
}
// enum OriginalLanguage { EN, RU, JA, ES }
