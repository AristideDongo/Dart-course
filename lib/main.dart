import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void direBonjour(String nom) {
  print('Bonjour $nom');
}

Function returncarre = (int x) => x * x;

void dieBonjourAvecTitre({required String titre, required String nom}) {
  print('Bonjour $titre $nom');
}

void tva(String montant, {double taux = 0.18}) {
  print('Le montant $montant a une TVA de $taux');
}

List<String> fruits = ['Banane', 'Pomme', 'Fraise'];
Set<String> couleurs = {'Rouge', 'Jaune', 'Bleu'};
Map<String, String> capitales = {'France': 'Paris', 'Italie': 'Rome'};

var villes = {'France': 'Paris', 'Italie': 'Rome'};
var nouvelleVille = {...villes, 'Allemagne': 'Berlin'};

bool afficherCodePromo = true;
var prix = [100, if (afficherCodePromo) 150];

var doubles = [for (var i in List.generate(10, (i) => i)) i * 2];

class Persone {
  String nom;
  int age;
  Persone(this.nom, this.age);

  void sePresenter() {
    print('Je m\'appelle $nom et j\'ai $age ans');
  }
}

class Etudiant {
  String nom;
  int note;
  Etudiant(this.nom, this.note);

  void afficherEtudiant() {
    print('Je m\'appelle $nom et j\'ai $note comme note');
  }
}

class Vehicule {
  String marque;
  Vehicule(this.marque);
}

class Voiture extends Vehicule {
  Voiture(String marque) : super(marque);
}

class Employer {
  double _salaireBrut = 0;
  void definirSalaireBrut(double montant) {
    if (montant > 0) {
      _salaireBrut = montant;
    }
  }

  double get salaireBrut => _salaireBrut;
  double get salaireNet => _salaireBrut * 0.9;
}

lireBonjour(String nom) {
  print('Bonjour $nom');
}

void emailverification(String email) {
  if (!email.contains('@gmail.com')) {
    throw Exception('L\'email n\'est pas valide');
  }
  print('L\'email est valide $email');
}

void main() {
//  var p = Persone('Aristide', 20);
//  p.sePresenter();
//  var e = Etudiant('Aristide', 20);
//  e.afficherEtudiant();
//  var emp = Employer();
//  emp.definirSalaireBrut(5000);
//  print(emp.salaireNet);
//  print(emp._salaireBrut);
//  try {
//    emailverification('aristide@gmail.com');
//  } catch (e) {
//    print(e);
//  }
//  lireBonjour('Daniel');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Name Generator',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black87),
        ),
        home: MyHomePage(),
        
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void tooglesFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    Widget page;
    switch(selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
      page = FavoritesPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  extended:  constraints.maxWidth >= 600,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: Text('Favorites'),
                    ),
                  ],
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.tooglesFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onSecondary,
    );
    return Card(
        color: theme.colorScheme.primary,
        child: Padding(
          padding: const EdgeInsets.all(17),
          child: Text(
            pair.asPascalCase,
            semanticsLabel: "${pair.first} ${pair.second}",
            style: style,
          ),
        ));
  }
}


class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have '
              '${appState.favorites.length} favorites:'),
        ),
        for (var pair in appState.favorites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(pair.asPascalCase),
          ),
      ],
    );
  }
}