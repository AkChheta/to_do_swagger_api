// ignore_for_file: prefer_const_constructors, sort_child_properties_last
import 'package:flutter/material.dart';
import 'package:to_do_swagger_api/Todo/add_todo_page.dart';
import 'package:to_do_swagger_api/Utils/snackbar_helper.dart';
import 'package:to_do_swagger_api/service/todo_service.dart';
import 'package:to_do_swagger_api/widgets/todo_card.dart';

class AddToDoListPage extends StatefulWidget {
  const AddToDoListPage({
    super.key,
  });

  @override
  State<AddToDoListPage> createState() => _AddToDoListPageState();
}

class _AddToDoListPageState extends State<AddToDoListPage> {
  @override
  void initState() {
    fetchTodoData();
    super.initState();
  }

  bool isloading = true;
  List items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF2D2D2D),
          centerTitle: true,
          title: const Text(
            "Todo List",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Visibility(
          visible: items.isNotEmpty,
          replacement: Center(
            child: Text(
              "No Todo Item",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          child: RefreshIndicator(
            onRefresh: fetchTodoData,
            child: ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index] as Map;
                final _id = item["_id"] as String;
                return TodoCard(
                    index: index,
                    item: item,
                    navigateedit: navigatetoEditPage,
                    deletedByid: deleteByid);
              },
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: navigatetoaddpage, label: Text("Add Todo")));
  }

  Future<void> navigatetoEditPage(Map item) async {
    final route = MaterialPageRoute(
        builder: (context) => AddToDoPage(
              todo: item,
            ));
    await Navigator.push(context, route);

    setState(() {
      isloading = true;
    });
    fetchTodoData();
  }

  Future<void> navigatetoaddpage() async {
    final route = MaterialPageRoute(builder: (context) => AddToDoPage());
    await Navigator.push(context, route);

    setState(() {
      isloading = true;
    });
    fetchTodoData();
  }

  Future<void> fetchTodoData() async {
    final response = await TodoService.fetchTodoData();
    if (response != null) {
      setState(() {
        items = response;
      });
    } else {
      showErrorMessage(context, message: "Something went wrong");
    }
    setState(() {
      isloading = false;
    });
  }

  Future<void> deleteByid(String id) async {
    final isSuccess = await TodoService.deleteByid(id);
    if (isSuccess) {
      final filtered = items.where((element) => element["_id"] != id).toList();
      setState(() {
        items = filtered;
      });
    } else {
      showErrorMessage(context, message: "Delete Failed!");
    }
  }
}
