class UserDataModel{
  final int id;
  final String ?name;
  final String ?userName;
  final String ?email;
  UserDataModel({required this.id,this.name,this.email,this.userName});

  ///json model into Dart object convert
 factory UserDataModel.fromJson(Map<String,dynamic> json){
   return UserDataModel(
   id: json["id"]??0,
   userName: json["username"]??"",
   email: json["email"]??"",
   name: json["name"]??"",
   );
 }

 /// dart object convert into json Model

Map<String,dynamic> toJson(){
   return {
     "id":id,
     "name":name,
     "username":userName,
     "email":email,
   };
}
}