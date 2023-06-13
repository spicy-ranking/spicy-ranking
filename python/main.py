from firebase_admin import firestore
import firebase_admin
from firebase_admin import credentials

def main():
    JSON_PATH = './python/private_key.json'
    # Firebaseの初期化
    cred = credentials.Certificate(JSON_PATH)
    firebase_admin.initialize_app(cred)
    db = firestore.client()

    # Firestoreからドキュメント取得
    doc_ref = db.collection('history')
    docs = doc_ref.stream()

    for doc in docs:
        print("----対戦----")
        print("辛くない：", doc.get('cold'))
        print("辛い：", doc.get('hot'))

if __name__ == '__main__':
    main()