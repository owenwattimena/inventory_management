part of 'components.dart';

class TransactionDate extends StatelessWidget {
  final DateTime dateTime;
  final int? total;
  // ignore: use_key_in_widget_constructors
  const TransactionDate({required this.dateTime, this.total});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 12, top: 8, right: 12),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(DateFormat('E dd-MM-yyyy').format(dateTime)),
          const SizedBox(width: 10),
          Text('$total Transaction(s)'),
        ],
      ),
    );
  }
}
