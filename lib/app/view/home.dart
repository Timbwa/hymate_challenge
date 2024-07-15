import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hymate_challenge/app/provider/provider.dart';
import 'package:hymate_challenge/app/widgets/widgets.dart';
import 'package:hymate_challenge/energy_charts_info_api/energy_charts_info_api.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DateTime? _endDateTime;
  DateTime? _startDateTime;

  /// Default Bidding Zone
  BiddingZone _selectedBiddingZone = BiddingZone.germanyLuxembourg;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hymate Challenge'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView(
          children: [
            const SizedBox(height: 50),
            ChartWidget(),
            const SizedBox(height: 20),
            Text(
              'Total Price',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const Divider(),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Country',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                DropdownMenu<BiddingZone>(
                  initialSelection: _selectedBiddingZone,
                  onSelected: (biddingZone) {
                    if (biddingZone != null) {
                      setState(() {
                        _selectedBiddingZone = biddingZone;
                      });
                    }
                  },
                  dropdownMenuEntries: BiddingZone.values
                      .map<DropdownMenuEntry<BiddingZone>>(
                        (biddingZone) => DropdownMenuEntry(
                          value: biddingZone,
                          label: biddingZone.name,
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(),
            Text(
              'Total Power',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Consumer(
              builder: (context, ref, child) {
                final totalPowerProductionTypeName = ref.watch(
                  appStateNotifierProvider.select((state) {
                    return state.valueOrNull?.lines['power']?.name ?? '';
                  }),
                );

                return Row(
                  children: [
                    Text('Production Type: ', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 20),
                    Text(totalPowerProductionTypeName,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                  ],
                );
              },
            ),
            Text(
              '(Currently, only Germany is Supported)',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const Divider(),
            // Date Time picker
            Text(
              'Date Time',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () => _selectDateTime(context, true),
                  leading: Text(
                    'Start date',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  trailing: Text(
                    _startDateTime == null ? '' : _getDateTimeString(context, _startDateTime!),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                ListTile(
                  onTap: () => _selectDateTime(context, false),
                  leading: Text(
                    'End date',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  trailing: Text(
                    _endDateTime == null ? '' : _getDateTimeString(context, _endDateTime!),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            Consumer(
              builder: (context, ref, child) {
                final startDate = _startDateTime?.unixTimeStampInSeconds.toString();
                final endDate = _endDateTime?.unixTimeStampInSeconds.toString();
                final appState = ref.watch(appStateNotifierProvider);
                ref.listen(appStateNotifierProvider, (prev, next) {
                  if (next.hasError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Something went wrong. Try changing dates or country'),
                      ),
                    );
                  }
                });

                return Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.end,
                  spacing: 20,
                  runSpacing: 16,
                  children: [
                    ElevatedButton(
                      onPressed: appState.maybeWhen(
                        loading: null,
                        orElse: () => () async {
                          await Future.wait([
                            ref.read(appStateNotifierProvider.notifier).fetchTotalPriceAndUpdateState(
                                PriceRequestModel(bzn: _selectedBiddingZone.abbreviation)),
                            ref
                                .read(appStateNotifierProvider.notifier)
                                .fetchTotalPowerAndUpdateState(TotalPowerRequestModel(start: startDate, end: endDate)),
                          ]);
                        },
                      ),
                      child: appState.maybeWhen(
                        skipLoadingOnRefresh: false,
                        orElse: () => const ButtonChildWidget(text: 'Fetch Data'),
                        loading: () => const ButtonChildWidget(text: '', isLoading: true),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _startDateTime = null;
                          _endDateTime = null;
                        });
                      },
                      child: const Text('Clear Dates'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/challenge');
                      },
                      child: const Text('Open Challenge Page'),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _getDateTimeString(BuildContext context, DateTime dateTime) {
    return '${'${dateTime.toLocal()}'.split(' ')[0]} ${TimeOfDay(
      hour: dateTime.hour,
      minute: dateTime.minute,
    ).format(context)}';
  }

  Future<void> _selectDateTime(BuildContext context, bool isStartDate) async {
    final firstDate = isStartDate ? DateTime(2015) : _startDateTime ?? DateTime(2015);

    await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: firstDate,
      lastDate: DateTime.now(),
    ).then((pickedDate) async {
      if (pickedDate != null) {
        final pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (pickedTime != null) {
          final selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          if (isStartDate) {
            setState(() {
              _startDateTime = selectedDateTime;
            });
          } else {
            setState(() {
              _endDateTime = selectedDateTime;
            });
          }
        }
      }
    });
  }
}

class ButtonChildWidget extends StatelessWidget {
  const ButtonChildWidget({required this.text, this.isLoading = false, super.key});

  final String text;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Padding(
            padding: EdgeInsets.all(4),
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          )
        : Text(text);
  }
}
