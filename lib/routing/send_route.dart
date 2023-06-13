import 'package:spicy_ranking/routing/calcurate.dart';

void main(){

  // player設定(ここはfirebaseから持ってくる)
  final player1 = setPlayer();
  final player2 = setPlayer();

  // 計算できるように成型
  final players = <Player>[player1, player2];
  // 1: win, 2: lose
  final ranks = [2, 1];

  final newPlayers = calcRatings(players, ranks);

  print("===loser=== \n rating: ${newPlayers[0].rating}");
  print("===winner=== \n rating: ${newPlayers[1].rating}");
}

// プレイヤーのパラメータを設定する関数
/// 変数rating, rd, volはそれぞれrating、rating deviation、rating volatilityの初期値
/// playerオブジェクトを1つ返す
setPlayer({double rating = 1500, double rd = 350, double vol = 0.06}) {
  final player = Player();
  player.rating = rating;
  player.rd = rd;
  player.vol = vol;
  return player;
}

// 複数プレイヤーのrating等パラメータを計算する関数
/// 変数playersは複数のplayerオブジェクトを格納したリスト
/// 変数ranksは複数のplayerの対戦時における順位を格納したリスト
/// 各playerのrating等を更新してplayersリストを返す
List<Player> calcRatings(List<Player> players, List<int> ranks) {
  final newPlayers = <Player>[];
  for (var i = 0; i < players.length; i++) {
    final targetPlayer = players[i];
    final targetRank = ranks[i];
    final newTargetPlayer = targetPlayer.clone();
    final ratings = <double>[];
    final rds = <double>[];
    final outcomes = <double>[];
    for (var j = 0; j < players.length; j++) {
      final player = players[j];
      final rank = ranks[j];
      if (i != j) {
        ratings.add(player.rating);
        rds.add(player.rd);
        if (rank > targetRank) {
          outcomes.add(1.0);
        } else if (rank < targetRank) {
          outcomes.add(0);
        } else if (rank == targetRank) {
          outcomes.add(0.5);
        }
      }
    }
    newTargetPlayer.updatePlayer(ratings, rds, outcomes);
    newPlayers.add(newTargetPlayer);
  }
  return newPlayers;
}