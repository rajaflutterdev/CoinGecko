import 'package:stu/Core/Network/ApiService.dart';
import 'package:stu/features/homeScreen/data/model/userDataModel.dart';
import '../../../constant/constants.dart';
import 'package:stu/features/homeScreen/bloc/userEvents.dart';
import 'package:stu/features/homeScreen/bloc/userStates.dart';
import 'package:stu/features/homeScreen/data/userRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Core/Network/responseException.dart';

class UserBloc extends Bloc<UserEvents, UserStates> {
  final ApiService apiService;
  final UserRepository userRespo;
  final url = "$baseUrl$userEndPoint";

  UserBloc()
    : apiService = ApiService(),
      userRespo = UserRepository(ApiService()),
      super(UserInitial()) {
    on<GetUserEvent>(_getUser);
    on<DeleteUserEvent>(_deleteUser);
    on<UpdateUserEvent>(_updateUser);
    on<PostUserEvent>(_postUser);
  }

  Future<void> _getUser(GetUserEvent event, Emitter<UserStates> emit) async {
    try {
      emit(UserLoad(true));
      final userData = await userRespo.getUserData(url);
      emit(UserLoaded(userData,));
    } on ResponseException catch (e) {
      emit(UserLoad(false));
      emit(UserError(e.message));
    } catch (e) {
      emit(UserLoad(false));
      emit(UserError(e.toString()));
    }
  }

  Future<void> _deleteUser(
    DeleteUserEvent event,
    Emitter<UserStates> emit,
  ) async {
    try {
      final currentState = state as UserLoaded;
      final response = await userRespo.deleteUserData("$url/${event.userId}");

      if (state is UserLoaded) {
        final updatedUsers = currentState.data
            .where((user) => user.id != event.userId)
            .toList();
        emit(UserLoaded(updatedUsers));
      }
    } on ResponseException catch (e) {
      emit(UserLoad(false));
      emit(UserError(e.message));
    } catch (e) {
      emit(UserLoad(false));
      emit(UserError(e.toString()));
    }
  }

  Future<void> _updateUser(UpdateUserEvent event, Emitter<UserStates> emit,) async {
    try {
      final currentState = state as UserLoaded;
      print("url value is $url");
      print("event.userId value is ${event.userId}");
      print("event.userDataModel value is ${event.userDataModel}");
      final response = await userRespo.updateUserData(
        "$url/${event.userId}",
        event.userDataModel,
      );
      print("state value is before------$state");

      if (response.statusCode == 200) {
        final List<UserDataModel> data = currentState.data.map((e) {
          if (e.id == event.userId) {
            return UserDataModel(
              id: e.id,
              name: event.userDataModel.name,
              email: event.userDataModel.email,
              userName: event.userDataModel.userName,
            );
          }

          return e;
        }).toList();
        emit(UserLoaded(data));
      }
      print("state value is after ------${state}");
    } on ResponseException catch (e) {
      emit(UserLoad(false));
      emit(UserError(e.message));
    } catch (e) {
      emit(UserLoad(false));
      emit(UserError(e.toString()));
    }
  }



  Future<void> _postUser(PostUserEvent event, Emitter<UserStates> emit,) async {
    try {
      final currentState = state as UserLoaded;
      print("url value is $url");
      print("event.userDataModel value is ${event.userDataModel}");
      final response = await userRespo.postUserData(
        url,
        event.userDataModel,
      );

      bool responseResult =(response.statusCode==200||response.statusCode==201);

      if(responseResult) {
        print("responseResult value is $responseResult");
        emit(UserLoaded(currentState.data,message: "user Add Data Successfully"));
      }
    } on ResponseException catch (e) {
      emit(UserLoad(false));
      emit(UserError(e.message));
    } catch (e) {
      emit(UserLoad(false));
      emit(UserError(e.toString()));
    }
  }
}
