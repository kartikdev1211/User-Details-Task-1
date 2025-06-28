import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_details/bloc/user_bloc.dart';
import 'package:user_details/bloc/user_event.dart';
import 'package:user_details/bloc/user_state.dart';
import 'package:user_details/models/user_model.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final searchController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: "Search by name",
            border: OutlineInputBorder(),
          ),
          onChanged: (query)=>context.read<UserBloc>().add(SearchUsers(searchQuery: query)),
        ),
        actions: [
          IconButton(onPressed: (){
            searchController.clear();
            context.read<UserBloc>().add(SearchUsers(searchQuery: ''));
          }, icon: Icon(Icons.clear))
        ],
      ),
      body: BlocBuilder<UserBloc,UserState>(builder: (context,state){
        switch(state){
          case UserLoading():
            return const CircularProgressIndicator();
          case UserError():
            return Center(child: Text(state.error),);
          case UserLoaded():
            return _buildList(state.users);
          default:
            return const SizedBox.shrink();
        }
      }),
    );
  }
  Widget _buildList(List<User> user){
    if(user.isEmpty){
      return const Center(child:Text("No user found.",style:TextStyle(fontSize:16,color: Colors.grey)));
    }
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: user.length,
      itemBuilder: (context,index){
        final users=user[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          elevation: 2,
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            title: Text(
              users.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Username: ${users.username}'),
                Text('Email: ${users.email}'),
                Text('Phone: ${users.phone}'),
                Text('Website: ${users.website}'),
                const SizedBox(height: 4),
                Text(
                  'Address: ${users.address.street}, ${users.address.suite}, ${users.address.city}, ${users.address.zipcode}',
                ),
                Text(
                  'Geo: (${users.address.geo.lat}, ${users.address.geo.lng})',
                ),
                const SizedBox(height: 4),
                Text(
                  'Company: ${users.company.name} - ${users.company.catchPhrase}',
                ),
              ],
            ),
          ),
        );
      },);
  }
}
