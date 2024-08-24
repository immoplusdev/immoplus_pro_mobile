import 'package:immoplus_pro/data/schemas/user_model_schema.dart';
import 'package:immoplus_pro/main.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class SessionManager {
  static final SessionManager _instance = SessionManager._internal();

  factory SessionManager() {
    return _instance;
  }

  SessionManager._internal();

  UserModelSchema? currentUser;

  // Future<void> init() async {
  //   if (isarInstance == null) {
  //     isarInstance = await Isar.open([UserModelSchema]);
  //   }
  // }

  Future<void> saveUser(UserModelSchema user) async {
    await isarInstance.writeTxn(() async {
      await isarInstance.userModelSchemas.put(user);
    });
    currentUser = user;
  }

  Future<UserModelSchema?> getCurrentUser() async {
    print('Get User');
    if (currentUser == null) {
      final user = await isarInstance.userModelSchemas.get(1);
      if (user != null) {
        currentUser = user;
      }
    }
    return currentUser;
  }

  Future<void> clearSession() async {
    await isarInstance.writeTxn(() async {
      await isarInstance.userModelSchemas.clear();
    });
    currentUser = null;
  }

  // Fonction qui sera exécutée dans le nouvel isolat
  Future<UserModelSchema?> getUserInIsolate() async {
    // Nous n'avons pas besoin du chemin du dossier ici étant donné que l'instance est déjà ouverte.
    final dir = await getApplicationDocumentsDirectory();
    final isar = await Isar.open(
      [UserModelSchemaSchema],
      directory: dir.path,
      name: 'second',
    );
    return await isar.userModelSchemas.get(1);
  }
}
