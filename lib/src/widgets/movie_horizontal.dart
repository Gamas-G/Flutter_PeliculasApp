import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class MovieHorizontal extends StatelessWidget {

  final List<Pelicula> peliculas;
  final Function siguientePagina;//Pedimos la funcion getPopulares de la misma instancia 'peliculasProviders' en la pagina de HomePage(es como un singleton)

  final _pageController = new PageController(//El controlador nos otorga muchas propiedades para nuestro carrusel. Podemos crear cosas geniales con el controlador del widget en este caso PageView.
    initialPage: 1,//Al usar el controlador se debe de incializar.
    viewportFraction: 0.3//Aqui se indica la cantidad de Page que se pueden visualizar, fraccionar, etc.... Entendamos que el page es una lista de Widget y cada Widget ocupa una pagina en nuestro dispositivo, aqui redusimos la dimension 1 a .3 siendo 1 una widget visto por pantalla
  );

  MovieHorizontal({ @required this.peliculas, @required this.siguientePagina });//El constructor necesita de la lista asi que va con required

  @override
  Widget build(BuildContext context) {

    final _screenSize = MediaQuery.of(context).size;//Obtencion de la dimenciones ancho y alto de la pantalla

    _pageController.addListener(() { 
      if(_pageController.position.pixels >= _pageController.position.maxScrollExtent - 200){
        siguientePagina();//Ejecutamos la funcion que recivimos en este caso es el sink, recuerda que pasamos el objeto osea la intancia y por eso podemos manejarlo
      }
    });

    return Container(
      height: _screenSize.height * 0.2,//Le decimos que ocupe el 20% de la pantalla(NOTA: esto genera error dependiendo de la pantalla y el tamaño de las imagenes que le otorguemos en nuestro caso redugimos la imagen manteniendo el 20%)
      child: PageView.builder(//Optimisamos el codigo utilizando el PageView.Builder para que construya las tarjeta bajo demanda ya que la cantidad de peliculas es muchisima  el PageView normal carga todas a la vez y eso resulta muy ineficiente y corre el riesgo de saturar la memeoria del dispositivo.
        pageSnapping: false,//Esto desactiva el efecto de pausado al momento de desplazar las imagenes haciendo que tenga el efecto de movimiento constante sin hacer un tipo rebote cuando se da con mucha fuerza
        controller: _pageController,
        itemCount: peliculas.length,
        itemBuilder: (context, index) {//realiza el bucle gracias a .builder
          return _tarjeta(context, peliculas[index]);//Como nuestras tarjetas llevaran un titulo y diseño mas elavorado los ocupamos en otro Widget
        }
      )
    );
  }

  Widget _tarjeta(BuildContext context, Pelicula pelicula){

    pelicula.uniqueId = '${ pelicula.id }-poster';
    
      //Almacenamos todo el container en una variable para poder incorporarlo en el GestureDetector
      final tarjeta = Container(
        margin: EdgeInsets.only(right: 15.0),
        child: Column(
          children: [
            Hero(
              tag: pelicula.uniqueId,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: FadeInImage(
                  placeholder: AssetImage('assets/no-image.jpg'),
                  image: NetworkImage(pelicula.getPosterImg()),
                  fit: BoxFit.cover,
                  height: 130.0,
                ),
              ),
            ),
            SizedBox(height: 5.0),
            Text(
              pelicula.title,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.caption,
            )
          ],
        ),
      );

      //Este Widget hace que que podamos agregarle la funcion de clic a otros widget en nuestro caso a nuestra tarjeta
      return GestureDetector(
        child: tarjeta,//pasamos la tarjeta
        onTap: (){ //y como podemos ver se le agrega la funcion de clic de onTap(genial no? :3)
          //Navegamos a otra pagina
          Navigator.pushNamed( context, 'detalle', arguments: pelicula );//este constructor nos perimite navegar mediante el nombre de la ruta que esta establecida en el material, y pasarle argumentos de tivo object osea cualquiere cosa, en nuestro caso la pelicula y 
          //gracias a al Navigator al construir la siguiente pagina tiene integrado todos los datos de la pelicula la cual fue dada clic
        },
      );
  }


  //Desechamos este Widget ya que el PageView.builder realiza iteraciones por si mismo
  /*List<Widget> _tarjetas(BuildContext context){//El PAgeView trabaja con una lista de Widget asi que tienemos que retornar un List

    return peliculas.map((pelicula){//Recorremos nuestra lista y en este caso se utiliza el .map, tambien se pudo hacer con foreach pero es igual
      return Container(
        margin: EdgeInsets.only(right: 15.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                placeholder: AssetImage('assets/no-image.jpg'),
                image: NetworkImage(pelicula.getPosterImg()),
                fit: BoxFit.cover,
                height: 140.0,
              ),
            ),
            SizedBox(height: 5.0),
            Text(
              pelicula.title,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.caption,
            )
          ],
        ),
      );
    }).toList();

  }*/
}