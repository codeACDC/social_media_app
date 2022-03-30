import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'app_state.dart';

class MediaAppCubit extends Cubit<MediaAppState> {
  MediaAppCubit() : super(const SignedInitial());

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> signIn({
    required String userEmail,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      emit(const SignedLoading());
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: userEmail,
        password: password,
      );
      emit(const SignedInLoaded());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(
            const SignedFailure(errorMessage: 'No user found for that email.'));
      } else if (e.code == 'wrong-password') {
        emit(const SignedFailure(
            errorMessage: 'Wrong password provided for that user.'));
      }
    } catch (error) {
      emit(const SignedFailure(errorMessage: 'An error has occurred.'));
    }
  }

  Future<void> signUp({
    required String userName,
    required String userEmail,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: userEmail,
        password: password,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'userId': userCredential.user!.uid,
        'userName': userName,
        'userEmail': userEmail,
      });
      userCredential.user!.updateDisplayName(userName);
      emit(const SignedUpLoaded());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(const SignedFailure(
            errorMessage: 'The password provided is too weak.'));
      } else if (e.code == 'email-already-in-use') {
        emit(const SignedFailure(
            errorMessage: 'The account already exists for that email.'));
      }
    } catch (e) {
      emit(SignedFailure(errorMessage: 'An error has occurred. ${e.toString()}'));
    }
  }

  Future <void> signOut() async{

    FirebaseAuth.instance.signOut();

  }
}
