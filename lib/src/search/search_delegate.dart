import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

import 'package:peliculas/src/providers/peliculas_provider.dart';

class DataSearch extends SearchDelegate{

  final peliculasProvider = new PeliculasProvider();

  final peliculas = [];

  final peliculasRecientes = [];

  @override
  List<Widget> buildActions(BuildContext context) {
      //Las acciones que estaran colocadas en nuestro appBar, como el Widget de AppBar que tiene actions estos son lo mismo
      return [
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: (){
            query = '';
          },
        ),
      ];
    }
  
    @override
    Widget buildLeading(BuildContext context) {
      // Este es el Widget que se posiciona del lado izq antes del titulo. igual el nombre lo dice 'leading' lo encuentras en el Widget de appbar y otros mas
      return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: (){
          close(
            context,
            null
          );
        }
      );
    }
  
    @override
    Widget buildResults(BuildContext context) {
      // Crea los resultados que vamos a mostrar. Note que el nombre es buildResults podemos imaginar que construye los widget que mostrara
      return Container();
    }

  @override
  Widget buildSuggestions(BuildContext context) {

    if(query.isEmpty) return Container();

    return FutureBuilder(
      future: peliculasProvider.buscarPelicula(query),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
        if(snapshot.hasData){

          final pelicula = snapshot.data;

          return ListView(
            children: pelicula.map((pelicula){
              return ListTile(
                leading: FadeInImage(
                  placeholder: AssetImage('assets/no-image.jpg'),
                  image: NetworkImage(pelicula.getPosterImg()),
                  width: 50.0,
                  fit: BoxFit.contain,
                ),
                title: Text(pelicula.title),
                subtitle: Text(pelicula.originalTitle),
                onTap: (){
                  close(context, null);//Con este metodo se cierra la pagina de busqueda
                  pelicula.uniqueId = '';
                  Navigator.pushNamed(context, 'detalle', arguments: pelicula);
                },
              );
            }).toList(),
          );

        }else{
        
        return Center(child: CircularProgressIndicator(),);

        }
      },
    );

  }
  
    


  //CODIGO DE PRACTICA
  //   @override
  //   Widget buildSuggestions(BuildContext context) {
  //   // Las sugerencias que aparecen cuando la personas escribe, la lista de coincidencia al escribir
    
  //   final listaSugerida = ( query.isEmpty )
  //                       ? peliculasRecientes
  //                       : peliculas.where(
  //                         ( p ) => p.toLowerCase().startsWith(query.toLowerCase())
  //                       ).toList();

  //   return ListView.builder(
  //     itemCount: listaSugerida.length,
  //     itemBuilder: (context, index){
  //       return ListTile(
  //         leading: Icon(Icons.movie),
  //         title: Text(listaSugerida[index]),
  //         onTap: (){},
  //       );
  //     }
  //   );
  // }



}