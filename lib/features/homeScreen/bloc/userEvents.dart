 import 'package:stu/features/homeScreen/data/model/userDataModel.dart';

abstract class UserEvents {}


class GetUserEvent extends UserEvents {}

class UpdateUserEvent extends UserEvents {
  int userId;
  UserDataModel userDataModel;
  UpdateUserEvent(this.userId,this.userDataModel);
}

class DeleteUserEvent extends UserEvents {
  int userId;
  DeleteUserEvent(this.userId);
}

class PostUserEvent extends UserEvents {
  UserDataModel userDataModel;
  PostUserEvent(this.userDataModel);
}