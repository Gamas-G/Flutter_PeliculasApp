import 'package:flutter/material.dart';

import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:peliculas/src/models/pelicula_model.dart';//Libreria importada de puv.dev

class CardSwiper extends StatelessWidget {

  final List<Pelicula> peliculas;

  CardSwiper({ @required this.peliculas });

  @override
  Widget build(BuildContext context) {

    final _screenSize = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only( top: 15.0),
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {

          peliculas[index].uniqueId = '${ peliculas[index].id }-tarjeta';

          return Hero(
            tag: peliculas[index].uniqueId,
            child: ClipRRect( /**Este Widget nos permite agregarle los bordes redondeados a la imagen, pero no podemos hacerlo circular si la imagen no tiene ancho y altos iguales */
              borderRadius: BorderRadius.circular(15.0),
              child: GestureDetector(
                child: FadeInImage(
                  placeholder: AssetImage('assets/no-image.jpg'),
                  image: NetworkImage(peliculas[index].getPosterImg()),
                  fit: BoxFit.cover,
                ),
                onTap: (){
                 Navigator.pushNamed(context, 'detalle', arguments: peliculas[index]); 
                },
              )
            )
          );
        },
        itemCount: 5,
        /**Nota: las dimenciones son necesarias ya que este widget falla sin estos datos*/
        itemWidth: _screenSize.width * 0.7,
        itemHeight: _screenSize.height * 0.5,
        layout: SwiperLayout.STACK,
      ),
    );
  }
}