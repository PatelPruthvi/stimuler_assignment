import 'dart:convert';

import 'package:sqflite/sqflite.dart' as sql;
import 'package:stimuler_assignment/models/day_model.dart';

class SqlHelper {
  static Future<sql.Database> db() async {
    return sql.openDatabase("stimuler.db", version: 1, onCreate: _onCreate);
  }

  static Future<void> _onCreate(sql.Database db, int version) async {
    await db.execute('''
    CREATE TABLE DAYS (
      DAY_ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
      TITLE TEXT
    )
  ''');

    await db.execute('''
    CREATE TABLE EXERCISE (
      E_ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
      TITLE TEXT, 
      IMGLINK TEXT, 
      DAY_ID INTEGER, 
      FOREIGN KEY (DAY_ID) REFERENCES DAYS(DAY_ID)
    )
  ''');

    await db.execute('''
    CREATE TABLE QUESTION (
      Q_ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
      QUESTION TEXT, 
      ANSWER TEXT, 
      E_ID INTEGER, 
      FOREIGN KEY (E_ID) REFERENCES EXERCISE(E_ID)
    )
  ''');

    await db.execute('''
    CREATE TABLE OPTIONS (
      O_ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
      OPTION_TEXT TEXT,  
      Q_ID INTEGER, 
      FOREIGN KEY (Q_ID) REFERENCES QUESTION(Q_ID)
    )
  ''');

    await db.execute('''
    CREATE TABLE PROGRESS (
      P_ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
      ISCOMPLETED INTEGER DEFAULT 0, 
      TOTALQ INTEGER, 
      CORRECTQ INTEGER, 
      E_ID INTEGER, 
      FOREIGN KEY (E_ID) REFERENCES EXERCISE(E_ID)
    )
  ''');
    final inserter = DataInserter(db: db);
    await inserter.insertAllData();
  }
}

class TableHelper {
  Future updateExerciseProgress(int exerciseId, int correctQ) async {
    final db = await SqlHelper.db();
    db.update('PROGRESS', {"E_ID": exerciseId, "CORRECTQ": correctQ},
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    // await fetchQuestionDetails();
  }

  // Fetching the days and associated exercises
  Future<List<DayModel>> fetchAllData() async {
    final db = await SqlHelper.db();

    // Fetching the days and associated exercises
    List<Map<String, dynamic>> rawQuery1 = await db.rawQuery('''
    SELECT
      d.DAY_ID AS dayId,
      d.TITLE AS title,
      json_group_array(
          json_object(
              'exercise_id', e.E_ID,
              'title', e.TITLE,
              'imgLink', e.IMGLINK
          )
      ) AS exercises
    FROM
      DAYS d
    LEFT JOIN
      EXERCISE e ON d.DAY_ID = e.DAY_ID
    GROUP BY
      d.DAY_ID;
  ''');

    // Fetching questions for each exercise
    List<Map<String, dynamic>> rawQuery2 = await db.rawQuery('''
    SELECT
      q.E_ID AS exercise_id,
      json_group_array(
          json_object(
              'question_id', q.Q_ID,
              'question', q.QUESTION,
              'answer', q.ANSWER,
              'options', (
                  SELECT json_group_array(o.OPTION_TEXT)
                  FROM OPTIONS o
                  WHERE o.Q_ID = q.Q_ID
              )
          )
      ) AS questions
    FROM
      QUESTION q
    GROUP BY
      q.E_ID;
  ''');
    //  fetch user progress details and then add them in the json too,just like dummy json in data folder
    //   List<Map<String, dynamic>> rawQuery3 = await db.rawQuery('''
    //   SELECT
    //     p.E_ID AS exercise_id,
    //     p.ISCOMPLETED,
    //     p.TOTALQ,
    //     p.CORRECTQ
    //   FROM
    //     PROGRESS p
    // ''');

    // final progressMap = {
    //   for (var p in rawQuery3)
    //     p['exercise_id']: {
    //       'isCompleted': p['ISCOMPLETED'],
    //       'totalQuestions': p['TOTALQ'],
    //       'correctQuestions': p['CORRECTQ']
    //     }
    // };

    // Step 1: Create a map for easy lookup of questions by exercise_id
    final questionsMap = {
      for (var q in rawQuery2) q['exercise_id']: q['questions']
    };

    // Step 2: Process days data and combine with questions
    List<Map<String, dynamic>> dayDemos = [];

    for (var day in rawQuery1) {
      Map<String, dynamic> dayDemo = {
        'dayId': day['dayId'],
        'title': day['title'],
        'exercises': []
      };

      // Step 3: Fetch exercises and add associated questions
      var exercises = jsonDecode(day['exercises']);
      for (var exercise in exercises) {
        var exerciseId = exercise['exercise_id'];
        var questions = jsonDecode(questionsMap[exerciseId]) ?? [];

        // Add questions to the exercise
        exercise['questions'] = questions;

        // Add the exercise to the day
        dayDemo['exercises'].add(exercise);
      }

      dayDemos.add(dayDemo);
    }
    List<DayModel> dayDataModels = [];
    for (var day in dayDemos) {
      dayDataModels.add(DayModel.fromJson(day));
    }
    // print(dayModel.length);
    return dayDataModels;
  }
}

class DataInserter {
  final sql.Database db;

  DataInserter({required this.db});

  Future<void> insertDays() async {
    await db.rawInsert('''
      INSERT INTO DAYS (TITLE) VALUES
        ('Adjectives'),
        ('Adverbs');
    ''');
  }

  Future<void> insertExercises() async {
    await db.rawInsert('''
      INSERT INTO EXERCISE ( TITLE, IMGLINK, DAY_ID) VALUES
        ( 'Compound Adjectives', 'https://avatar.iran.liara.run/public/1', 1),
        ( 'Participle Adjectives', 'https://avatar.iran.liara.run/public/2', 1),
        ( 'Order of Adjectives', 'https://avatar.iran.liara.run/public/3', 1),
        ( 'Adverbs of Manner in Complex Sentences', 'https://avatar.iran.liara.run/public/4', 2),
        ( 'Comparative and Superlative Adverbs', 'https://avatar.iran.liara.run/public/5', 2);
    ''');
  }

  Future<void> insertQuestions() async {
    await db.rawInsert('''
      INSERT INTO QUESTION (QUESTION, ANSWER, E_ID) VALUES
        ( 'The company implemented a _ security protocol for their data centers.', 'cutting-edge', 1),
        ( 'The physicist presented a _ theory about quantum entanglement.', 'ground-breaking', 1),
        ( 'The expedition required _ equipment for the harsh Antarctic conditions.', 'military-grade', 1),
        ( 'The _ evidence presented at the trial changed the jury''s perspective.', 'overwhelming', 2),
        ('The archaeologists discovered a _ manuscript in the ancient temple.', 'fascinating', 2),
        ('She purchased a _ briefcase for her new job.', 'expensive Italian leather', 3),
        ( 'The museum displayed a _ artifact from the Ming Dynasty.', 'ancient valuable porcelain', 3),
        ( 'The soprano _ executed the challenging aria, earning a standing ovation.', 'flawlessly', 4),
        ( 'The quantum computer _ processed the complex algorithms, surpassing traditional computing methods.', 'efficiently', 4),
        ( 'Among all the competitors, Sarah completed the triathlon _ than expected.', 'more impressively', 5),
        ( 'The financial analysis was presented _ of all the quarterly reports.', 'most comprehensively', 5),
        ( 'The AI system performed _ in the latest benchmarking tests.', 'sophisticatedly', 5);
    ''');
  }

  Future<void> insertOptions() async {
    await db.rawInsert('''
      INSERT INTO OPTIONS (OPTION_TEXT, Q_ID) VALUES
        ('cutting-edge', 1),
        ( 'cutting edge', 1),
        ( 'edge-cutting', 1),
        ( 'edge cutting', 1),
        ( 'ground-breaking', 2),
        ( 'ground breaking', 2),
        ( 'breaking-ground', 2),
        ( 'break-grounding', 2),
        ( 'military-grade', 3),
        ( 'military grade', 3),
        ( 'grade-military', 3),
        ( 'grade military', 3),
        ( 'overwhelming', 4),
        ( 'overwhelmed', 4),
        ( 'overwhelm', 4),
        ( 'overwhelms', 4),
        ( 'fascinating', 5),
        ( 'fascinated', 5),
        ( 'fascinate', 5),
        ( 'fascinates', 5),
        ( 'expensive Italian leather', 6),
        ( 'leather expensive Italian', 6),
        ( 'Italian expensive leather', 6),
        ( 'expensive leather Italian', 6),
        ( 'ancient valuable porcelain', 7),
        ( 'porcelain ancient valuable', 7),
        ( 'valuable ancient porcelain', 7),
        ( 'porcelain valuable ancient', 7),
        ( 'flawlessly', 8),
        ( 'flawless', 8),
        ( 'flawlessness', 8),
        ('flawlessing', 8),
        ('efficiently', 9),
        ('efficient', 9),
        ('efficiency', 9),
        ('efficienting', 9),
        ('more impressively', 10),
        ('more impressive', 10),
        ( 'most impressively', 10),
        ('impressive', 10),
        ('most comprehensively', 11),
        ('more comprehensively', 11),
        ('most comprehensive', 11),
        ('comprehensive', 11),
        ('sophisticatedly', 12),
        ('more sophisticatedly', 12),
        ('most sophisticatedly', 12),
        ('sophisticated', 12);
    ''');
  }

  Future<void> initializeProgress() async {
    await db.rawQuery('''
    INSERT INTO PROGRESS (E_ID, TOTALQ, ISCOMPLETED)
    SELECT 
      e.E_ID, 
      COUNT(q.Q_ID) AS TOTALQ, 
      0 AS ISCOMPLETED
    FROM EXERCISE e
    LEFT JOIN QUESTION q ON e.E_ID = q.E_ID
    GROUP BY e.E_ID;
  ''');
  }

  Future<void> insertAllData() async {
    await insertDays();
    await insertExercises();
    await insertQuestions();
    await insertOptions();
    await initializeProgress();
    print('All data inserted successfully!');
  }
}
