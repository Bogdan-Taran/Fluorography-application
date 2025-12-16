import 'package:flutter/material.dart';


class MessageButton extends StatefulWidget {
  const MessageButton({super.key});

  @override
  State<MessageButton> createState() => _MessageButtonState();
}

class _MessageButtonState extends State<MessageButton> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Показ сообщений'),
      ),
      body: Center(
        child: TextButton(onPressed: _showMessageInitial, 
            child: Text('Show message'))
      ),
    );
      
    
  }





  _showMessageInitial() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('This is a role-based architecture'))
    );
  }
  _showMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('This is a role-based architecture'))
    );
  }
  _showMessageDefault() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('This is a role-based architecture'))
    );
  }
}