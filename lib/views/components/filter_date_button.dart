part of 'components.dart';

class FilterDateButton extends StatelessWidget {
  final Function() onPrevMonthPressed;
  final Function() onMonthPressed;
  final Function() onNextMonthPressed;
  final DateTime date;
  final Color foreground;
  const FilterDateButton(
      {Key? key,
      required this.onPrevMonthPressed,
      required this.onMonthPressed,
      required this.onNextMonthPressed,
      required this.date, this.foreground = Colors.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton(
          onPressed: onPrevMonthPressed,
          child: Icon(
            Icons.keyboard_arrow_left_sharp,
            color: foreground,
            size: 24,
          ),
        ),
        TextButton(
          onPressed: onMonthPressed,
          child: Text(
            DateFormat('MMM yyyy').format(date),
            style: primaryTextStyle.copyWith(color: foreground),
          ),
        ),
        TextButton(
          onPressed: onNextMonthPressed,
          child: Icon(
            Icons.keyboard_arrow_right_sharp,
            color: foreground,
            size: 24,
          ),
        ),
      ],
    );
  }
}
