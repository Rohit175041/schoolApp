class SchoolModel{
  SchoolModel({
    required this.name,
    required this.phonenumber,
    required this.state,
    required this.city,
    required this.address,
    required this.about,
    required this.uid,
    required this.Startdate,
    required this.block,
    required this.visit,
    required this.postID,
    required this.search,
    required this.image,
  });
  late final String name;
  late final int phonenumber;
  late final String state;
  late final String city;
  late final String address;
  late final String about;
  late final String uid;
  late final String Startdate;
  late final String block;
  late final int visit;
  late final String postID;
  late final List<String> search;
  late final List<String> image;

  SchoolModel.fromJson(Map<String, dynamic> json){
    name = json['name'];
    phonenumber = json['phonenumber'];
    state = json['state'];
    city = json['city'];
    address = json['address'];
    about = json['about'];
    uid = json['uid'];
    Startdate = json['Startdate'];
    block = json['block'];
    visit = json['visit'];
    postID = json['postID'];
    search = List.castFrom<dynamic, String>(json['search']);
    image = List.castFrom<dynamic, String>(json['image']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['phonenumber'] = phonenumber;
    _data['state'] = state;
    _data['city'] = city;
    _data['address'] = address;
    _data['about'] = about;
    _data['uid'] = uid;
    _data['Startdate'] = Startdate;
    _data['block'] = block;
    _data['visit'] = visit;
    _data['postID'] = postID;
    _data['search'] = search;
    _data['image'] = image;
    return _data;
  }
}