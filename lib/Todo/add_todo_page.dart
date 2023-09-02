// ignore_for_file: unused_local_variable, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:to_do_swagger_api/Utils/snackbar_helper.dart';
import 'package:to_do_swagger_api/service/todo_service.dart';

class AddToDoPage extends StatefulWidget {
  final Map? todo;
  const AddToDoPage({super.key, this.todo});

  @override
  State<AddToDoPage> createState() => _AddToDoPageState();
}

class _AddToDoPageState extends State<AddToDoPage> {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (widget.todo != null) {
      isEdit = true;
      final title = todo?["title"];
      final description = todo?["description"];
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit todo" : "Add Todo"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(hintText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(hintText: 'Descriptions'),
              keyboardType: TextInputType.multiline,
              minLines: 5,
              maxLines: 8,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: isEdit ? updateData : submitData,
                child: Text(isEdit ? "Update" : "Submit"))
          ],
        ),
      ),
    );
  }

  Future<void> submitData() async {
    final title = titleController.text;
    final description = descriptionController.text;

    final body = {
      "title": title,
      "description": description,
      "is_completed": false,
    };
    final isSuccess = await TodoService.addTodo(body);

    if (isSuccess) {
      titleController.text = '';
      descriptionController.text = "";
      showSuccssMessage(context, message: "Creatione Success");
    } else {
      showErrorMessage(context, message: "Creatione Failed!");
    }
  }

  Future<void> updateData() async {
    final todo = widget.todo;
    if (todo == null) {
      print("");
    }
    final id = todo?["_id"];
    final is_complete = todo?["is_completed"];
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false,
    };

    final isSuccess = await TodoService.updateTodoData(id, body);
    if (isSuccess) {
      titleController.text = '';
      descriptionController.text = "";
      showSuccssMessage(context, message: "Update Success");
    } else {
      showErrorMessage(context, message: "Update Failed!");
    }
  }
}
