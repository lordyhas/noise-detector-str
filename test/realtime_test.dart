
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';



class Measure {
  final String message;
  Measure(this.message );

  final Stopwatch _time = Stopwatch();

  Future<void>  timeUp(Future<void> Function() onRun) async {
    _time.start();
    await onRun();
    _time.stop();
    print('##### $message (Temps ecoulé): ${_time.elapsedMilliseconds} milli sec');
  }
  get time => _time;
}


Future<String> chercherDonneesUtilisateur() async {
  // Simuler une requête réseau pour obtenir des données utilisateur
  await Future.delayed(Duration(seconds: 2)); // Attendre 2 secondes
  return 'Données Utilisateur';
}

Future<String> chercherDonneesProduit() async {
  // Simuler une requête réseau pour obtenir des données de produit
  await Future.delayed(Duration(seconds: 3)); // Attendre 3 secondes
  return 'Données Produit';
}

Future<void> fetchData() async {
  var data =
  await chercherDonneesProduit(); // Attend que la donnée soit récupérée
  print(data);
}

Future<void> display() async {
  print('1 display');
  await fetchData();
  print('2 display');
}

void __main() async {
  Measure me = Measure("Ops");
  /*Future.wait([
    chercherDonneesUtilisateur(),
    chercherDonneesProduit(),
  ]).then((List<dynamic> reponses) {
    print(reponses[0]); // Affiche 'Données Utilisateur'
    print(reponses[1]); // Affiche 'Données Produit'
  });*/

  me.timeUp(() async {
    await display();
  });

  print('1 Chargement des données...');
  print('2 Chargement des données...');
  print('3 Chargement des données...');
}

class MockFunction extends Mock {
  Future<void> call();
}

void main() {
  group('Test de la classe Measure', () {
    test('Vérification du temps écoulé', () async {
      // Création d'un mock pour simuler la fonction asynchrone
      var mockFunction = MockFunction();
      when(mockFunction.call()).thenAnswer((_) async {
        // Simuler un délai
        await Future.delayed(Duration(seconds: 1));
      });

      // Création d'une instance de Measure
      var measure = Measure('Test de fonction asynchrone');

      // Exécution de la fonction timeUp avec la fonction mockée
      await measure.timeUp(mockFunction.call);

      // Vérification que le temps écoulé est d'environ 1 seconde
      expect(measure.time.elapsedMilliseconds, closeTo(1000, 100));
    });
  });
}

