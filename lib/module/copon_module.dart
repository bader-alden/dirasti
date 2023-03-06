class copon_module{
  String? uid_copon;
  String? name_copon;
  bool? is_open;
  String? price;
  copon_module.fromjson(json){
    uid_copon = json['uid_copon'];
    name_copon = json['name_copon'];
    is_open = json['is_open']==1;
    price = json['price'].toString();
  }
}