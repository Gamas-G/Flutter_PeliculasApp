// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';
import 'package:peliculas/src/search/search_delegate.dart';
import 'package:peliculas/src/widgets/card_swiper_widget.dart';
import 'package:peliculas/src/widgets/movie_horizontal.dart';

class HomePage extends StatelessWidget {
  
  final peliculasProvider = new PeliculasProvider();

  @override
  Widget build(BuildContext context) {

    //Inicializamos el metodo ya que nuestro page inicia en 0, para que nuestro StreamBuilder tenga datos para construir
    peliculasProvider.getPopulares();

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Películas'),
        backgroundColor: Colors.indigoAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: (){
              showSearch(
                context: context,
                delegate: DataSearch()
              );
            }
          ),
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _swiperTarjetas(),
            _footer(context)
          ],
        )
      ),
    );
  }

  Widget _swiperTarjetas(){
    // peliculasProvider.getEnCines();
    //Creacion de nuestro widget que requiere una lista por parte de nuestro construcctor
    //Como hacemos peticiones a internet esto demorara flutter en construir nuestros widget para eso 'FutureBuilder' es el indicado para construir las targetas
    return FutureBuilder(
      future: peliculasProvider.getEnCines(),//aqui se almacena el metodo que consumira tiempo en ejecutarse un 'Future'
      builder: (BuildContext context, AsyncSnapshot<List> snapshot){
        if(snapshot.hasData){//una pequeña validación por si la peticion falla o se demora mucho y evitar que nuestra app se detenga y muestre que sigue trabajando
        return CardSwiper(
          peliculas: snapshot.data//snapshot.data contiene nuestro listado de Peliculas
        );
        }else{
          return Container(
            height: 400.0,
            child: Center(
              child: CircularProgressIndicator()
            )
          );
        }
      }
    );
  }

  /*
   * El Widget footer sera nuestro widget de carrusel que se muestra en la parte inferior de nuestra pantalla
   * Las peliculas que se ven son las mas populares obteneidas de la API
   */
  Widget _footer(BuildContext context){
    return Container( //Contenedor que envuelve multiples widget tales como el titulo 'populares' y las tarjetas de pelicualas en este caso un PageView
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, //Alineamos los elementos hacia el lado izquierdo
        children: [
          Container(
            padding: EdgeInsets.only(left: 20.0),
            child: Text('Populares', style: Theme.of(context).textTheme.subtitle1)//Theme son los datos que trae la aplicacion osea en el MaterialApp los cuales podemos modificas y ahora que flutter es para web subtitle es como un grupo de etiquetas en web como el h1,h2,h3 etc
          ),
          
          SizedBox(height: 5.0,),

          StreamBuilder(
            stream: peliculasProvider.popularesStream,//como explicamos este esta escuchando al sink(popularesSink)
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if(snapshot.hasData){
              return MovieHorizontal(
                peliculas: snapshot.data,
                siguientePagina: peliculasProvider.getPopulares,//hacemos referencia sin parentesis solo lo enviamos con parentecis dak entiende que debe ejecutar el metodo en nuestro caso no
              );
              }else{
                return Center(child: CircularProgressIndicator());
              }
            }
          )
        ],
      ),
    );
  }

    /**
     * ESTE WIDGET ESTABA EN _footer
   * Al igual que el Swiper como debemos pedir a la API un JSON esto consumira tiempo
   * Asi que un FutureBuilder sera la mejor opcion para construir nuetro carrusel
   * PROBLEMA: Este widget construye su(s) widget de forma async ya que usualmente es por una peticion http o una tarea que consume mucho tiempo
   * pero son datos finitos pueden 500 pero ya no hay mas y solo hace una peticion y puede trar datos o traer un error, para este caso consumimos una cantidad de informacion muy grande y en forma JSON
   * por lo que la API esta seccionada en Paginas entonces se debe pedir mas datos de la API lo cual este Widget no me perimite.
   */
  /*FutureBuilder(
    future: peliculasProvider.getPopulares(),//al igual que el swiper obtenemos un Future
    builder: (BuildContext context, AsyncSnapshot<List> snapshot) {//Aqui se encarga de construir cada Widget ya que lo que recive es un 'Lis<Pelicula>' de tipo Pelicula
      if(snapshot.hasData){//Por documentacion y logica la peticion puede venir vacia asique una validacion ayuda a que la app mantenga señales de proecesos
        return MovieHorizontal(//Widget creado por nosotros
          peliculas: snapshot.data
        );
      }else{
        return Center(child: CircularProgressIndicator());
      }
    },
  ),*/

}