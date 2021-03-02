import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'dart:async';

abstract class BaseAuth {
  Future<String> signInWithEmailAndPassword(String email, String password);
  Future<String> createUserWithEmailAndPassword(String email, String password);
  Future<String> currentUser();
  Future<void> signOutUser();
}

class Auth implements BaseAuth {
  final databaseReference = FirebaseDatabase.instance.reference();

  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    User user = (await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email.toString().trim(), password: password))
        .user;
    print('Signed in: ${user.uid}');
    return user.uid;
  }

  Future<String> createUserWithEmailAndPassword(
      String email, String password) async {
    User user = (await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password))
        .user;
    createUser(user.uid);
    return user.uid;
  }

  Future<String> currentUser() async {
    User user = FirebaseAuth.instance.currentUser;
    return user.uid;
  }

  Future<void> signOutUser() async {
    return FirebaseAuth.instance.signOut();
  }

  void createUser(String uid) {
    UserData user = new UserData(uid);
    databaseReference.reference().child('users').child(uid).set(user.toJSON());
  }
}

class UserData {
  String uid;

  UserData(this.uid);
  // UserData.fromSnapshot(DataSnapshot snapshot) : uid = snapshot.value;
  toJSON() {
    return {
      "Points": {
        "-MS-4Pt02EJzmU9_mXoK": {"Date": "26 Jan", "XP": 0},
      },
      "DG": {"Date": " ", "Earn": 0, "Practice": 0, "Quiz": 0},
      "WOTD": {
        "1": {
          "Deck": 2,
          "POS": "Exclamation",
          "Translation": "Sure",
          "Word": "Iyo baga"
        },
        "Date": " "
      },
      "basics1": {
        "Drink": [
          {"POS": "Noun", "Translation": "Coffee", "Word": "Kape"},
          {"POS": "Noun", "Translation": "Water", "Word": "Tubig"},
          {"POS": "Noun", "Translation": "Milk", "Word": "Gatas"}
        ],
        "Food": [
          {"POS": "Noun", "Translation": "Coconut", "Word": "Niyog"},
          {"POS": "Noun", "Translation": "Bread", "Word": "Tinapay"},
          {"POS": "Noun", "Translation": "Rice", "Word": "Luto"},
          {"POS": "Noun", "Translation": "Fish", "Word": "Sira"},
          {"POS": "Noun", "Translation": "Meat", "Word": "Karne"}
        ],
        "Level1": {
          "LevelID": 1,
          "LevelStatus": 0,
          "Words": [
            null,
            {
              "Deck": 1,
              "POS": "Exclamation",
              "Translation": "Hello",
              "Word": "Kumusta"
            },
            {
              "Deck": 1,
              "POS": "Exclamation",
              "Translation": "Good morning",
              "Word": "Marhay na aga"
            },
            {
              "Deck": 1,
              "POS": "Exclamation",
              "Translation": "Good afternoon",
              "Word": "Marhay na hapon"
            },
            {
              "Deck": 1,
              "POS": "Exclamation",
              "Translation": "Good evening",
              "Word": "Marhay na banggi"
            },
            {
              "Deck": 1,
              "POS": "Common Phrase",
              "Translation": "Welcome to",
              "Word": "Maogmang pag-abot sa"
            },
            {
              "Deck": 1,
              "POS": "Common Phrase",
              "Translation": "How are you",
              "Word": "Kumusta ka po"
            },
            {
              "Deck": 1,
              "POS": "Common Phrase",
              "Translation": "Fine, thank you",
              "Word": "Marhay man, salamat"
            },
            {
              "Deck": 1,
              "POS": "Exclamation",
              "Translation": "Thank you",
              "Word": "Salamat tabi"
            },
            {
              "Deck": 1,
              "POS": "Exclamation",
              "Translation": "Welcome",
              "Word": "Daing ano man"
            },
            {
              "Deck": 1,
              "POS": "Common Phrase",
              "Translation": "What is your name?",
              "Word": "Ano an pangaran mo?"
            },
            {
              "Deck": 1,
              "POS": "Common Phrase",
              "Translation": "What time is it?",
              "Word": "Anong oras na tabi?"
            },
            {
              "Deck": 1,
              "POS": "Exclamation",
              "Translation": "Goodbye",
              "Word": "Maduman na ko"
            },
            {
              "Deck": 1,
              "POS": "Exclamation",
              "Translation": "Yes",
              "Word": "Iyo tabi"
            },
            {
              "Deck": 1,
              "POS": "Exclamation",
              "Translation": "No",
              "Word": "Dai tabi"
            },
            {
              "Deck": 1,
              "POS": "Adverb",
              "Translation": "Not",
              "Word": "Bako tabi"
            },
            {
              "Deck": 1,
              "POS": "Pronoun",
              "Translation": "None",
              "Word": "Wara tabi"
            },
            {
              "Deck": 1,
              "POS": "Common Phrase",
              "Translation": "I don't know",
              "Word": "Dai ko aram"
            },
            {
              "Deck": 1,
              "POS": "Common Phrase",
              "Translation": "Do you understand?",
              "Word": "Nasasabutan mo?"
            },
            {
              "Deck": 1,
              "POS": "Exclamation",
              "Translation": "Sure",
              "Word": "Iyo baga"
            }
          ]
        },
        "Level2": {
          "LevelID": 2,
          "LevelStatus": 0,
          "Words": [
            null,
            {
              "Deck": 1,
              "POS": "Common Phrase",
              "Translation": "I undertand",
              "Word": "Nasasabutan ko"
            },
            {
              "Deck": 1,
              "POS": "Common Phrase",
              "Translation": "I don't understand",
              "Word": "Dai ko nasasabutan"
            },
            {
              "Deck": 1,
              "POS": "Common Phrase",
              "Translation": "Do you speak in English?",
              "Word": "Tatao ka magtaram nin Ingles?"
            },
            {
              "Deck": 1,
              "POS": "Common Phrase",
              "Translation": "Excuse me",
              "Word": "Maki-agi tabi"
            },
            {
              "Deck": 1,
              "POS": "Common Phrase",
              "Translation": "I am sorry",
              "Word": "Pasensya na tabi"
            },
            {
              "Deck": 1,
              "POS": "Adverb",
              "Translation": "Please",
              "Word": "Tabi"
            },
            {
              "Deck": 1,
              "POS": "Common Phrase",
              "Translation": "Do not worry",
              "Word": "Dai ka maghadet"
            },
            {
              "Deck": 1,
              "POS": "Common Phrase",
              "Translation": "Where is the toilet?",
              "Word": "Sain tabi an banyo?"
            },
            {
              "Deck": 1,
              "POS": "Exclamation",
              "Translation": "Help!",
              "Word": "Tabang!"
            },
            {
              "Deck": 1,
              "POS": "Common Phrase",
              "Translation": "My name is",
              "Word": "Ako si"
            },
            {
              "Deck": 1,
              "POS": "Common Phrase",
              "Translation": "Where are you from?",
              "Word": "Taga-sain ka?"
            },
            {
              "Deck": 1,
              "POS": "Common Phrase",
              "Translation": "I'm from Manila",
              "Word": "Taga-Manila ako"
            },
            {
              "Deck": 1,
              "POS": "Common Phrase",
              "Translation": "How old are you?",
              "Word": "Pira na tabi and edad mo?"
            },
            {
              "Deck": 1,
              "POS": "Common Phrase",
              "Translation": "Good luck!",
              "Word": "Swertihon ka man lugod!"
            },
            {
              "Deck": 1,
              "POS": "Common Phrase",
              "Translation": "Happy Birthday!",
              "Word": "Maogmang Compleaño!"
            },
            {"Deck": 1, "POS": "Number", "Translation": "One", "Word": "Saro"},
            {"Deck": 1, "POS": "Number", "Translation": "Two", "Word": "Duwa"},
            {
              "Deck": 1,
              "POS": "Number",
              "Translation": "Three",
              "Word": "Tolo"
            },
            {"Deck": 1, "POS": "Number", "Translation": "Four", "Word": "Apat"},
            {"Deck": 1, "POS": "Number", "Translation": "Five", "Word": "Lima"},
            {"Deck": 1, "POS": "Number", "Translation": "Six", "Word": "Anom"},
            {
              "Deck": 1,
              "POS": "Number",
              "Translation": "Seven",
              "Word": "Pito"
            },
            {
              "Deck": 1,
              "POS": "Number",
              "Translation": "Eight",
              "Word": "Walo"
            },
            {
              "Deck": 1,
              "POS": "Number",
              "Translation": "Nine",
              "Word": "Siyam"
            },
            {
              "Deck": 1,
              "POS": "Number",
              "Translation": "Ten",
              "Word": "Sampulo"
            }
          ]
        },
        "Level3": {
          "LevelID": 3,
          "LevelStatus": 0,
          "Words": [
            null,
            {"Deck": 1, "POS": "Noun", "Translation": "Age", "Word": "Edad"},
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Name",
              "Word": "Pangaran"
            },
            {
              "Deck": 1,
              "POS": "Adjective",
              "Translation": "Marhay",
              "Word": "Good"
            },
            {
              "Deck": 1,
              "POS": "Adjective",
              "Translation": "Maraoton",
              "Word": "Bad"
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Second",
              "Word": "Segundo"
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Minute",
              "Word": "Minuto"
            },
            {"Deck": 1, "POS": "Noun", "Translation": "Hour", "Word": "Oras"},
            {"Deck": 1, "POS": "Noun", "Translation": "Day", "Word": "Aldaw"},
            {"Deck": 1, "POS": "Noun", "Translation": "Week", "Word": "Semana"},
            {"Deck": 1, "POS": "Noun", "Translation": "Month", "Word": "Bulan"},
            {"Deck": 1, "POS": "Noun", "Translation": "Year", "Word": "Taon"},
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Monday",
              "Word": "Lunes"
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Tuesday",
              "Word": "Martes"
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Wednesday",
              "Word": "Miyerkules"
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Thursday",
              "Word": "Huwebes"
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Friday",
              "Word": "Biyernes"
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Saturday",
              "Word": "Sabado"
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Sunday",
              "Word": "Domingo"
            },
            null,
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Yesterday",
              "Word": "Kasu-ugma"
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Tomorrow",
              "Word": "Sa aga"
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Tonight",
              "Word": "Ngunyan na banggi"
            },
            {"Deck": 1, "POS": "Noun", "Translation": "Morning", "Word": "Aga"},
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Evening",
              "Word": "Banggi"
            }
          ]
        },
        "Level4": {
          "LevelID": 4,
          "LevelStatus": 0,
          "Words": [
            null,
            {
              "Deck": 1,
              "POS": "Verb",
              "Translation": "to Eat",
              "Word": "Kakan"
            },
            {
              "Deck": 1,
              "POS": "Verb",
              "Translation": "to Drink",
              "Word": "Inom"
            },
            {"Deck": 1, "POS": "Noun", "Translation": "Rice", "Word": "Luto"},
            {"Deck": 1, "POS": "Noun", "Translation": "Egg", "Word": "Sugok"},
            {"Deck": 1, "POS": "Noun", "Translation": "Fish", "Word": "Sira"},
            {"Deck": 1, "POS": "Noun", "Translation": "Meat", "Word": "Karne"},
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Sandwich",
              "Word": "Sandwich"
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Apple",
              "Word": "Mansanas"
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Orange",
              "Word": "Aranghita"
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Mango",
              "Word": "Mangga"
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Coconut",
              "Word": "Niyog"
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Papaya",
              "Word": "Tapayas"
            },
            {"Deck": 1, "POS": "Noun", "Translation": "Salt", "Word": "Asin"},
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Pepper",
              "Word": "Paminta"
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Onion",
              "Word": "Sibuyas"
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Garlic",
              "Word": "Bawang"
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Chicken",
              "Word": "Manok"
            },
            {"Deck": 1, "POS": "Noun", "Translation": "Cheese", "Word": "Keso"},
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Fruit",
              "Word": "Prutas"
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Vegetables",
              "Word": "Gulay"
            },
            {"Deck": 1, "POS": "Noun", "Translation": "Juice", "Word": "Tagok"},
            {"Deck": 1, "POS": "Noun", "Translation": "Coffee", "Word": "Kape"},
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Beer",
              "Word": "Serbesa"
            },
            {"Deck": 1, "POS": "Noun", "Translation": "Tea", "Word": "Tsa"},
            {"Deck": 1, "POS": "Noun", "Translation": "Milk", "Word": "Gatas"},
            {"Deck": 1, "POS": "Noun", "Translation": "Chili", "Word": "Sili"},
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Bread",
              "Word": "Tinapay"
            },
            {
              "Deck": 1,
              "POS": "Verb",
              "Translation": "Drinking",
              "Word": "Nag-iinom"
            },
            {
              "Deck": 1,
              "POS": "Verb",
              "Translation": "Eating",
              "Word": "Nagkakaon"
            },
            {
              "Deck": 1,
              "POS": "Verb",
              "Translation": "will Eat",
              "Word": "Magkaon"
            },
            {
              "Deck": 1,
              "POS": "Verb",
              "Translation": "will Drink",
              "Word": "Mag-inom"
            },
            {"Deck": 1, "POS": "Verb", "Translation": "Ate", "Word": "Nagkaon"},
            {
              "Deck": 1,
              "POS": "Verb",
              "Translation": "Drank",
              "Word": "Nag-inom"
            }
          ]
        },
        "Level5": {
          "LevelID": 5,
          "LevelStatus": 0,
          "Words": [
            null,
            {"Deck": 1, "POS": "Noun", "Translation": "Boy", "Word": "Nonoy"},
            {"Deck": 1, "POS": "Noun", "Translation": "Girl", "Word": "Nene"},
            {"Deck": 1, "POS": "Noun", "Translation": "Man", "Word": "Lalaki"},
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Babae",
              "Word": "Babayi"
            },
            {"Deck": 1, "POS": "Pronoun", "Translation": "He", "Word": "Siya"},
            {"Deck": 1, "POS": "Pronoun", "Translation": "She", "Word": "Siya"},
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Men",
              "Word": "Mga lalaki"
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Women",
              "Word": "Mga babayi"
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Boys",
              "Word": "Mga nonoy"
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Girls",
              "Word": "Mga nene"
            },
            {
              "Deck": 1,
              "POS": "Pronoun",
              "Translation": "You (singular)",
              "Word": "Ika"
            },
            {
              "Deck": 1,
              "POS": "Pronoun",
              "Translation": "You (plural)",
              "Word": "Kamo"
            },
            {"Deck": 1, "POS": "Pronoun", "Translation": "I", "Word": "Ako"},
            {
              "Deck": 1,
              "POS": "Verb",
              "Translation": "to Want",
              "Word": "Gusto"
            }
          ]
        },
        "Markers": [
          null,
          {"POS": "Marker", "Translation": "Of/By/With/From", "Word": "Nin"},
          {"POS": "Marker", "Translation": "The (singular)", "Word": "An"},
          {"POS": "Marker", "Translation": "The (plural)", "Word": "An mga"},
          {"POS": "Marker", "Translation": "That", "Word": "Na"},
          {"POS": "Marker", "Translation": "A/An", "Word": "Kan"}
        ],
        "Names": [
          {
            "Gender": "Female",
            "Name": "Clara",
            "Number": "Singular",
            "POS": "Proper Noun"
          },
          {
            "Gender": "Male",
            "Name": "Simon",
            "Number": "Singular",
            "POS": "Proper Noun"
          },
          {
            "Gender": "Male",
            "Name": "Juan",
            "Number": "Singular",
            "POS": "Proper Noun"
          }
        ],
        "Pronouns": [
          null,
          {
            "Number": "Singular",
            "POS": "Pronoun",
            "POV": "Second",
            "Translation": "You",
            "Word": "Ika"
          },
          {
            "Number": "Plural",
            "POS": "Pronoun",
            "POV": "Second",
            "Translation": "You",
            "Word": "Kamo"
          },
          {
            "Number": "Plural",
            "POS": "Pronoun",
            "POV": "First",
            "Translation": "I",
            "Word": "Ako"
          },
          {
            "Gender": "Female",
            "Number": "Singular",
            "POS": "Pronoun",
            "POV": "Third",
            "Translation": "She",
            "Word": "Siya"
          },
          {
            "Gender": "Male",
            "Number": "Singular",
            "POS": "Pronoun",
            "POV": "Third",
            "Translation": "He",
            "Word": "Siya"
          }
        ],
        "Sentences": [
          null,
          {"Sentence": "Siya si Clara", "Translation": "She is Clara"},
          {"Sentence": "Nagkaon ako tinapay", "Translation": "I ate bread"},
          {"Sentence": "Siya si Juan", "Translation": "He is Juan"},
          {"Sentence": "Babayi ako", "Translation": "I am a woman"},
          {"Sentence": "Lalaki ako", "Translation": "I am a man"},
          {
            "Sentence": "Nagkaon si Juan kan mansanas",
            "Translation": "Juan ate an apple"
          },
          {
            "Sentence": "Gusto mo kan kape?",
            "Translation": "Do you want coffee?"
          },
          {
            "Sentence": "Si Juan ay nagkakaon ng karne",
            "Translation": "Juan is eating meat"
          },
          {"Sentence": "Ang mga nonoy", "Translation": "The boys"},
          {"Sentence": "Ang mga babayi", "Translation": "The women"},
          {
            "Sentence": "Nagkaon kan mga niyog ang mga lalaki",
            "Translation": "The men ate coconuts"
          },
          {
            "Sentence": "Gusto mo su mangga?",
            "Translation": "Do you want the mango?"
          }
        ],
        "Verbs": [
          null,
          {
            "Category": "Food",
            "POS": "Verb",
            "Tense": "Continuous",
            "Translation": "Eat",
            "Word": "Kakaon"
          },
          {
            "Category": "Drink",
            "POS": "Verb",
            "Tense": "Continuous",
            "Translation": "Drink",
            "Word": "Inom"
          },
          {
            "Category": "Food",
            "POS": "Verb",
            "Tense": "Present",
            "Translation": "Eating",
            "Word": "Nagkakaon"
          },
          {
            "Category": "Drink",
            "POS": "Verb",
            "Tense": "Present",
            "Translation": "Drinking",
            "Word": "Nag-iinom"
          },
          {
            "Category": "Food",
            "POS": "Verb",
            "Tense": "Future",
            "Translation": "will Eat",
            "Word": "Magkaon"
          },
          {
            "Category": "Drink",
            "POS": "Verb",
            "Tense": "Future",
            "Translation": "will Drink",
            "Word": "Mag-iinom"
          },
          {
            "Category": "Food",
            "POS": "Verb",
            "Tense": "Past",
            "Translation": "Ate",
            "Word": "Nagkaon"
          },
          {
            "Category": "Drink",
            "POS": "Verb",
            "Tense": "Past",
            "Translation": "Drank",
            "Word": "Nag-inom"
          }
        ]
      }
    };
  }
}
