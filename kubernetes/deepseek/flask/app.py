import json
from flask import Flask, request, jsonify
import requests

app = Flask(__name__)

DEEPSEEK_API_URL = "http://deepseek-server.deepseek.svc.cluster.local:11434/api/generate"

@app.route('/webhook', methods=['POST'])
def webhook():
    # Get the payload from Telegram's webhook
    telegram_payload = request.get_json()

    # Extract the relevant information (this can be adjusted based on your needs)
    telegram_message = telegram_payload.get('message', {}).get('text', '')

    if telegram_message:
        # Prepare the request to Deepseek API
        deepseek_payload = {
            "model": "deepseek-r1:1.5b",
            "prompt": telegram_message,
            "stream": False
        }

        # Send the request to Deepseek
        response = requests.post(DEEPSEEK_API_URL, json=deepseek_payload)

        if response.status_code == 200:
            # Get the response from Deepseek
            deepseek_answer = response.json().get('response', 'No response from Deepseek.')

            # Clean up any HTML-encoded characters
            deepseek_answer = deepseek_answer.replace("\u003c", "<").replace("\u003e", ">")

            # Reply with Deepseek's cleaned answer
            return jsonify({
                "method": "sendMessage",
                "chat_id": telegram_payload['message']['chat']['id'],
                "text": deepseek_answer
            })
        else:
            return jsonify({
                "method": "sendMessage",
                "chat_id": telegram_payload['message']['chat']['id'],
                "text": "Error: Could not get a response from Deepseek."
            })

    return '', 200

if __name__ == '__main__':
    app.run(debug=True, host="0.0.0.0", port=5010)

