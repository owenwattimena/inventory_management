part of 'components.dart';

class FilterDateDialog extends StatelessWidget {
  final int activeMonth;
  final int activeYear;
  final Function() onPrevYear;
  final Function() onNextYear;
  final Function(int) onMonthSelected;
  final Function() onThisMonthSelected;
  const FilterDateDialog({
    Key? key,
    required this.activeMonth,
    required this.activeYear,
    required this.onNextYear,
    required this.onPrevYear,
    required this.onMonthSelected,
    required this.onThisMonthSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> monthList = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC'
    ];
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Align(
        alignment: Alignment.topCenter,
        child: DecoratedBox(
          position: DecorationPosition.background,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width * 0.9,
              child: IntrinsicHeight(
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Date',
                              style: primaryTextStyle.copyWith(
                                  decoration: TextDecoration.none)),
                          Row(children: [
                            TextButton(
                                onPressed: onThisMonthSelected,
                                child: const Text('This Month')),
                            const SizedBox(width: 10),
                            GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const Icon(Icons.close)),
                          ])
                        ]),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                            onPressed: onPrevYear,
                            child: const Icon(Icons.keyboard_arrow_left_sharp)),
                        Text('$activeYear',
                            style: primaryTextStyle.copyWith(
                                decoration: TextDecoration.none)),
                        TextButton(
                            onPressed: onNextYear,
                            child:
                                const Icon(Icons.keyboard_arrow_right_sharp)),
                      ]),
                  SizedBox(
                    height: 150,
                    // height: MediaQuery.of(context).size.width * 0.9,
                    child: GridView.count(
                      childAspectRatio: 2.0,
                      shrinkWrap: true,
                      // padding: const EdgeInsets.only(top: 8),
                      crossAxisCount: 4,
                      children: monthList
                          .asMap()
                          .entries
                          .map((entry) => TextButton(
                            onPressed: () => onMonthSelected(entry.key + 1),
                            child: Text(entry.value,
                              style: primaryTextStyle.copyWith(
                                decoration: TextDecoration.none,
                                color: (activeMonth - 1 == entry.key)
                                    ? Colors.blue
                                    : Colors.black,
                              ),
                              textAlign: TextAlign.center)))
                          .toList(),
                    ),
                  ),
                ]),
              )),
        ),
      ),
    );
  }
}
