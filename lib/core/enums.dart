enum StudyMode {
  practice,
  exam,
}

enum SessionSource {
  manual,
  weightedRandom,
  sequential,
}

enum StudyEventType {
  sessionStarted,
  answerRevealed,
  reset,
  over,
  sessionCompleted,
}

extension StudyModeLabel on StudyMode {
  String get text {
    switch (this) {
      case StudyMode.practice:
        return '练习模式';
      case StudyMode.exam:
        return '考试模式';
    }
  }
}

extension SessionSourceLabel on SessionSource {
  String get text {
    switch (this) {
      case SessionSource.manual:
        return '自选';
      case SessionSource.weightedRandom:
        return '随机';
      case SessionSource.sequential:
        return '顺序';
    }
  }
}
