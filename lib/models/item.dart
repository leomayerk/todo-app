class Item {
  String title;
  bool done;

  Item({this.title, this.done});

  //recebe json
  Item.fromJson(Map<String, dynamic> json){
    title = json['title'];
    done = json['done'];
  }

  //retorna json
  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['done'] = this.done;
    return data;
  }
}

// var item = new Item(title: "blablabla", done: true); já da pra fazer assim