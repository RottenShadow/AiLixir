import 'package:ailixir/core/errors/failure.dart';
import 'package:ailixir/core/services/api/app_endpoints.dart';
import 'package:ailixir/core/services/api/dio_service.dart';
import 'package:ailixir/core/utils/helper_functions/safe_api_call.dart';
import 'package:dartz/dartz.dart';

class SimilarityRepo {
  final DioService dioService;
  SimilarityRepo({required this.dioService});

  Future<Either<Failure, Map<String, dynamic>>> getSimilar(String smiles) {
    return safeApiCall(() async {
      return await dioService.get(
        endpoint: "${AppEndpoints.baseUrl}scientists/$smiles",
        //TODO: FIX THIS URL
      );
    });
  }

  Future<Either<Failure, Map<String, dynamic>>> getTestSimilar(
    String smiles,
  ) async {
    await Future.delayed(Duration(milliseconds: 33));
    Map<String, dynamic> fakedata = {
      "query_smiles":
          "C1=CC(=CC=C1C(CC(C(F)(F)F)(C(F)(F)F)O)O)C(=O)CC(C(F)(F)F)(C(F)(F)F)O",
      "total_results": 5,
      "results": [
        {
          "name": "Compound_58232",
          "cid": "58232",
          "similarity_score": 1.0,
          "smiles":
              "C1=CC(=CC=C1C(CC(C(F)(F)F)(C(F)(F)F)O)O)C(=O)CC(C(F)(F)F)(C(F)(F)F)O",
          "image": "https://ibin.co/w800/9Ju3dBGtNh3b.jpg",
          "explanation":
              "Query and Match: Identical compound.\nSimilarity Score: 1.000\n\nExplanation: The structure is an exact match. It features a para-substituted benzene ring with two complex side chains containing hexafluoroisopropanol (HFIP) functional groups and a ketone bridge. The complete alignment of SMILES strings confirms identity.",
        },
        {
          "name": "Compound_58141",
          "cid": "58141",
          "similarity_score": 0.9951409101486206,
          "smiles":
              "C1=CC(=CC=C1C(CC(C(F)(F)F)(C(F)(F)F)O)O)C(CC(C(F)(F)F)(C(F)(F)F)O)O",
          "image": "https://ibin.co/w800/9Ju3dBGtNh3b.jpg",
          "explanation":
              "Query: C1=CC...C(=O)... | Match: C1=CC...C(O)...\nSimilarity Score: 0.995\n\nExplanation: This match represents a reduction of the ketone group (C=O) in the query to a secondary alcohol group (C-OH). The rest of the molecular framework, including the fluorinated side chains and the aromatic core, remains identical, leading to an extremely high similarity score.",
        },
        {
          "name": "Compound_25312",
          "cid": "25312",
          "similarity_score": 0.9893719553947449,
          "smiles": "C(C(=O)CC(C(F)(F)F)(C(F)(F)F)O)C(C(F)(F)F)(C(F)(F)F)O",
          "image": "https://ibin.co/w800/9Ju3dBGtNh3b.jpg",
          "explanation":
              "Structural Analysis:\nThis match contains the key HFIP-ketone side chain found in the query but lacks the central benzene ring and the second aromatic substituent. It represents a significant fragment of the original molecule, preserving the highly electronegative trifluoromethyl clusters.",
        },
        {
          "name": "Compound_50143",
          "cid": "50143",
          "similarity_score": 0.9893719553947449,
          "smiles": "C(C(CC(C(F)(F)F)(C(F)(F)F)O)O)C(C(F)(F)F)(C(F)(F)F)O",
          "image": "https://ibin.co/w800/9Ju3dBGtNh3b.jpg",
          "explanation":
              "Structural Analysis:\nSimilar to the previous fragment, this compound retains the aliphatic backbone and the dual hexafluoroisopropanol groups but is in a fully reduced (alcohol) form. The high score is driven by the density of fluorine atoms and shared chain connectivity.",
        },
        {
          "name": "Compound_15244",
          "cid": "15244",
          "similarity_score": 0.9888942837715149,
          "smiles": "C(C(=O)O)C(C(F)(F)F)(C(F)(F)F)O",
          "image": "https://ibin.co/w800/9Ju3dBGtNh3b.jpg",
          "explanation":
              "Analysis:\nThis is a smaller carboxylic acid derivative of the fluorinated chain. It shares the characteristic (CF3)2C(OH)- arrangement which is a major feature of the query molecule's chemical signature, leading to significant structural overlap in fingerprint space.",
        },
      ],
    };
    return Right(fakedata);
  }
}
