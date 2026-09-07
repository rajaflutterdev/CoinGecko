import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stu/features/homeScreen/bloc/userBloc.dart';
import 'package:stu/features/homeScreen/bloc/userEvents.dart';
import 'package:stu/features/homeScreen/bloc/userStates.dart';
import 'package:stu/features/homeScreen/data/model/userDataModel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<UserBloc>().add(GetUserEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            BlocBuilder<UserBloc, UserStates>(
              builder: (context, state) {
                if (state is UserLoad) {
                  return CircularProgressIndicator();
                }

                if (state is UserLoaded) {

                    if ((state.message!.isNotEmpty)){
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp){
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Success")));
                      },);
                  }
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.separated(
                      separatorBuilder: (context, index) => Divider(),
                      shrinkWrap: true,
                      itemCount: state.data.length,
                      itemBuilder: (context, index) {
                        final userdata = state.data[index];
                        return ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          tileColor: Colors.grey.shade400,
                          title: Text(userdata.name.toString()),
                          subtitle: Text(userdata.email.toString()),
                          onTap: () {
                            context.read<UserBloc>().add(
                              DeleteUserEvent(userdata.id),
                            );
                          },
                          trailing: IconButton(
                            onPressed: () {
                              final UserDataModel user = UserDataModel(
                                id: 5,
                                email: "demo",
                                name: "Raja Madhu",
                                userName: "CoupleVlog",
                              );

                              context.read<UserBloc>().add(
                                UpdateUserEvent(userdata.id, user),
                              );
                            },
                            icon: Icon(Icons.edit),
                          ),
                          leading: InkWell(
                              onTap: (){
                                final UserDataModel user = UserDataModel(
                                  id: 12,
                                  email: "madhuvijaya@gmail.com",
                                  name: "Madhu",
                                  userName: "wife of Raja",
                                );

                                context.read<UserBloc>().add(
                                  PostUserEvent(user)
                                );
                              },
                              child: Icon(Icons.update)),
                        );
                      },
                    ),
                  );
                }
                return Text("data");
              },
            ),
          ],
        ),
      ),
    );
  }
}
