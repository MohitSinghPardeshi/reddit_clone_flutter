import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_tutorial/core/constants/firebase_constants.dart';
import 'package:reddit_tutorial/core/failure.dart';
import 'package:reddit_tutorial/core/providers/firebase_providers.dart';
import 'package:reddit_tutorial/core/type_def.dart';
import 'package:reddit_tutorial/models/community_model.dart';

final communityRepositoryProvider = Provider((ref) {
  return CommunityRepository(
    firestore: ref.watch(firestoreProvider),
  );
});

class CommunityRepository {
  final FirebaseFirestore _firestore;
  CommunityRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _community =>
      _firestore.collection(FirebaseConstants.communitiesCollection);

  FutureVoid createCommunity(Community community) async {
    try {
      var communityDoc = await _community.doc(community.name).get();
      if (communityDoc.exists) {
        throw "Community with same name already exists.";
      }

      return Right(_community.doc(community.name).set(community.toMap()));
    } on FirebaseException catch (E) {
      throw E.message!;
    } catch (E) {
      return Left(Failure(E.toString()));
    }
  }

  FutureVoid joinCommunity(String communityName, String userId) async {
    try {
      return Right(_community.doc(communityName).update({
        'members': FieldValue.arrayUnion([userId]),
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  FutureVoid leaveCommunity(String communityName, String userId) async {
    try {
      return Right(_community.doc(communityName).update({
        'members': FieldValue.arrayRemove([userId]),
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  FutureVoid addMods(String communityName, List<String> uids) async {
    try {
      return Right(_community.doc(communityName).update({
        'mods': uids,
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Stream<List<Community>> getUserCommunities(String uid) {
    return _community
        .where('members', arrayContains: uid)
        .snapshots()
        .map((event) {
      List<Community> communityList = [];
      for (var doc in event.docs) {
        communityList
            .add(Community.fromMap(doc.data() as Map<String, dynamic>));
      }
      return communityList;
    });
  }

  Stream<Community> getCommunityByName(String name) {
    return _community.doc(name).snapshots().map(
          (event) => Community.fromMap(event.data() as Map<String, dynamic>),
        );
  }

  FutureVoid editCommunity(Community community) async {
    try {
      return right(_community.doc(community.name).update(community.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Stream<List<Community>> searchCommunity(String query) {
    return _community
        .where(
          'name',
          isGreaterThanOrEqualTo: query.isEmpty ? 0 : query,
          isLessThan: query.isEmpty
              ? null
              : query.substring(0, query.length - 1) +
                  String.fromCharCode(
                    query.codeUnitAt(query.length - 1) + 1,
                  ),
        )
        .snapshots()
        .map((event) {
      List<Community> communities = [];
      for (var community in event.docs) {
        communities
            .add(Community.fromMap(community.data() as Map<String, dynamic>));
      }
      return communities;
    });
  }
}
