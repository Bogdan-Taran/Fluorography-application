import 'package:flutter/material.dart';

class DateEditDialog extends StatefulWidget {
  final DateTime? currentDate;
  final Function(DateTime) onDateSelected;
  final VoidCallback onCancel;

  const DateEditDialog({
    Key? key,
    this.currentDate,
    required this.onDateSelected,
    required this.onCancel,
  }) : super(key: key);

  @override
  State<DateEditDialog> createState() => _DateEditDialogState();
}

class _DateEditDialogState extends State<DateEditDialog> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.currentDate ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Изменить дату флюорографии'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Текущая дата: ${_formatDate(widget.currentDate)}',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (date != null) {
                      setState(() {
                        selectedDate = date;
                      });
                    }
                  },
                  child: const Text('Выбрать дату'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      selectedDate = DateTime.now();
                    });
                  },
                  child: const Text('Сегодня'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Выбранная дата: ${_formatDate(selectedDate)}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: widget.onCancel,
          child: const Text('Отменить'),
        ),
        TextButton(
          onPressed: () {
            widget.onDateSelected(selectedDate);
          },
          child: const Text('Сохранить'),
        ),
      ],
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}