import 'package:flutter/material.dart';
import 'package:example/api_request/api_request_with_dio.dart';
import 'package:example/api_request/api_request_with_http.dart';
import 'package:example/model/user_model.dart';
import 'package:example/ui/login_page.dart';
import 'package:example/ui/other_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ApiRequestWithHttp apiRequestHttp = ApiRequestWithHttp();
  ApiRequestWithDio apiRequestWithDio = ApiRequestWithDio();

  final users = <UserModel>[];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel?>(
      future: apiRequestHttp.getUserInfo(2),
      builder: (_, snapshot) {
        UserModel? user;
        String title = 'Error with user information';

        if (snapshot.hasData) {
          user = snapshot.requireData;
          title = user!.firstName + ' ' + user.lastName;
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(title),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OtherPage(),
                        ));
                  },
                  icon: Icon(Icons.label_important_outline),
                ),
              ),
            ],
            leading: user != null
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: FadeInImage(
                        placeholder: const AssetImage('assets/circular_loading.gif'),
                        image: NetworkImage(user.avatar),
                      ),
                    ),
                  )
                : null,
          ),
          body: FutureBuilder<Iterable<UserModel>>(
            future: apiRequestWithDio.getAllUsers(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                users.clear();
                users.addAll(snapshot.requireData);
              }

              return (users.isEmpty)
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) => _BodyUserList(
                        users: users,
                        rowElements: [
                          _AvatarUser(user: users[index]),
                          _InfoUser(user: users[index]),
                        ],
                      ),
                    );
            },
          ),
          floatingActionButton: ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ));
            },
            child: Text('Logout'),
          ),
        );
      },
    );
  }
}

class _BodyUserList extends StatelessWidget {
  final List<UserModel> users;
  final List<Widget> rowElements;

  const _BodyUserList({
    Key? key,
    required this.users,
    required this.rowElements,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin: EdgeInsets.all(8),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              spreadRadius: -4,
              blurRadius: 8,
              offset: Offset(0, 4),
            )
          ]),
      child: Row(
        children: rowElements,
      ),
    );
  }
}

class _AvatarUser extends StatelessWidget {
  const _AvatarUser({
    Key? key,
    required this.user,
  }) : super(key: key);

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(30),
        topLeft: Radius.circular(30),
      ),
      child: FadeInImage(
        placeholder: const AssetImage('assets/circular_loading.gif'),
        image: NetworkImage(user.avatar),
        fit: BoxFit.cover,
      ),
    );
  }
}

class _InfoUser extends StatelessWidget {
  const _InfoUser({
    Key? key,
    required this.user,
  }) : super(key: key);

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListTile(
        title: Text(
          '${user.firstName} ${user.lastName}',
          style: TextStyle(
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          user.email,
          style: TextStyle(
            fontSize: 11,
          ),
        ),
      ),
    );
  }
}
