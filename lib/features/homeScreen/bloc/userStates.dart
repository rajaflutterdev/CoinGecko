import 'package:stu/features/homeScreen/data/model/userDataModel.dart';

abstract class UserStates {}

class UserInitial extends UserStates {}

class UserLoad extends UserStates {
  final bool load;
  UserLoad(this.load);
}
class UserUpdate extends UserStates {
  UserUpdate();
}
class UserUpdateSuccess extends UserStates {
  UserUpdateSuccess();
}

class UserLoaded extends UserStates {
  final List<UserDataModel> data;
final String? message;
  UserLoaded(this.data,{
    this.message="",
  });
}

class UserError extends UserStates {
  final String error;
  UserError(this.error);
}
