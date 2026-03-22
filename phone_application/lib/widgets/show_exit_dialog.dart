import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShowExitDialog extends StatelessWidget{
  final VoidCallback onYesPressed;
  final VoidCallback onNoPressed;
  const ShowExitDialog({
    super.key,
    required this.onYesPressed,
    required this.onNoPressed,});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Подтверждение выхода'),
      content: SingleChildScrollView(
        child: ListBody(
          children: const <Widget>[
            Text(
              'Вы уверены что хотите выйти?',
            ),
          ],
        ),
      ),
      actions: <Widget>[
        // no
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor:
            WidgetStateProperty.resolveWith<
                Color
            >((Set<WidgetState> states) {
              if (states.contains(
                WidgetState.disabled,
              )) {
                return const Color(
                  0xffD5D6D7,
                );
              }
              if (states.contains(
                WidgetState.pressed,
              )) {
                return const Color(
                  0xFFE4E4E4,
                );
              }
              if (states.contains(
                WidgetState.hovered,
              )) {
                return const Color(
                  0xFFBADEFF,
                );
              }
              return const Color(
                0xffffffff,
              );
            }),
            foregroundColor:
            WidgetStateProperty.all(
              const Color(0xffffffff),
            ),
            minimumSize:
            WidgetStateProperty.all(
              Size(
                MediaQuery
                    .of(
                  context,
                )
                    .size
                    .width *
                    0.1,
                35,
              ),
            ),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(10),
              ),
            ),
          ),
          onPressed: onNoPressed, /*() {
                print(
                  'Экран: Нажата кнопка отмены',
                );
                context.read<AuthenticationBloc>().add(SignOutCancelEvent());
                Navigator.of(context).pop();
              },*/
          child: const Text(
            'Отмена',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xff98BFF3),
              fontWeight: FontWeight.w600,
              fontFamily: 'Geologica',
            ),
          ),
        ),
        //yes
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor:
            WidgetStateProperty.resolveWith<
                Color
            >((Set<WidgetState> states) {
              if (states.contains(
                WidgetState.disabled,
              )) {
                return const Color(
                  0xffD5D6D7,
                );
              }
              if (states.contains(
                WidgetState.pressed,
              )) {
                return const Color(
                  0xFF72A7EB,
                );
              }
              if (states.contains(
                WidgetState.hovered,
              )) {
                return const Color(
                  0xFFBADEFF,
                );
              }
              return const Color(
                0xff98BFF3,
              );
            }),
            foregroundColor:
            WidgetStateProperty.all(
              const Color(0xffffffff),
            ),
            minimumSize:
            WidgetStateProperty.all(
              Size(
                MediaQuery
                    .of(
                  context,
                )
                    .size
                    .width *
                    0.1,
                35,
              ),
            ),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(10),
              ),
            ),
          ),
          onPressed: onYesPressed, /*() {
                context
                    .read<AuthenticationBloc>()
                    .add(SignOutAcceptEvent());
              },*/
          child: const Text(
            'Да',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xffffffff),
              fontWeight: FontWeight.w600,
              fontFamily: 'Geologica',
            ),
          ),
        ),
      ],
    );
  }
}