import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'dart:async';

abstract class BaseAuth {
  Future<String> signInWithEmailAndPassword(String email, String password);
  Future<String> createUserWithEmailAndPassword(
      String email, String password, String name);
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
      String email, String password, String name) async {
    User user = (await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password))
        .user;
    createUser(user.uid, name);
    return user.uid;
  }

  Future<String> currentUser() async {
    User user = FirebaseAuth.instance.currentUser;
    return user.uid;
  }

  Future<void> signOutUser() async {
    return FirebaseAuth.instance.signOut();
  }

  void createUser(String uid, String name) {
    UserData user = new UserData(uid, name);
    databaseReference.reference().child('users').child(uid).set(user.toJSON());
  }
}

class UserData {
  String uid;
  String name;

  UserData(this.uid, this.name);
  // UserData.fromSnapshot(DataSnapshot snapshot) : uid = snapshot.value;
  toJSON() {
    return {
      "ProfilePic": false,
      "Requests": false,
      "Friends": false,
      "Streak": {
        "Date": "26 Jan",
        "Value": 0,
      },
      "Trophies": {
        "Words": 0,
        "Streak": 0,
        "Story": 0,
        "XP": 0,
      },
      "Name": name,
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
      "TOTD": [
        "Use 'tabi' to show respect.",
      ],
      //=======================================================================
      //===============================STORIES=================================
      //=======================================================================
      "Stories": [
        {
          "QuizStatus": 0,
          "QuizScore": 0,
          "Answers": {"0": false, "1": false, "2": false, "3": false},
          "Status": 'u',
          "Quiz": [
            {
              "Answer": "Pedro",
              "Question": "Who invited Juan to eat?",
              "Type": "I"
            },
            {
              "Answer": "Prutas",
              "Question": "What was the first thing Juan ate?",
              "Type": "I"
            },
            {
              "Answer": "Karne",
              "Question": "What was the second thing Juan ate?",
              "Type": "I"
            },
            {
              "Answer": "Banggi",
              "Choice1": "Banggi",
              "Choice2": "Udto",
              "Choice3": "Bahaw",
              "Question": "What did they eat?",
              "Type": "MC"
            }
          ],
          "Story":
              "\t\t Matalik na mag-amigo si Pedro at Juan. Pigimbitaran ni Pedro si Juan sa saindang harong para magkaon ki pangpanggihan. / \t  \t“Marhay na hapon po.” taram ni Juan sa Ama at Ina ni Pedro. / \t \t“Marhay na hapon dman saimo Juan. Kumusta?” simbag kan Ina ni Pedro. /  \t“Maray man tabi, salamat.” / \t \tAng apat ay pumunta sa komedor at nagpoon ng magkaon. Enot na pigkakan ni Juan ay an prutas na inihanda.  /  \t“Karne o sira, Juan?” hapot kan Ama ni Pedro. / \t \t“Karne po, salamat.” simbag ni Juan at pigturol saiya an karne. /  \tDakol an pigkakan ninda at kan matapos magkakan ki pamanggihan nag-inom sinda kan tubig. /  \t“Salamat po sa pamanggihan. Maduman na tabi ako.” taram ni Juan. /  \t“Daing ano man. Paaram.” simbag ni Pedro. /"
        },
        {
          "QuizStatus": 0,
          "QuizScore": 0,
          "Answers": {"0": false, "1": false, "2": false, "3": false},
          "Status": 'u',
          "Quiz": [
            {
              "Answer": "Domingo",
              "Question": "When is the feast?",
              "Type": "I"
            },
            {
              "Answer": "Bestida",
              "Question": "What did they buy at the mall?",
              "Type": "I"
            },
            {
              "Answer": "Ensalada",
              "Question": "What did Maria eat?",
              "Type": "I"
            },
            {
              "Answer": "Kaunan",
              "Choice1": "Harong",
              "Choice2": "Fiesta",
              "Choice3": "Kaunan",
              "Question": "Where did they go after buying?",
              "Type": "MC"
            }
          ],
          "Story":
              "\t\tSi Maria at Clara ay nagduman sa Mall para bumakal ki bado para sa piesta kan saindang bayan sa maabot na domingo. Nakakita tulos si Clara ki bestida na muya nya isulot sa piesta. /\t\t“Mamira ini tabi?” hapot ni Clara sa saleslady habang kapot kapot an bestida. /\t\t“250 tabi.” simbag kan saleslady. /\t\t“Husto daw ini sakuya?” hapot ni Clara kay Maria. /\t\t“Garo dakula saimo.” simbag ni Maria. /\t\tNagparahanap pa si Maria dangan si Clara sa tindahan ugaring mga mahalon. Nagbalyo na sana sinda sa ibang tindahan taning makahanap pa nung magayon. / \t\t“Magayon ining bestida, Clara!” taram ni Maria. /\t\t“Bukon ba halipot sako?” simbag ni Clara kay Maria. /\t\t“Dai dangan barato pa, bakalon mo na!” /\t\t“Sige! Ika Maria, dai ka mabakal?” hapot ni Clara sa amiga. /\t\t“Dai. Igwa ako bado sa harong.” simbag ni Maria. / \t\tKan matapos sinda magbayad nag-adun sinda sa kaunan. Manok at maluto ki Clara, ensalada naman ki Maria. /\t\t“Magkaon na kita!” taram ni Clara at pigtao ki Maria an saiyang order. /\t\tNagkakan an mag-amiga dangan nag-uli na saindang harong. /"
        },
        {
          "QuizStatus": 0,
          "QuizScore": 0,
          "Answers": {"0": false, "1": false, "2": false, "3": false},
          "Status": 'u',
          "Quiz": [
            {"Answer": "Mark", "Question": "Who called Rob?", "Type": "I"},
            {
              "Answer": "Legazpi",
              "Question": "Where did they go for their fieldtrip?",
              "Type": "I"
            },
            {
              "Answer": "Gwardiya",
              "Question": "Who did Rob ask for directions?",
              "Type": "I"
            },
            {
              "Answer": "Hotel",
              "Choice1": "Hotel",
              "Choice2": "Park",
              "Choice3": "Kaunan",
              "Question": "Where did they go after they left the airport?",
              "Type": "MC"
            }
          ],
          "Story":
              "\t\tSarong aldaw sa Manila, igwang estudiante na si Rob an naimbitahan kan saiyang eskuwelahan na sumama sa sarong fieldtrip kaibahan an saiyang mga amigo ngunit, siya ay nasobrahan sa katurog. /\t\tPingapodan kan saiyang mga amigo si Rob sa telepono para magmata. /\t\t“Rob haen ka?” hapot kan amigo ni Rob na si Mark. / \t\t“Kamamata ko sana, nalabihan ako kan katurog.” simbag ni Rob. /\t\t“Ala! Nasa harong ka pa?” hapot ni Mark. /\t\t“Nagpakarhay kan gamit so Rob at nagdalagan paluwas kn harong at naglunad ki bus paduman sa airport kung saen sinda maghirilingan. /\t\tKan mahiling ni Mark si Rob sa airport, pig-apod niya ito. /\t\t“Rob yaon kami digdi!” suriyaw ni Mark. /\t\tSinda ay naglunad sa eroplano paduman sa Legazpi, Bicol kan haen an saindang field trip. /\t\tPag kalipas kan sarong oras nag-abot na sinda sa Bicol. /\t\t“Mark, haen digdi an banyo?” hapot ni Rob. /\t\t“Dai ko aram. Hapoton mo su gwardiya.” simbag ni Mark. /\t\tHinapot ni Rob and gwardiya para sa direksyon paduman sa banyo. Suminunod si Rob sa pigtao na direksyon kan gwardiya at nagbweltada tulos sa mga kaklase nya. /\t\t“Magduman kita sa kaunan at sa parke!” taram kan sarong kaklase. /\t\t“Atyan na gayod, dumuman muna kita sa hotel ta walaton ta su mga gamit ta. Bumakal din kita kan payo ta garu maruan.” simbag ni Rob. /\t\tSinda ay naduman sa hotel at nagpahingalo. Dangan pagkatapos magpahingalo ay maugma sindang naglibot-libot para mahiling an magagayon na lugar sa Legazpi."
        },
        {
          "QuizStatus": 0,
          "QuizScore": 0,
          "Answers": {"0": false, "1": false, "2": false, "3": false},
          "Status": 'u',
          "Quiz": [
            {
              "Answer": "Juan",
              "Question": "Who is Pedro's friend?",
              "Type": "I"
            },
            {
              "Answer": "75",
              "Question": "What is the passing grade?",
              "Type": "I"
            },
            {
              "Answer": "Sanaysay",
              "Question": "What did the students write?",
              "Type": "I"
            },
            {
              "Answer": "3PM",
              "Choice1": "5PM",
              "Choice2": "3PM",
              "Choice3": "4PM",
              "Question": "What time did Simon leave the school?",
              "Type": "MC"
            }
          ],
          "Story":
              "\t\t Inot na aldaw ni Simon sa saiyang bagong eskwelahan. Siya ay nagtukaw dangan pigkaag an saiyang mga libro at kwaderno sa lamesa. /  \t  \t“Kumusta! Ako si Pedro. Ano ngaran mo?” taram kan estudiante na nasa tuo niya. / \t  \t “Ako si Simon. Bago lang ako digdi.” simbag ni Simon. /\t  \t“Ah bago ka palan digdi. Pamidbid taka sa amigo ko.” nagtindog si Pedro sa saiyang tukawan at pigapod an saiyang amigo. /\t  \t“Ini si Juan.” itinuro ni Pedro an saiyang amigo. “Ini naman si Simon. Bago siya sa eskwelahan ta.” / \t  \t“Kumusta ka Simon?” taram ni Juan. “Igwa ka hapot samuya?” / \t  \t“Mapagal ba an eksaminasion at anu an pasadong marka?” hapot ni Simon. /\t  \t“Basta mag-adal ka sana ki marhay mapasa ka sa mga eksam.” simbag ni Pedro. /\t  \t“An pasadong marka ay 75.” simbag ni Juan. “Dai ka magparahadit! Kaya an.” /\t  \t“Sana nga at gusto ko maging abogado. Kaipohan ko halangkaw na grado sa gabos na aralin ko.” taram ni Simon. \"Kamo? Unan kukuon nindo na kurso sa kolehiyo?\" /\t  \t“Ako arkitektura.” simbag ni Pedro. “Si Juan naman ay medisina.” Nagtanog an kampana pagkasimbag ni Pedro. / \t  \t“Magturukaw na kita ta maabot na an maestro.” taram ni Juan. /\t  \t An mga estudiante ay nagbasa kan saindang mga libro, nagdangog sa saindang mga maestro, at nagsurat kan mga sanaysay. /\t  \tPag-abot kan alas-tres ay hapon, nag-uli na si Simon sa saiyang harong. /\t  \t“Kumusta an eskuela?” hapot kan ina nya. /\t  \t “Maogma man tabi!” simbag ni Simon. /"
        },
        {
          "QuizStatus": 0,
          "QuizScore": 0,
          "Answers": {"0": false, "1": false, "2": false, "3": false},
          "Status": 'u',
          "Quiz": [
            {
              "Answer": "Clara",
              "Question": "Whose house did Ana went to?",
              "Type": "I"
            },
            {
              "Answer": "Sala",
              "Question": "Which part of the house was shown first?",
              "Type": "I"
            },
            {
              "Answer": "Kusina",
              "Question": "What's beside the dining area?",
              "Type": "I"
            },
            {
              "Answer": "Isabela",
              "Choice1": "Ana",
              "Choice2": "Maria",
              "Choice3": "Isabela",
              "Question": "What's name of Clara's sister?",
              "Type": "MC"
            }
          ],
          "Story":
              "\t\t Si Ana ay nagduman sa harong ni Clara para mag-”sleepover”. Pag-abot ni Ana ay kumatok siya sa puerta. /\t\t“Yaon ka na palan Ana!” maogmang taram ni Clara. “Maglaog ka!” /\t\tPaglaog ni Ana sa harong ay binati siya kan Ama at Ina ni Clara. /\t\t“Kumusta ka Ana?” hapot ninda. /\t\t“Marhay na hapon tabi. Marhay man po, salamat.” simbag ni Ana. /\t\t“Clara, ipasyar mo si Ana sa satuyang harong.” taram kan Ama ni Clara. /\t\t“Iyo tabi. Ini an samuyang sala, Ana.” taram ni Clara. /\t\tNagduman sinda sa ibang kuarto. “Ini an samuyang komedor.” taram ni Clara sa sarong kuarto na igwa lamesa at tukawan. “Kataning kaini an samuyang kusina.” /\t\tNagpanik sinda sa itaas.”Digdi naman an samuyang kuarto.” /\t\tNaglaog an dua sa kuarto sa wala. “Ini an sako na kuarto at digdi kita makaturog.” taram ni Clara habang pigturo an saiyang kama. /\t\t“Magayon an harong nindo, Clara!” taram ni Ana. /\t\t“Salamat, Ana. Mare na ta matapos na sinda magluro kan pagkaon si ina.” /\t\tAn duwa ay nagduman sa komedor at nagkaon si Ana kaibahan an pamilya ni Clara. /\t\t“Uni palan si manay Isabela at manoy Simon ko.” taram ni Clara kay Ana. /\t\t“Kumusta po kamo manay at manoy.” taram ni Ana sa mga tugang ni Clara. /\t\t“Ika palan an amiga ni Clara.” taram ni Isabela. “Magkaon ka dakol!” pigturo ni Isabela an maluto kay Ana. /\t\t“Mabalos po, taram ni Ana.” / \t\tPagkatapos ninda magkaon dangan mag-huron ay nagduman na sila sa kuarto dangan naturog. /"
        },
      ],
      //=======================================================================
      //===============================BASICS1=================================
      //=======================================================================
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
          "LevelStatus": 1,
          "Words": [
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
            {"Deck": 1, "POS": "Noun", "Translation": "Boy", "Word": "Nonoy"},
            {"Deck": 1, "POS": "Noun", "Translation": "Girl", "Word": "Nene"},
            {"Deck": 1, "POS": "Noun", "Translation": "Man", "Word": "Lalaki"},
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Woman",
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
          {
            "Number": "Plural",
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
        "Verbs": [
          // {
          //   "Category": "Food",
          //   "POS": "Verb",
          //   "Tense": "Continuous",
          //   "Translation": "Eat",
          //   "Word": "Makaon"
          // },
          // {
          //   "Category": "Drink",
          //   "POS": "Verb",
          //   "Tense": "Continuous",
          //   "Translation": "Drink",
          //   "Word": "Mag-inom"
          // },
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
      },
      //=======================================================================
      //===============================TRAVEL==================================
      //=======================================================================
      "travel": {
        "See": [
          {"POS": "Noun", "Translation": "Concert", "Word": "Konsierto"},
          {"POS": "Noun", "Translation": "Parade", "Word": "Parada"},
          {"POS": "Noun", "Translation": "Beach", "Word": "Baybay"},
          {"POS": "Noun", "Translation": "Waterfall", "Word": "Busay"},
        ],
        "Ask": [
          {"POS": "Name", "Translation": "Clara", "Word": "Clara"},
          {"POS": "Pronoun", "Translation": "Her", "Word": "Saiya"},
          {"POS": "Name", "Translation": "Juan", "Word": "Juan"},
          {"POS": "Pronoun", "Translation": "Him", "Word": "Saiya"},
        ],
        "Look": [
          {"POS": "Noun", "Translation": "Passport", "Word": "Pasaporte"},
          {"POS": "Noun", "Translation": "Bathroom", "Word": "Banyo"},
          {"POS": "Noun", "Translation": "Guide", "Word": "Giya"},
          {"POS": "Noun", "Translation": "Bank", "Word": "Banko"},
          {"POS": "Noun", "Translation": "Telephone", "Word": "Telepono"},
        ],
        "Bring": [
          {"POS": "Noun", "Translation": "Passport", "Word": "Pasaporte"},
          {"POS": "Noun", "Translation": "Certificate", "Word": "Sertipiko"},
          {"POS": "Noun", "Translation": "Food", "Word": "Pagkaon"},
          {"POS": "Noun", "Translation": "Pen", "Word": "Pluma"},
          {"POS": "Noun", "Translation": "Book", "Word": "Libro"},
        ],
        "Call": [
          {"POS": "Noun", "Translation": "Friend", "Word": "Amigo"},
          {"POS": "Noun", "Translation": "Friend", "Word": "Amiga"},
          {"POS": "Noun", "Translation": "Restaurant", "Word": "Restauran"},
          {"POS": "Noun", "Translation": "Hospital", "Word": "Ospital"},
          {"POS": "Noun", "Translation": "Bank", "Word": "Banko"},
        ],
        "Place": [
          {"POS": "Noun", "Translation": "Beach", "Word": "Baybay"},
          {"POS": "Noun", "Translation": "Island", "Word": "Isla"},
          {"POS": "Noun", "Translation": "Park", "Word": "Parke"},
        ],
        "Adjectives": [
          {
            "Category": "Place",
            "POS": "Adjective",
            "Translation": "Sunny",
            "Word": "Maaraw"
          },
          {
            "Category": "Place",
            "POS": "Adjective",
            "Translation": "Cloudy",
            "Word": "Rumarom"
          },
          {
            "Category": "Place",
            "POS": "Adjective",
            "Translation": "Rainy",
            "Word": "Mauran"
          },
          {
            "Category": "Place",
            "POS": "Adjective",
            "Translation": "Windy",
            "Word": "Maduros"
          },
          {
            "Category": "Place",
            "POS": "Adjective",
            "Translation": "Hot",
            "Word": "Mainit"
          },
          {
            "Category": "Place",
            "POS": "Adjective",
            "Translation": "Cold",
            "Word": "Malipot"
          },
          {
            "Category": "Place",
            "POS": "Adjective",
            "Translation": "Popular",
            "Word": "Popular"
          },
          {
            "Category": "Person",
            "POS": "Adjective",
            "Translation": "Hungry",
            "Word": "Gutom"
          },
          {
            "Category": "Person",
            "POS": "Adjective",
            "Translation": "Thirsty",
            "Word": "Paha"
          },
        ],
        "Verbs": [
          // {
          //   "Category": "See",
          //   "POS": "Verb",
          //   "Tense": "Continuous",
          //   "Translation": "See",
          //   "Word": "Maghiling"
          // },
          {
            "Category": "See",
            "POS": "Verb",
            "Tense": "Present",
            "Translation": "Seeing",
            "Word": "Naghihiling"
          },
          {
            "Category": "See",
            "POS": "Verb",
            "Tense": "Future",
            "Translation": "will See",
            "Word": "Maghihiling"
          },
          {
            "Category": "See",
            "POS": "Verb",
            "Tense": "Past",
            "Translation": "Saw",
            "Word": "Naghiling"
          },
          // {
          //   "Category": "Ask",
          //   "POS": "Verb",
          //   "Tense": "Continuous",
          //   "Translation": "Ask",
          //   "Word": "Maghapot"
          // },
          {
            "Category": "Ask",
            "POS": "Verb",
            "Tense": "Present",
            "Translation": "Asking",
            "Word": "Naghahapot"
          },
          {
            "Category": "Ask",
            "POS": "Verb",
            "Tense": "Future",
            "Translation": "will Ask",
            "Word": "Maghahapot"
          },
          {
            "Category": "Ask",
            "POS": "Verb",
            "Tense": "Past",
            "Translation": "Asked",
            "Word": "Naghapot"
          },
          // {
          //   "Category": "Look",
          //   "POS": "Verb",
          //   "Tense": "Continuous",
          //   "Translation": "Look",
          //   "Word": "Maghanap"
          // },
          {
            "Category": "Look",
            "POS": "Verb",
            "Tense": "Present",
            "Translation": "Looking",
            "Word": "Naghahanap"
          },
          {
            "Category": "Look",
            "POS": "Verb",
            "Tense": "Future",
            "Translation": "will Look",
            "Word": "Maghahanap"
          },
          {
            "Category": "Look",
            "POS": "Verb",
            "Tense": "Past",
            "Translation": "Looked",
            "Word": "Naghanap"
          },
          // {
          //   "Category": "Bring",
          //   "POS": "Verb",
          //   "Tense": "Continuous",
          //   "Translation": "Bring",
          //   "Word": "Magdara"
          // },
          {
            "Category": "Bring",
            "POS": "Verb",
            "Tense": "Present",
            "Translation": "Bringing",
            "Word": "Nagdadara"
          },
          {
            "Category": "Bring",
            "POS": "Verb",
            "Tense": "Future",
            "Translation": "will Bring",
            "Word": "Magdadara"
          },
          {
            "Category": "Bring",
            "POS": "Verb",
            "Tense": "Past",
            "Translation": "Brought",
            "Word": "Nagdara"
          },
          // {
          //   "Category": "Call",
          //   "POS": "Verb",
          //   "Tense": "Continuous",
          //   "Translation": "Call",
          //   "Word": "Mag-apod"
          // },
          {
            "Category": "Call",
            "POS": "Verb",
            "Tense": "Present",
            "Translation": "Calling",
            "Word": "Nag-aapod"
          },
          {
            "Category": "Call",
            "POS": "Verb",
            "Tense": "Future",
            "Translation": "will Call",
            "Word": "Maapod"
          },
          {
            "Category": "Call",
            "POS": "Verb",
            "Tense": "Past",
            "Translation": "Called",
            "Word": "Nag-apod"
          },
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
          {
            "Number": "Plural",
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
        "Level1": {
          "LevelID": 1,
          "LevelStatus": 0,
          "Words": [
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "House",
              "Word": "Balay",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Home",
              "Word": "Baluy",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Address",
              "Word": "Adres",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Direction",
              "Word": "Direksyon",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Certificate",
              "Word": "Sertipiko",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Building",
              "Word": "Bilding",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Elevator",
              "Word": "Elevator",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Stairs",
              "Word": "Hagyan",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Bathroom",
              "Word": "Banyo",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Level",
              "Word": "Patas",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Camera",
              "Word": "Kamera",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Telephone",
              "Word": "Telepono",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Foreigner",
              "Word": "Dayo",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Guide",
              "Word": "Giya",
            },
            {
              "Deck": 1,
              "POS": "Adjective",
              "Translation": "Right",
              "Word": "To",
            },
            {
              "Deck": 1,
              "POS": "Adjective",
              "Translation": "Left",
              "Word": "Wala",
            },
            {
              "Deck": 1,
              "POS": "Common Phrase",
              "Translation": "Where are you?",
              "Word": "Hain ka?",
            },
            {
              "Deck": 1,
              "POS": "Common Phrase",
              "Translation": "Where are you going?",
              "Word": "Padin ka?",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Passport",
              "Word": "Pasaporte",
            },
          ]
        },
        "Level2": {
          "LevelID": 2,
          "LevelStatus": 0,
          "Words": [
            {
              "Deck": 1,
              "POS": "Verb",
              "Translation": "to See",
              "Word": "Hiling",
            },
            {
              "Deck": 1,
              "POS": "Verb",
              "Translation": "to Ask",
              "Word": "Hapot",
            },
            {
              "Deck": 1,
              "POS": "Verb",
              "Translation": "to Find",
              "Word": "Ku'a",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Church",
              "Word": "Simbahan",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Airport",
              "Word": "Airport",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "School",
              "Word": "Eskuela",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Police Station",
              "Word": "Polisia",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Park",
              "Word": "Parke",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Market",
              "Word": "Saod",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Bakery",
              "Word": "Panaderia",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Hair Salon",
              "Word": "Salon",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Museum",
              "Word": "Museo",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Gas Station",
              "Word": "Gasolinahan",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Bank",
              "Word": "Banko",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Pharmacy",
              "Word": "To",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Zoo",
              "Word": "Zoo",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Bus Station",
              "Word": "Parada",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Restaurant",
              "Word": "Restauran",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Cinema",
              "Word": "Sine",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Shop",
              "Word": "Tindahan",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Chapel",
              "Word": "Kapilya",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Clinic",
              "Word": "Klinika",
            },
            // {
            //   "Deck": 1,
            //   "POS": "Noun",
            //   "Translation": "",
            //   "Word": "",
            // },
          ],
        },
        "Level3": {
          "LevelID": 3,
          "LevelStatus": 0,
          "Words": [
            {
              "Deck": 1,
              "POS": "Verb",
              "Translation": "to Go",
              "Word": "Duman",
            },
            {
              "Deck": 1,
              "POS": "Verb",
              "Translation": "to Run",
              "Word": "Dalagan",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Concert",
              "Word": "Konsierto",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Feast",
              "Word": "Piesta",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Wedding",
              "Word": "Kasal",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Parade",
              "Word": "Parada",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Game",
              "Word": "Kawat",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Start",
              "Word": "Puon",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "End",
              "Word": "Tapos",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Time",
              "Word": "Oras",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Ticket",
              "Word": "Tiket",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Ticket Window",
              "Word": "Takilya",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Car",
              "Word": "Auto",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Bicycle",
              "Word": "Bisikleta",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Motorcycle",
              "Word": "Motorsiklo",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Train",
              "Word": "Tren",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Taxi Cab",
              "Word": "Taxi",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Boat",
              "Word": "Bangka",
            },
          ]
        },
        "Level4": {
          "LevelID": 4,
          "LevelStatus": 0,
          "Words": [
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Cloud",
              "Word": "Panganuron",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Sun",
              "Word": "Saldang",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Rain",
              "Word": "Uran",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Star",
              "Word": "Bituon",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Moon",
              "Word": "Bulan",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Sky",
              "Word": "Langit",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Shooting Star",
              "Word": "Bulalakaw",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Rainbow",
              "Word": "Balangaw",
            },
            {
              "Deck": 1,
              "POS": "Adjective",
              "Translation": "Cloudy",
              "Word": "Rumarom",
            },
            {
              "Deck": 1,
              "POS": "Adjective",
              "Translation": "Rainy",
              "Word": "Mauran",
            },
            {
              "Deck": 1,
              "POS": "Adjective",
              "Translation": "Windy",
              "Word": "Duros",
            },
            {
              "Deck": 1,
              "POS": "Verb",
              "Translation": "to Rain",
              "Word": "Uran",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Beach",
              "Word": "Baybay",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Garden",
              "Word": "Hardin",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Island",
              "Word": "Isla",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Mountain",
              "Word": "Bulod",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Volcano",
              "Word": "Bulkan",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Hill",
              "Word": "Bukid",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Waterfall",
              "Word": "Busay",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Ocean",
              "Word": "Dagat",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "River",
              "Word": "Salog",
            },
          ],
        },
        // "Level5": {
        //   "LevelID": 5,
        //   "LevelStatus": 0,
        //   "Words": [
        //     {
        //       "Deck": 1,
        //       "POS": "",
        //       "Translation": "",
        //       "Word": "",
        //     },
        //     {
        //       "Deck": 1,
        //       "POS": "",
        //       "Translation": "",
        //       "Word": "",
        //     },
        //     {
        //       "Deck": 1,
        //       "POS": "",
        //       "Translation": "",
        //       "Word": "",
        //     },
        //     {
        //       "Deck": 1,
        //       "POS": "",
        //       "Translation": "",
        //       "Word": "",
        //     },
        //     {
        //       "Deck": 1,
        //       "POS": "",
        //       "Translation": "",
        //       "Word": "",
        //     },
        //     {
        //       "Deck": 1,
        //       "POS": "",
        //       "Translation": "",
        //       "Word": "",
        //     },
        //     {
        //       "Deck": 1,
        //       "POS": "",
        //       "Translation": "",
        //       "Word": "",
        //     },
        //     {
        //       "Deck": 1,
        //       "POS": "",
        //       "Translation": "",
        //       "Word": "",
        //     },
        //     {
        //       "Deck": 1,
        //       "POS": "",
        //       "Translation": "",
        //       "Word": "",
        //     },
        //     {
        //       "Deck": 1,
        //       "POS": "",
        //       "Translation": "",
        //       "Word": "",
        //     },
        //     {
        //       "Deck": 1,
        //       "POS": "",
        //       "Translation": "",
        //       "Word": "",
        //     },
        //     {
        //       "Deck": 1,
        //       "POS": "",
        //       "Translation": "",
        //       "Word": "",
        //     },
        //   ],
        // },
      },
      //=======================================================================
      //===============================FAMILY==================================
      //=======================================================================
      "family": {
        "Food": [
          {"POS": "Noun", "Translation": "Meat", "Word": "Karne"},
          {"POS": "Noun", "Translation": "Bread", "Word": "Tinapay"},
          {"POS": "Noun", "Translation": "Rice", "Word": "Luto"},
          {"POS": "Noun", "Translation": "Soup", "Word": "Sabaw"},
        ],
        "House": [
          {"POS": "Noun", "Translation": "Living Room", "Word": "Sala"},
          {"POS": "Noun", "Translation": "Room", "Word": "Kuarto"},
          {"POS": "Noun", "Translation": "Dining Room", "Word": "Komedor"},
          {"POS": "Noun", "Translation": "Window", "Word": "Bintana"},
        ],
        "Talk": [
          {"POS": "Noun", "Translation": "Mother", "Word": "Ina"},
          {"POS": "Noun", "Translation": "Father", "Word": "Ama"},
          {"POS": "Noun", "Translation": "Siblings", "Word": "Mga tugang"},
          {"POS": "Noun", "Translation": "Grandmother", "Word": "Lola"},
        ],
        "Adverb": [
          {
            "Category": "Present",
            "POS": "Adverb",
            "Translation": "Often",
            "Word": "Parati"
          },
          {
            "Category": "Continuous",
            "POS": "Adverb",
            "Translation": "Rarely",
            "Word": "Bihira"
          },
          {
            "Category": "Present",
            "POS": "Adverb",
            "Translation": "Quickly",
            "Word": "Dali-dali"
          },
          {
            "Category": "Continuous",
            "POS": "Adverb",
            "Translation": "Slowly",
            "Word": "Luway-luway"
          },
        ],
        "VerbsCont": [
          {
            "Category": "Food",
            "POS": "Verb",
            "Tense": "Continuous",
            "Translation": "Cook",
            "Word": "Magluto"
          },
          {
            "Category": "House",
            "POS": "Verb",
            "Tense": "Continuous",
            "Translation": "Clean",
            "Word": "Maglinig"
          },
          {
            "Category": "Talk",
            "POS": "Verb",
            "Tense": "Continuous",
            "Translation": "Talk",
            "Word": "Maghuron"
          },
        ],
        "VerbsPresent": [
          {
            "Category": "Food",
            "POS": "Verb",
            "Tense": "Present",
            "Translation": "Cook",
            "Word": "Nagluluto"
          },
          {
            "Category": "House",
            "POS": "Verb",
            "Tense": "Present",
            "Translation": "Clean",
            "Word": "Naglilinig"
          },
          {
            "Category": "Talk",
            "POS": "Verb",
            "Tense": "Present",
            "Translation": "Talk",
            "Word": "Nagtataram"
          },
        ],
        "Room": [
          {
            "POS": "Noun",
            "Translation": "Bed Room",
            "Word": "Kuarto",
            "Number": "Singular"
          },
          {
            "POS": "Noun",
            "Translation": "Living Room",
            "Word": "Sala",
            "Number": "Singular"
          },
          {
            "POS": "Noun",
            "Translation": "Kitchen",
            "Word": "Kusina",
            "Number": "Singular"
          },
          {
            "POS": "Noun",
            "Translation": "Garden",
            "Word": "Hardin",
            "Number": "Singular"
          },
        ],
        "Things": [
          {
            "POS": "Noun",
            "Translation": "Cabinet",
            "Word": "Aparador",
            "Number": "Singular"
          },
          {
            "POS": "Noun",
            "Translation": "Plate",
            "Word": "Plato",
            "Number": "Singular"
          },
          {
            "POS": "Noun",
            "Translation": "Kitchen",
            "Word": "Kusina",
            "Number": "Singular"
          },
          {
            "POS": "Noun",
            "Translation": "Garden",
            "Word": "Hardin",
            "Number": "Singular"
          },
        ],
        "Adjectives": [
          {
            "Category": "Room",
            "POS": "Adjective",
            "Translation": "Big",
            "Word": "Dakula"
          },
          {
            "Category": "Room",
            "POS": "Adjective",
            "Translation": "Small",
            "Word": "Sadit"
          },
          {
            "Category": "Room",
            "POS": "Adjective",
            "Translation": "Wide",
            "Word": "Hiwas"
          },
          {
            "Category": "Room",
            "POS": "Adjective",
            "Translation": "Narrow",
            "Word": "Mapiot"
          },
          {
            "Category": "Room",
            "POS": "Adjective",
            "Translation": "Clean",
            "Word": "Malinig"
          },
          {
            "Category": "Room",
            "POS": "Adjective",
            "Translation": "Dirty",
            "Word": "Maati"
          },
          {
            "Category": "Person",
            "POS": "Adjective",
            "Translation": "Short",
            "Word": "Lipot"
          },
          {
            "Category": "Person",
            "POS": "Adjective",
            "Translation": "Tall",
            "Word": "Langkaw"
          },
          {
            "Category": "Person",
            "POS": "Adjective",
            "Translation": "Early",
            "Word": "Amay"
          },
          {
            "Category": "Person",
            "POS": "Adjective",
            "Translation": "Late",
            "Word": "Huri"
          },
          {
            "Category": "Person",
            "POS": "Adjective",
            "Translation": "Young",
            "Word": "Hoben"
          },
          {
            "Category": "Person",
            "POS": "Adjective",
            "Translation": "Old",
            "Word": "Gurang"
          },
          {
            "Category": "Things",
            "POS": "Adjective",
            "Translation": "New",
            "Word": "Bago"
          },
          {
            "Category": "Things",
            "POS": "Adjective",
            "Translation": "Old",
            "Word": "Luma"
          },
          {
            "Category": "Things",
            "POS": "Adjective",
            "Translation": "Important",
            "Word": "Importante"
          },
        ],
        "Verbs": [
          // {
          //   "Category": "Food",
          //   "POS": "Verb",
          //   "Tense": "Continuous",
          //   "Translation": "Cook",
          //   "Word": "Magluto"
          // },
          {
            "Category": "Food",
            "POS": "Verb",
            "Tense": "Present",
            "Translation": "Cooking",
            "Word": "Nagluluto"
          },
          {
            "Category": "Food",
            "POS": "Verb",
            "Tense": "Future",
            "Translation": "will Cook",
            "Word": "Magluluto"
          },
          {
            "Category": "Food",
            "POS": "Verb",
            "Tense": "Past",
            "Translation": "Cooked",
            "Word": "Nagluto"
          },
          // {
          //   "Category": "House",
          //   "POS": "Verb",
          //   "Tense": "Continuous",
          //   "Translation": "Clean",
          //   "Word": "Maglinig"
          // },
          {
            "Category": "House",
            "POS": "Verb",
            "Tense": "Present",
            "Translation": "Cleaning",
            "Word": "Naglilinig"
          },
          {
            "Category": "House",
            "POS": "Verb",
            "Tense": "Future",
            "Translation": "will Clean",
            "Word": "Maglilinig"
          },
          {
            "Category": "House",
            "POS": "Verb",
            "Tense": "Past",
            "Translation": "Cleaned",
            "Word": "Naglinig"
          },
          // {
          //   "Category": "Talk",
          //   "POS": "Verb",
          //   "Tense": "Continuous",
          //   "Translation": "Talk",
          //   "Word": "Maghuron"
          // },
          {
            "Category": "Talk",
            "POS": "Verb",
            "Tense": "Present",
            "Translation": "Talking",
            "Word": "Naghuhuron"
          },
          {
            "Category": "Talk",
            "POS": "Verb",
            "Tense": "Future",
            "Translation": "will Talk",
            "Word": "Maghuhuron"
          },
          {
            "Category": "Talk",
            "POS": "Verb",
            "Tense": "Past",
            "Translation": "Talked",
            "Word": "Naghuron"
          },
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
          {
            "Number": "Plural",
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
        "Level1": {
          "LevelID": 1,
          "LevelStatus": 0,
          "Words": [
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Family",
              "Word": "Pamilya",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Husband and Wife",
              "Word": "Mag-agom",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Boyfriend and Girlfriend",
              "Word": "Mag-ilusyon",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Father",
              "Word": "Ama",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Mother",
              "Word": "Ina",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Siblings",
              "Word": "Tugang",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Older brother",
              "Word": "Kuya",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Older sister",
              "Word": "Ate",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Parents",
              "Word": "Magurang",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Children",
              "Word": "Mga aki",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Child",
              "Word": "Aki",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Grandfather",
              "Word": "Lolo",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Grandmother",
              "Word": "Lola",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Grandchild",
              "Word": "Apo",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Grandchildren",
              "Word": "Makoapo",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Baby",
              "Word": "Umboy",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Uncle",
              "Word": "Tiyo",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Aunt",
              "Word": "Tiya",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Spouse",
              "Word": "Agom",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Cousin",
              "Word": "Pinsan",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Husband",
              "Word": "Agom",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Wife",
              "Word": "Agom",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Boyfriend",
              "Word": "Ilusyon",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Girlfriend",
              "Word": "Ilusyon",
            },
          ]
        },
        "Level2": {
          "LevelID": 2,
          "LevelStatus": 0,
          "Words": [
            {
              "Deck": 1,
              "POS": "Adjective",
              "Translation": "Big",
              "Word": "Dakula",
            },
            {
              "Deck": 1,
              "POS": "Adjective",
              "Translation": "Small",
              "Word": "Sadit",
            },
            {
              "Deck": 1,
              "POS": "Adjective",
              "Translation": "Short",
              "Word": "Li'pot",
            },
            {
              "Deck": 1,
              "POS": "Adjective",
              "Translation": "Tall",
              "Word": "Langkaw",
            },
            {
              "Deck": 1,
              "POS": "Adjective",
              "Translation": "Long",
              "Word": "Laba",
            },
            {
              "Deck": 1,
              "POS": "Adjective",
              "Translation": "Little",
              "Word": "Dikit",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Height",
              "Word": "Langkaw",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Weight",
              "Word": "Timbang",
            },
            {
              "Deck": 1,
              "POS": "Adjective",
              "Translation": "Wide",
              "Word": "Hiwas",
            },
            {
              "Deck": 1,
              "POS": "Adjective",
              "Translation": "Narrow",
              "Word": "Pi'ot",
            },
            // {
            //   "Deck": 1,
            //   "POS": "Adjective",
            //   "Translation": "",
            //   "Word": "",
            // },
            {
              "Deck": 1,
              "POS": "Adjective",
              "Translation": "Important",
              "Word": "Importante",
            },
            {
              "Deck": 1,
              "POS": "Adjective",
              "Translation": "Clean",
              "Word": "Linig",
            },
            {
              "Deck": 1,
              "POS": "Adjective",
              "Translation": "Dirty",
              "Word": "Ati",
            },
            {
              "Deck": 1,
              "POS": "Verb",
              "Translation": "to Clean",
              "Word": "Linig",
            },
            {
              "Deck": 1,
              "POS": "Verb",
              "Translation": "to Cook",
              "Word": "Luto",
            },
            {
              "Deck": 1,
              "POS": "Verb",
              "Translation": "to Live in/at",
              "Word": "Istar",
            },
            {
              "Deck": 1,
              "POS": "Adjective",
              "Translation": "New",
              "Word": "Bago",
            },
            {
              "Deck": 1,
              "POS": "Adjective",
              "Translation": "Old (Things)",
              "Word": "Luma",
            },
            {
              "Deck": 1,
              "POS": "Adjective",
              "Translation": "Early",
              "Word": "Amay",
            },
            {
              "Deck": 1,
              "POS": "Adjective",
              "Translation": "Late",
              "Word": "Huri",
            },
            {
              "Deck": 1,
              "POS": "Adjective",
              "Translation": "Young",
              "Word": "Hoben",
            },
            {
              "Deck": 1,
              "POS": "Adjective",
              "Translation": "Old (People)",
              "Word": "Gurang",
            },
          ]
        },
        "Level3": {
          "LevelID": 3,
          "LevelStatus": 0,
          "Words": [
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Couch",
              "Word": "Katre",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Bed",
              "Word": "Kama",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Toilet",
              "Word": "Kasilyasan",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Shower",
              "Word": "Banyo",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Bed Room",
              "Word": "Kuarto",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Living Room",
              "Word": "Sala",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Kitchen",
              "Word": "Kosina",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Dining Room",
              "Word": "Komedor",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Attic",
              "Word": "Kisame",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Garden",
              "Word": "Hardin",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Pillow",
              "Word": "Ulon",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Blanket",
              "Word": "Tamong",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Cabinet",
              "Word": "Aparador",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Floor",
              "Word": "Salog",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Trashcan",
              "Word": "Basurahan",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Plate",
              "Word": "Plato",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Spoon",
              "Word": "Kutsara",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Fork",
              "Word": "Tinidor",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Bowl",
              "Word": "Mangko",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Teaspoon",
              "Word": "Kutsarita",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Cup",
              "Word": "Tasa",
            },
          ]
        },
        "Level4": {
          "LevelID": 4,
          "LevelStatus": 0,
          "Words": [
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Elderly",
              "Word": "Gurang",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Godfather",
              "Word": "Ninong",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Godmother",
              "Word": "Ninang",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Godchild",
              "Word": "Tinubong",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Friends",
              "Word": "Barkada",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Friend",
              "Word": "Amigo",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Friend",
              "Word": "Amiga",
            },
            {
              "Deck": 1,
              "POS": "Verb",
              "Translation": "to get Acquainted",
              "Word": "Bistado",
            },
            {
              "Deck": 1,
              "POS": "Verb",
              "Translation": "to Talk",
              "Word": "Taram",
            },
            {
              "Deck": 1,
              "POS": "Verb",
              "Translation": "to Meet",
              "Word": "Sabat",
            },
          ]
        }
      },
      //=======================================================================
      //===============================SCHOOL==================================
      //=======================================================================
      "school": {
        "Study": [
          {"POS": "Noun", "Translation": "Mathematics", "Word": "Matematika"},
          {"POS": "Noun", "Translation": "Science", "Word": "Siensia"},
          {"POS": "Noun", "Translation": "Philosophy", "Word": "Pilosopia"},
          {"POS": "Noun", "Translation": "Medicine", "Word": "Medisina"},
        ],
        "Write": [
          {"POS": "Noun", "Translation": "Book", "Word": "Libro"},
          {"POS": "Noun", "Translation": "Letter", "Word": "Letra"},
          {"POS": "Noun", "Translation": "Name", "Word": "Pangaran"},
          {"POS": "Noun", "Translation": "Number", "Word": "Numero"},
        ],
        "Read": [
          {"POS": "Noun", "Translation": "Book", "Word": "Libro"},
          {"POS": "Noun", "Translation": "Magazine", "Word": "Magasin"},
          {"POS": "Noun", "Translation": "Sign", "Word": "Karatula"},
          {"POS": "Noun", "Translation": "Letter", "Word": "Letra"},
          {"POS": "Noun", "Translation": "Newspaper", "Word": "Diario"},
        ],
        "Adverb": [
          {
            "Category": "Present",
            "POS": "Adverb",
            "Translation": "Often",
            "Word": "Parati"
          },
          {
            "Category": "Continuous",
            "POS": "Adverb",
            "Translation": "Rarely",
            "Word": "Bihira"
          },
          {
            "Category": "Present",
            "POS": "Adverb",
            "Translation": "Quickly",
            "Word": "Dali-dali"
          },
          {
            "Category": "Continuous",
            "POS": "Adverb",
            "Translation": "Slowly",
            "Word": "Luway-luway"
          },
        ],
        "VerbsCont": [
          {
            "Category": "Study",
            "POS": "Verb",
            "Tense": "Continuous",
            "Translation": "Study",
            "Word": "Mag-adal"
          },
          {
            "Category": "Write",
            "POS": "Verb",
            "Tense": "Continuous",
            "Translation": "Write",
            "Word": "Magsurat"
          },
          {
            "Category": "Read",
            "POS": "Verb",
            "Tense": "Continuous",
            "Translation": "Read",
            "Word": "Magbasa"
          },
        ],
        "VerbsPresent": [
          {
            "Category": "Study",
            "POS": "Verb",
            "Tense": "Present",
            "Translation": "Study",
            "Word": "Nag-aadal"
          },
          {
            "Category": "Write",
            "POS": "Verb",
            "Tense": "Present",
            "Translation": "Write",
            "Word": "Nagsusurat"
          },
          {
            "Category": "Read",
            "POS": "Verb",
            "Tense": "Present",
            "Translation": "Read",
            "Word": "Nagbabasa"
          },
        ],
        "Subjects": [
          {
            "POS": "Noun",
            "Translation": "Mathematics",
            "Word": "Matematika",
            "Number": "Singular"
          },
          {
            "POS": "Noun",
            "Translation": "Science",
            "Word": "Siensia",
            "Number": "Singular"
          },
          {
            "POS": "Noun",
            "Translation": "Philosophy",
            "Word": "Pilosopia",
            "Number": "Singular"
          },
          {
            "POS": "Noun",
            "Translation": "Examinations",
            "Word": "Mga eksaminasion",
            "Number": "Plural"
          },
        ],
        "Adjectives": [
          {
            "Category": "Subjects",
            "POS": "Adjective",
            "Translation": "Interesting",
            "Word": "Interesante"
          },
          {
            "Category": "Subjects",
            "POS": "Adjective",
            "Translation": "Difficult",
            "Word": "Dipisil"
          },
          {
            "Category": "Subjects",
            "POS": "Adjective",
            "Translation": "Easy",
            "Word": "Madali"
          },
          {
            "Category": "Person",
            "POS": "Adjective",
            "Translation": "Tired",
            "Word": "Mapagal"
          },
          {
            "Category": "Person",
            "POS": "Adjective",
            "Translation": "Quiet",
            "Word": "Matuninong"
          },
          {
            "Category": "Person",
            "POS": "Adjective",
            "Translation": "Angry",
            "Word": "Maanggot"
          },
          {
            "Category": "Person",
            "POS": "Adjective",
            "Translation": "Comfortable",
            "Word": "Maginhawa"
          },
          {
            "Category": "Person",
            "POS": "Adjective",
            "Translation": "Excited",
            "Word": "Magana"
          },
          {
            "Category": "Person",
            "POS": "Adjective",
            "Translation": "Friendly",
            "Word": "Maamigo"
          },
          {
            "Category": "Person",
            "POS": "Adjective",
            "Translation": "Helpful",
            "Word": "Matinabang"
          },
          {
            "Category": "Person",
            "POS": "Adjective",
            "Translation": "Serious",
            "Word": "Serioso"
          },
          {
            "Category": "Person",
            "POS": "Adjective",
            "Translation": "Diligent",
            "Word": "Matali"
          },
        ],
        "Verbs": [
          // {
          //   "Category": "Study",
          //   "POS": "Verb",
          //   "Tense": "Continuous",
          //   "Translation": "Study",
          //   "Word": "Mag-adal"
          // },
          {
            "Category": "Study",
            "POS": "Verb",
            "Tense": "Present",
            "Translation": "Studying",
            "Word": "Nag-aadal"
          },
          {
            "Category": "Study",
            "POS": "Verb",
            "Tense": "Future",
            "Translation": "will Study",
            "Word": "Mag-aadal"
          },
          {
            "Category": "Study",
            "POS": "Verb",
            "Tense": "Past",
            "Translation": "Studied",
            "Word": "Nag-adal"
          },
          // {
          //   "Category": "Write",
          //   "POS": "Verb",
          //   "Tense": "Continuous",
          //   "Translation": "Write",
          //   "Word": "Magsurat"
          // },
          {
            "Category": "Write",
            "POS": "Verb",
            "Tense": "Present",
            "Translation": "Writing",
            "Word": "Nagsusurat"
          },
          {
            "Category": "Write",
            "POS": "Verb",
            "Tense": "Future",
            "Translation": "will Write",
            "Word": "Magsusurat"
          },
          {
            "Category": "Write",
            "POS": "Verb",
            "Tense": "Past",
            "Translation": "Wrote",
            "Word": "Nagsurat"
          },
          // {
          //   "Category": "Read",
          //   "POS": "Verb",
          //   "Tense": "Continuous",
          //   "Translation": "Read",
          //   "Word": "Magbasa"
          // },
          {
            "Category": "Read",
            "POS": "Verb",
            "Tense": "Present",
            "Translation": "Reading",
            "Word": "Nagbabasa"
          },
          {
            "Category": "Read",
            "POS": "Verb",
            "Tense": "Future",
            "Translation": "will Read",
            "Word": "Magbabasa"
          },
          {
            "Category": "Read",
            "POS": "Verb",
            "Tense": "Past",
            "Translation": "Read",
            "Word": "Nagbasa"
          },
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
          {
            "Number": "Plural",
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
        "Level1": {
          "LevelID": 1,
          "LevelStatus": 0,
          "Words": [
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Chair",
              "Word": "Tukawan",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Table",
              "Word": "Lamesa",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Book",
              "Word": "Libro",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Letter",
              "Word": "Letra",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Newspaper",
              "Word": "Diario",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Student",
              "Word": "Estudiante",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Teacher",
              "Word": "Maestro",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Subject",
              "Word": "Tema",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "School",
              "Word": "Eskuela",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Schedule",
              "Word": "Programa",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Notebook",
              "Word": "Kwaderno",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Pencil",
              "Word": "Lapis",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Pen",
              "Word": "Pluma",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Guitar",
              "Word": "Gitara",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Instrument",
              "Word": "Instrumento",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Introduction",
              "Word": "Midmid",
            },
            {
              "Deck": 1,
              "POS": "Verb",
              "Translation": "to Introduce",
              "Word": "Midmid",
            },
            {
              "Deck": 1,
              "POS": "Verb",
              "Translation": "to Sit",
              "Word": "Tukaw",
            },
            {
              "Deck": 1,
              "POS": "Verb",
              "Translation": "to Stand",
              "Word": "Tindag",
            },
          ]
        },
        "Level2": {
          "LevelID": 2,
          "LevelStatus": 0,
          "Words": [
            {
              "Deck": 1,
              "POS": "Verb",
              "Translation": "to Study",
              "Word": "Adal",
            },
            {
              "Deck": 1,
              "POS": "Verb",
              "Translation": "to Say",
              "Word": "Sabihun",
            },
            {
              "Deck": 1,
              "POS": "Verb",
              "Translation": "to Go to School",
              "Word": "Eskuela",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Acknowledgement",
              "Word": "Simbag",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Advice",
              "Word": "Hatol",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Announcement",
              "Word": "Anunsiyo",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Department",
              "Word": "Departamento",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Semester",
              "Word": "Semestre",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Enrollment",
              "Word": "Entra",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Examination",
              "Word": "Eksaminasion",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Government",
              "Word": "Gobierno",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Grade",
              "Word": "Marka",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Group",
              "Word": "Grupo",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Hobby",
              "Word": "Apision",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Instruction",
              "Word": "Instrukesiones",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Interview",
              "Word": "Interbiyu",
            },
            // {
            //   "Deck": 1,
            //   "POS": "Noun",
            //   "Translation": "",
            //   "Word": "",
            // },
          ]
        },
        "Level3": {
          "LevelID": 3,
          "LevelStatus": 0,
          "Words": [
            {
              "Deck": 1,
              "POS": "Verb",
              "Translation": "to Write",
              "Word": "Surat",
            },
            {
              "Deck": 1,
              "POS": "Verb",
              "Translation": "to Read",
              "Word": "Basa",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Lawyer",
              "Word": "Abogado",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Judge",
              "Word": "Huwes",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Doctor",
              "Word": "Doktor",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Actor",
              "Word": "Aktor",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Engineer",
              "Word": "Inheniero",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Artist",
              "Word": "Artista",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Chemist",
              "Word": "Kimiko",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Architect",
              "Word": "Arkitekto",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Baker",
              "Word": "Panadero",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Cook",
              "Word": "Kosinero",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Author",
              "Word": "Autor",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Dentist",
              "Word": "Dentista",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Farmer",
              "Word": "Uma",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Fisherman",
              "Word": "Sira",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Electrician",
              "Word": "Elektrisista",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Secretary",
              "Word": "Sekretario",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Priest",
              "Word": "Padi",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Nun",
              "Word": "Madre",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Shepherd",
              "Word": "Pastor",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Fireman",
              "Word": "Bombero",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Guitarist",
              "Word": "Gitarista",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Pianist",
              "Word": "Pianista",
            }
          ]
        },
        "Level4": {
          "LevelID": 4,
          "LevelStatus": 0,
          "Words": [
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Architecture",
              "Word": "Arkitektura",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Chemistry",
              "Word": "Kimika",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Mathematics",
              "Word": "Matematika",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Science",
              "Word": "Siensia",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "English",
              "Word": "Ingles",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Grammar",
              "Word": "Gramatika",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Philosophy",
              "Word": "Pilosopia",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Sports",
              "Word": "Kawat",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Engineering",
              "Word": "Inhenieria",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Medicine",
              "Word": "Medisina",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Employee",
              "Word": "Empleado",
            },
            {
              "Deck": 1,
              "POS": "Verb",
              "Translation": "Employer",
              "Word": "Bos",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Manager",
              "Word": "Maneho",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Company",
              "Word": "Kompania",
            },
          ]
        },
        "Level5": {
          "LevelID": 5,
          "LevelStatus": 0,
          "Words": [
            {
              "Deck": 1,
              "POS": "Verb",
              "Translation": "to Leave",
              "Word": "Hali",
            },
            {
              "Deck": 1,
              "POS": "Verb",
              "Translation": "to Work",
              "Word": "Trabaho",
            },
            {
              "Deck": 1,
              "POS": "Adjective",
              "Translation": "Artistic",
              "Word": "Arte",
            },
            {
              "Deck": 1,
              "POS": "Adjective",
              "Translation": "Interesting",
              "Word": "Interesante",
            },
            {
              "Deck": 1,
              "POS": "Adjective",
              "Translation": "Difficult",
              "Word": "Dipisil",
            },
            {
              "Deck": 1,
              "POS": "Adjective",
              "Translation": "Easy",
              "Word": "Madali",
            },
            {
              "Deck": 1,
              "POS": "Adjective",
              "Translation": "Tired",
              "Word": "Mapagal",
            },
            {
              "Deck": 1,
              "POS": "Adjective",
              "Translation": "Quiet",
              "Word": "Matuninong",
            },
            {
              "Deck": 1,
              "POS": "Adjective",
              "Translation": "Angry",
              "Word": "Maanggot",
            },
            {
              "Deck": 1,
              "POS": "Adjective",
              "Translation": "Comfortable",
              "Word": "Maginhawa",
            },
            {
              "Deck": 1,
              "POS": "Adjective",
              "Translation": "Happy",
              "Word": "Maugma",
            },
            {
              "Deck": 1,
              "POS": "Adjective",
              "Translation": "Excited",
              "Word": "Magana",
            },
            {
              "Deck": 1,
              "POS": "Adjective",
              "Translation": "Friendly",
              "Word": "Maamigo",
            },
            {
              "Deck": 1,
              "POS": "Adjective",
              "Translation": "Helpful",
              "Word": "Matinabang",
            },
            {
              "Deck": 1,
              "POS": "Adjective",
              "Translation": "Serious",
              "Word": "Serioso",
            },
            {
              "Deck": 1,
              "POS": "Adjective",
              "Translation": "Diligent",
              "Word": "Matali",
            },
          ]
        },
      },
      //=======================================================================
      //===============================SHOPPING================================
      //=======================================================================
      "shopping": {
        "Have": [
          {"POS": "Noun", "Translation": "Pair of shoes", "Word": "Sapatos"},
          {"POS": "Noun", "Translation": "Sickness", "Word": "Mati"},
          {"POS": "Noun", "Translation": "Watch", "Word": "Relo"},
          {"POS": "Noun", "Translation": "Money", "Word": "Kuarta"},
        ],
        "Want": [
          {"POS": "Noun", "Translation": "Mango", "Word": "Mangga"},
          {"POS": "Noun", "Translation": "Coffee", "Word": "Kape"},
          {"POS": "Noun", "Translation": "To go out", "Word": "Magluwas"},
          {"POS": "Noun", "Translation": "To eat", "Word": "Magkaon"},
        ],
        "Get": [
          {"POS": "Noun", "Translation": "Passport", "Word": "Pasaporte"},
          {"POS": "Noun", "Translation": "Fruit", "Word": "Prutas"},
          {"POS": "Noun", "Translation": "Guide", "Word": "Giya"},
          {"POS": "Noun", "Translation": "Bread", "Word": "Tinapay"},
          {"POS": "Noun", "Translation": "Telephone", "Word": "Telepono"},
        ],
        "Buy": [
          {"POS": "Noun", "Translation": "Dress", "Word": "Bestida"},
          {"POS": "Noun", "Translation": "Wallet", "Word": "Pitaka"},
          {"POS": "Noun", "Translation": "Pair of shoes", "Word": "Sapatos"},
          {"POS": "Noun", "Translation": "Pen", "Word": "Pluma"},
          {"POS": "Noun", "Translation": "Book", "Word": "Libro"},
        ],
        "Pay": [
          {"POS": "Noun", "Translation": "Cashier", "Word": "Kahero"},
          {"POS": "Noun", "Translation": "Cashier's window", "Word": "Takilya"},
          {"POS": "Noun", "Translation": "Driver", "Word": "Tsuper"},
        ],
        "Clothes": [
          {
            "POS": "Noun",
            "Translation": "Clothes",
            "Word": "Bado",
            "Number": "Plural"
          },
          {
            "POS": "Noun",
            "Translation": "Pants",
            "Word": "Pantalon",
            "Number": "Singular",
          },
          {
            "POS": "Noun",
            "Translation": "Dress",
            "Word": "Bestida",
            "Number": "Singular",
          },
        ],
        "Adjectives": [
          {
            "Category": "Clothes",
            "POS": "Adjective",
            "Translation": "Beautiful",
            "Word": "Magayon"
          },
          {
            "Category": "Clothes",
            "POS": "Adjective",
            "Translation": "Big",
            "Word": "Dakula"
          },
          {
            "Category": "Clothes",
            "POS": "Adjective",
            "Translation": "Small",
            "Word": "Sadit"
          },
          {
            "Category": "Clothes",
            "POS": "Adjective",
            "Translation": "Short",
            "Word": "Lipot"
          },
          {
            "Category": "Clothes",
            "POS": "Adjective",
            "Translation": "Long",
            "Word": "Laba"
          },
          {
            "Category": "Clothes",
            "POS": "Adjective",
            "Translation": "Cheap",
            "Word": "Barato"
          },
          {
            "Category": "Clothes",
            "POS": "Adjective",
            "Translation": "Expensive",
            "Word": "Mahal"
          },
        ],
        "Verbs": [
          // {
          //   "Category": "Have",
          //   "POS": "Verb",
          //   "Tense": "Continuous",
          //   "Translation": "Have",
          //   "Word": "Igwa",
          //   "Number": "Plural"
          // },
          // {
          //   "Category": "Have",
          //   "POS": "Verb",
          //   "Tense": "Continuous",
          //   "Translation": "Has",
          //   "Word": "Igwa",
          //   "Number": "Singular"
          // },
          {
            "Category": "Want",
            "POS": "Verb",
            "Tense": "Continuous",
            "Translation": "Want",
            "Word": "Gusto"
          },
          // {
          //   "Category": "Get",
          //   "POS": "Verb",
          //   "Tense": "Continuous",
          //   "Translation": "Get",
          //   "Word": "Magkua"
          // },
          {
            "Category": "Get",
            "POS": "Verb",
            "Tense": "Present",
            "Translation": "Getting",
            "Word": "Nagkukua"
          },
          {
            "Category": "Get",
            "POS": "Verb",
            "Tense": "Future",
            "Translation": "will Get",
            "Word": "Magkukua"
          },
          {
            "Category": "Get",
            "POS": "Verb",
            "Tense": "Past",
            "Translation": "Took",
            "Word": "Nakua"
          },
          // {
          //   "Category": "Buy",
          //   "POS": "Verb",
          //   "Tense": "Continuous",
          //   "Translation": "Buy",
          //   "Word": "Mabakal"
          // },
          {
            "Category": "Buy",
            "POS": "Verb",
            "Tense": "Present",
            "Translation": "Buying",
            "Word": "Nagbabakal"
          },
          {
            "Category": "Buy",
            "POS": "Verb",
            "Tense": "Future",
            "Translation": "will Buy",
            "Word": "Magbabakal"
          },
          {
            "Category": "Buy",
            "POS": "Verb",
            "Tense": "Past",
            "Translation": "bought",
            "Word": "Nagbakal"
          },
          // {
          //   "Category": "Pay",
          //   "POS": "Verb",
          //   "Tense": "Continuous",
          //   "Translation": "Pay",
          //   "Word": "Magbayad"
          // },
          {
            "Category": "Pay",
            "POS": "Verb",
            "Tense": "Present",
            "Translation": "Paying",
            "Word": "Nagbayayad"
          },
          {
            "Category": "Pay",
            "POS": "Verb",
            "Tense": "Future",
            "Translation": "will Pay",
            "Word": "Magbabayad"
          },
          {
            "Category": "Pay",
            "POS": "Verb",
            "Tense": "Past",
            "Translation": "Paid",
            "Word": "Nagbayad"
          },
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
          {
            "Number": "Plural",
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
        "IndirectPronouns": [
          {
            "Number": "Plural",
            "POS": "Pronoun",
            "POV": "Second",
            "Translation": "You",
            "Word": "Mo"
          },
          {
            "Number": "Plural",
            "POS": "Pronoun",
            "POV": "Second",
            "Translation": "You",
            "Word": "Nindo"
          },
          {
            "Number": "Plural",
            "POS": "Pronoun",
            "POV": "First",
            "Translation": "I",
            "Word": "Ko"
          },
          {
            "Gender": "Female",
            "Number": "Singular",
            "POS": "Pronoun",
            "POV": "Third",
            "Translation": "She",
            "Word": "Niya"
          },
          {
            "Gender": "Male",
            "Number": "Singular",
            "POS": "Pronoun",
            "POV": "Third",
            "Translation": "He",
            "Word": "Niya"
          }
        ],
        "Level1": {
          "LevelID": 1,
          "LevelStatus": 1,
          "Words": [
            {
              "Deck": 1,
              "POS": "Common Phrase",
              "Translation": "How much?",
              "Word": "Mamira?",
            },
            {
              "Deck": 1,
              "POS": "Common Phrase",
              "Translation": "Let's eat!",
              "Word": "Magkaon kita!",
            },
            {
              "Deck": 1,
              "POS": "Common Phrase",
              "Translation": "One more",
              "Word": "Saro pa tabi",
            },
            {
              "Deck": 1,
              "POS": "Common Phrase",
              "Translation": "How many?",
              "Word": "Pira?",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Many",
              "Word": "Dakolon",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Few",
              "Word": "Diiton",
            },
            {
              "Deck": 1,
              "POS": "Pronoun",
              "Translation": "This",
              "Word": "Ini",
            },
            {
              "Deck": 1,
              "POS": "Prnoun",
              "Translation": "Those",
              "Word": "Ini",
            },
            {
              "Deck": 1,
              "POS": "Verb",
              "Translation": "to Buy",
              "Word": "Mabakal",
            },
            {
              "Deck": 1,
              "POS": "Verb",
              "Translation": "to Pay",
              "Word": "Bayad",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Free",
              "Word": "Libre",
            },
          ]
        },
        "Level2": {
          "LevelID": 2,
          "LevelStatus": 0,
          "Words": [
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Check",
              "Word": "Tseke",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Clothes",
              "Word": "Bado",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Shoes",
              "Word": "Sapatos",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Dress",
              "Word": "Bestida",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Wallet",
              "Word": "Pitaka",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Shorts",
              "Word": "Media-Pantalon",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Pants",
              "Word": "Pantalon",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Hat",
              "Word": "Kopya",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Socks",
              "Word": "Medias",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Belt",
              "Word": "Paha",
            },
            {
              "Deck": 1,
              "POS": "Noun",
              "Translation": "Boots",
              "Word": "Botas",
            },
            {
              "Deck": 1,
              "POS": "Verb",
              "Translation": "to Get",
              "Word": "Ku'a",
            },
            {
              "Deck": 1,
              "POS": "Verb",
              "Translation": "to Want",
              "Word": "Gusto",
            },
          ]
        },
        "Level3": {
          "LevelID": 3,
          "LevelStatus": 0,
          "Words": [
            {
              "Deck": 1,
              "POS": "Verb",
              "Translation": "to Have",
              "Word": "Igwa",
            },
            {
              "Deck": 1,
              "POS": "Verb",
              "Translation": "to Give",
              "Word": "Ta'o",
            },
            {
              "Deck": 1,
              "POS": "Adjective",
              "Translation": "Beautiful",
              "Word": "Magayon",
            },
            {
              "Deck": 1,
              "POS": "Adjective",
              "Translation": "Big",
              "Word": "Dakula",
            },
            {
              "Deck": 1,
              "POS": "Adjective",
              "Translation": "Small",
              "Word": "Sadit",
            },
            {
              "Deck": 1,
              "POS": "Adjective",
              "Translation": "Short",
              "Word": "Li'pot",
            },
            {
              "Deck": 1,
              "POS": "Adjective",
              "Translation": "Long",
              "Word": "Laba",
            },
            {
              "Deck": 1,
              "POS": "Adjective",
              "Translation": "Cheap",
              "Word": "Barato",
            },
            {
              "Deck": 1,
              "POS": "Adjective",
              "Translation": "Expensive",
              "Word": "Mahal",
            },
            // {
            //   "Deck": 1,
            //   "POS": "Noun",
            //   "Translation": "",
            //   "Word": "",
            // },
          ]
        }
      },
      //=======================================================================
      //===============================BASICS2=================================
      //=======================================================================
      "basics2": {
        "Markers": [
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
          {
            "Number": "Plural",
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
        "IndirectPronouns": [
          {
            "Number": "Plural",
            "POS": "Pronoun",
            "POV": "Second",
            "Translation": "You",
            "Word": "Mo"
          },
          {
            "Number": "Plural",
            "POS": "Pronoun",
            "POV": "Second",
            "Translation": "You",
            "Word": "Nindo"
          },
          {
            "Number": "Plural",
            "POS": "Pronoun",
            "POV": "First",
            "Translation": "I",
            "Word": "Ko"
          },
          {
            "Gender": "Female",
            "Number": "Singular",
            "POS": "Pronoun",
            "POV": "Third",
            "Translation": "She",
            "Word": "Niya"
          },
          {
            "Gender": "Male",
            "Number": "Singular",
            "POS": "Pronoun",
            "POV": "Third",
            "Translation": "He",
            "Word": "Niya"
          }
        ],
        "Drink": [
          {"POS": "Noun", "Translation": "Coffee", "Word": "Kape"},
          {"POS": "Noun", "Translation": "Water", "Word": "Tubig"},
          {"POS": "Noun", "Translation": "Milk", "Word": "Gatas"}
        ],
        "Have": [
          {"POS": "Noun", "Translation": "Pair of shoes", "Word": "Sapatos"},
          {"POS": "Noun", "Translation": "Sickness", "Word": "Mati"},
          {"POS": "Noun", "Translation": "Watch", "Word": "Relo"},
          {"POS": "Noun", "Translation": "Money", "Word": "Kuarta"},
        ],
        "Want": [
          {"POS": "Noun", "Translation": "Mango", "Word": "Mangga"},
          {"POS": "Noun", "Translation": "Coffee", "Word": "Kape"},
          {"POS": "Noun", "Translation": "To go out", "Word": "Magluwas"},
          {"POS": "Noun", "Translation": "To eat", "Word": "Magkaon"},
        ],
        "Get": [
          {"POS": "Noun", "Translation": "Passport", "Word": "Pasaporte"},
          {"POS": "Noun", "Translation": "Fruit", "Word": "Prutas"},
          {"POS": "Noun", "Translation": "Guide", "Word": "Giya"},
          {"POS": "Noun", "Translation": "Bread", "Word": "Tinapay"},
          {"POS": "Noun", "Translation": "Telephone", "Word": "Telepono"},
        ],
        "Buy": [
          {"POS": "Noun", "Translation": "Dress", "Word": "Bestida"},
          {"POS": "Noun", "Translation": "Wallet", "Word": "Pitaka"},
          {"POS": "Noun", "Translation": "Pair of shoes", "Word": "Sapatos"},
          {"POS": "Noun", "Translation": "Pen", "Word": "Pluma"},
          {"POS": "Noun", "Translation": "Book", "Word": "Libro"},
        ],
        "Pay": [
          {"POS": "Noun", "Translation": "Cashier", "Word": "Kahero"},
          {"POS": "Noun", "Translation": "Cashier's window", "Word": "Takilya"},
          {"POS": "Noun", "Translation": "Driver", "Word": "Tsuper"},
        ],
        "Clothes": [
          {
            "POS": "Noun",
            "Translation": "Clothes",
            "Word": "Bado",
            "Number": "Plural"
          },
          {
            "POS": "Noun",
            "Translation": "Pants",
            "Word": "Pantalon",
            "Number": "Singular",
          },
          {
            "POS": "Noun",
            "Translation": "Dress",
            "Word": "Bestida",
            "Number": "Singular",
          },
        ],
        "See": [
          {"POS": "Noun", "Translation": "Concert", "Word": "Konsierto"},
          {"POS": "Noun", "Translation": "Parade", "Word": "Parada"},
          {"POS": "Noun", "Translation": "Beach", "Word": "Baybay"},
          {"POS": "Noun", "Translation": "Waterfall", "Word": "Busay"},
        ],
        "Ask": [
          {"POS": "Name", "Translation": "Clara", "Word": "Clara"},
          {"POS": "Pronoun", "Translation": "Her", "Word": "Saiya"},
          {"POS": "Name", "Translation": "Juan", "Word": "Juan"},
          {"POS": "Pronoun", "Translation": "Him", "Word": "Saiya"},
        ],
        "Look": [
          {"POS": "Noun", "Translation": "Passport", "Word": "Pasaporte"},
          {"POS": "Noun", "Translation": "Bathroom", "Word": "Banyo"},
          {"POS": "Noun", "Translation": "Guide", "Word": "Giya"},
          {"POS": "Noun", "Translation": "Bank", "Word": "Banko"},
          {"POS": "Noun", "Translation": "Telephone", "Word": "Telepono"},
        ],
        "Bring": [
          {"POS": "Noun", "Translation": "Passport", "Word": "Pasaporte"},
          {"POS": "Noun", "Translation": "Certificate", "Word": "Sertipiko"},
          {"POS": "Noun", "Translation": "Food", "Word": "Pagkaon"},
          {"POS": "Noun", "Translation": "Pen", "Word": "Pluma"},
          {"POS": "Noun", "Translation": "Book", "Word": "Libro"},
        ],
        "Call": [
          {"POS": "Noun", "Translation": "Friend", "Word": "Amigo"},
          {"POS": "Noun", "Translation": "Friend", "Word": "Amiga"},
          {"POS": "Noun", "Translation": "Restaurant", "Word": "Restauran"},
          {"POS": "Noun", "Translation": "Hospital", "Word": "Ospital"},
          {"POS": "Noun", "Translation": "Bank", "Word": "Banko"},
        ],
        "Place": [
          {"POS": "Noun", "Translation": "Beach", "Word": "Baybay"},
          {"POS": "Noun", "Translation": "Island", "Word": "Isla"},
          {"POS": "Noun", "Translation": "Park", "Word": "Parke"},
        ],
        "Food": [
          {"POS": "Noun", "Translation": "Meat", "Word": "Karne"},
          {"POS": "Noun", "Translation": "Bread", "Word": "Tinapay"},
          {"POS": "Noun", "Translation": "Rice", "Word": "Luto"},
          {"POS": "Noun", "Translation": "Soup", "Word": "Sabaw"},
        ],
        "House": [
          {"POS": "Noun", "Translation": "Living Room", "Word": "Sala"},
          {"POS": "Noun", "Translation": "Room", "Word": "Kuarto"},
          {"POS": "Noun", "Translation": "Dining Room", "Word": "Komedor"},
          {"POS": "Noun", "Translation": "Window", "Word": "Bintana"},
        ],
        "Talk": [
          {"POS": "Noun", "Translation": "Mother", "Word": "Ina"},
          {"POS": "Noun", "Translation": "Father", "Word": "Ama"},
          {"POS": "Noun", "Translation": "Siblings", "Word": "Mga tugang"},
          {"POS": "Noun", "Translation": "Grandmother", "Word": "Lola"},
        ],
        "Subjects": [
          {
            "POS": "Noun",
            "Translation": "Mathematics",
            "Word": "Matematika",
            "Number": "Singular"
          },
          {
            "POS": "Noun",
            "Translation": "Science",
            "Word": "Siensia",
            "Number": "Singular"
          },
          {
            "POS": "Noun",
            "Translation": "Philosophy",
            "Word": "Pilosopia",
            "Number": "Singular"
          },
          {
            "POS": "Noun",
            "Translation": "Examinations",
            "Word": "Mga eksaminasion",
            "Number": "Plural"
          },
        ],
        "Adverb": [
          {
            "Category": "Present",
            "POS": "Adverb",
            "Translation": "Often",
            "Word": "Parati"
          },
          {
            "Category": "Continuous",
            "POS": "Adverb",
            "Translation": "Rarely",
            "Word": "Bihira"
          },
          {
            "Category": "Present",
            "POS": "Adverb",
            "Translation": "Quickly",
            "Word": "Dali-dali"
          },
          {
            "Category": "Continuous",
            "POS": "Adverb",
            "Translation": "Slowly",
            "Word": "Luway-luway"
          },
          {
            "Category": "Present",
            "POS": "Adverb",
            "Translation": "Often",
            "Word": "Parati"
          },
          {
            "Category": "Continuous",
            "POS": "Adverb",
            "Translation": "Rarely",
            "Word": "Bihira"
          },
          {
            "Category": "Present",
            "POS": "Adverb",
            "Translation": "Quickly",
            "Word": "Dali-dali"
          },
          {
            "Category": "Continuous",
            "POS": "Adverb",
            "Translation": "Slowly",
            "Word": "Luway-luway"
          },
        ],
        "VerbsCont": [
          {
            "Category": "Food",
            "POS": "Verb",
            "Tense": "Continuous",
            "Translation": "Cook",
            "Word": "Magluto"
          },
          {
            "Category": "House",
            "POS": "Verb",
            "Tense": "Continuous",
            "Translation": "Clean",
            "Word": "Maglinig"
          },
          {
            "Category": "Talk",
            "POS": "Verb",
            "Tense": "Continuous",
            "Translation": "Talk",
            "Word": "Maghuron"
          },
          {
            "Category": "Study",
            "POS": "Verb",
            "Tense": "Continuous",
            "Translation": "Study",
            "Word": "Mag-adal"
          },
          {
            "Category": "Write",
            "POS": "Verb",
            "Tense": "Continuous",
            "Translation": "Write",
            "Word": "Magsurat"
          },
          {
            "Category": "Read",
            "POS": "Verb",
            "Tense": "Continuous",
            "Translation": "Read",
            "Word": "Magbasa"
          },
        ],
        "VerbsPresent": [
          {
            "Category": "Food",
            "POS": "Verb",
            "Tense": "Present",
            "Translation": "Cook",
            "Word": "Nagluluto"
          },
          {
            "Category": "House",
            "POS": "Verb",
            "Tense": "Present",
            "Translation": "Clean",
            "Word": "Naglilinig"
          },
          {
            "Category": "Talk",
            "POS": "Verb",
            "Tense": "Present",
            "Translation": "Talk",
            "Word": "Nagtataram"
          },
          {
            "Category": "Study",
            "POS": "Verb",
            "Tense": "Present",
            "Translation": "Study",
            "Word": "Nag-aadal"
          },
          {
            "Category": "Write",
            "POS": "Verb",
            "Tense": "Present",
            "Translation": "Write",
            "Word": "Nagsusurat"
          },
          {
            "Category": "Read",
            "POS": "Verb",
            "Tense": "Present",
            "Translation": "Read",
            "Word": "Nagbabasa"
          },
        ],
        "Room": [
          {
            "POS": "Noun",
            "Translation": "Bed Room",
            "Word": "Kuarto",
            "Number": "Singular"
          },
          {
            "POS": "Noun",
            "Translation": "Living Room",
            "Word": "Sala",
            "Number": "Singular"
          },
          {
            "POS": "Noun",
            "Translation": "Kitchen",
            "Word": "Kusina",
            "Number": "Singular"
          },
          {
            "POS": "Noun",
            "Translation": "Garden",
            "Word": "Hardin",
            "Number": "Singular"
          },
        ],
        "Things": [
          {
            "POS": "Noun",
            "Translation": "Cabinet",
            "Word": "Aparador",
            "Number": "Singular"
          },
          {
            "POS": "Noun",
            "Translation": "Plate",
            "Word": "Plato",
            "Number": "Singular"
          },
          {
            "POS": "Noun",
            "Translation": "Kitchen",
            "Word": "Kusina",
            "Number": "Singular"
          },
          {
            "POS": "Noun",
            "Translation": "Garden",
            "Word": "Hardin",
            "Number": "Singular"
          },
        ],
        "Study": [
          {"POS": "Noun", "Translation": "Mathematics", "Word": "Matematika"},
          {"POS": "Noun", "Translation": "Science", "Word": "Siensia"},
          {"POS": "Noun", "Translation": "Philosophy", "Word": "Pilosopia"},
          {"POS": "Noun", "Translation": "Medicine", "Word": "Medisina"},
        ],
        "Write": [
          {"POS": "Noun", "Translation": "Book", "Word": "Libro"},
          {"POS": "Noun", "Translation": "Letter", "Word": "Letra"},
          {"POS": "Noun", "Translation": "Name", "Word": "Pangaran"},
          {"POS": "Noun", "Translation": "Number", "Word": "Numero"},
        ],
        "Read": [
          {"POS": "Noun", "Translation": "Book", "Word": "Libro"},
          {"POS": "Noun", "Translation": "Magazine", "Word": "Magasin"},
          {"POS": "Noun", "Translation": "Sign", "Word": "Karatula"},
          {"POS": "Noun", "Translation": "Letter", "Word": "Letra"},
          {"POS": "Noun", "Translation": "Newspaper", "Word": "Diario"},
        ],
        "Adjectives": [
          {
            "Category": "Place",
            "POS": "Adjective",
            "Translation": "Sunny",
            "Word": "Maaraw"
          },
          {
            "Category": "Place",
            "POS": "Adjective",
            "Translation": "Cloudy",
            "Word": "Rumarom"
          },
          {
            "Category": "Place",
            "POS": "Adjective",
            "Translation": "Rainy",
            "Word": "Mauran"
          },
          {
            "Category": "Place",
            "POS": "Adjective",
            "Translation": "Windy",
            "Word": "Maduros"
          },
          {
            "Category": "Place",
            "POS": "Adjective",
            "Translation": "Hot",
            "Word": "Mainit"
          },
          {
            "Category": "Place",
            "POS": "Adjective",
            "Translation": "Cold",
            "Word": "Malipot"
          },
          {
            "Category": "Place",
            "POS": "Adjective",
            "Translation": "Popular",
            "Word": "Popular"
          },
          {
            "Category": "Person",
            "POS": "Adjective",
            "Translation": "Hungry",
            "Word": "Gutom"
          },
          {
            "Category": "Person",
            "POS": "Adjective",
            "Translation": "Thirsty",
            "Word": "Paha"
          },
          {
            "Category": "Room",
            "POS": "Adjective",
            "Translation": "Big",
            "Word": "Dakula"
          },
          {
            "Category": "Room",
            "POS": "Adjective",
            "Translation": "Small",
            "Word": "Sadit"
          },
          {
            "Category": "Room",
            "POS": "Adjective",
            "Translation": "Wide",
            "Word": "Hiwas"
          },
          {
            "Category": "Room",
            "POS": "Adjective",
            "Translation": "Narrow",
            "Word": "Mapiot"
          },
          {
            "Category": "Room",
            "POS": "Adjective",
            "Translation": "Clean",
            "Word": "Malinig"
          },
          {
            "Category": "Room",
            "POS": "Adjective",
            "Translation": "Dirty",
            "Word": "Maati"
          },
          {
            "Category": "Person",
            "POS": "Adjective",
            "Translation": "Short",
            "Word": "Lipot"
          },
          {
            "Category": "Person",
            "POS": "Adjective",
            "Translation": "Tall",
            "Word": "Langkaw"
          },
          {
            "Category": "Person",
            "POS": "Adjective",
            "Translation": "Early",
            "Word": "Amay"
          },
          {
            "Category": "Person",
            "POS": "Adjective",
            "Translation": "Late",
            "Word": "Huri"
          },
          {
            "Category": "Person",
            "POS": "Adjective",
            "Translation": "Young",
            "Word": "Hoben"
          },
          {
            "Category": "Person",
            "POS": "Adjective",
            "Translation": "Old",
            "Word": "Gurang"
          },
          {
            "Category": "Things",
            "POS": "Adjective",
            "Translation": "New",
            "Word": "Bago"
          },
          {
            "Category": "Things",
            "POS": "Adjective",
            "Translation": "Old",
            "Word": "Luma"
          },
          {
            "Category": "Things",
            "POS": "Adjective",
            "Translation": "Important",
            "Word": "Importante"
          },
          {
            "Category": "Subjects",
            "POS": "Adjective",
            "Translation": "Interesting",
            "Word": "Interesante"
          },
          {
            "Category": "Subjects",
            "POS": "Adjective",
            "Translation": "Difficult",
            "Word": "Dipisil"
          },
          {
            "Category": "Subjects",
            "POS": "Adjective",
            "Translation": "Easy",
            "Word": "Madali"
          },
          {
            "Category": "Person",
            "POS": "Adjective",
            "Translation": "Tired",
            "Word": "Mapagal"
          },
          {
            "Category": "Person",
            "POS": "Adjective",
            "Translation": "Quiet",
            "Word": "Matuninong"
          },
          {
            "Category": "Person",
            "POS": "Adjective",
            "Translation": "Angry",
            "Word": "Maanggot"
          },
          {
            "Category": "Person",
            "POS": "Adjective",
            "Translation": "Comfortable",
            "Word": "Maginhawa"
          },
          {
            "Category": "Person",
            "POS": "Adjective",
            "Translation": "Excited",
            "Word": "Magana"
          },
          {
            "Category": "Person",
            "POS": "Adjective",
            "Translation": "Friendly",
            "Word": "Maamigo"
          },
          {
            "Category": "Person",
            "POS": "Adjective",
            "Translation": "Helpful",
            "Word": "Matinabang"
          },
          {
            "Category": "Person",
            "POS": "Adjective",
            "Translation": "Serious",
            "Word": "Serioso"
          },
          {
            "Category": "Person",
            "POS": "Adjective",
            "Translation": "Diligent",
            "Word": "Matali"
          },
          {
            "Category": "Clothes",
            "POS": "Adjective",
            "Translation": "Beautiful",
            "Word": "Magayon"
          },
          {
            "Category": "Clothes",
            "POS": "Adjective",
            "Translation": "Big",
            "Word": "Dakula"
          },
          {
            "Category": "Clothes",
            "POS": "Adjective",
            "Translation": "Small",
            "Word": "Sadit"
          },
          {
            "Category": "Clothes",
            "POS": "Adjective",
            "Translation": "Short",
            "Word": "Lipot"
          },
          {
            "Category": "Clothes",
            "POS": "Adjective",
            "Translation": "Long",
            "Word": "Laba"
          },
          {
            "Category": "Clothes",
            "POS": "Adjective",
            "Translation": "Cheap",
            "Word": "Barato"
          },
          {
            "Category": "Clothes",
            "POS": "Adjective",
            "Translation": "Expensive",
            "Word": "Mahal"
          },
        ],
        "Verbs": [
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
          },
          {
            "Category": "See",
            "POS": "Verb",
            "Tense": "Present",
            "Translation": "Seeing",
            "Word": "Naghihiling"
          },
          {
            "Category": "See",
            "POS": "Verb",
            "Tense": "Future",
            "Translation": "will See",
            "Word": "Maghihiling"
          },
          {
            "Category": "See",
            "POS": "Verb",
            "Tense": "Past",
            "Translation": "Saw",
            "Word": "Naghiling"
          },
          {
            "Category": "Ask",
            "POS": "Verb",
            "Tense": "Present",
            "Translation": "Asking",
            "Word": "Naghahapot"
          },
          {
            "Category": "Ask",
            "POS": "Verb",
            "Tense": "Future",
            "Translation": "will Ask",
            "Word": "Maghahapot"
          },
          {
            "Category": "Ask",
            "POS": "Verb",
            "Tense": "Past",
            "Translation": "Asked",
            "Word": "Naghapot"
          },
          {
            "Category": "Look",
            "POS": "Verb",
            "Tense": "Present",
            "Translation": "Looking",
            "Word": "Naghahanap"
          },
          {
            "Category": "Look",
            "POS": "Verb",
            "Tense": "Future",
            "Translation": "will Look",
            "Word": "Maghahanap"
          },
          {
            "Category": "Look",
            "POS": "Verb",
            "Tense": "Past",
            "Translation": "Looked",
            "Word": "Naghanap"
          },
          {
            "Category": "Bring",
            "POS": "Verb",
            "Tense": "Present",
            "Translation": "Bringing",
            "Word": "Nagdadara"
          },
          {
            "Category": "Bring",
            "POS": "Verb",
            "Tense": "Future",
            "Translation": "will Bring",
            "Word": "Magdadara"
          },
          {
            "Category": "Bring",
            "POS": "Verb",
            "Tense": "Past",
            "Translation": "Brought",
            "Word": "Nagdara"
          },
          {
            "Category": "Call",
            "POS": "Verb",
            "Tense": "Present",
            "Translation": "Calling",
            "Word": "Nag-aapod"
          },
          {
            "Category": "Call",
            "POS": "Verb",
            "Tense": "Future",
            "Translation": "will Call",
            "Word": "Maapod"
          },
          {
            "Category": "Call",
            "POS": "Verb",
            "Tense": "Past",
            "Translation": "Called",
            "Word": "Nag-apod"
          },
          {
            "Category": "Food",
            "POS": "Verb",
            "Tense": "Present",
            "Translation": "Cooking",
            "Word": "Nagluluto"
          },
          {
            "Category": "Food",
            "POS": "Verb",
            "Tense": "Future",
            "Translation": "will Cook",
            "Word": "Magluluto"
          },
          {
            "Category": "Food",
            "POS": "Verb",
            "Tense": "Past",
            "Translation": "Cooked",
            "Word": "Nagluto"
          },
          {
            "Category": "House",
            "POS": "Verb",
            "Tense": "Present",
            "Translation": "Cleaning",
            "Word": "Naglilinig"
          },
          {
            "Category": "House",
            "POS": "Verb",
            "Tense": "Future",
            "Translation": "will Clean",
            "Word": "Maglilinig"
          },
          {
            "Category": "House",
            "POS": "Verb",
            "Tense": "Past",
            "Translation": "Cleaned",
            "Word": "Naglinig"
          },
          {
            "Category": "Talk",
            "POS": "Verb",
            "Tense": "Present",
            "Translation": "Talking",
            "Word": "Naghuhuron"
          },
          {
            "Category": "Talk",
            "POS": "Verb",
            "Tense": "Future",
            "Translation": "will Talk",
            "Word": "Maghuhuron"
          },
          {
            "Category": "Talk",
            "POS": "Verb",
            "Tense": "Past",
            "Translation": "Talked",
            "Word": "Naghuron"
          },
          {
            "Category": "Study",
            "POS": "Verb",
            "Tense": "Present",
            "Translation": "Studying",
            "Word": "Nag-aadal"
          },
          {
            "Category": "Study",
            "POS": "Verb",
            "Tense": "Future",
            "Translation": "will Study",
            "Word": "Mag-aadal"
          },
          {
            "Category": "Study",
            "POS": "Verb",
            "Tense": "Past",
            "Translation": "Studied",
            "Word": "Nag-adal"
          },
          {
            "Category": "Write",
            "POS": "Verb",
            "Tense": "Present",
            "Translation": "Writing",
            "Word": "Nagsusurat"
          },
          {
            "Category": "Write",
            "POS": "Verb",
            "Tense": "Future",
            "Translation": "will Write",
            "Word": "Magsusurat"
          },
          {
            "Category": "Write",
            "POS": "Verb",
            "Tense": "Past",
            "Translation": "Wrote",
            "Word": "Nagsurat"
          },
          {
            "Category": "Read",
            "POS": "Verb",
            "Tense": "Present",
            "Translation": "Reading",
            "Word": "Nagbabasa"
          },
          {
            "Category": "Read",
            "POS": "Verb",
            "Tense": "Future",
            "Translation": "will Read",
            "Word": "Magbabasa"
          },
          {
            "Category": "Read",
            "POS": "Verb",
            "Tense": "Past",
            "Translation": "Read",
            "Word": "Nagbasa"
          },
          {
            "Category": "Want",
            "POS": "Verb",
            "Tense": "Continuous",
            "Translation": "Want",
            "Word": "Gusto"
          },
          {
            "Category": "Get",
            "POS": "Verb",
            "Tense": "Present",
            "Translation": "Getting",
            "Word": "Nagkukua"
          },
          {
            "Category": "Get",
            "POS": "Verb",
            "Tense": "Future",
            "Translation": "will Get",
            "Word": "Magkukua"
          },
          {
            "Category": "Get",
            "POS": "Verb",
            "Tense": "Past",
            "Translation": "Took",
            "Word": "Nakua"
          },
          {
            "Category": "Buy",
            "POS": "Verb",
            "Tense": "Present",
            "Translation": "Buying",
            "Word": "Nagbabakal"
          },
          {
            "Category": "Buy",
            "POS": "Verb",
            "Tense": "Future",
            "Translation": "will Buy",
            "Word": "Magbabakal"
          },
          {
            "Category": "Buy",
            "POS": "Verb",
            "Tense": "Past",
            "Translation": "bought",
            "Word": "Nagbakal"
          },
          {
            "Category": "Pay",
            "POS": "Verb",
            "Tense": "Present",
            "Translation": "Paying",
            "Word": "Nagbayayad"
          },
          {
            "Category": "Pay",
            "POS": "Verb",
            "Tense": "Future",
            "Translation": "will Pay",
            "Word": "Magbabayad"
          },
          {
            "Category": "Pay",
            "POS": "Verb",
            "Tense": "Past",
            "Translation": "Paid",
            "Word": "Nagbayad"
          },
        ],
        "Level1": {
          "LevelID": 1,
          "LevelStatus": 0,
          "Words": [
            {
              "Word": "Ano",
              "Translation": "What",
              "POS": "Pronoun",
              "Deck": 1,
            },
            {
              "Word": "Sisay",
              "Translation": "Who",
              "POS": "Pronoun",
              "Deck": 1,
            },
            {
              "Word": "Sirisay",
              "Translation": "Who (plural)",
              "POS": "Pronoun",
              "Deck": 1,
            },
            {
              "Word": "Nata",
              "Translation": "Why",
              "POS": "Pronoun",
              "Deck": 1,
            },
            {
              "Word": "Hain",
              "Translation": "Where",
              "POS": "Pronoun",
              "Deck": 1,
            },
            {
              "Word": "Nu-arin",
              "Translation": "When",
              "POS": "Pronoun",
              "Deck": 1,
            },
            {
              "Word": "Paon",
              "Translation": "How",
              "POS": "Pronoun",
              "Deck": 1,
            },
            {
              "Word": "Arin",
              "Translation": "Which",
              "POS": "Pronoun",
              "Deck": 1,
            },
            {
              "Word": "Yaon",
              "Translation": "Over there",
              "POS": "Pronoun",
              "Deck": 1,
            },
            {
              "Word": "Nin",
              "Translation": "Some",
              "POS": "Pronoun",
              "Deck": 1,
            },
            {
              "Word": "Ini",
              "Translation": "This",
              "POS": "Pronoun",
              "Deck": 1,
            },
            {
              "Word": "Itu",
              "Translation": "That",
              "POS": "Pronoun",
              "Deck": 1,
            },
            {
              "Word": "Digdi",
              "Translation": "Here",
              "POS": "Adverb",
              "Deck": 1,
            },
            {
              "Word": "Ngunyan",
              "Translation": "Now",
              "POS": "Adverb",
              "Deck": 1,
            },
          ]
        },
        "Level2": {
          "LevelID": 2,
          "LevelStatus": 0,
          "Words": [
            {
              "Word": "Maaga",
              "Translation": "Dawn",
              "POS": "Noun",
              "Deck": 1,
            },
            {
              "Word": "Mabanggi",
              "Translation": "Dawn",
              "POS": "Noun",
              "Deck": 1,
            },
            {
              "Word": "Atyan",
              "Translation": "Later",
              "POS": "Noun",
              "Deck": 1,
            },
            {
              "Word": "Kasubago",
              "Translation": "Lately",
              "POS": "Noun",
              "Deck": 1,
            },
            {
              "Word": "Aro-aldaw",
              "Translation": "Every day",
              "POS": "Noun",
              "Deck": 1,
            },
            {
              "Word": "Boro-banggi",
              "Translation": "Every night",
              "POS": "Noun",
              "Deck": 1,
            },
            {
              "Word": "Payo",
              "Translation": "Head",
              "POS": "Noun",
              "Deck": 1,
            },
            {
              "Word": "Lalawgon",
              "Translation": "Face",
              "POS": "Noun",
              "Deck": 1,
            },
            {
              "Word": "Talinga",
              "Translation": "Ear",
              "POS": "Noun",
              "Deck": 1,
            },
            {
              "Word": "Mata",
              "Translation": "Eyes",
              "POS": "Noun",
              "Deck": 1,
            },
            {
              "Word": "Nguso",
              "Translation": "Mouth",
              "POS": "Noun",
              "Deck": 1,
            },
            {
              "Word": "Dungo",
              "Translation": "Nose",
              "POS": "Noun",
              "Deck": 1,
            },
            {
              "Word": "Hawak",
              "Translation": "Body",
              "POS": "Noun",
              "Deck": 1,
            },
            {
              "Word": "Braso",
              "Translation": "Arm",
              "POS": "Noun",
              "Deck": 1,
            },
            {
              "Word": "Tabay",
              "Translation": "Leg",
              "POS": "Noun",
              "Deck": 1,
            },
            {
              "Word": "Kamot",
              "Translation": "Hand",
              "POS": "Noun",
              "Deck": 1,
            },
            {
              "Word": "Muro",
              "Translation": "Finger",
              "POS": "Noun",
              "Deck": 1,
            },
            {
              "Word": "Tanggugurang",
              "Translation": "Thumb",
              "POS": "Noun",
              "Deck": 1,
            },
            {
              "Word": "Muro",
              "Translation": "Toe",
              "POS": "Noun",
              "Deck": 1,
            },
            {
              "Word": "Tuhod",
              "Translation": "Knees",
              "POS": "Noun",
              "Deck": 1,
            },
            {
              "Word": "Li'og",
              "Translation": "Neck",
              "POS": "Noun",
              "Deck": 1,
            },
            {
              "Word": "Buhok",
              "Translation": "Hair",
              "POS": "Noun",
              "Deck": 1,
            },
            {
              "Word": "Puso",
              "Translation": "Heart",
              "POS": "Noun",
              "Deck": 1,
            },
          ]
        },
        "Level3": {
          "LevelID": 3,
          "LevelStatus": 0,
          "Words": [
            {
              "Word": "Guapo",
              "Translation": "Handsome",
              "POS": "Adjective",
              "Deck": 1,
            },
            {
              "Word": "Hababa",
              "Translation": "Low",
              "POS": "Adjective",
              "Deck": 1,
            },
            {
              "Word": "Hararom",
              "Translation": "Deep",
              "POS": "Adjective",
              "Deck": 1,
            },
            {
              "Word": "Hababaw",
              "Translation": "Shallow",
              "POS": "Adjective",
              "Deck": 1,
            },
            {
              "Word": "Harayo",
              "Translation": "Far",
              "POS": "Adjective",
              "Deck": 1,
            },
            {
              "Word": "Harani",
              "Translation": "Near",
              "POS": "Adjective",
              "Deck": 1,
            },
            {
              "Word": "Hayakpit",
              "Translation": "Narrow",
              "POS": "Adjective",
              "Deck": 1,
            },
            {
              "Word": "Halakbang",
              "Translation": "Wide",
              "POS": "Adjective",
              "Deck": 1,
            },
            {
              "Word": "Gayon",
              "Translation": "Attractive",
              "POS": "Adjective",
              "Deck": 1,
            },
          ]
        },
        "Level4": {
          "LevelID": 4,
          "LevelStatus": 0,
          "Words": [
            {
              "Word": "Ikos",
              "Translation": "Cat",
              "POS": "Noun",
              "Deck": 1,
            },
            {
              "Word": "Ayam",
              "Translation": "Dog",
              "POS": "Noun",
              "Deck": 1,
            },
            {
              "Word": "Elepante",
              "Translation": "Elephant",
              "POS": "Noun",
              "Deck": 1,
            },
            {
              "Word": "Kabayo",
              "Translation": "Horse",
              "POS": "Noun",
              "Deck": 1,
            },
            {
              "Word": "Gamgam",
              "Translation": "Bird",
              "POS": "Noun",
              "Deck": 1,
            },
            {
              "Word": "Pato",
              "Translation": "Duck",
              "POS": "Noun",
              "Deck": 1,
            },
            {
              "Word": "Lawa",
              "Translation": "Spider",
              "POS": "Noun",
              "Deck": 1,
            },
            {
              "Word": "Kulagbaw",
              "Translation": "Butterfly",
              "POS": "Noun",
              "Deck": 1,
            },
            {
              "Word": "Oso",
              "Translation": "Bear",
              "POS": "Noun",
              "Deck": 1,
            },
            {
              "Word": "Mariposa",
              "Translation": "Moth",
              "POS": "Noun",
              "Deck": 1,
            },
            {
              "Word": "Kino",
              "Translation": "Mouse",
              "POS": "Noun",
              "Deck": 1,
            },
            {
              "Word": "Koneyo",
              "Translation": "Rabbit",
              "POS": "Noun",
              "Deck": 1,
            },
            {
              "Word": "Kabalang",
              "Translation": "Monkey",
              "POS": "Noun",
              "Deck": 1,
            },
            {
              "Word": "Leon",
              "Translation": "Lion",
              "POS": "Noun",
              "Deck": 1,
            },
            {
              "Word": "Bukid",
              "Translation": "Mountain",
              "POS": "Noun",
              "Deck": 1,
            },
            {
              "Word": "Bulod",
              "Translation": "Hill",
              "POS": "Noun",
              "Deck": 1,
            },
            {
              "Word": "Kahoy",
              "Translation": "Tree",
              "POS": "Noun",
              "Deck": 1,
            },
            {
              "Word": "Masetas",
              "Translation": "Plant",
              "POS": "Noun",
              "Deck": 1,
            },
            {
              "Word": "Burak",
              "Translation": "Flower",
              "POS": "Noun",
              "Deck": 1,
            },
          ]
        },
        "Level5": {
          "LevelID": 5,
          "LevelStatus": 0,
          "Words": [
            {
              "Word": "Lamesa",
              "Translation": "Table",
              "POS": "Noun",
              "Deck": 1,
            },
            {
              "Word": "Daga",
              "Translation": "Knife",
              "POS": "Noun",
              "Deck": 1,
            },
            {
              "Word": "Plato",
              "Translation": "Plate",
              "POS": "Noun",
              "Deck": 1,
            },
            {
              "Word": "Baso",
              "Translation": "Glass",
              "POS": "Noun",
              "Deck": 1,
            },
            {
              "Word": "Tasa",
              "Translation": "Cup",
              "POS": "Noun",
              "Deck": 1,
            },
          ]
        }
      }
    };
  }
}
