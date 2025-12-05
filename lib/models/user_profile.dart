class WorkoutPlan {
  final String plan;
  final String insight;

  WorkoutPlan({
    required this.plan,
    required this.insight,
  });

  factory WorkoutPlan.fromJson(Map<String, dynamic> json) {
    return WorkoutPlan(
      plan: json['plan'] ?? '',
      insight: json['insight'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'plan': plan,
      'insight': insight,
    };
  }
}

class UserProfile {
  final String nickName;
  final String userIcon;
  final List<String> showPhotoArray;
  final List<String> showVideoArray;
  final List<String> showThumbnailArray;
  final String showMotto;
  final int showFollowNum;
  final int showLike;
  final String showSayhi;
  final String showBackground;
  final WorkoutPlan? showWorkoutPlan5Days;
  final WorkoutPlan? showWorkoutPlan7Days;
  final WorkoutPlan? showWorkoutPlan1Month;

  UserProfile({
    required this.nickName,
    required this.userIcon,
    required this.showPhotoArray,
    required this.showVideoArray,
    required this.showThumbnailArray,
    required this.showMotto,
    required this.showFollowNum,
    required this.showLike,
    required this.showSayhi,
    required this.showBackground,
    this.showWorkoutPlan5Days,
    this.showWorkoutPlan7Days,
    this.showWorkoutPlan1Month,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      nickName: json['RoroNickName'] ?? '',
      userIcon: json['RoroUserIcon'] ?? '',
      showPhotoArray: List<String>.from(json['RoroShowPhotoArray'] ?? []),
      showVideoArray: List<String>.from(json['RoroShowVideoArray'] ?? []),
      showThumbnailArray: List<String>.from(json['RoroShowThumbnailArray'] ?? []),
      showMotto: json['RoroShowMotto'] ?? '',
      showFollowNum: json['RoroShowFollowNum'] ?? 0,
      showLike: json['RoroShowLike'] ?? 0,
      showSayhi: json['RoroShowSayhi'] ?? '',
      showBackground: json['RoroShowBackground'] ?? '',
      showWorkoutPlan5Days: json['RoroShowWorkoutPlan5Days'] != null
          ? WorkoutPlan.fromJson(json['RoroShowWorkoutPlan5Days'])
          : null,
      showWorkoutPlan7Days: json['RoroShowWorkoutPlan7Days'] != null
          ? WorkoutPlan.fromJson(json['RoroShowWorkoutPlan7Days'])
          : null,
      showWorkoutPlan1Month: json['RoroShowWorkoutPlan1Month'] != null
          ? WorkoutPlan.fromJson(json['RoroShowWorkoutPlan1Month'])
          : null,
    );
  }
}

