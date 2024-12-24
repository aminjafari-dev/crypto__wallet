#! Flask Example

# from flask import Flask, request, jsonify

# app = Flask(__name__)

# @app.route('/hello', methods=['GET'])
# def hello():
#     return jsonify({"message": "Hello, World!"}), 200

# if __name__ == '__main__':
#     app.run(debug=True)


from flask import Flask, request, jsonify
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from crypto_wallet import CryptoWallet  # Add this import

app = Flask(__name__)
rpc_url = "https://base-mainnet.g.alchemy.com/v2/kDPMGfNynLb-uJDyPm2qEclRiZ5IM40g"  # Alchemy Base Mainnet RPC URL
wallet_service = CryptoWallet(rpc_url)

@app.route('/create_wallet', methods=['GET'])
def create_wallet():
    wallet = wallet_service.create_wallet()
    return jsonify(wallet), 200

@app.route('/get_balance', methods=['POST'])
def get_balance():
    data = request.json
    address = data.get('address')
    try:
        balance = wallet_service.get_balance(address)
        return jsonify({'balance': balance}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 400

@app.route('/send_tokens', methods=['POST'])
def send_tokens():
    data = request.json
    private_key = data.get('private_key')
    to_address = data.get('to_address')
    amount = data.get('amount')
    try:
        txn_hash = wallet_service.send_tokens(private_key, to_address, amount)
        return jsonify({'transaction_hash': txn_hash}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 400

if __name__ == '__main__':
    app.run(debug=True)



#! FastAPI Example

# from fastapi import FastAPI

# app = FastAPI()

# @app.get("/hello")
# async def hello():
#     return {"message": "Hello, World!"}





# app = FastAPI()
# rpc_url = "https://base-mainnet.g.alchemy.com/v2/your-api-key"
# wallet_service = CryptoWallet(rpc_url)

# class WalletAddress(BaseModel):
#     address: str

# class TokenTransaction(BaseModel):
#     private_key: str
#     to_address: str
#     amount: float

# @app.get("/create_wallet")
# def create_wallet():
#     wallet = wallet_service.create_wallet()
#     return wallet

# @app.post("/get_balance")
# def get_balance(data: WalletAddress):
#     try:
#         balance = wallet_service.get_balance(data.address)
#         return {"balance": balance}
#     except Exception as e:
#         raise HTTPException(status_code=400, detail=str(e))

# @app.post("/send_tokens")
# def send_tokens(data: TokenTransaction):
#     try:
#         txn_hash = wallet_service.send_tokens(data.private_key, data.to_address, data.amount)
#         return {"transaction_hash": txn_hash}
#     except Exception as e:
#         raise HTTPException(status_code=400, detail=str(e))
