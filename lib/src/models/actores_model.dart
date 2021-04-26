
class Cast{
  List<Actor> actores = [];

  Cast.fromJsonList( List<dynamic> jsonList ){
    
    if(jsonList == null) return;
    
    jsonList.forEach(( item ) { 

      final actor = Actor.fromJsonMap(item);
      actores.add(actor);

    });

  }
}

class Actor {
  bool adult;
  int gender;
  int id;
  // Department knownForDepartment;
  String name;
  String originalName;
  double popularity;
  String profilePath;
  int castId;
  String character;
  String creditId;
  int order;
  // Department department;
  String job;

  Actor({
    this.adult,
    this.gender,
    this.id,
    this.name,
    this.originalName,
    this.popularity,
    this.profilePath,
    this.castId,
    this.character,
    this.creditId,
    this.order,
    // this.knownForDepartment,
    // this.department,
    this.job,
  });

  Actor.fromJsonMap( Map<String, dynamic> json ){

    adult              = json['adult'];
    gender             = json['gender'];
    id                 = json['id'];
    name               = json['name'];
    originalName       = json['original_name'];
    popularity         = json['popularity'];
    profilePath        = json['profile_path'];
    castId             = json['cast_id'];
    character          = json['character'];
    creditId           = json['credit_id'];
    order              = json['order'];
    job                = json['job'];
    // knownForDepartment = json['knownForDepartment'];
    // department         = json['department'];

  }

    getFoto(){
    if(profilePath == null){
      // return 'https://danbooru.donmai.us/data/sample/sample-15a0c6772aa6e861905ce5c076a98a1b.jpg'; abre el link guapo :3
      return 'https://iupac.org/wp-content/uploads/2018/05/default-avatar.png';
    }else{
    return 'https://www.themoviedb.org/t/p/original/$profilePath';
    }
  }
}

// enum Department { ACTING, CREW, PRODUCTION, WRITING, ART, SOUND, EDITING, CAMERA, COSTUME_MAKE_UP, DIRECTING, VISUAL_EFFECTS, LIGHTING }
