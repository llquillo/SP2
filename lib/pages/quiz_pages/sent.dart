import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../common_widgets/page_title.dart';
import '../common_widgets/quiz_template.dart';

import 'package:google_fonts/google_fonts.dart';
import '../sub_pages/level_content.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';

class Sent extends StatefulWidget {
  final int i;
  final BuildContext currentContext;
  final int score;
  final databaseTemp;
  final List<Map> wordList;
  final String level;
  final String category;
  Sent(
      {@required this.i,
      @required this.currentContext,
      this.levelContent,
      this.score,
      this.wordList,
      this.databaseTemp,
      this.level,
      this.category});
  final LevelContent levelContent;
  @override
  _SentState createState() => _SentState();
}

class _SentState extends State<Sent> with SingleTickerProviderStateMixin {
  TextEditingController answerController = new TextEditingController();
  LevelContent levelContent;
  String correctAnswer;
  String userAnswer;
  List<String> buttons = [];
  List<String> selectedWords = List<String>();
  List<Map> sentenceList = List<Map>();

  List<Map> verbList = List<Map>();
  List<Map> adjectiveList = List<Map>();
  List<Map> nounList = List<Map>();
  List<Map> pronList = List<Map>();
  List<Map> indirectPronList = List<Map>();
  List<Map> nameList = List<Map>();
  List<Map> foodList = List<Map>();
  List<Map> drinkList = List<Map>();
  List<Map> houseList = List<Map>();
  List<Map> talkList = List<Map>();
  List<Map> studyList = List<Map>();
  List<Map> readList = List<Map>();
  List<Map> writeList = List<Map>();
  List<Map> seeList = List<Map>();
  List<Map> askList = List<Map>();
  List<Map> lookList = List<Map>();
  List<Map> bringList = List<Map>();
  List<Map> callList = List<Map>();
  List<Map> haveList = List<Map>();
  List<Map> wantList = List<Map>();
  List<Map> getList = List<Map>();
  List<Map> buyList = List<Map>();
  List<Map> payList = List<Map>();
  List<Map> clothesList = List<Map>();
  List<Map> placeList = List<Map>();
  List<Map> roomList = List<Map>();
  List<Map> thingsList = List<Map>();
  List<Map> subjectsList = List<Map>();
  List<Map> adverbsList = List<Map>();
  List<Map> verbsPresList = List<Map>();
  List<Map> verbsContList = List<Map>();

  String finalSentence = "";
  final databaseReference = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();
    levelContent = new LevelContent(
      databaseTemp: widget.databaseTemp,
      wordList: widget.wordList,
      category: widget.category,
    );
    _initDatabase();
  }

  _initDatabase() {
    var db = widget.databaseTemp;
    switch (widget.category) {
      case 'basics1':
        foodList = fetchWords(db, widget.category, 'Food');
        drinkList = fetchWords(db, widget.category, 'Drink');
        break;
      case 'family':
        foodList = fetchWords(db, widget.category, 'Food');
        houseList = fetchWords(db, widget.category, 'House');
        talkList = fetchWords(db, widget.category, 'Talk');
        adjectiveList = fetchWords(db, widget.category, 'Adjectives');
        roomList = fetchWords(db, widget.category, 'Room');
        thingsList = fetchWords(db, widget.category, 'Things');
        adverbsList = fetchWords(db, widget.category, 'Adverb');
        verbsPresList = fetchWords(db, widget.category, 'VerbsPresent');
        verbsContList = fetchWords(db, widget.category, 'VerbsCont');
        break;
      case 'school':
        studyList = fetchWords(db, widget.category, 'Study');
        writeList = fetchWords(db, widget.category, 'Write');
        readList = fetchWords(db, widget.category, 'Read');
        adjectiveList = fetchWords(db, widget.category, 'Adjectives');
        subjectsList = fetchWords(db, widget.category, 'Subjects');
        adverbsList = fetchWords(db, widget.category, 'Adverb');
        verbsPresList = fetchWords(db, widget.category, 'VerbsPresent');
        verbsContList = fetchWords(db, widget.category, 'VerbsCont');
        break;
      case 'travel':
        seeList = fetchWords(db, widget.category, 'See');
        askList = fetchWords(db, widget.category, 'Ask');
        lookList = fetchWords(db, widget.category, 'Look');
        bringList = fetchWords(db, widget.category, 'Bring');
        callList = fetchWords(db, widget.category, 'Call');
        adjectiveList = fetchWords(db, widget.category, 'Adjectives');
        placeList = fetchWords(db, widget.category, 'Place');
        break;
      case 'shopping':
        haveList = fetchWords(db, widget.category, 'Have');
        wantList = fetchWords(db, widget.category, 'Want');
        getList = fetchWords(db, widget.category, 'Get');
        buyList = fetchWords(db, widget.category, 'Buy');
        payList = fetchWords(db, widget.category, 'Pay');
        adjectiveList = fetchWords(db, widget.category, 'Adjectives');
        clothesList = fetchWords(db, widget.category, 'Clothes');
        indirectPronList = fetchWords(db, widget.category, 'IndirectPronouns');
        break;
      case 'basics2':
        foodList = fetchWords(db, widget.category, 'Food');
        drinkList = fetchWords(db, widget.category, 'Drink');
        foodList = fetchWords(db, widget.category, 'Food');
        houseList = fetchWords(db, widget.category, 'House');
        talkList = fetchWords(db, widget.category, 'Talk');
        adjectiveList = fetchWords(db, widget.category, 'Adjectives');
        roomList = fetchWords(db, widget.category, 'Room');
        thingsList = fetchWords(db, widget.category, 'Things');
        adverbsList = fetchWords(db, widget.category, 'Adverb');
        verbsPresList = fetchWords(db, widget.category, 'VerbsPresent');
        verbsContList = fetchWords(db, widget.category, 'VerbsCont');
        studyList = fetchWords(db, widget.category, 'Study');
        writeList = fetchWords(db, widget.category, 'Write');
        readList = fetchWords(db, widget.category, 'Read');
        adjectiveList = fetchWords(db, widget.category, 'Adjectives');
        subjectsList = fetchWords(db, widget.category, 'Subjects');
        adverbsList = fetchWords(db, widget.category, 'Adverb');
        verbsPresList = fetchWords(db, widget.category, 'VerbsPresent');
        verbsContList = fetchWords(db, widget.category, 'VerbsCont');
        seeList = fetchWords(db, widget.category, 'See');
        askList = fetchWords(db, widget.category, 'Ask');
        lookList = fetchWords(db, widget.category, 'Look');
        bringList = fetchWords(db, widget.category, 'Bring');
        callList = fetchWords(db, widget.category, 'Call');
        adjectiveList = fetchWords(db, widget.category, 'Adjectives');
        placeList = fetchWords(db, widget.category, 'Place');
        haveList = fetchWords(db, widget.category, 'Have');
        wantList = fetchWords(db, widget.category, 'Want');
        getList = fetchWords(db, widget.category, 'Get');
        buyList = fetchWords(db, widget.category, 'Buy');
        payList = fetchWords(db, widget.category, 'Pay');
        adjectiveList = fetchWords(db, widget.category, 'Adjectives');
        clothesList = fetchWords(db, widget.category, 'Clothes');
        indirectPronList = fetchWords(db, widget.category, 'IndirectPronouns');
        break;
    }
    verbList = fetchWords(db, widget.category, 'Verbs');
    pronList = fetchWords(db, widget.category, 'Pronouns');
    nameList = fetchWords(db, widget.category, 'Names');

    verbList.shuffle();
    adjectiveList.shuffle();
    // pronList.shuffle();
    // nameList.shuffle();
    foodList.shuffle();
    drinkList.shuffle();
    houseList.shuffle();
    talkList.shuffle();
    studyList.shuffle();
    writeList.shuffle();
    readList.shuffle();
    seeList.shuffle();
    askList.shuffle();
    lookList.shuffle();
    bringList.shuffle();
    callList.shuffle();
    haveList.shuffle();
    wantList.shuffle();
    getList.shuffle();
    buyList.shuffle();
    payList.shuffle();
    clothesList.shuffle();
    placeList.shuffle();
    roomList.shuffle();
    thingsList.shuffle();
    subjectsList.shuffle();
    adverbsList.shuffle();
    verbsPresList.shuffle();
    verbsContList.shuffle();
    indirectPronList.shuffle();
    formSentence();
  }

  List<Map> fetchWords(snapshot, String catName, String posName) {
    var temp = snapshot[posName];
    List<Map> tempList = new List<Map>();
    List<Map> finalList = new List<Map>();
    var word = new List<Map>();
    word = List<Map>.from(temp);
    for (var i = 0; i < word.length; i++) {
      if (word[i] != null) {
        print(word[i]);
        tempList.add(word[i]);
      }
      finalList = List<Map>.from(tempList);
    }
    return finalList;
  }

  Map getVerb() {
    var rand = new Random();
    int r = 1 + rand.nextInt(verbList.length - 1);
    return verbList[r];
  }

  Map getAdjective() {
    var rand = new Random();
    int r = 1 + rand.nextInt(adjectiveList.length - 1);
    return adjectiveList[r];
  }

  Map getPron() {
    var rand = new Random();
    int r = 1 + rand.nextInt(pronList.length - 1);
    return pronList[r];
  }

  Map getIndirectPron() {
    var rand = new Random();
    int r = 1 + rand.nextInt(indirectPronList.length - 1);
    return indirectPronList[r];
  }

  Map getPropName() {
    var rand = new Random();
    int r = 1 + rand.nextInt(nameList.length - 1);
    return nameList[r];
  }

  Map getFood() {
    var rand = new Random();
    int r = 1 + rand.nextInt(foodList.length - 1);
    return foodList[r];
  }

  Map getDrink() {
    var rand = new Random();
    int r = 1 + rand.nextInt(drinkList.length - 1);
    return drinkList[r];
  }

  Map getHouse() {
    var rand = new Random();
    int r = 1 + rand.nextInt(houseList.length - 1);
    return houseList[r];
  }

  Map getTalk() {
    var rand = new Random();
    int r = 1 + rand.nextInt(talkList.length - 1);
    return talkList[r];
  }

  Map getStudy() {
    var rand = new Random();
    int r = 1 + rand.nextInt(studyList.length - 1);
    return studyList[r];
  }

  Map getWrite() {
    var rand = new Random();
    int r = 1 + rand.nextInt(writeList.length - 1);
    return writeList[r];
  }

  Map getRead() {
    var rand = new Random();
    int r = 1 + rand.nextInt(readList.length - 1);
    return readList[r];
  }

  Map getSee() {
    var rand = new Random();
    int r = 1 + rand.nextInt(seeList.length - 1);
    return seeList[r];
  }

  Map getAsk() {
    var rand = new Random();
    int r = 1 + rand.nextInt(askList.length - 1);
    return askList[r];
  }

  Map getLook() {
    var rand = new Random();
    int r = 1 + rand.nextInt(lookList.length - 1);
    return lookList[r];
  }

  Map getBring() {
    var rand = new Random();
    int r = 1 + rand.nextInt(bringList.length - 1);
    return bringList[r];
  }

  Map getCall() {
    var rand = new Random();
    int r = 1 + rand.nextInt(callList.length - 1);
    return callList[r];
  }

  Map getHave() {
    var rand = new Random();
    int r = 1 + rand.nextInt(haveList.length - 1);
    return haveList[r];
  }

  Map getWant() {
    var rand = new Random();
    int r = 1 + rand.nextInt(wantList.length - 1);
    return wantList[r];
  }

  Map getGet() {
    var rand = new Random();
    int r = 1 + rand.nextInt(getList.length - 1);
    return getList[r];
  }

  Map getBuy() {
    var rand = new Random();
    int r = 1 + rand.nextInt(buyList.length - 1);
    return buyList[r];
  }

  Map getPay() {
    var rand = new Random();
    int r = 1 + rand.nextInt(payList.length - 1);
    return payList[r];
  }

  Map getClothes() {
    var rand = new Random();
    int r = 1 + rand.nextInt(clothesList.length - 1);
    return clothesList[r];
  }

  Map getPlace() {
    var rand = new Random();
    int r = 1 + rand.nextInt(placeList.length - 1);
    return placeList[r];
  }

  Map getRoom() {
    var rand = new Random();
    int r = 1 + rand.nextInt(roomList.length - 1);
    return roomList[r];
  }

  Map getThings() {
    var rand = new Random();
    int r = 1 + rand.nextInt(thingsList.length - 1);
    return thingsList[r];
  }

  Map getSubjects() {
    var rand = new Random();
    int r = 1 + rand.nextInt(subjectsList.length - 1);
    return subjectsList[r];
  }

  Map getAdverb() {
    var rand = new Random();
    int r = 1 + rand.nextInt(adverbsList.length - 1);
    return adverbsList[r];
  }

  Map getVerbsPres() {
    var rand = new Random();
    int r = 1 + rand.nextInt(verbsPresList.length - 1);
    return verbsPresList[r];
  }

  Map getVerbsCont() {
    var rand = new Random();
    int r = 1 + rand.nextInt(verbsContList.length - 1);
    return verbsContList[r];
  }

  var seeFlag = false,
      bringFlag = false,
      lookFlag = false,
      callFlag = false,
      writeFlag = false,
      readFlag = false,
      cleanFlag = false,
      payFlag = false,
      buyFlag = false,
      getFlag = false,
      haveFlag = false,
      wantFlag = false,
      talkFlag = false,
      askFlag = false;
  var askHolder;
  var adverbFlag = false, adjectiveFlag = false, introFlag = false;
  var wrongRandFlag = false;

  String formSentence() {
    var rand;
    int r;

    rand = new Random();
    r = 1 + rand.nextInt(3 - 1);
    if (r == 3 && widget.category == "basics1") {
      r = 1;
    }
    if (r == 4 && widget.category == "shopping") {
      r = 1;
    }
    if (r == 4 && widget.category == "travel") {
      r = 1;
    }
    if (r == 2 && widget.category == "travel") {
      r = 3;
    }
    if (r == 2 && widget.category == "school") {
      r = 3;
    }
    if (r == 2 && widget.category == "family") {
      r = 4;
    }
    // r = 1;
    List<Map> translatedWords = new List<Map>();
    String sentence;
    String tense;
    String verbType;
    String verb;
    switch (r) {
      case 1:
        var r = new Random();
        int choice = 1 + r.nextInt(4 - 1);
        var holder = getVerb();
        sentence = holder['Word'];
        verb = holder['Word'];
        tense = holder['Tense'];
        verbType = holder['Category'];
        translatedWords.add(holder);
        choice = 2;
        switch (choice) {
          case 1:
            var holder;
            if (verb == "Want") {
              holder = getIndirectPron();
            } else {
              holder = getPron();
              if (verb == "Have") {
                if (holder['Number'] != 'Plural') {
                  holder = pronList[1];
                }
              }
              if (verb == "Has") {
                if (holder['Number'] == 'Plural') {
                  holder = pronList[0];
                }
              }
            }
            sentence += " " + holder['Word'].toLowerCase();
            translatedWords.add(holder);
            print(sentence);
            break;
          case 2:
            if (verb == "Gusto") {
              holder = getIndirectPron();
            } else {
              holder = getPron();
              if (verb == "Have") {
                if (holder['Number'] != 'Plural') {
                  holder = pronList[1];
                }
              }
              if (verb == "Has") {
                if (holder['Number'] == 'Plural') {
                  holder = pronList[0];
                }
              }
            }
            sentence += " " + holder['Word'].toLowerCase();
            translatedWords.add(holder);
            switch (verbType) {
              case 'Food':
                var holder = getFood();
                sentence += " " + "kan" + " " + holder['Word'].toLowerCase();
                translatedWords.add(holder);
                break;
              case 'Drink':
                var holder = getDrink();
                sentence += " " + "kan" + " " + holder['Word'].toLowerCase();
                translatedWords.add(holder);
                break;
              case 'House':
                var holder = getHouse();
                cleanFlag = true;
                sentence += " " + "kan" + " " + holder['Word'].toLowerCase();
                translatedWords.add(holder);
                break;
              case 'Talk':
                var holder = getTalk();
                talkFlag = true;
                sentence += " " + "kan" + " " + holder['Word'].toLowerCase();
                translatedWords.add(holder);
                break;
              case 'Study':
                var holder = getStudy();
                sentence += " " + "kan" + " " + holder['Word'].toLowerCase();
                translatedWords.add(holder);
                break;
              case 'Write':
                var holder = getWrite();
                writeFlag = true;
                sentence += " " + "kan" + " " + holder['Word'].toLowerCase();
                translatedWords.add(holder);
                break;
              case 'Read':
                var holder = getRead();
                readFlag = true;
                sentence += " " + "kan" + " " + holder['Word'].toLowerCase();
                translatedWords.add(holder);
                break;
              case 'See':
                var holder = getSee();
                seeFlag = true;
                sentence += " " + "kan" + " " + holder['Word'].toLowerCase();
                translatedWords.add(holder);
                break;
              case 'Ask':
                var holder = getAsk();
                askFlag = true;
                holder['POS'] == 'Pronoun'
                    ? sentence += " " + holder['Word'].toLowerCase()
                    : sentence +=
                        " " + "kay" + " " + holder['Word'].toLowerCase();
                askHolder = holder['POS'];
                holder['POS'] = 'Noun';
                translatedWords.add(holder);
                break;
              case 'Look':
                var holder = getLook();
                lookFlag = true;
                sentence += " " + "kan" + " " + holder['Word'].toLowerCase();
                translatedWords.add(holder);
                break;
              case 'Bring':
                var holder = getBring();
                bringFlag = true;
                sentence += " " + "kan" + " " + holder['Word'].toLowerCase();
                translatedWords.add(holder);
                break;
              case 'Call':
                var holder = getCall();
                callFlag = true;
                sentence += " " + "sa" + " " + holder['Word'].toLowerCase();
                translatedWords.add(holder);
                break;
              case 'Have':
                var holder = getHave();
                haveFlag = true;
                sentence += " " + "kan" + " " + holder['Word'].toLowerCase();
                translatedWords.add(holder);
                break;
              case 'Want':
                var holder = getWant();
                wantFlag = true;
                if (holder['POS'] == 'Verb') {
                  sentence += " " + holder['Word'].toLowerCase();
                } else {
                  sentence += " kan" + " " + holder['Word'].toLowerCase();
                }
                translatedWords.add(holder);
                break;
              case 'Get':
                var holder = getGet();
                getFlag = true;
                sentence += " " + "kan" + " " + holder['Word'].toLowerCase();
                translatedWords.add(holder);
                break;
              case 'Buy':
                var holder = getBuy();
                buyFlag = true;
                sentence += " " + "kan" + " " + holder['Word'].toLowerCase();
                translatedWords.add(holder);
                break;
              case 'Pay':
                var holder = getPay();
                payFlag = true;
                sentence += " " + "sa" + " " + holder['Word'].toLowerCase();
                translatedWords.add(holder);
                break;
            }
            print(sentence);
            break;
          case 3:
            var holder = getPropName();
            if (verb == "Gusto") {
              sentence += " " + "ni" + " " + holder['Name'];
            } else {
              sentence += " " + "si" + " " + holder['Name'];
            }
            translatedWords.add(holder);
            print(sentence);
            break;
          case 4:
            var holder = getPropName();
            if (verb == "Gusto") {
              sentence += " " + "ni" + " " + holder['Name'];
            } else {
              sentence += " " + "si" + " " + holder['Name'];
            }
            translatedWords.add(holder);
            switch (verbType) {
              case 'Food':
                var holder = getFood();
                sentence += "kan" + " " + holder['Word'].toLowerCase();
                translatedWords.add(holder);
                break;
              case 'Drink':
                var holder = getDrink();
                sentence += "kan" + " " + holder['Word'].toLowerCase();
                translatedWords.add(holder);
                break;
              case 'House':
                var holder = getHouse();
                cleanFlag = true;
                sentence += "kan" + " " + holder['Word'].toLowerCase();
                translatedWords.add(holder);
                break;
              case 'Talk':
                var holder = getTalk();
                talkFlag = true;
                sentence += "kan" + " " + holder['Word'].toLowerCase();
                translatedWords.add(holder);
                break;
              case 'Study':
                var holder = getStudy();
                sentence += "kan" + " " + holder['Word'].toLowerCase();
                translatedWords.add(holder);
                break;
              case 'Write':
                var holder = getWrite();
                writeFlag = true;
                sentence += "kan" + " " + holder['Word'].toLowerCase();
                translatedWords.add(holder);
                break;
              case 'Read':
                var holder = getRead();
                readFlag = true;
                sentence += "kan" + " " + holder['Word'].toLowerCase();
                translatedWords.add(holder);
                break;
              case 'See':
                var holder = getSee();
                seeFlag = true;
                sentence += "kan" + " " + holder['Word'].toLowerCase();
                translatedWords.add(holder);
                break;
              case 'Ask':
                var holder = getAsk();
                askFlag = true;
                holder['POS'] == 'Pronoun'
                    ? sentence += holder['Word'].toLowerCase()
                    : sentence += "kay" + " " + holder['Word'];
                askHolder = holder['POS'];
                holder['POS'] = 'Noun';
                translatedWords.add(holder);
                break;
              case 'Look':
                var holder = getLook();
                lookFlag = true;
                sentence += "kan" + " " + holder['Word'].toLowerCase();
                translatedWords.add(holder);
                break;
              case 'Bring':
                var holder = getBring();
                bringFlag = true;
                sentence += "kan" + " " + holder['Word'].toLowerCase();
                translatedWords.add(holder);
                break;
              case 'Call':
                var holder = getCall();
                callFlag = true;
                sentence += "sa" + " " + holder['Word'].toLowerCase();
                translatedWords.add(holder);
                break;
              case 'Have':
                var holder = getHave();
                haveFlag = true;
                sentence += "kan" + " " + holder['Word'].toLowerCase();
                translatedWords.add(holder);
                break;
              case 'Want':
                var holder = getWant();
                wantFlag = true;
                if (holder['POS'] == 'Verb') {
                  sentence += " " + holder['Word'].toLowerCase();
                } else {
                  sentence += " kan" + " " + holder['Word'].toLowerCase();
                }
                translatedWords.add(holder);
                break;
              case 'Get':
                var holder = getGet();
                getFlag = true;
                sentence += "kan" + " " + holder['Word'].toLowerCase();
                translatedWords.add(holder);
                break;
              case 'Buy':
                var holder = getBuy();
                buyFlag = true;
                sentence += "kan" + " " + holder['Word'].toLowerCase();
                translatedWords.add(holder);
                break;
              case 'Pay':
                var holder = getPay();
                payFlag = true;
                sentence += "kan" + " " + holder['Word'].toLowerCase();
                translatedWords.add(holder);
                break;
            }
            print(sentence);
            break;
        }
        break;
      case 2:
        introFlag = true;
        var holder, genderPron, genderName;
        do {
          holder = getPron();
        } while (holder['Number'] == "Plural");
        translatedWords.add(holder);
        sentence = holder['Word'] + " si ";
        genderPron = holder['Gender'];
        print(genderPron);
        do {
          holder = getPropName();
          genderName = holder['Gender'];

          if (genderName != genderPron) {
            if (genderPron == "Female") {
              holder = nameList[0];
            } else {
              holder = nameList[2];
            }
            genderName = holder['Gender'];
          }

          print("$genderName == $genderPron");
        } while (genderName != genderPron);
        translatedWords.add(holder);
        sentence += holder['Name'];
        print(sentence);
        break;
      case 3:
        adjectiveFlag = true;
        var holder = getAdjective();
        var category = holder["Category"];
        sentence = holder['Word'];
        translatedWords.add(holder);
        switch (category) {
          case 'Clothes':
            var holder = getClothes();
            sentence += " an" + " " + holder['Word'].toLowerCase();
            translatedWords.add(holder);
            break;
          case 'Place':
            var holder = getPlace();
            sentence += " an" + " " + holder['Word'].toLowerCase();
            translatedWords.add(holder);
            break;
          case 'Room':
            var holder = getRoom();
            sentence += " an" + " " + holder['Word'].toLowerCase();
            translatedWords.add(holder);
            break;
          case 'Things':
            var holder = getThings();
            sentence += " an" + " " + holder['Word'].toLowerCase();
            translatedWords.add(holder);
            break;
          case 'Subjects':
            var holder = getSubjects();
            sentence += " an" + " " + holder['Word'].toLowerCase();
            translatedWords.add(holder);
            break;
          case 'Person':
            var r = new Random();
            int choice = 1 + r.nextInt(2 - 1);
            switch (choice) {
              case 1:
                var holder = getPron();
                sentence += " " + holder['Word'].toLowerCase();
                translatedWords.add(holder);
                break;
              case 2:
                var holder = getSubjects();
                sentence += " si" + " " + holder['Word'].toLowerCase();
                translatedWords.add(holder);
                break;
            }
        }
        print(sentence);
        break;
      case 4:
        adverbFlag = true;
        var holder = getAdverb();
        var category = holder["Category"];
        sentence = holder['Word'];
        translatedWords.add(holder);
        print(widget.category);
        switch (widget.category) {
          case "school":
            var holder = getPron();
            sentence += " " + holder['Word'].toLowerCase() + "ng ";
            translatedWords.add(holder);
            switch (category) {
              case "Present":
                holder = getVerbsPres();
                sentence += holder["Word"].toLowerCase();
                translatedWords.add(holder);
                break;
              case "Continuous":
                holder = getVerbsCont();
                sentence += holder["Word"].toLowerCase();
                translatedWords.add(holder);
                break;
            }
            break;
          case "family":
            var holder = getPron();
            sentence += " " + holder["Word"].toLowerCase() + "ng ";
            translatedWords.add(holder);
            switch (category) {
              case "Present":
                holder = getVerbsPres();
                sentence += holder["Word"].toLowerCase();
                translatedWords.add(holder);
                break;
              case "Continuous":
                holder = getVerbsCont();
                sentence += holder["Word"].toLowerCase();
                translatedWords.add(holder);
                break;
            }
            break;
        }
        break;

      default:
        break;
    }
    print(sentence);

    finalSentence = sentence;
    translateSentence(translatedWords, sentence, tense);
  }

  void translateSentence(List<Map> words, String sentence, String tense) {
    bool sFlag = false;
    int sIndex;
    String translatedSentence = "";

    List<Map> copySent = new List<Map>();

    List<Map> reversedSent = new List<Map>();
    List<Map> unreversedSent = new List<Map>();

    copySent = List.from(words);
    reversedSent = List.from(copySent.reversed);
    var temp, flag = false;
    buttons = [];
    if (tense != null) {
      for (var i = 0; i < reversedSent.length; i++) {
        if (reversedSent[i]['POS'] == 'Noun') {
          temp = reversedSent[i];
          print(temp);
          reversedSent.remove(reversedSent[i]);
          flag = true;
        }
      }
    }
    if (flag && tense != null) {
      print(temp);
      reversedSent.add(temp);
    }
    if (tense != null) {
      switch (tense) {
        case 'Present':
          for (var i = 0; i < reversedSent.length - 1; i++) {
            print("see: $seeFlag");
            print("bring: $bringFlag");
            print("look: $lookFlag");
            if (reversedSent[i + 1]['POS'] == 'Verb') {
              if (reversedSent[i]['Translation'] != null) {
                if (reversedSent[i]['POS'] == 'Noun') {
                  if (bringFlag ||
                      buyFlag ||
                      getFlag ||
                      wantFlag ||
                      haveFlag ||
                      seeFlag ||
                      readFlag ||
                      writeFlag) {
                    translatedSentence +=
                        " a " + reversedSent[i]['Translation'];
                    buttons.add(reversedSent[i]['Translation']);
                    buttons.add("a");
                  }

                  if (cleanFlag || payFlag || callFlag) {
                    translatedSentence +=
                        " the " + reversedSent[i]['Translation'];
                    buttons.add(reversedSent[i]['Translation']);
                    buttons.add("the");
                  }
                  if (talkFlag) {
                    translatedSentence +=
                        " to the " + reversedSent[i]['Translation'];
                    buttons.add(reversedSent[i]['Translation']);
                    buttons.add("the");
                    buttons.add("to");
                  }
                  if (lookFlag) {
                    translatedSentence +=
                        " for a " + reversedSent[i]['Translation'];
                    buttons.add(reversedSent[i]['Translation']);
                    buttons.add("for");
                    buttons.add("a");
                  }
                  if (askFlag) {
                    reversedSent[i]['POS'] = askHolder;
                  }

                  if (!lookFlag &&
                      !callFlag &&
                      !bringFlag &&
                      !seeFlag &&
                      !writeFlag &&
                      !readFlag &&
                      !cleanFlag &&
                      !payFlag &&
                      !buyFlag &&
                      !getFlag &&
                      !wantFlag &&
                      !haveFlag &&
                      !talkFlag) {
                    translatedSentence += " " + reversedSent[i]['Translation'];
                    buttons.add(reversedSent[i]['Translation']);
                  }
                } else {
                  // translatedSentence += reversedSent[i]['Translation'];
                  buttons.add(reversedSent[i]['Translation']);
                }
                if (reversedSent[i]['Translation'] == "You") {
                  translatedSentence +=
                      reversedSent[i]['Translation'] + " are ";
                  buttons.add("are");
                } else {
                  if (reversedSent[i]['Translation'] == "I") {
                    translatedSentence +=
                        reversedSent[i]['Translation'] + " am ";
                    buttons.add("am");
                  } else {
                    translatedSentence +=
                        reversedSent[i]['Translation'] + " is ";
                    buttons.add("is");
                  }
                }
              } else {
                translatedSentence += reversedSent[i]['Name'] + " is ";
                buttons.add(reversedSent[i]['Name']);
                buttons.add("is");
              }
            } else {
              if (reversedSent[i]['Translation'] != null) {
                if (reversedSent[i]['POS'] == 'Noun') {
                  if (bringFlag ||
                      buyFlag ||
                      getFlag ||
                      wantFlag ||
                      haveFlag ||
                      seeFlag ||
                      readFlag ||
                      writeFlag) {
                    translatedSentence +=
                        " a " + reversedSent[i]['Translation'];
                    buttons.add(reversedSent[i]['Translation']);
                    buttons.add("a");
                  }
                  if (cleanFlag || payFlag || callFlag) {
                    translatedSentence +=
                        " the " + reversedSent[i]['Translation'];
                    buttons.add(reversedSent[i]['Translation']);
                    buttons.add("the");
                  }
                  if (talkFlag) {
                    translatedSentence +=
                        " to the " + reversedSent[i]['Translation'];
                    buttons.add(reversedSent[i]['Translation']);
                    buttons.add("the");
                    buttons.add("to");
                  }
                  if (lookFlag) {
                    translatedSentence +=
                        " for a " + reversedSent[i]['Translation'];
                    buttons.add(reversedSent[i]['Translation']);
                    buttons.add("for");
                    buttons.add("a");
                  }
                  if (askFlag) {
                    reversedSent[i]['POS'] = askHolder;
                  }

                  if (!lookFlag &&
                      !callFlag &&
                      !bringFlag &&
                      !seeFlag &&
                      !writeFlag &&
                      !readFlag &&
                      !cleanFlag &&
                      !payFlag &&
                      !buyFlag &&
                      !getFlag &&
                      !wantFlag &&
                      !haveFlag &&
                      !talkFlag) {
                    translatedSentence += " " + reversedSent[i]['Translation'];
                    buttons.add(reversedSent[i]['Translation']);
                  }
                } else {
                  translatedSentence += reversedSent[i]['Translation'];
                  buttons.add(reversedSent[i]['Translation']);
                }
              } else {
                translatedSentence += reversedSent[i]['Name'] + " ";
                buttons.add(reversedSent[i]['Name']);
              }
            }
          }
          if (reversedSent[reversedSent.length - 1]['POS'] == 'Noun') {
            if (bringFlag ||
                buyFlag ||
                getFlag ||
                wantFlag ||
                haveFlag ||
                seeFlag ||
                readFlag ||
                writeFlag) {
              translatedSentence +=
                  " a " + reversedSent[reversedSent.length - 1]['Translation'];
              buttons.add(reversedSent[reversedSent.length - 1]['Translation']);
              buttons.add("a");
            }

            if (cleanFlag || payFlag || callFlag) {
              translatedSentence += " the " +
                  reversedSent[reversedSent.length - 1]['Translation'];
              buttons.add(reversedSent[reversedSent.length - 1]['Translation']);
              buttons.add("the");
            }
            if (talkFlag) {
              translatedSentence += " to the " +
                  reversedSent[reversedSent.length - 1]['Translation'];
              buttons.add(reversedSent[reversedSent.length - 1]['Translation']);
              buttons.add("the");
              buttons.add("to");
            }
            if (lookFlag) {
              translatedSentence += " for a " +
                  reversedSent[reversedSent.length - 1]['Translation'];
              buttons.add(reversedSent[reversedSent.length - 1]['Translation']);
              buttons.add("for");
              buttons.add("a");
            }
            if (askFlag) {
              reversedSent[reversedSent.length - 1]['POS'] = askHolder;
            }

            if (!lookFlag &&
                !callFlag &&
                !bringFlag &&
                !seeFlag &&
                !writeFlag &&
                !readFlag &&
                !cleanFlag &&
                !payFlag &&
                !buyFlag &&
                !getFlag &&
                !wantFlag &&
                !haveFlag &&
                !talkFlag) {
              translatedSentence +=
                  " " + reversedSent[reversedSent.length - 1]['Translation'];
              buttons.add(reversedSent[reversedSent.length - 1]['Translation']);
            }
          } else {
            translatedSentence +=
                (reversedSent[reversedSent.length - 1]['Translation']);
            buttons.add(reversedSent[reversedSent.length - 1]['Translation']);
          }

          break;
        case 'Past':
          for (var i = 0; i < reversedSent.length; i++) {
            print("see: $seeFlag");
            print("bring: $bringFlag");
            print("look: $lookFlag");

            if (reversedSent[i]['Translation'] != null) {
              if (reversedSent[i]['POS'] == 'Noun') {
                if (bringFlag ||
                    buyFlag ||
                    getFlag ||
                    wantFlag ||
                    haveFlag ||
                    seeFlag ||
                    readFlag ||
                    writeFlag) {
                  translatedSentence += "a " + reversedSent[i]['Translation'];
                  buttons.add(reversedSent[i]['Translation']);
                  buttons.add("a");
                }
                if (cleanFlag || payFlag || callFlag) {
                  translatedSentence += "the " + reversedSent[i]['Translation'];
                  buttons.add(reversedSent[i]['Translation']);
                  buttons.add("the");
                }
                if (talkFlag) {
                  translatedSentence +=
                      " to the " + reversedSent[i]['Translation'];
                  buttons.add(reversedSent[i]['Translation']);
                  buttons.add("the");
                  buttons.add("to");
                }
                if (lookFlag) {
                  translatedSentence +=
                      "for a " + reversedSent[i]['Translation'];
                  buttons.add(reversedSent[i]['Translation']);
                  buttons.add("for");
                  buttons.add("a");
                }
                if (askFlag) {
                  reversedSent[i]['POS'] = askHolder;
                }

                if (!lookFlag &&
                    !callFlag &&
                    !bringFlag &&
                    !seeFlag &&
                    !writeFlag &&
                    !readFlag &&
                    !cleanFlag &&
                    !payFlag &&
                    !buyFlag &&
                    !getFlag &&
                    !wantFlag &&
                    !haveFlag &&
                    !talkFlag) {
                  translatedSentence += reversedSent[i]['Translation'];
                  buttons.add(reversedSent[i]['Translation']);
                }
              } else {
                translatedSentence += reversedSent[i]['Translation'];
                buttons.add(reversedSent[i]['Translation']);
              }
            } else {
              translatedSentence += reversedSent[i]['Name'];
              buttons.add(reversedSent[i]['Name']);
            }
            translatedSentence += " ";
          }

          break;
        case 'Future':
          for (var i = 0; i < reversedSent.length; i++) {
            print("see: $seeFlag");
            print("bring: $bringFlag");
            print("look: $lookFlag");

            if (reversedSent[i]['Translation'] != null) {
              if (reversedSent[i]['POS'] == 'Noun') {
                if (bringFlag ||
                    buyFlag ||
                    getFlag ||
                    wantFlag ||
                    haveFlag ||
                    seeFlag ||
                    readFlag ||
                    writeFlag) {
                  translatedSentence += "a " + reversedSent[i]['Translation'];
                  buttons.add(reversedSent[i]['Translation']);
                  buttons.add("a");
                }

                if (cleanFlag || payFlag || callFlag) {
                  translatedSentence += "the " + reversedSent[i]['Translation'];
                  buttons.add(reversedSent[i]['Translation']);
                  buttons.add("the");
                }
                if (talkFlag) {
                  translatedSentence +=
                      " to the " + reversedSent[i]['Translation'];
                  buttons.add(reversedSent[i]['Translation']);
                  buttons.add("the");
                  buttons.add("to");
                }
                if (lookFlag) {
                  translatedSentence +=
                      "for a " + reversedSent[i]['Translation'];
                  buttons.add(reversedSent[i]['Translation']);
                  buttons.add("for");
                  buttons.add("a");
                }
                if (askFlag) {
                  reversedSent[i]['POS'] = askHolder;
                }

                if (!lookFlag &&
                    !callFlag &&
                    !bringFlag &&
                    !seeFlag &&
                    !writeFlag &&
                    !readFlag &&
                    !cleanFlag &&
                    !payFlag &&
                    !buyFlag &&
                    !getFlag &&
                    !wantFlag &&
                    !haveFlag &&
                    !talkFlag) {
                  translatedSentence += " " + reversedSent[i]['Translation'];
                  buttons.add(reversedSent[i]['Translation']);
                }
              } else {
                translatedSentence += reversedSent[i]['Translation'];
                buttons.add(reversedSent[i]['Translation']);
              }
            } else {
              translatedSentence += reversedSent[i]['Name'];
              buttons.add(reversedSent[i]['Name']);
            }
            translatedSentence += " ";
          }

          break;
        case 'Continuous':
          for (var i = 0; i < reversedSent.length - 1; i++) {
            print("see: $seeFlag");
            print("bring: $bringFlag");
            print("look: $lookFlag");

            if (reversedSent[i + 1]['POS'] == 'Verb') {
              if (reversedSent[i]['Translation'] != null) {
                if (reversedSent[i]['POS'] == 'Noun') {
                  if (bringFlag ||
                      buyFlag ||
                      getFlag ||
                      wantFlag ||
                      haveFlag ||
                      seeFlag ||
                      readFlag ||
                      writeFlag) {
                    translatedSentence +=
                        " a " + reversedSent[i]['Translation'];
                    buttons.add(reversedSent[i]['Translation']);
                    buttons.add("a");
                  }

                  if (cleanFlag || payFlag || callFlag) {
                    translatedSentence +=
                        " the " + reversedSent[i]['Translation'];
                    buttons.add(reversedSent[i]['Translation']);
                    buttons.add("the");
                  }
                  if (talkFlag) {
                    translatedSentence +=
                        " to the " + reversedSent[i]['Translation'];
                    buttons.add(reversedSent[i]['Translation']);
                    buttons.add("the");
                    buttons.add("to");
                  }
                  if (lookFlag) {
                    translatedSentence +=
                        " for a " + reversedSent[i]['Translation'];
                    buttons.add(reversedSent[i]['Translation']);
                    buttons.add("for");
                    buttons.add("a");
                  }
                  if (askFlag) {
                    reversedSent[i]['POS'] = askHolder;
                  }

                  if (!lookFlag &&
                      !callFlag &&
                      !bringFlag &&
                      !seeFlag &&
                      !writeFlag &&
                      !readFlag &&
                      !cleanFlag &&
                      !payFlag &&
                      !buyFlag &&
                      !getFlag &&
                      !wantFlag &&
                      !haveFlag &&
                      !talkFlag) {
                    translatedSentence += " " + reversedSent[i]['Translation'];
                    buttons.add(reversedSent[i]['Translation']);
                  }
                } else {
                  translatedSentence += reversedSent[i]['Translation'];
                  buttons.add(reversedSent[i]['Translation']);
                }

                if (reversedSent[i]['Number'] == 'Singular') {
                  reversedSent[i + 1]['Translation'] += 's';
                  sFlag = true;
                  sIndex = i + 1;
                }
              } else {
                translatedSentence += reversedSent[i]['Name'] + " ";
                buttons.add(reversedSent[i]['Name']);
                reversedSent[i + 1]['Translation'] += 's';
                sFlag = true;
                sIndex = i + 1;
              }
            } else {
              if (reversedSent[i]['Translation'] != null) {
                if (reversedSent[i]['POS'] == 'Noun') {
                  if (bringFlag ||
                      buyFlag ||
                      getFlag ||
                      wantFlag ||
                      haveFlag ||
                      seeFlag ||
                      readFlag ||
                      writeFlag) {
                    translatedSentence +=
                        " a " + reversedSent[i]['Translation'];
                    buttons.add(reversedSent[i]['Translation']);
                    buttons.add("a");
                  }

                  if (cleanFlag || payFlag || callFlag) {
                    translatedSentence +=
                        " the " + reversedSent[i]['Translation'];
                    buttons.add(reversedSent[i]['Translation']);
                    buttons.add("the");
                  }
                  if (talkFlag) {
                    translatedSentence +=
                        " to the " + reversedSent[i]['Translation'];
                    buttons.add(reversedSent[i]['Translation']);
                    buttons.add("to");
                    buttons.add("the");
                  }
                  if (lookFlag) {
                    translatedSentence +=
                        " for a " + reversedSent[i]['Translation'];
                    buttons.add(reversedSent[i]['Translation']);
                    buttons.add("for");
                    buttons.add("a");
                  }
                  if (askFlag) {
                    reversedSent[i]['POS'] = askHolder;
                  }

                  if (!lookFlag &&
                      !callFlag &&
                      !bringFlag &&
                      !seeFlag &&
                      !writeFlag &&
                      !readFlag &&
                      !cleanFlag &&
                      !payFlag &&
                      !buyFlag &&
                      !getFlag &&
                      !wantFlag &&
                      !haveFlag &&
                      !talkFlag) {
                    translatedSentence += " " + reversedSent[i]['Translation'];
                    buttons.add(reversedSent[i]['Translation']);
                  }
                } else {
                  translatedSentence += " " + reversedSent[i]['Translation'];
                  buttons.add(reversedSent[i]['Translation']);
                }
              } else {
                translatedSentence += reversedSent[i]['Name'] + " ";
                buttons.add(reversedSent[i]['Name']);
              }
            }
          }
          if (reversedSent[reversedSent.length - 1]['POS'] == 'Noun') {
            if (bringFlag ||
                buyFlag ||
                getFlag ||
                wantFlag ||
                haveFlag ||
                seeFlag ||
                readFlag ||
                writeFlag) {
              translatedSentence +=
                  " a " + reversedSent[reversedSent.length - 1]['Translation'];
              buttons.add(reversedSent[reversedSent.length - 1]['Translation']);
              buttons.add("a");
            }

            if (cleanFlag || payFlag || callFlag) {
              translatedSentence += " the " +
                  reversedSent[reversedSent.length - 1]['Translation'];
              buttons.add(reversedSent[reversedSent.length - 1]['Translation']);
              buttons.add("the");
            }
            if (talkFlag) {
              translatedSentence += " to the " +
                  reversedSent[reversedSent.length - 1]['Translation'];
              buttons.add(reversedSent[reversedSent.length - 1]['Translation']);
              buttons.add("the");
              buttons.add("to");
            }
            if (lookFlag) {
              translatedSentence += " for a " +
                  reversedSent[reversedSent.length - 1]['Translation'];
              buttons.add(reversedSent[reversedSent.length - 1]['Translation']);
              buttons.add("for");
              buttons.add("a");
            }
            if (askFlag) {
              reversedSent[reversedSent.length - 1]['POS'] = askHolder;
            }

            if (!lookFlag &&
                !callFlag &&
                !bringFlag &&
                !seeFlag &&
                !writeFlag &&
                !readFlag &&
                !cleanFlag &&
                !payFlag &&
                !buyFlag &&
                !getFlag &&
                !wantFlag &&
                !haveFlag &&
                !talkFlag) {
              translatedSentence +=
                  " " + reversedSent[reversedSent.length - 1]['Translation'];
              buttons.add(reversedSent[reversedSent.length - 1]['Translation']);
            }
          } else {
            translatedSentence +=
                (reversedSent[reversedSent.length - 1]['Translation']);
            buttons.add(reversedSent[reversedSent.length - 1]['Translation']);
          }

          break;
        default:
          break;
      }
    } else {
      if (adjectiveFlag) {
        var nounNum;
        for (var i = 0; i < reversedSent.length; i++) {
          if (reversedSent[i]['POS'] == "Noun") {
            nounNum = reversedSent[i]["Number"];
            buttons.add("the");
            if (nounNum == "Plural") {
              translatedSentence +=
                  "The " + reversedSent[i]['Translation'] + " are ";
              buttons.add("are");
              buttons.add(reversedSent[i]['Translation']);
            } else {
              translatedSentence +=
                  "The " + reversedSent[i]['Translation'] + " is ";
              buttons.add("is");
              buttons.add(reversedSent[i]['Translation']);
            }
          }
          if (reversedSent[i]['POS'] == "Adjective") {
            translatedSentence += reversedSent[i]['Translation'];
            buttons.add(reversedSent[i]['Translation']);
          }
          if (reversedSent[i]['Translation'] == null) {
            translatedSentence += reversedSent[i]['Name'] + " is ";
            buttons.add(reversedSent[i]['Name']);
          }
          if (reversedSent[i]['POS'] == "Pronoun") {
            if (reversedSent[i]['Number'] == "Plural") {
              if (reversedSent[i]['Translation'] == "I") {
                translatedSentence += reversedSent[i]['Translation'] + " am ";
                buttons.add(reversedSent[i]['Translation']);
                buttons.add("am");
              } else {
                translatedSentence += reversedSent[i]['Translation'] + " are ";
                buttons.add(reversedSent[i]['Translation']);
                buttons.add("are");
              }
            } else {
              if (reversedSent[i]['Translation'] == "I") {
                translatedSentence += reversedSent[i]['Translation'] + " am ";
                buttons.add(reversedSent[i]['Translation']);
                buttons.add("am");
              } else {
                translatedSentence += reversedSent[i]['Translation'] + " is ";
                buttons.add(reversedSent[i]['Translation']);
                buttons.add("is");
              }
            }
          }
        }
      }
      if (adverbFlag) {
        unreversedSent = List.from(reversedSent.reversed);
        var lastAdverb, nounNum;
        for (var i = 0; i < unreversedSent.length; i++) {
          print(unreversedSent[i]["Translation"]);
          if (unreversedSent[i]['POS'] != "Adverb") {
            if (unreversedSent[i]['POS'] == 'Pronoun') {
              nounNum = unreversedSent[i]['Number'];
              print(nounNum);
              if (nounNum == "Singular") {
                unreversedSent[i + 1]['Translation'] += 's';
                sFlag = true;
                sIndex = i + 1;
              }
              translatedSentence += unreversedSent[i]['Translation'] + " ";
              buttons.add(unreversedSent[i]['Translation']);
            } else {
              translatedSentence += unreversedSent[i]['Translation'] + " ";
              buttons.add(unreversedSent[i]['Translation']);
            }
          } else {
            lastAdverb = unreversedSent[i];
            buttons.add(unreversedSent[i]['Translation']);
          }
        }
        translatedSentence += lastAdverb['Translation'];
      }
      if (introFlag) {
        unreversedSent = List.from(reversedSent.reversed);
        for (var i = 0; i < unreversedSent.length; i++) {
          if (unreversedSent[i]['Translation'] != null) {
            if (unreversedSent[i]['POS'] == "Pronoun") {
              translatedSentence += unreversedSent[i]['Translation'] + " is ";
              buttons.add(unreversedSent[i]['Translation']);
              buttons.add("is");
            }
          } else {
            translatedSentence += unreversedSent[i]['Name'];
            buttons.add(unreversedSent[i]['Name']);
          }
        }
      }
      print(translatedSentence);
      print(buttons);
    }
    for (var i = 0; i < buttons.length; i++) {
      buttons[i] = buttons[i].toLowerCase();
    }
    correctAnswer = translatedSentence;
    correctAnswer = correctAnswer.toLowerCase();
    correctAnswer = correctAnswer[0].toUpperCase() + correctAnswer.substring(1);
    buttons.shuffle();
    print(buttons);
    print(translatedSentence);
    print(correctAnswer);
    if (sFlag) {
      if (adverbFlag) {
        unreversedSent[sIndex]['Translation'] = unreversedSent[sIndex]
                ['Translation']
            .substring(0, (unreversedSent[sIndex]['Translation']).length - 1);
      } else {
        reversedSent[sIndex]['Translation'] = reversedSent[sIndex]
                ['Translation']
            .substring(0, (reversedSent[sIndex]['Translation']).length - 1);
      }
    }
  }

  Widget buildAnswerBox() {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.start,
      children: <Widget>[
        ...buttons.map(
          (i) => Container(
            margin: EdgeInsets.all(4),
            width: MediaQuery.of(context).size.width / 3.5,
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
              ),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              height: 12.0,
              minWidth: 1.0,
              padding: EdgeInsets.fromLTRB(9, 6, 9, 6),
              color: Color(0xffBDE0FE),
              onPressed: () {
                addWord(i);
              },
              child: Center(
                child: Text(
                  i,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.fredokaOne(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget correctAnswerValidation(BuildContext context, String correctAnswer) {
    return AlertDialog(
      backgroundColor: Color(0xffdef2c8),
      title: Text(
        'You are correct!',
        style: GoogleFonts.fredokaOne(
          color: Colors.black,
          fontSize: 22,
        ),
      ),
      content: Text(
        'The correct answer is: $correctAnswer',
        style: GoogleFonts.fredokaOne(
          color: Colors.black,
          fontSize: 14,
        ),
      ),
      actions: [
        MaterialButton(
          onPressed: () {
            print("category ${widget.category}");
            levelContent.initiateQuiz(
                widget.currentContext,
                widget.i,
                1,
                widget.score,
                widget.level,
                widget.category,
                widget.databaseTemp);
          },
          child: Text("Next",
              style: GoogleFonts.fredokaOne(
                fontSize: 16,
                decoration: TextDecoration.underline,
              )),
        )
      ],
    );
  }

  Widget incorrectAnswerValidation(BuildContext context, String correctAnswer) {
    return AlertDialog(
      backgroundColor: Color(0xffedafb8),
      title: Text(
        'You are incorrect!',
        style: GoogleFonts.fredokaOne(
          color: Colors.black,
          fontSize: 22,
        ),
      ),
      content: Text(
        'The correct answer is: $correctAnswer',
        style: GoogleFonts.fredokaOne(
          color: Colors.black,
          fontSize: 14,
        ),
      ),
      actions: [
        MaterialButton(
          onPressed: () {
            levelContent.initiateQuiz(
                widget.currentContext,
                widget.i,
                0,
                widget.score,
                widget.level,
                widget.category,
                widget.databaseTemp);
          },
          child: Text("Next",
              style: GoogleFonts.fredokaOne(
                fontSize: 16,
                decoration: TextDecoration.underline,
              )),
        )
      ],
    );
  }

  Future<void> _quizValidation() async {
    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Container(
              alignment: Alignment(0, -1),
              child: Opacity(
                  opacity: 0.85,
                  child:
                      answerController.text.toLowerCase().replaceAll(" ", "") ==
                              correctAnswer.toLowerCase().replaceAll(" ", "")
                          ? correctAnswerValidation(context, correctAnswer)
                          : incorrectAnswerValidation(context, correctAnswer)));
        });
  }

  String getText() {
    String text = "";
    for (var i = 0; i < selectedWords.length; i++) {
      text += " " + selectedWords[i];
    }
    return text;
  }

  void addWord(String word) {
    bool flag = false;
    for (var j = 0; j < selectedWords.length; j++) {
      if (selectedWords[j] == word) {
        flag = true;
      }
    }
    if (!flag) {
      selectedWords.add(word);
    }
    String text = getText();
    setState(() {
      answerController = TextEditingController(text: text);
    });
  }

  void deleteWord() {
    if (selectedWords.length > 0) {
      selectedWords.remove(selectedWords[selectedWords.length - 1]);
      String text = getText();

      setState(() {
        answerController = TextEditingController(text: text);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return QuizTemplate(
      pageTitle: "Drills",
      pageGreeting: "Question ${(widget.i)}",
      // pageChild: _pageContent(context),
      quizStatus: widget.i / 10,
      pageChildUpper: _pageUpper(context),
      pageChildLower: _pageLower(context),
    );
  }

  Widget _pageUpper(context) {
    return Column(
      children: [
        Container(
            padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
            height: MediaQuery.of(context).size.height / 16,
            child: Row(
              children: [
                Icon(
                  Icons.lightbulb,
                  color: Colors.yellow,
                ),
                Text(
                  "Translate the sentence given",
                  style: GoogleFonts.fredokaOne(
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            )),
        Container(
          padding: EdgeInsets.all(20),
          // padding: EdgeInsets.fromLTRB(18, 15, 20, 15),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 5,
          child: Center(
            child: Text(
              finalSentence,
              textAlign: TextAlign.center,
              style: GoogleFonts.fredokaOne(
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _pageLower(context) {
    return Column(children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.all(0),
            width: MediaQuery.of(context).size.width / 1.4,
            height: MediaQuery.of(context).size.height / 10,
            child: TextFormField(
              enabled: false,
              controller: answerController,
              textAlign: TextAlign.center,
              style: GoogleFonts.fredokaOne(color: Colors.black),
            ),
          ),
          SizedBox(width: 10),
          MaterialButton(
            padding: EdgeInsets.all(2),
            height: 5.0,
            minWidth: 2.0,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            child: Icon(
              Icons.delete,
              size: 30.0,
            ),
            onPressed: () {
              deleteWord();
            },
          )
        ],
      ),
      Container(
        padding: EdgeInsets.all(8),
        width: MediaQuery.of(context).size.width - 30,
        height: MediaQuery.of(context).size.height / 4.3,
        child: Center(
          child: buildAnswerBox(),
        ),
      ),
      Container(
        width: MediaQuery.of(context).size.width / 3.5,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)),
          ),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: EdgeInsets.fromLTRB(0, 6, 0, 6),
          color: Colors.grey[300],
          onPressed: () {
            _quizValidation();
            // formSentence();
          },
          child: Text(
            "Submit",
            style: GoogleFonts.fredokaOne(
              textStyle: TextStyle(color: Colors.black, fontSize: 13),
            ),
          ),
        ),
      )
    ]);
  }
}
