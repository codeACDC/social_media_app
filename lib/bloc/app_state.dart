part of 'app_cubit.dart';

abstract class MediaAppState extends Equatable{
  const MediaAppState();

  @override
  List<Object> get props => [];
}

class SignedInitial extends MediaAppState{
  const SignedInitial();

  @override
  List<Object> get props => [];
}

class SignedLoading extends MediaAppState{
  const SignedLoading();


  @override
  List<Object> get props => [];
}

class SignedUpLoaded extends MediaAppState{
  const SignedUpLoaded();


  @override
  List<Object> get props => [];
}
class SignedInLoaded extends MediaAppState{
  const SignedInLoaded();


  @override
  List<Object> get props => [];
}

class SignedFailure extends MediaAppState{
  final String errorMessage;
  const SignedFailure({required this.errorMessage});


  @override
  List<Object> get props => [errorMessage];
}