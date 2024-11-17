# Flutter Exercise Roadmap Application

This Flutter application is an exercise roadmap app demonstrating proficiency in UI implementation, system design, and progress tracking for daily exercises. The app is structured as a roadmap with interactive nodes representing each day's exercises. The system tracks user progress for exercises and questions, and supports animations for unlocking new days and exercises.

## Features

- **Interactive Roadmap**: Displays a roadmap where each day contains exercises, and each exercise contains multiple MCQ questions.
- **Exercise Progress Tracking**: Tracks progress for each exercise, showing how many correct answers were selected.
- **Dynamic UI with Animations**: Day nodes and exercise nodes are dynamically unlocked with smooth animations as the user progresses.
- **Exercise Bottom Sheet**: A bottom sheet appears when a day node is tapped, showing all exercises for that day.
- **Multiple MCQ Questions**: Each exercise contains multiple questions with options. The app supports answering and checking correctness.
- **Persistent User Data**: The app supports login, data persistence across sessions, and user progress storage.


## Core Requirements Implemented

- **Roadmap Visualization**: A curved path connects nodes representing each day. Each node is tappable, and days/exercises unlock sequentially.
- **Day Unlocking Mechanism**: The app only allows users to access the next day's exercise once all exercises from the previous day are completed.
- **Exercise Bottom Sheet**: Displays a list of exercises when tapping a node, with relevant metadata and smooth transitions for sheet appearance/disappearance.
- **MCQ Screen**: The exercise question screen presents MCQs, allows answer selection, and checks correctness.
- **Login & User Progress**: Simple login with username. User data persists across app restarts, including progress and answers.

## Project Architecture

This app is structured using a clean and maintainable architecture to separate UI, business logic, and data concerns. The system follows the principles of scalability, performance optimization, and error handling.

### Folder Structure

assets/
**Contains Images, Icons and font family used across the app.**
#
lib/ 
# 
├── models/ 
**Contains Dart models for Day, Exercise, Question, Progress**
#
├── screens/ 
**Contains screens for the roadmap, exercise bottom sheet, and question screens** 
   #
   ├── bloc/ 
**Contains bloc folder for state management** 
   #
   ├── ui/
**Contains dart code for frontend ui**
#
├── resources/ 
**Contains app colors and widget components used across the app.**


### State Management

State management is handled using **BLoC** for simpler architecture and easier maintainability. The state of the app is managed for the following components:

- **Exercise Progress**: Tracks user progress, completed exercises, and correct answers.
- **UI State**: Manages visibility of UI components, animations, and transitions.

### Proposed Database Schema
## CURRENTLY NOT IMPLEMENTED IN APPLICATION

Here is the proposed app SQL database schema to manage the given data:

1. **User Table**: Stores user data such as username, userid.
2. **Exercise Table**: Stores exercises, linked to days and containing MCQ questions.
3. **Question Table**: Stores questions for each exercise, with options and correct answers.
4. **Progress Table**: Tracks the progress of exercises for user, storing completion status and correct answers.

### Database Schema Documentation

#### Tables:

- **DAYS**: 
  - `DAY_ID`: Unique ID for the day.
  - `TITLE`: Title of the day (e.g., "Adjectives", "Adverbs").
  
- **EXERCISES**:
  - `EXERCISE_ID`: Unique ID for each exercise.
  - `DAY_ID`: Foreign key linking the exercise to a specific day.
  - `TITLE`: Title of the exercise.
  - `IMGLINK`: Image URL associated with the exercise.

- **QUESTIONS**:
  - `QUESTION_ID`: Unique ID for each question.
  - `EXERCISE_ID`: Foreign key linking the question to a specific exercise.
  - `QUESTION`: The text of the question.
  - `ANSWER`: Correct answer to the question.
  
- **OPTIONS**:
  - `OPTION_ID`: Unique ID for each option.
  - `QUESTION_ID`: Foreign key linking the option to a specific question.
  - `OPTION_TEXT`: The text of the option.

- **PROGRESS**:
  - `PROGRESS_ID`: Unique ID for each progress record.
  - `USER_ID`: Foreign key linking the progress record to a specific user.
  - `EXERCISE_ID`: Foreign key linking the progress record to a specific exercise.
  - `IS_COMPLETED`: Boolean flag indicating if the exercise is completed.
  - `CORRECT_ANSWERS`: Number of correct answers selected by the user.

## Setup & Compilation Instructions

### 1. Clone the Repository

Clone this repository to your local machine:

```bash
git clone https://github.com/PatelPruthvi/stimuler_assignment.git
cd stimuler_assignment
```

```bash
flutter pub get
```

 ```bash
flutter run
```