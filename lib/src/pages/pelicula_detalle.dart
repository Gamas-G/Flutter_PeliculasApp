import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class PeliculaDetalle extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    //Para obtener los argumentos de una navegacion de paginas hecha por Navigator.pushName, ModalRoute funciona con el.
    //Nueva observación, no solo es de Navigator si no de la aplicación en genral 'ModalRoute' es una calse abstracta que esta diciendo que
    //del context de este widget que fue creado apartir de un clic de una pelicula y al cual se le ingreso un argumento(un objeto de tipo Pelicula)
    //en palabras simples estamso extrayendo el argumento del context.
    final Pelicula pelicula = ModalRoute.of(context).settings.arguments;//Asi obtenemos el argumento enviado en este caso enviamos la pelicula.

    return Scaffold(
      body: CustomScrollView(//Una vista scrolable personalizada. Se puede pensar que es como un scaffold ya que otorga unos widget tales como el SliverAppBar que es similar al appbar pero con efectos de animacion bastante bonitas
        slivers: <Widget>[
          _crearAppbar( pelicula ),//Widget SliverAppBar. Es un AppBar con mejores funciones
          //SliverList es como el List.
          SliverList(//Al usar CustomScrollView hay widget que van de la mano y permiten nuevas caracteristicas a medida que se mueve el CustomScrollView
            delegate: SliverChildListDelegate(
              [
                SizedBox(height: 10.0),
                _posterTitulo( pelicula, context ),
                _descripcion(pelicula),
                _descripcion(pelicula),
                _descripcion(pelicula),
                _descripcion(pelicula),
                _descripcion(pelicula),
                _descripcion(pelicula),
                _descripcion(pelicula),
                _descripcion(pelicula),
                _descripcion(pelicula),

                _crearCasting( pelicula )
              ]
            )
          )
        ],
      )
    );
  }

  Widget _crearAppbar( Pelicula pelicula ){
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.indigoAccent,
      expandedHeight: 200.0,
      floating: false,//esta propiedad hace que al comprimir el appbar se mantenga comprimido hasta su posicion original, si esta en true, si hacemos scroll hacia abajo para comprimir el appbar por un buen tiempo y decidimo desplazar hacia arriba el scroll este se ira descomprimiendo aun si no esta en su punto original(un efecto parecido a la app de youtube)
      pinned: true,//esto hace que el appbar una vez comprimido se mantenga visible al igual que en web como un sticky, que este pegado y esta en false se quedara en la parte superior hasta perdelro de vista
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          pelicula.title,
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),
        background: FadeInImage(
          image: NetworkImage(pelicula.getBackdropPath()),
          placeholder: AssetImage('assets/loading.gif'),
          fadeInDuration: Duration(milliseconds: 50),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _posterTitulo( Pelicula pelicula, BuildContext context ){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Hero(
            tag: pelicula.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image(
                image: NetworkImage( pelicula.getPosterImg() ),
                height: 150.0,
              ),
            ),
          ),

          SizedBox(width: 20.0,),

          Flexible(//Este Widget ocupa todo el espacio disponible.
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(pelicula.title, style: Theme.of(context).textTheme.subtitle2, overflow: TextOverflow.ellipsis,),
                Text(pelicula.originalTitle, style: Theme.of(context).textTheme.subtitle1, overflow: TextOverflow.ellipsis,),
                Row(
                  children: [
                    Icon(Icons.star_border),
                    Text( pelicula.voteAverage.toString(), style: Theme.of(context).textTheme.subtitle1 )
                  ],
                )
              ],
            )
          )
        ],
      ),
    );
  }

  Widget _descripcion( Pelicula pelicula ){

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: Text(
        pelicula.overview,
        textAlign: TextAlign.justify,
      ),

    );

  }

  Widget _crearCasting( Pelicula pelicula ){

    final peliProvider = PeliculasProvider();

    return FutureBuilder(
      future: peliProvider.getCast(pelicula.id.toString()),
      // initialData: InitialData,
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if(snapshot.hasData){
          return _crearActoresPageView( snapshot.data );
        }else{
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _crearActoresPageView( List<Actor> actores ){

    return SizedBox(
      height: 200.0,
      child: PageView.builder(
        pageSnapping: false,
        itemCount: actores.length,
        controller: PageController(
          viewportFraction: 0.3,
          initialPage: 1
        ),
        itemBuilder: ( context, i ){
          return _actorTarjeta( actores[i] );
        }
      ),
    );

  }

  Widget _actorTarjeta( Actor actor ){

    return Container(
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
              placeholder: AssetImage('assets/no-image.jpg'),
              image: NetworkImage(actor.getFoto()),
              height: 150.0,
              fit: BoxFit.cover,
            ),
          ),
          Text(
            actor.name,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );

  }
}