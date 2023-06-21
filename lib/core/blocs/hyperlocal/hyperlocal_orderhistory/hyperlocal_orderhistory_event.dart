// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'hyperlocal_orderhistory_bloc.dart';

abstract class HyperlocalOrderhistoryEvent extends Equatable {
  const HyperlocalOrderhistoryEvent();

  @override
  List<Object> get props => [];
}

class GetHyperlocalOrderHistoryEvent extends HyperlocalOrderhistoryEvent {}

class SevenDaysFilterHyperLocalOrderEvent extends HyperlocalOrderhistoryEvent {
  final int nSeven;
  const SevenDaysFilterHyperLocalOrderEvent({required this.nSeven});
  @override
  List<Object> get props => [nSeven];
}

class SevenDaysFilterHyperlocalOrderScrollEvent
    extends HyperlocalOrderhistoryEvent {
  final int nSeven;

  const SevenDaysFilterHyperlocalOrderScrollEvent({required this.nSeven});
  @override
  List<Object> get props => [nSeven];
}

class ThirtyDaysFilterHyperLocalOrderEvent extends HyperlocalOrderhistoryEvent {
  final int nthirty;
  const ThirtyDaysFilterHyperLocalOrderEvent({required this.nthirty});
  @override
  List<Object> get props => [nthirty];
}

class ThirtyDaysFilterScrollHyperlocalOrderEvent
    extends HyperlocalOrderhistoryEvent {
  final int nthirty;
  const ThirtyDaysFilterScrollHyperlocalOrderEvent({required this.nthirty});
  @override
  List<Object> get props => [nthirty];
}

class CustomDaysFilterHyperLocalOrderEvent extends HyperlocalOrderhistoryEvent {
  final List<DateTime?> selectedDates;
  final int nCustom;
  const CustomDaysFilterHyperLocalOrderEvent(
      {required this.selectedDates, required this.nCustom});
  @override
  List<Object> get props => [selectedDates, nCustom];
}

class CustomDaysScrollFilterHyperlocalOrderEvent
    extends HyperlocalOrderhistoryEvent {
  final List<DateTime?> selectedDates;
  final int nCustom;
  const CustomDaysScrollFilterHyperlocalOrderEvent({
    required this.selectedDates,
    required this.nCustom,
  });
  @override
  List<Object> get props => [selectedDates, nCustom];
}

class ResetOrderHistoryEvent extends HyperlocalOrderhistoryEvent {}
