from firebase_admin import firestore
import firebase_admin
from firebase_admin import credentials
import glicko2_rating
import copy

def main():
    JSON_PATH = './python/private_key.json'
    # Firebaseの初期化
    cred = credentials.Certificate(JSON_PATH)
    firebase_admin.initialize_app(cred)
    db = firestore.client()

    # Firestoreからドキュメント取得
    doc_ref = db.collection('history')
    docs = doc_ref.stream()

    # for doc in docs:
    #     print("----対戦----")
    #     print("辛くない：", doc.get('cold'))
    #     print("辛い：", doc.get('hot'))
    
    # player設定(ここはfirebaseから持ってくる)
    player1 = setPlayer()
    player2 = setPlayer()
    
    # 計算できるように成型
    players = [player1, player2]
    # 1: win, 2: lose
    ranks=[2,1]

    newPlayers = calcRatings(players,ranks)

    print("===loser=== \n rating: ",newPlayers[0].rating,newPlayers[0].rd,newPlayers[0].vol)
    print("===winner=== \nrating: ",newPlayers[1].rating,newPlayers[1].rd,newPlayers[1].vol)

    

# プレイヤーのパラメータを設定する関数
## 変数rating, rd, volはそれぞれrating、rating deviation、rating volatilityの初期値
## playerオブジェクトを1つ返す
def setPlayer(rating=1500, rd=350, vol=0.06):
    player = glicko2_rating.Player()
    player.rating=rating
    player.rd=rd
    player.vol=vol
    return player

# 複数プレイヤーのrating等パラメータを計算する関数
## 変数playersは複数のplayerオブジェクトを格納したリスト
## 変数ranksは複数のplayerの対戦時における順位を格納したリスト
## 各playerのrating等を更新してplayersリストを返す
def calcRatings(players,ranks):
    newPlayers=[]
    for i, (target_player,target_rank) in enumerate(zip(players,ranks)):
        new_target_player = copy.deepcopy(target_player)
        ratings=[]
        rds=[]
        outcomes=[]
        for j, (player, rank) in enumerate(zip(players,ranks)):
            if not i==j:
                ratings.append(player.rating)
                rds.append(player.rd)
                if rank>target_rank:
                    outcomes.append(1)
                elif rank<target_rank:
                    outcomes.append(0)
                elif rank==target_rank:
                    outcomes.append(0.5)
        
        new_target_player.update_player(ratings, rds, outcomes)
        newPlayers.append(new_target_player)
    
    return newPlayers


if __name__ == '__main__':
    main()