import 'package:equatable/equatable.dart';

abstract class HomeStates extends Equatable {
  @override
  List<Object> get props => [];
}
class InitialHomeState extends HomeStates{}
class LoadingResponseState extends HomeStates{}
class SuccessfulResponseState extends HomeStates{
  final List<Map<String, dynamic>> chatHistory;
  SuccessfulResponseState(this.chatHistory);
  @override
  List<Object> get props => [chatHistory];
}
class FailureResponseState extends HomeStates{
  final String message;
  FailureResponseState(this.message);
  @override
  List<Object> get props => [message];
}